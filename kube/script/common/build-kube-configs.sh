
#!bin/bash
set -e

echo "Helm version: $(helm version)"
if [[ "$BITBUCKET_TAG" =~ ^v-([0-9]+).([0-9]+).([0-9]+)-prod$ ]]; then
  transformed_tag=$(echo "$BITBUCKET_TAG" | sed 's/-prod$//')
  export TAG_VERSION=$transformed_tag
elif [[ "$BITBUCKET_TAG" =~ ^v-([0-9]+).([0-9]+).([0-9]+)-uat$ ]]; then
  transformed_tag=$(echo "$BITBUCKET_TAG" | sed 's/-uat$//')
  export TAG_VERSION=$transformed_tag
else
  export TAG_VERSION="dev-${BITBUCKET_COMMIT}"
fi
echo "Tag version: $TAG_VERSION"
helm template kube/${SERVICE_NAME} --values kube/${SERVICE_NAME}/${ENV_NAME}-values.yaml --set image_tag=$TAG_VERSION > kube/script/configs.yaml

