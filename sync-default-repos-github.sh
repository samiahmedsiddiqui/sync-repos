#! /bin/sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

if [ "$#" -lt	2 ];
then
  echo "${RED}Required arugments are missing, please check the documentation at: https://github.com/samiahmedsiddiqui/sync-repos#default-branch${NC}"
  # terminate
  exit 1
fi

# Set sync FROM repo
SYNC_FROM_REPO=$1

# Set sync TO repo
SYNC_TO_REPO=$2

COMMIT_MESSAGE="Sync with ${SYNC_FROM_REPO} repo"

if [ $3 ];
then
  COMMIT_MESSAGE=${@:3}
fi

# Add timestamp in temporary directory
TEMP_DIR="samiahmedsiddiqui-$(date +%s)"

# Create temporary directory for clone and sync
mkdir ${TEMP_DIR}

# Enter in temporary directory
cd ${TEMP_DIR}

# Clone (sync FROM) repo
git clone "https://github.com/${SYNC_FROM_REPO}.git" ${SYNC_FROM_REPO}

if [ ! -d ${SYNC_FROM_REPO} ];
then
  echo "${RED}${SYNC_FROM_REPO} repo does not exist${NC}"
  # Move out from the temporary directory
  cd ..
  # Deleting temporary directory
  rm -rf ${TEMP_DIR}
  exit 1
fi

# Clone (sync TO) repo
git clone "https://github.com/${SYNC_TO_REPO}.git" ${SYNC_TO_REPO}

if [ ! -d ${SYNC_TO_REPO} ];
then
  echo "${RED}${SYNC_TO_REPO} repo does not exist${NC}"
  # Move out from the temporary directory
  cd ..
  # Deleting temporary directory
  rm -rf ${TEMP_DIR}
  exit 1
fi

# Move to `sync TO` directory
cd ${SYNC_TO_REPO}

# Sync everything if file doesn't exisst ooon source then it gets deleted
rsync -r --delete --exclude=.git ../../${SYNC_FROM_REPO}/ ./

# Add all changes to stage
git add -A

# Captures a snapshot of the project's currently staged changes
git commit -m "${COMMIT_MESSAGE}"

# Push changes to the upstream
git push

# Move out from the temporary directory
cd ../../..

# Deleting temporary directory
rm -rf ${TEMP_DIR}

echo "${GREEN}Default branch of ${SYNC_TO_REPO} repo gets synced with the default branch of ${SYNC_FROM_REPO}${NC}"
exit 0
