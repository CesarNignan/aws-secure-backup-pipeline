import json
import boto3
import urllib.parse
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('backup-log')

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    
    for record in event['Records']:
        bucket = record['s3']['bucket']['name']
        key = urllib.parse.unquote_plus(record['s3']['object']['key'], encoding='utf-8')
        size = record['s3']['object'].get('size', 0)
        event_time = record['eventTime']
        
        backup_id = key.split('/')[-1] if '/' in key else key
        
        item = {
            'backup_id': backup_id,
            'bucket_name': bucket,
            'object_key': key,
            'file_size_bytes': size,
            'uploaded_at': event_time,
            'logged_at': datetime.utcnow().isoformat()
        }
        
        table.put_item(Item=item)
        print(f"Successfully logged backup {backup_id} to DynamoDB.")
        
    return {
        'statusCode': 200,
        'body': json.dumps('Backup log recorded successfully!')
    }
