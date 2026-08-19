# 🌐 Static Website Hosting with S3 & CloudFront

![Terraform](https://img.shields.io/badge/Terraform-1.x-7B42BC?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-S3%20%26%20CloudFront-FF9900?logo=amazonaws&logoColor=white)
![CloudFront](https://img.shields.io/badge/CloudFront-CDN-232F3E?logo=amazonaws&logoColor=white)

## 📖 Overview

This project demonstrates **secure static website hosting** on AWS using S3 and CloudFront. The entire infrastructure is provisioned using **Infrastructure as Code (IaC)** with Terraform. The S3 bucket is completely private and only accessible through CloudFront, providing optimal security and performance.

<p align="center">
  <img width="731" height="301" alt="Untitled Diagram drawio (1)" src="https://github.com/user-attachments/assets/8dac3099-28d1-4cca-95ca-6e7b4c68afc6" />
</p>

### 🎯 Key Features

- ✅ **Secure Architecture** – S3 bucket is private, accessible only via CloudFront
- ✅ **Global CDN** – CloudFront delivers content worldwide with edge caching
- ✅ **Infrastructure as Code** – Complete infrastructure defined in Terraform

## 📸 Screenshots

<img width="1920" height="1080" alt="Screenshot 2026-08-19 102112" src="https://github.com/user-attachments/assets/a433c0fd-3fe8-4b9b-a396-df6a062d0e8c" />
<img width="1920" height="1020" alt="Screenshot 2026-08-19 102320" src="https://github.com/user-attachments/assets/bc697ccc-94bb-410d-9a7b-f9fba0076757" />
<img width="1920" height="1020" alt="Screenshot 2026-08-19 102146" src="https://github.com/user-attachments/assets/de86129b-31b9-4fe1-b40a-4bb6875809ee" />

## 📋 Infrastructure Components

| Component | Description | Purpose |
|:---|:---|:---|
| **S3 Bucket** | Private storage for static files | Stores HTML, CSS, JS files |
| **Public Access Block** | All public access disabled | Security - no direct S3 access |
| **Origin Access Control** | CloudFront → S3 authentication | Secure access mechanism |
| **S3 Bucket Policy** | Allows only CloudFront to read | Restricts access to CDN only |
| **CloudFront Distribution** | Global CDN with caching | Fast content delivery worldwide |
| **SSL Certificate** | Default CloudFront certificate | Enables HTTPS connections |

## 🚀 Getting Started

### Prerequisites

| Tool | Purpose | Installation Link |
|:---|:---|:---|
| **Terraform** | Infrastructure as Code | [Terraform Download](https://www.terraform.io/downloads) |
| **AWS CLI** | AWS interaction | [AWS CLI Install](https://aws.amazon.com/cli/) |
| **Git** | Version control | [Git Download](https://git-scm.com/downloads) |

### AWS Account Setup

**1. Create an IAM User**
- Go to AWS Console → IAM → Users → Create user
- Username: `terraform-user`
- Attach policies: `AmazonS3FullAccess`, `CloudFrontFullAccess`

**2. Generate Access Keys**
- Click on the user → Security credentials → Create access key
- Copy and save:
  - `Access Key ID`
  - `Secret Access Key`
- ⚠️ **Never share these keys publicly!**

**3. Configure AWS CLI**
```bash
aws configure
# Enter Access Key ID
# Enter Secret Access Key
# Region: us-east-1 (or your preferred region)
# Output format: json
```
### Deploy Infrastructure

**Initialize Terraform**
```bash
terraform init
```
**Review what will be created**
```bash
terraform plan
```
**Deploy the infrastructure**
```bash
terraform apply -auto-approve
```
## 📚 What I Learned

- ✅ **Infrastructure as Code** – Terraform best practices for AWS resource provisioning
- ✅ **Cloud Security** – Implementing private S3 buckets with CloudFront OAC
- ✅ **CDN Architecture** – Global content delivery with edge caching strategies
- ✅ **AWS Automation** – Complete infrastructure automation with Terraform
- ✅ **Cost Optimization** – Using Price Class 100 for most cost-effective CDN
- ✅ **DevOps Best Practices** – Security, automation, and infrastructure management

---

⭐ Star this repository if you found it helpful!

## 📊 Project Status

[![GitHub last commit](https://img.shields.io/github/last-commit/BhathiyaVicum/s3-static-web-host)](https://github.com/yourusername/terraform-s3-cloudfront)
[![GitHub repo size](https://img.shields.io/github/repo-size/BhathiyaVicum/s3-static-web-host)](https://github.com/yourusername/terraform-s3-cloudfront)
[![GitHub stars](https://img.shields.io/github/stars/BhathiyaVicum/s3-static-web-host)](https://github.com/yourusername/terraform-s3-cloudfront)
