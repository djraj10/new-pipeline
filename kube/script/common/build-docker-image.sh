#!bin/bash
set -e

pip3 install awscli
if [ -n "$BITBUCKET_TAG" ]; then
  transformed_tag=$(echo "$BITBUCKET_TAG" | sed 's/-uat$//')
  export TAG_VERSION=$transformed_tag
else
  export TAG_VERSION="dev-${BITBUCKET_COMMIT}"
fi
export TAG="${AWS_ECR_URI}/${SERVICE_NAME}:${TAG_VERSION}"
git submodule update --init
aws ecr get-login-password --region ap-southeast-1 | docker login --username AWS --password-stdin ${AWS_ECR_URI}
docker build -t $TAG .
docker push $TAG
docker rmi $TAG
docker logout
