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

if [[ $syncFromRepo == git@* ]];
then
  IFS=':' read -ra REPO <<< "$syncFromRepo"
  syncFromName=${REPO[@]:1}
  syncFromName=${syncFromName/.git}
else
  IFS='/' read -ra REPO <<< "$syncFromRepo"
  syncFromName=${REPO[@]:3}
  syncFromName=${syncFromName/.git}
  syncFromName=`echo "${syncFromName}" | sed 's/\ /\//g'`
fi

if [[ $syncToRepo == git@* ]];
then
  IFS=':' read -ra REPO <<< "$syncToRepo"
  syncToName=${REPO[@]:1}
  syncToName=${syncToName/.git}
else
  IFS='/' read -ra REPO <<< "$syncToRepo"
  syncToName=${REPO[@]:3}
  syncToName=${syncToName/.git}
  syncToName=`echo "${syncToName}" | sed 's/\ /\//g'`
fi

# Add timestamp in temporary directory
tempDir="samiahmedsiddiqui-$(date +%s)"

# Create temporary directory for clone and sync
mkdir ${tempDir}

# Enter in temporary directory
cd ${tempDir}

# Clone (sync FROM) repo
git clone -b ${syncFromBranch} ${syncFromRepo} ${syncFromName}

if [ ! -d ${syncFromName} ];
then
  echo "${RED}${syncFromRepo} repo or ${syncFromBranch} branch does not exist${NC}"
  # Move out from the temporary directory
  cd ..
  # Deleting temporary directory
  rm -rf ${tempDir}
  exit 1
fi

# Clone (sync TO) repo
git clone ${syncToRepo} ${syncToName}

if [ ! -d ${syncToName} ];
then
  echo "${RED}${syncToRepo} repo does not exist${NC}"
  # Move out from the temporary directory
  cd ..
  # Deleting temporary directory
  rm -rf ${tempDir}
  exit 1
fi

# Move to `sync TO` directory
cd ${syncToName}

# Checkout to a branch that needs to be synced (if not exist then create a new branch)
git checkout -B ${syncToBranch}

# Sync everything if file doesn't exisst ooon source then it gets deleted
rsync -r --delete --exclude=.git ../../${syncFromName}/ ./

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

echo "${GREEN}${syncToBranch} branch of ${syncToName} repo gets synced with the ${syncFromBranch} branch of ${syncFromName}${NC}"
exit 0
