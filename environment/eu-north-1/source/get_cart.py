import json
import boto3
from boto3.dynamodb.conditions import Key
import os

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["DYNAMODB_TABLE_NAME"])


def lambda_handler(event, context):
    query_params = event["queryStringParameters"]
    userId = event["requestContext"]["authorizer"]["claims"]["sub"]

    pk = userId

    response = table.query(
        KeyConditionExpression=Key("pk").eq(pk) & Key("sk").begins_with("product#"),
        ProjectionExpression="sk,productName,productDetails",
    )
    product_list = response.get("Items", [])

    for product in product_list:
        product["id"] = product["sk"].replace("product#", "")
        del product["sk"]

        product["name"] = product.pop("productName")

        product_details = json.loads(product.pop("productDetails"))
        product.update(product_details)

    response = {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET",
        },
        "body": json.dumps(product_list),
    }

    return response
