#!/usr/bin/env bash

MAX_NUM_REPOSITORES=500
REPO_NAME=${1:-alexandria}
NUM_REPOSITORIES=`aws ecr list-images --repository-name $REPO_NAME | grep -c imageTag`
OLDEST_IMAGE_TAG=`aws ecr list-images --repository-name $REPO_NAME | grep imageTag | sort -t. -k 2,2n -k 3,3n | grep '[0-9]\.[0-9]\.[0-9]' | head -n 1`
REGEX='"[A-Za-z]+": "([0-9]+.[0-9]+.[0-9]+)"'

if [ "$NUM_REPOSITORIES" -gt "$MAX_NUM_REPOSITORES" ]; then
    if [[ "$OLDEST_IMAGE_TAG" =~ $REGEX ]]; then
        echo "Removing image tag: "${BASH_REMATCH[1]} "from repo" $REPO_NAME
        aws ecr batch-delete-image --repository-name $REPO_NAME --image-ids imageTag=${BASH_REMATCH[1]}
    else
        echo "Cannot find a valid image tag to remove. Please review manually"
    fi
fi
