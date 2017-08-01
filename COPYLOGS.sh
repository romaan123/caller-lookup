#!/usr/bin/env bash
##################################################################################
echo "SAVING LOGS..."
##################################################################################
LOG_REPO="test-logs"
PROJECT_REPO_NAME="caller-lookup"
JOB_DIR="/home/travis/Logs"
GIT_DIR="/home/travis/github"
BUILD_ARTIFACTS_ROOT="/home/travis/logs"
REPO_PATH="${GITHUB_PASSWORD}@github.com/${GITHUB_USERNAME}/${LOG_REPO}.git"
MESSAGE="${TRAVIS_COMMIT} (Job ${TRAVIS_JOB_NUMBER})"

LOG_JOB_PATH="${JOB_DIR}/${TRAVIS_JOB_NUMBER}"
echo "TEST JOB DATA DIRECTORY: ${LOG_JOB_PATH}"

GIT_JOB_PATH="${GIT_DIR}/${LOG_REPO}/${PROJECT_REPO_NAME}/${TRAVIS_JOB_NUMBER}"
echo "GIT JOB DATA DIRECTORY: ${GIT_JOB_PATH}"
mkdir -P ${GIT_JOB_PATH}

cd "${GIT_DIR}"
git init .
git config user.email "travis@travis-ci.org"
git config user.name "Travis CI"

echo "ADDING TO GIT [https://${REPO_PATH}] ..."
git clone https://${REPO_PATH}
cd "${LOG_REPO}"

echo "MOVING FILES... [${LOG_JOB_PATH} >> ${GIT_JOB_PATH}]"
mv -v "${LOG_JOB_PATH}" "${GIT_JOB_PATH}"

echo "ADDING FILES TO GIT... [${GIT_JOB_PATH}]"
git add "${GIT_JOB_PATH}"

echo "COMMITTING CHANGES... [${MESSAGE}]"
git commit -m ${MESSAGE}

echo "UPLOADING FILES..."
git remote add origin https://${REPO_PATH} > /dev/null 2>&1
git push origin master

echo "COMPLETE"
