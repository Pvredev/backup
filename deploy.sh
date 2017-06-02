#!/usr/bin/env bash

stackName=$1
stackTemplateFile=$2
stackParamsFile=$3

if [ -z "$( aws cloudformation describe-stacks --stack-name $stackName 2>/dev/null )" ]; then
  action="create-stack --disable-rollback"
else
  action="update-stack"
fi

aws cloudformation $action \
  --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM \
  --stack-name $stackName \
  --template-body "file://${stackTemplateFile}" \
  --parameters "file://${stackParamsFile}" > /dev/null
