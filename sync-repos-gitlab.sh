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
syncFromRepo=$1

# Set sync FROM branch
syncFromBranch=$2

# Set sync TO repo
syncToRepo=$3

# Set sync TO branch same as FROM branch
syncToBranch=$2

commitMsg="Sync with ${syncFromRepo} repo"

if [ $4 ];
then
  # Set sync TO branch
  syncToBranch=$4
fi

if [ $5 ];
then
  commitMsg=${@:5}
fi

# Add timestamp in temporary directory
tempDir="samiahmedsiddiqui-$(date +%s)"

# Create temporary directory for clone and sync
mkdir ${tempDir}

# Enter in temporary directory
cd ${tempDir}

# Clone (sync FROM) repo
git clone -b ${syncFromBranch} "https://gitlab.com/${syncFromRepo}.git" ${syncFromRepo}

if [ ! -d ${syncFromRepo} ];
then
  echo "${RED}${syncFromRepo} repo or ${syncFromBranch} branch does not exist${NC}"
  # Move out from the temporary directory
  cd ..
  # Deleting temporary directory
  rm -rf ${tempDir}
  exit 1
fi

# Clone (sync TO) repo
git clone "https://gitlab.com/${syncToRepo}.git" ${syncToRepo}

if [ ! -d ${syncToRepo} ];
then
  echo "${RED}${syncToRepo} repo does not exist${NC}"
  # Move out from the temporary directory
  cd ..
  # Deleting temporary directory
  rm -rf ${tempDir}
  exit 1
fi

# Move to `sync TO` directory
cd ${syncToRepo}

# Checkout to a branch that needs to be synced (if not exist then create a new branch)
git checkout -B ${syncToBranch}

# Sync everything if file doesn't exisst ooon source then it gets deleted
rsync -r --delete --exclude=.git ../../${syncFromRepo}/ ./

# Add all changes to stage
git add -A

# Captures a snapshot of the project's currently staged changes
git commit -m "${commitMsg}"

# Push changes to the upstream
git push --set-upstream origin ${syncToBranch}

# Move out from the temporary directory
cd ../../..

# Deleting temporary directory
rm -rf ${tempDir}

echo "${GREEN}${syncToBranch} branch of ${syncToRepo} repo gets synced with ${syncFromBranch} branch of ${syncFromRepo}${NC}"
exit 0
