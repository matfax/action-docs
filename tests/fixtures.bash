#!/bin/bash

config_test_env(){
    WORKING_DIR=$1

    # Create a simple working directory with the necessary files
    mkdir -p "$WORKING_DIR"
    cd "$WORKING_DIR"
    
    # Initialize git repository
    git init
    git config user.name "Test User"
    git config user.email "test@example.com"
    
    # Create the required files
    _init_readme
    cp ${DIR_PATH}/action.yml .
    
    # Stage files for git status to work correctly
    git add README.md action.yml
}

_init_readme(){
cat <<EOF > README.md
# Test Action

<!--- BEGIN_ACTION_DOCS --->
<!--- END_ACTION_DOCS --->
EOF
}

# mkdir -p test
# cd test

# create_remote_repo remote
# REMOTE_PATH="${BATS_TEST_DIRNAME}/tmp/remote"

# COMMIT=$(get_latest_commit $REMOTE_PATH)
# echo "$COMMIT"

# mkdir -p "${BATS_TEST_DIRNAME}/tmp/local" && cd "${BATS_TEST_DIRNAME}/tmp/local"
# git init
# git remote add origin "$REMOTE_PATH"
# git fetch --no-tags --prune --progress --no-recurse-submodules --depth=1 origin "$COMMIT":mabranche

# git branch -la
# git checkout mabranche
# echo 'fin' >> README.md
# git add README.md
# git commit -sm 'update readme'

# git push origin HEAD:main
# git log --first-parent
# ##############################

# # git checkout -b "test"
# # git fetch --unshallow

# rm -rf "${BATS_TEST_DIRNAME}/tmp"
