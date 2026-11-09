# Cost Analysis: Secure Automated Backup and Audit Pipeline

Prices checked on: 2026-11-09  
Region: EU (London) / `eu-west-2`  
Assumed Usage: Low-traffic demo environment (running active compute for demonstration hours, low request volume).

---

## 1. Summary
* **Estimated Monthly Cost:** ~$5.00 – $10.00 / month (depending on NAT Gateway runtime and EC2 instance hours).
* **Most Expensive Service:** Amazon VPC NAT Gateway (hourly charges).
* **Can this project stay free?** No. While S3, Lambda, and DynamoDB offer generous free tiers or low costs, Amazon EC2 and NAT Gateway incur fixed hourly costs regardless of traffic volume.

---

## 2. Cost Table

| Service | Role in this project | What you are charged for | Free allowance | Estimated monthly cost (Demo usage) | Source Link |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Amazon VPC (NAT Gateway)** | Enables outbound internet/AWS API access for private subnet | Hourly charge + data processing fee per GB | None | ~$33.00/mo if left running 24/7 (or ~$2–$5 for demo hours) | [AWS NAT Gateway Pricing](https://aws.amazon.com/vpc/pricing/) |
| **Amazon EC2 (`t3.micro`)** | Hosts bastion and private app server | Instance runtime per hour | 750 hours/month free for 12 months (New AWS accounts) | $0.00 (under 12-month free tier) or ~$8.61/mo per instance | [AWS EC2 Pricing](https://aws.amazon.com/ec2/pricing/on-demand/) |
| **Amazon S3 Standard** | Stores compressed backup archives | GB-month of storage + PUT request fees | None | < $0.01/mo | [AWS S3 Pricing](https://aws.amazon.com/s3/pricing/) |
| **Amazon DynamoDB** | Stores backup audit logs | On-demand write/read request units & storage | 25 GB storage + 25 WCU/RCU free always | $0.00 (well within free tier limits) | [AWS DynamoDB Pricing](https://aws.amazon.com/dynamodb/pricing/) |
| **AWS Lambda** | Triggers audit log entry on S3 upload | Number of requests and compute duration (GB-seconds) | 1 million requests per month free always | $0.00 (free tier) | [AWS Lambda Pricing](https://aws.amazon.com/lambda/pricing/) |
| **Amazon CloudWatch Logs** | Captures Lambda and system logs | Data ingestion and log storage GB | 5 GB ingestion / month free | $0.00 | [AWS CloudWatch Pricing](https://aws.amazon.com/cloudwatch/pricing/) |

---

## 3. Fixed Costs
* **NAT Gateway:** Charges $0.045 per hour plus $0.045 per GB processed. Even with zero traffic, running 24/7 costs ~32.85 per month.
* **EC2 Instances (`t3.micro`):** Charges ~$0.0118 per hour in London (`eu-west-2`) when running.

---

## 4. Pay-per-Use Costs
* **Amazon S3:** $0.024 per GB-month for storage and $0.005 per 1,000 PUT requests. Example: Storing 5 GB of backups with 4,320 uploads/month costs about $0.12 for storage and $0.02 for requests.
* **Amazon DynamoDB (On-Demand):** $0.625 per million write request units. Example: 4,320 backup audit records written per month costs approximately $0.003.

---

## 5. Optional Extras
* **Enhanced Monitoring / CloudWatch Alarms:** Free tier covers basic metrics; custom alarms cost $0.10/alarm/month.

---

## 6. Hidden Costs and Gotchas
* Leaving the NAT Gateway and EC2 instances running continuously after completing your demo.
* Backup archives accumulating in S3 indefinitely without a lifecycle policy to transition or expire old backups.

---

## 7. How to Avoid Surprise Bills
* Set up AWS Budgets to alert you if monthly spending exceeds $5.00.
* Immediately execute the cleanup checklist after your demonstration.

---

## 8. Cleanup Checklist
1. **Delete DynamoDB Table:** Go to DynamoDB > Tables > delete `backup-log`.
2. **Delete Lambda Function:** Go to Lambda > Functions > delete `backup-log-function`.
3. **Empty and Delete S3 Bucket:** Delete all objects in `semester-exam-314201983162-eu-west-2-an`, then delete the bucket.
4. **Terminate EC2 Instances:** Stop and terminate `private-app-server` and `semester-exam-bastion-host`.
5. **Delete VPC Resources:** Delete NAT Gateway, Internet Gateway, subnets, and `semester-exam-vpc` to stop hourly NAT charges.

---

## 9. Assumptions and Disclaimer
Assumes low-traffic demo usage with 10-minute backup intervals. Prices are subject to change by AWS and vary by region. Consult the official [AWS Pricing Calculator](https://calculator.aws/) for exact enterprise estimates.
