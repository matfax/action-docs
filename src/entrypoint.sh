#!/bin/bash
set -e

debug_message(){
    msg="$1"
    if [ "$INPUT_DEBUG_MODE" == "true" ];then
        echo "$msg"
    fi
}

debug_message "Into update_doc"

debug_message "WORKING_DIR: [ $INPUT_WORKING_DIR ]"
debug_message "TEMPLATE_FILE: [ $INPUT_TEMPLATE_FILE ]"

if [ ! -f "${INPUT_WORKING_DIR}/action.yml" ]; then
    echo "::error::action.yml does not exist in ${INPUT_WORKING_DIR}"
    exit 2
fi

echo "Create the documentation"
# Use fallback template if specified template doesn't exist
if [ -z "${INPUT_WORKING_DIR}/${INPUT_TEMPLATE_FILE}" ] || [ ! -f "${INPUT_WORKING_DIR}/${INPUT_TEMPLATE_FILE}" ]; then
    TEMPLATE_FILE="/app/default.tpl"
    echo "::notice::Template not found, using default: ${TEMPLATE_FILE}"
else
    TEMPLATE_FILE="${INPUT_WORKING_DIR}/${INPUT_TEMPLATE_FILE}"
fi

gomplate -d action="${INPUT_WORKING_DIR}/action.yml" -f "${TEMPLATE_FILE}" -o /tmp/action_doc.md

# Check that README.md exists
if [ ! -f "${INPUT_WORKING_DIR}/README.md" ]; then
    echo "::error::README.md does not exist in ${INPUT_WORKING_DIR}"
    exit 4
fi

HAS_ACTION_DOCS=$(grep -E '(BEGIN|END)_ACTION_DOCS' "${INPUT_WORKING_DIR}/README.md" | wc -l)

# Verify it has BEGIN and END markers
if [ "${HAS_ACTION_DOCS}" -ne 2 ]; then
    echo "::error::README.md does not contain <!--- BEGIN_ACTION_DOCS ---> and <!--- END_ACTION_DOCS --->"
    exit 3
fi

# Replace content between BEGIN_ACTION_DOCS and END_ACTION_DOCS markers
sed -i '/<!--- BEGIN_ACTION_DOCS --->/,/<!--- END_ACTION_DOCS --->/{ /<!--- BEGIN_ACTION_DOCS --->/!{ /<!--- END_ACTION_DOCS --->/!d; }; }' "${INPUT_WORKING_DIR}/README.md"
sed -i '/<!--- BEGIN_ACTION_DOCS --->/r /tmp/action_doc.md' "${INPUT_WORKING_DIR}/README.md"

debug_message "End update_doc"
