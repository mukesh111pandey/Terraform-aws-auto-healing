import os
import json
import logging
import boto3

logger = logging.getLogger()
logger.setLevel(logging.INFO)

ec2 = boto3.client("ec2")
sns = boto3.client("sns")

SNS_TOPIC = os.environ.get("SNS_TOPIC_ARN")  # passed from Terraform

def extract_instance_id_from_event(event):
    # Try resources list first (common for EC2 alarms)
    resources = event.get("resources", [])
    for r in resources:
        if ":instance/" in r:
            return r.split("/")[-1]

    # Try CloudWatch Alarm detail path
    detail = event.get("detail", {})
    conf = detail.get("configuration", {}) or {}
    # old/new formats vary — try multiple places
    # 1) metricAlarm -> dimensions
    metric_alarm = conf.get("metricAlarm", {})
    for d in metric_alarm.get("dimensions", []):
        if d.get("name") == "InstanceId":
            return d.get("value")

    # 2) configuration.metricAlarm.dimensions
    for d in conf.get("dimensions", []):
        if d.get("name") == "InstanceId":
            return d.get("value")

    # 3) fallback: try parsing textual fields
    if "alarmName" in detail:
        # no instance id here, skip
        pass

    return None

def launch_replacement_instance(old_instance_id):
    # Describe the old instance to copy config (AMI, instance type, subnet, security groups)
    resp = ec2.describe_instances(InstanceIds=[old_instance_id])
    reservations = resp.get("Reservations", [])
    if not reservations:
        raise Exception(f"Instance {old_instance_id} not found")

    inst = reservations[0]["Instances"][0]
    image_id = inst.get("ImageId")
    instance_type = inst.get("InstanceType")
    subnet_id = inst.get("SubnetId")
    sgs = [g["GroupId"] for g in inst.get("SecurityGroups", [])]

    # Launch a new instance with same ami/type/subnet/sgs
    new = ec2.run_instances(
        ImageId=image_id,
        InstanceType=instance_type,
        SubnetId=subnet_id,
        SecurityGroupIds=sgs,
        MinCount=1,
        MaxCount=1,
        TagSpecifications=[{
            "ResourceType": "instance",
            "Tags": [
                {"Key": "Name", "Value": f"replaced-{old_instance_id}"},
                {"Key": "ReplacedFrom", "Value": old_instance_id},
                {"Key": "AutoHealing", "Value": "true"}
            ]
        }]
    )
    new_id = new["Instances"][0]["InstanceId"]
    return new_id

def publish_sns(message, subject="AutoHealing Notification"):
    if not SNS_TOPIC:
        logger.warning("SNS_TOPIC_ARN not set; skipping SNS publish")
        return
    try:
        sns.publish(TopicArn=SNS_TOPIC, Subject=subject, Message=message)
    except Exception as e:
        logger.exception("Failed to publish SNS message: %s", e)

def lambda_handler(event, context):
    logger.info("Received event: %s", json.dumps(event))
    try:
        instance_id = extract_instance_id_from_event(event)
        if not instance_id:
            msg = "No instance id found in event; skipping"
            logger.error(msg)
            publish_sns(msg, subject="AutoHealing: No instance id")
            return {"status": "no-instance-id"}

        # Optionally: mark old instance as terminating (or do snapshot), then create replacement
        msg = f"Attempting to replace instance {instance_id}"
        logger.info(msg)
        publish_sns(msg, subject="AutoHealing: Started replacement")

        new_id = launch_replacement_instance(instance_id)
        msg2 = f"Replaced {instance_id} with {new_id}"
        logger.info(msg2)
        publish_sns(msg2, subject="AutoHealing: Replacement complete")
        return {"status": "ok", "new_instance": new_id}

    except Exception as err:
        logger.exception("Error in auto healing")
        publish_sns(f"AutoHealing error: {str(err)}", subject="AutoHealing: Error")
        raise