#!/bin/sh
# Usage:
#
# $0 artifact pomFile
#   - or -
# $0 artifact groupId artifactId version [packaging]

REPO_URL=...
REPO_ID=...

#mvn deploy:deploy-file \
#    -Durl=${REPO_URL} \
#    -DrepositoryId=${REPO_ID} \
#    -Dfile=${1} \
#    -DpomFile=${2}

mvn deploy:deploy-file \
    -Durl=${REPO_URL} \
    -DrepositoryId=${REPO_ID} \
    -Dfile=${1} \
    -DgroupId=${2} \
    -DartifactId=${3} \
    -Dversion=${4} \
    -Dpackaging=${5}
