#! /bin/sh

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

if [ "$#" -lt	3 ];
then
  echo "${RED}Required arugments are missing, please check the documentation at: https://github.com/samiahmedsiddiqui/sync-repos#any-other-branch${NC}"
  # terminate
  exit 1
fi

# Set sync FROM repo
SYNC_FROM_REPO=$1

# Set sync FROM branch
SYNC_FROM_BRANCH=$2

# Set sync TO repo
SYNC_TO_REPO=$3

# Set sync TO branch same as FROM branch
SYNC_TO_BRANCH=$2

COMMIT_MESSAGE="Sync with ${SYNC_FROM_REPO} repo"

if [ $4 ];
then
  # Set sync TO branch
  SYNC_TO_BRANCH=$4
fi

if [ $5 ];
then
  COMMIT_MESSAGE=${@:5}
fi

if [[ $SYNC_FROM_REPO == git@* ]];
then
  IFS=':' read -ra REPO <<< "$SYNC_FROM_REPO"
  SYNC_FROM_NAME=${REPO[@]:1}
  SYNC_FROM_NAME=${SYNC_FROM_NAME/.git}
else
  IFS='/' read -ra REPO <<< "$SYNC_FROM_REPO"
  SYNC_FROM_NAME=${REPO[@]:3}
  SYNC_FROM_NAME=${SYNC_FROM_NAME/.git}
  SYNC_FROM_NAME=`echo "${SYNC_FROM_NAME}" | sed 's/\ /\//g'`
fi

if [[ $SYNC_TO_REPO == git@* ]];
then
  IFS=':' read -ra REPO <<< "$SYNC_TO_REPO"
  SYNC_TO_NAME=${REPO[@]:1}
  SYNC_TO_NAME=${SYNC_TO_NAME/.git}
else
  IFS='/' read -ra REPO <<< "$SYNC_TO_REPO"
  SYNC_TO_NAME=${REPO[@]:3}
  SYNC_TO_NAME=${SYNC_TO_NAME/.git}
  SYNC_TO_NAME=`echo "${SYNC_TO_NAME}" | sed 's/\ /\//g'`
fi

# Add timestamp in temporary directory
TEMP_DIR="samiahmedsiddiqui-$(date +%s)"

# Create temporary directory for clone and sync
mkdir ${TEMP_DIR}

# Enter in temporary directory
cd ${TEMP_DIR}

# Clone (sync FROM) repo
git clone -b ${SYNC_FROM_BRANCH} ${SYNC_FROM_REPO} ${SYNC_FROM_NAME}

if [ ! -d ${SYNC_FROM_NAME} ];
then
  echo "${RED}${SYNC_FROM_REPO} repo or ${SYNC_FROM_BRANCH} branch does not exist${NC}"
  # Move out from the temporary directory
  cd ..
  # Deleting temporary directory
  rm -rf ${TEMP_DIR}
  exit 1
fi

# Clone (sync TO) repo
git clone ${SYNC_TO_REPO} ${SYNC_TO_NAME}

if [ ! -d ${SYNC_TO_NAME} ];
then
  echo "${RED}${SYNC_TO_REPO} repo does not exist${NC}"
  # Move out from the temporary directory
  cd ..
  # Deleting temporary directory
  rm -rf ${TEMP_DIR}
  exit 1
fi

# Move to `sync TO` directory
cd ${SYNC_TO_NAME}

# Checkout to a branch that needs to be synced (if not exist then create a new branch)
git checkout -B ${SYNC_TO_BRANCH}

# Sync everything if file doesn't exisst ooon source then it gets deleted
rsync -r --delete --exclude=.git ../../${SYNC_FROM_NAME}/ ./

# Add all changes to stage
git add -A

# Captures a snapshot of the project's currently staged changes
git commit -m "${COMMIT_MESSAGE}"

# Push changes to the upstream
git push --set-upstream origin ${SYNC_TO_BRANCH}

# Move out from the temporary directory
cd ../../..

# Deleting temporary directory
rm -rf ${TEMP_DIR}

echo "${GREEN}${SYNC_TO_BRANCH} branch of ${SYNC_TO_NAME} repo gets synced with the ${SYNC_FROM_BRANCH} branch of ${SYNC_FROM_NAME}${NC}"
exit 0
