#!/usr/bin/env bats

setup() {
    path=$(pwd)
    DIR_PATH=$(dirname "$path")

    export SRC_BASE_DIR="${DIR_PATH}/src"
    export DEBUG="true"
    export INPUT_ACTION_DOCS_TEMPLATE_FILE="${DIR_PATH}/src/default_template.tpl"
    export INPUT_ACTION_DOCS_GIT_COMMIT_MESSAGE="Automatic commit"
    
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
    load './fixtures.bash'
}

teardown() {
    echo "clean temp dir"
    rm -rf "${BATS_TEST_DIRNAME}/tmp"  
}

setup_file() {
    # cd into the directory containing the bats file    
    cd "$BATS_TEST_DIRNAME" || exit 1
    echo "$BATS_TEST_DIRNAME"
}

teardown_file() {
    echo "clean temp dir"
    rm -rf "${BATS_TEST_DIRNAME}/tmp"
}

@test "Should generate README.md" {

    export GITHUB_WORKSPACE="${BATS_TEST_DIRNAME}/tmp/local"
    export INPUT_ACTION_DOCS_WORKING_DIR="${GITHUB_WORKSPACE}"
    export INPUT_ACTION_DOCS_DEBUG_MODE='true'
    export GITHUB_ACTION_PATH="${DIR_PATH}"
    export GITHUB_OUTPUT="/tmp/github_output"
    
    # Create output file
    touch "$GITHUB_OUTPUT"
 
    config_test_env "$GITHUB_WORKSPACE"

    run "${SRC_BASE_DIR}/generate-docs.sh"

    assert_success
    assert_output --partial "Create the documentation"
    
    # Check that num_changed was written to GITHUB_OUTPUT
    run grep "num_changed=1" "$GITHUB_OUTPUT"
    assert_success
}

@test "Should detect no changes when README.md already up to date" {

    export GITHUB_WORKSPACE="${BATS_TEST_DIRNAME}/tmp/local"
    export INPUT_ACTION_DOCS_WORKING_DIR="${GITHUB_WORKSPACE}"
    export INPUT_ACTION_DOCS_DEBUG_MODE='true'
    export GITHUB_ACTION_PATH="${DIR_PATH}"
    export GITHUB_OUTPUT="/tmp/github_output_2"
    
    # Create output file
    touch "$GITHUB_OUTPUT"
 
    config_test_env "$GITHUB_WORKSPACE"
    
    # Run twice to ensure second run detects no changes
    "${SRC_BASE_DIR}/generate-docs.sh"
    
    # Clear output file for second run
    > "$GITHUB_OUTPUT"
    
    run "${SRC_BASE_DIR}/generate-docs.sh"

    assert_success
    
    # Check that num_changed was 0 on second run
    run grep "num_changed=0" "$GITHUB_OUTPUT"
    assert_success
}