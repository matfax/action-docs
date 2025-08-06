#!/bin/bash
set -e

path=$(readlink -f "${BASH_SOURCE:-$0}")
DIR_PATH=$(dirname "$path")

# shellcheck source=/dev/null
source "${DIR_PATH}/utils.sh"

update_doc() {
    debug_message "Into update_doc"
    
    WORKING_DIR="${1}"
    TEMPLATE_FILE="${2}"
    
    # Use absolute path for template if it's relative
    if [[ "${TEMPLATE_FILE}" == ./* ]]; then
        TEMPLATE_FILE="${GITHUB_ACTION_PATH}/${TEMPLATE_FILE#./}"
    fi
    
    debug_message "WORKING_DIR: [ $WORKING_DIR ]"
    debug_message "TEMPLATE_FILE: [ $TEMPLATE_FILE ]"

    if [ ! -f "${WORKING_DIR}/action.yml" ]; then
        echo "::error::action.yml does not exist in ${WORKING_DIR}"
        exit 2
    fi

    echo "Create the documentation"
    gomplate -d action="${WORKING_DIR}/action.yml" -f "${TEMPLATE_FILE}" -o /tmp/action_doc.md

    # Create README.md if it doesn't exist
    if [ ! -f "${WORKING_DIR}/README.md" ]; then
        gomplate -d action="${WORKING_DIR}/action.yml" -f "${GITHUB_ACTION_PATH}/src/README.tpl" -o "${WORKING_DIR}/README.md"
    fi

    HAS_ACTION_DOCS=$(grep -E '(BEGIN|END)_ACTION_DOCS' "${WORKING_DIR}/README.md" | wc -l)

    # Verify it has BEGIN and END markers
    if [ "${HAS_ACTION_DOCS}" -ne 2 ]; then
        echo "::error::README.md does not contain <!--- BEGIN_ACTION_DOCS ---> and <!--- END_ACTION_DOCS --->"
        exit 3
    fi

    sed -i -ne '/<!--- BEGIN_ACTION_DOCS --->/ {p; r /tmp/action_doc.md' -e ':a; n; /<!--- END_ACTION_DOCS --->/ {p; b}; ba}; p' "${WORKING_DIR}/README.md"

    debug_message "End update_doc"
}

git_changed() {
    debug_message "Into git_changed"
    
    GIT_FILES_CHANGED=$(git status --porcelain | grep -E '([MA]\W).+' | wc -l)
    echo "num_changed=${GIT_FILES_CHANGED}" >> $GITHUB_OUTPUT
    
    debug_message "Files changed: ${GIT_FILES_CHANGED}"
    debug_message "End git_changed"
}

# Main execution
cd $GITHUB_WORKSPACE

update_doc "${INPUT_ACTION_DOCS_WORKING_DIR}" "${INPUT_ACTION_DOCS_TEMPLATE_FILE}"
git_changed

exit 0