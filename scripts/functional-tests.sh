#!/bin/bash
test -e ssshtest || wget -q https://raw.githubusercontent.com/ryanlayer/ssshtest/master/ssshtest

. ssshtest

PARENT_DIR="$(git rev-parse --show-toplevel)"
export PATH="${PARENT_DIR}:${PATH}"

set -o nounset

function line_count {
    wc -l "${@}" | awk '{ print $1 }'
}
export -f line_count

#=======#
# slice #
#=======#
run slice_inf tut slice 5: tests/data/*.tsv
assert_exit_code 0
assert_no_stderr
assert_equal "21" "$(line_count ${STDOUT_FILE})"
assert_in_stdout "Dodge Challenger"

run slice_low tut slice :3 tests/data/*.tsv
assert_exit_code 0
assert_no_stderr
assert_equal "9" "$(line_count "${STDOUT_FILE}")"
assert_in_stdout "Fiat 128"

run slice tut slice 1:3 tests/data/*.tsv
assert_exit_code 0
assert_no_stderr
assert_equal "9" "$(line_count "${STDOUT_FILE}")"

run slice tut slice huh:3 tests/data/*.tsv
assert_exit_code 1
assert_stderr
assert_in_stderr "Malformed range"

run slice_add_col tut slice -b 0:3 tests/data/*.tsv
assert_exit_code 0
assert_in_stdout "basename"
assert_equal "$(cut -f 1 "${STDOUT_FILE}" | uniq | line_count /dev/stdin )" "9"
assert_equal "$(cut -f 7 "${STDOUT_FILE}" | head -n 1)" "basename"
assert_equal "$(cut -f 7 "${STDOUT_FILE}" | head -n 2 | tail -n 1)" "df1.tsv"

#========#
# select #
#========#
run select_1 tut select 1,2,3 tests/data/*.tsv
assert_exit_code 0
assert_no_stderr
assert_in_stdout "model"
assert_in_stdout "mpg"
assert_in_stdout "cyl"


# select missing column
run select_2 tut select mpg tests/data/df3.tsv
assert_in_stdout "mpg" # header should be included
assert_equal "$(uniq "${STDOUT_FILE}" | line_count /dev/stdin )" "2"

# basename
run select_3 tut select -b mpg tests/data/df1.tsv
assert_equal "$(cut -f 2 "${STDOUT_FILE}" | tail -n 1)" "df1.tsv"
assert_in_stdout "basename"

run select_4 tut select -a mpg tests/data/df1.tsv
assert_in_stdout "filename"

#=======#
# Stack #
#=======#

run stack_1 tut stack -b tests/data/*.tsv
assert_in_stdout "model"
assert_in_stdout "mpg"
assert_in_stdout "disp"
assert_in_stdout "hp"
assert_in_stdout "qsec"
assert_in_stdout "vs"
assert_in_stdout "carb"
assert_in_stdout "am"
assert_in_stdout "basename"
assert_equal "$(line_count "${STDOUT_FILE}")" "31"

run stack_2 tut stack -a --header=false tests/data/*.tsv
assert_equal "$(line_count "${STDOUT_FILE}")" "30"
assert_equal "$(cut -f 2 "${STDOUT_FILE}" | head -n 23 | paste -sd+ - | bc)" "454.8"

run stack_gzip_1 tut stack -b tests/data/*.tsv.gz
assert_in_stdout "model"
assert_in_stdout "mpg"
assert_in_stdout "disp"
assert_in_stdout "hp"
assert_in_stdout "qsec"
assert_in_stdout "vs"
assert_in_stdout "carb"
assert_in_stdout "am"
assert_in_stdout "basename"
assert_equal "$(line_count "${STDOUT_FILE}")" "31"

run stack_gzip_2 tut stack -a --header=false tests/data/*.tsv.gz
assert_equal "$(line_count "${STDOUT_FILE}")" "30"
assert_equal "$(cut -f 2 "${STDOUT_FILE}" | head -n 23 | paste -sd+ - | bc)" "454.8"

# Mix tsv and tsv.gz
run stack_mix tut stack -a --header=false tests/data/df1.tsv.gz tests/data/df2.tsv tests/data/df3.tsv
assert_equal "$(line_count "${STDOUT_FILE}")" "30"
assert_equal "$(cut -f 2 "${STDOUT_FILE}"| head -n 23 | paste -sd+ - | bc)" "454.8"
