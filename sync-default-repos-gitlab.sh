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

# Set sync TO repo
syncToRepo=$2

commitMsg="Sync with ${syncFromRepo} repo"

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
git clone "https://gitlab.com/${syncFromRepo}.git" ${syncFromRepo}

if [ ! -d ${syncFromRepo} ];
then
  echo "${RED}${syncFromRepo} repo does not exist${NC}"
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

# Sync everything if file doesn't exisst ooon source then it gets deleted
rsync -r --delete --exclude=.git ../../${syncFromRepo}/ ./

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

echo "${GREEN}Default branch of ${syncToRepo} repo gets synced with the default branch of ${syncFromRepo}${NC}"
exit 0
