#!/bin/bash
set -e

debug_message(){
    msg="$1"
    if [ "$INPUT_DEBUG_MODE" == "true" ];then
        echo "$msg"
    fi
}

update_doc() {
    debug_message "Into update_doc"
    
    WORKING_DIR="${1}"
    TEMPLATE_FILE="${2}"
    
    debug_message "WORKING_DIR: [ $WORKING_DIR ]"
    debug_message "TEMPLATE_FILE: [ $TEMPLATE_FILE ]"

    if [ ! -f "${WORKING_DIR}/action.yml" ]; then
        echo "::error::action.yml does not exist in ${WORKING_DIR}"
        exit 2
    fi

    echo "Create the documentation"
    # Use fallback template if specified template doesn't exist
    if [ ! -f "${TEMPLATE_FILE}" ]; then
        TEMPLATE_FILE="/default.tpl"
        echo "::notice::Template not found, using default: ${TEMPLATE_FILE}"
    fi
    gomplate -d action="${WORKING_DIR}/action.yml" -f "${TEMPLATE_FILE}" -o /tmp/action_doc.md

    # Create README.md if it doesn't exist
    if [ ! -f "${WORKING_DIR}/README.md" ]; then
        gomplate -d action="${WORKING_DIR}/action.yml" -f "${INPUT_TEMPLATE_FILE}" -o "${WORKING_DIR}/README.md"
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

# Main execution
cd /github/workspace

update_doc "${INPUT_WORKING_DIR}" "${INPUT_TEMPLATE_FILE}"

exit 0