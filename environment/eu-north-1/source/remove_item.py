import json
import boto3
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["DYNAMODB_TABLE_NAME"])


def lambda_handler(event, context):
    product = json.loads(event["body"])
    userId = event["requestContext"]["authorizer"]["claims"]["sub"]

    pk = userId
    sk = "product#" + product["id"]

    print("pk", type(pk), pk)
    print("sk", type(sk), sk)

    delete_item = table.delete_item(Key={"pk": pk, "sk": sk})

    response = {
        "statusCode": 200,
        "headers": {"Access-Control-Allow-Origin": "*"},
        "body": json.dumps(delete_item),
    }

    return response
