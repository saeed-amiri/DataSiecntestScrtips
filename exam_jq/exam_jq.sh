#!/usr/bin/env bash
# ---------------------------------------------------
# Saeed Amiri - BASH, LINUX, JQ Exam Script
# ---------------------------------------------------

# Files & Directories
JSON_FILE="people.json"
BONUS_DIR="bonus"


# Helper functions

header() {
    echo -e "$(date)\n"
    echo -e "------------- Saeed-Amiri ----------------"
    echo -e "---------------- JQ-Exam -----------------\n"
}

require_file() {
    if [[ ! -f "$1" ]]; then
        echo -e "Error: required file '$1' not found!"
        exit 1
    fi
}

require_command() {
    if ! command -v "$1" &>/dev/null; then
        echo -e "Error: required command '$1' not found in PATH"
        exit 1
    fi
}

commander() {
    echo "$1. Statement of question $1"
    echo "Command: $2"
    eval "$2"
    echo "Answer: $3"
    echo "Main attribute(s): $4"
    echo -e "\n----------------------------------------\n"
}

bonus_setup() {
    echo -e "\n---------------- BONUS ----------------\n"

    if [[ -d $BONUS_DIR ]]; then
        rm -f "$BONUS_DIR"/*
        echo "All old files in '$BONUS_DIR' are deleted"
    else
        mkdir -p "$BONUS_DIR"
    fi
}


# ----------------------
# Main Execution
# ----------------------


header
require_command jq
require_file "$JSON_FILE"


commander 1 \
"jq -r '.[] | \"\(.name)\t\(. | keys_unsorted | length)\"' people.json | head -n 12" \
"Each document has 17 attributes" \
"name"


commander 2 \
"jq '[.[] | select(.birth_year == \"unknown\")] | length' people.json" \
"6 unknown values for birth_year" \
"birth_year"

commander 3 \
"jq -r '.[] | .created[0:10]' people.json | head -n 10" \
"First 10 creation dates displayed" \
"created"

commander 4 \
"jq -r '.[] | {id: .url, birth_year}' people.json | sort -k2 | uniq -d" \
"IDs with the same birth date" \
"id, birth_year"

commander 5 \
"jq -r '.[] | [(.films // [] | length), .name] | @tsv' people.json | head -n 10" \
"First 10 lines: number of films + character name" \
"films, name"


#--------------------------------------------------------------------------------



bonus_setup

# Q6
jq '[.[] | select(.height|test("^[0-9]+$"))]' people.json > bonus/people_6.json

# Q7
jq '[.[] | .height |= tonumber]' bonus/people_6.json > bonus/people_7.json

# Q8
jq '[.[] | select(.height >= 156 and .height <= 171)]' bonus/people_7.json > bonus/people_8.json

# Q9
jq -r 'min_by(.height) | "\(.name) is \(.height) tall"' bonus/people_8.json > bonus/people_9.txt


echo -e "All done! Results saved in res_jq.txt and $BONUS_DIR/"