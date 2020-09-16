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
syncFromRepo=$1

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

# Set sync TO repo
syncToRepo=$2

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

commitMsg="Sync with ${syncFromName} repo"

if [ $3 ];
then
  commitMsg=${@:3}
fi

# Add timestamp in temporary directory
tempDir="samiahmedsiddiqui-$(date +%s)"

# Create temporary directory for clone and sync
mkdir ${tempDir}

# Enter in temporary directory
cd ${tempDir}

# Clone (sync FROM) repo
git clone ${syncFromRepo} ${syncFromName}

if [ ! -d ${syncFromName} ];
then
  echo "${RED}${syncFromRepo} repo does not exist${NC}"
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

# Sync everything if file doesn't exisst ooon source then it gets deleted
rsync -r --delete --exclude=.git ../../${syncFromName}/ ./

# Add all changes to stage
git add -A

# Captures a snapshot of the project's currently staged changes
git commit -m "${commitMsg}"

# Push changes to the upstream
git push

# Move out from the temporary directory
cd ../../..

# Deleting temporary directory
rm -rf ${tempDir}

echo "${GREEN}Default branch of ${syncToName} repo gets synced with the default branch of ${syncFromName}${NC}"
exit 0
