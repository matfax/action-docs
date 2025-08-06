#!/bin/bash
set -e

path=$(readlink -f "${BASH_SOURCE:-$0}")
DIR_PATH=$(dirname "$path")

# shellcheck source=/dev/null
source "${DIR_PATH}/utils.sh"

git_changed() {
    debug_message "Into git_changed"
    
    GIT_FILES_CHANGED=$(git status --porcelain | grep -E '([MA]\W).+' | wc -l)
    echo "num_changed=${GIT_FILES_CHANGED}" >> $GITHUB_OUTPUT
    
    debug_message "Files changed: ${GIT_FILES_CHANGED}"
    debug_message "End git_changed"
}

# Main execution
cd $GITHUB_WORKSPACE

git_changed

exit 0