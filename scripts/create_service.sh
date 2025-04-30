#!/bin/bash 
set -e  # Exit immediately if a command exits with a non-zero status

# Set AWS region explicitly
AWS_REGION="ap-south-1"

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
# First register the task definition with explicit region
TASK_DEF_ARN=$(aws ecs register-task-definition \
  --region $AWS_REGION \
  --cli-input-json file://task_def.json \
  --query 'taskDefinition.taskDefinitionArn' \
  --output text)

echo "Task definition registered with ARN: $TASK_DEF_ARN"

echo "Creating ECS service..."
# Then create the service using the task definition ARN
aws ecs create-service \
  --region $AWS_REGION \
  --cluster killshot \
  --service-name ci_node_app \
  --task-definition "$TASK_DEF_ARN" \
  --launch-type EC2 \
  --desired-count 1

echo "Service creation completed successfully!"