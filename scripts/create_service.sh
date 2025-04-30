#!/bin/bash

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

# First register the task definition
TASK_DEF_ARN=$(aws ecs register-task-definition --cli-input-json file://task_def.json --query 'taskDefinition.taskDefinitionArn' --output text)

# Then create the service using the task definition ARN
aws ecs create-service \
  --cluster killshot \
  --service-name ci_node_app \
  --task-definition "$TASK_DEF_ARN" \
  --launch-type EC2 \
  --desired-count 1