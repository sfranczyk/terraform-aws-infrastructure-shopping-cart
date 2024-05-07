import json
import boto3
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["DYNAMODB_TABLE_NAME"])


def lambda_handler(event, context):
    product = json.loads(event["body"])
    userId = event["requestContext"]["authorizer"]["claims"]["sub"]

    pk = userId
    sk = product.pop("id")
    name = product.pop("name")

    put_item = table.put_item(
        Item={
            "pk": pk,
            "sk": f"product#{sk}",
            "productName": name,
            "productDetails": json.dumps(product),
        }
    )

    response = {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Origin": "*",
        },
        "body": json.dumps(put_item),
    }

    return response
