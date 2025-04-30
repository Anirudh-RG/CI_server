#!/bin/bash 
set -e  # Exit immediately if a command exits with a non-zero status

# Set AWS region explicitly
AWS_REGION="ap-south-1"
CLUSTER_NAME="killshot"
SERVICE_NAME="ci_node_app"

echo "Creating ECS task definition..."

# Create the task definition JSON inline
cat > task_def.json << EOF
{
  "family": "node-app",
  "containerDefinitions": [
    {
      "name": "nodejs-container",
      "image": "public.ecr.aws/c5d4m2m5/nodejs/sserver:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "tcp"
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ],
  "requiresCompatibilities": [
    "EC2"
  ],
  "networkMode": "bridge"
}
EOF

echo "Registering task definition..."

# Register the task definition with explicit region
TASK_DEF_ARN=$(aws ecs register-task-definition \
  --region $AWS_REGION \
  --cli-input-json file://task_def.json \
  --query 'taskDefinition.taskDefinitionArn' \
  --output text)

echo "Task definition registered with ARN: $TASK_DEF_ARN"

# Check if the service already exists
SERVICE_EXISTS=$(aws ecs describe-services \
  --region $AWS_REGION \
  --cluster $CLUSTER_NAME \
  --services $SERVICE_NAME \
  --query 'services[?status!=`INACTIVE`].status' \
  --output text || echo "")

if [ -z "$SERVICE_EXISTS" ]; then
  echo "Service does not exist. Creating new ECS service..."
  # Create the service using the task definition ARN
  aws ecs create-service \
    --region $AWS_REGION \
    --cluster $CLUSTER_NAME \
    --service-name $SERVICE_NAME \
    --task-definition "$TASK_DEF_ARN" \
    --launch-type EC2 \
    --desired-count 1
  
  echo "Service creation completed successfully!"
else
  echo "Service already exists. Updating ECS service..."
  # Update the existing service with the new task definition
  aws ecs update-service \
    --region $AWS_REGION \
    --cluster $CLUSTER_NAME \
    --service $SERVICE_NAME \
    --task-definition "$TASK_DEF_ARN" \
    --desired-count 1 \
    --force-new-deployment
  
  echo "Service update completed successfully!"
fi