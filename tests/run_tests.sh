#!/bin/bash

all_tests=$(find $PWD -type f -name "*.P");
pyacc_exec=$(find $PWD -name "pyacc");
if [ -z "$all_tests" ] || ! [ -f "$pyacc_exec" ]; then
    echo -e "Test set incomplete"
    echo -e "   Executable: $pyacc_exec"
    echo -e "   Tests: $all_tests"
    exit 1
fi
for tst in $all_tests; do
    tst_output=$($pyacc_exec "$tst" 2>&1)
    if grep -q "Error" <<< "$tst_output"; then
        echo -e "FAILURE: $tst failed:"
        echo -e "   $tst_output"
    fi
done