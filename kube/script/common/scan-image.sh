#!bin/bash
set -e

if [ -n "$BITBUCKET_TAG" ]; then
  transformed_tag=$(echo "$BITBUCKET_TAG" | sed 's/-uat$//')
  export TAG_VERSION=$transformed_tag
else
  export TAG_VERSION="dev-${BITBUCKET_COMMIT}"
fi
export AWS_DEFAULT_REGION='ap-southeast-1'
export TAG="${AWS_ECR_URI}/${SERVICE_NAME}:${TAG_VERSION}"
trivy --version
trivy \
  --severity=HIGH,CRITICAL \
  --format=table \
  --exit-code=1 \
  --quiet \
  image $TAG \
  --ignore-unfixed
