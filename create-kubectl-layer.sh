#!/bin/bash

# Set variables
REGION="us-east-1"
ACCOUNT_ID="131332286832"
LAYER_NAME="AWSLambdaKubernetesLayer"
KUBECTL_VERSION="v1.29.0"
ZIP_FILE="kubectl-layer.zip"
LAYER_DIR="lambda-kubectl-layer"

# Clean up previous build
rm -rf $LAYER_DIR $ZIP_FILE

# Download kubectl binary
echo "🔽 Downloading kubectl $KUBECTL_VERSION..."
curl -Lo kubectl https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl
chmod +x kubectl

# Create layer directory structure
echo "📦 Creating Lambda Layer directory structure..."
mkdir -p $LAYER_DIR/bin
mv kubectl $LAYER_DIR/bin/

# Package the layer
echo "📦 Zipping the layer..."
cd $LAYER_DIR
zip -r ../$ZIP_FILE .
cd ..

# (Optional) Publish the layer to Lambda
# Uncomment this block if you want to auto-upload it

# echo "🚀 Publishing layer to AWS Lambda..."
# aws lambda publish-layer-version \
#   --layer-name $LAYER_NAME \
#   --description "Kubectl $KUBECTL_VERSION for EKS CDK deployments" \
#   --zip-file fileb://$ZIP_FILE \
#   --compatible-runtimes nodejs14.x nodejs16.x python3.9 \
#   --region $REGION

# echo "✅ Done. Uploaded layer to AWS."

# Clean up
# rm -rf $LAYER_DIR $ZIP_FILE

echo "🎉 Kubectl Lambda Layer is ready: $ZIP_FILE"
