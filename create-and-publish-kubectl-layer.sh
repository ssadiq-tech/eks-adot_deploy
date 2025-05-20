#!/bin/bash

set -e

# Variables
KUBECTL_VERSION="v1.29.2"
LAYER_NAME="AWSLambdaKubernetesLayer"
REGION="us-east-1"
BUCKET_NAME="your-s3-bucket-name"   # <--- replace this with your actual S3 bucket
ZIP_FILE="kubectl-layer.zip"
S3_KEY="lambda-layers/$ZIP_FILE"

echo "📦 Downloading kubectl $KUBECTL_VERSION..."
curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"

chmod +x kubectl

echo "📂 Packaging kubectl into layer directory structure..."
mkdir -p kubectl-layer/bin
mv kubectl kubectl-layer/bin/

echo "🗜️ Zipping the layer..."
zip -r $ZIP_FILE kubectl-layer/

echo "☁️ Uploading zip to S3 bucket $BUCKET_NAME..."
aws s3 cp $ZIP_FILE s3://$BUCKET_NAME/$S3_KEY --region $REGION

echo "📣 Publishing Lambda Layer from S3..."
LAYER_VERSION_ARN=$(aws lambda publish-layer-version \
  --layer-name $LAYER_NAME \
  --description "kubectl $KUBECTL_VERSION for EKS CDK deployments" \
  --content S3Bucket=$BUCKET_NAME,S3Key=$S3_KEY \
  --compatible-runtimes nodejs14.x nodejs16.x python3.9 \
  --region $REGION \
  --query 'LayerVersionArn' --output text)

echo "✅ Lambda Layer published successfully!"
echo "🔗 Layer Version ARN: $LAYER_VERSION_ARN"

# Clean up
rm -rf kubectl-layer $ZIP_FILE

echo "🧹 Cleanup done!"
