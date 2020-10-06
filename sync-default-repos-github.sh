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

if [ $3 ];
then
  COMMIT_MESSAGE=${@:3}
else
  # Set default commit message
  COMMIT_MESSAGE="Sync from ${SYNC_FROM_REPO}"
fi

# Add timestamp in temporary directory
TEMP_DIR="samiahmedsiddiqui-$(date +%s)"

# Save directory path for later use (To delete temporary directory)
DIR_PATH=`PWD`

# Create temporary directory for clone and sync
mkdir $TEMP_DIR

# Enter in temporary directory
cd $TEMP_DIR

delete_temp_dir () {
  # Move out from the temporary directory
  cd $DIR_PATH

  # Deleting temporary directory
  rm -rf $TEMP_DIR
}

# Clone (sync FROM) repo
git clone "https://github.com/${SYNC_FROM_REPO}.git" $SYNC_FROM_REPO

if [ ! -d "$SYNC_FROM_REPO" ];
then
  echo "${RED}${SYNC_FROM_REPO}${NC} does not exist"

  # Delete temporary directory
  delete_temp_dir

  exit 1
fi

# Clone (sync TO) repo
git clone "https://github.com/${SYNC_TO_REPO}.git" $SYNC_TO_REPO

if [ ! -d "$SYNC_TO_REPO" ];
then
  echo "${RED}${SYNC_TO_REPO}${NC} does not exist"

  # Delete temporary directory
  delete_temp_dir

  exit 1
fi

# Move to `sync TO` directory
cd $SYNC_TO_REPO

# Sync everything from the the source, files on the target destination side to be
# deleted if they do not exist at the source
rsync -r --delete --exclude=.git ../../${SYNC_FROM_REPO}/ ./

STATUS=`git status`
if [[ $STATUS == *"Changes not staged for commit"* ]];
then
  # Add all changes to stage
  git add -A

  # Captures a snapshot of the project's currently staged changes
  git commit --quiet -m "$COMMIT_MESSAGE"

  # Push changes to the upstream
  git push --quiet

  echo "${GREEN}Default branch of ${SYNC_TO_REPO} gets synced from the default branch of ${SYNC_FROM_REPO}${NC}"
else
  echo "${GREEN}Nothing to commit, Everything is already up-to-date in default branch of ${SYNC_TO_REPO}${NC}"
fi

# Delete temporary directory
delete_temp_dir
exit 0
