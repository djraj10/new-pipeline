#!bin/bash
set -e

export SSH_KEY=$HARBOR_SSH_KEY
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config
echo -n ${SSH_KEY} | base64 -d > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa
