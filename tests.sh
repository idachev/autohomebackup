#!/bin/bash
#set -x

BASEDIR=$(readlink -f $0)
BASEDIR=$(dirname ${BASEDIR})

function execute_test()
{
./src/autohomebackup.sh -c "${1}"
${BASEDIR}/test/test_cmp.sh "${BASEDIR}/tmp/test.tar.gz" "${2}"
}

execute_test test/test_1.conf test/expected_test_1
execute_test test/test_2.conf test/expected_test_2
execute_test test/test_3.conf test/expected_test_3
execute_test test/test_4.conf test/expected_test_4
execute_test test/test_5.conf test/expected_test_5
execute_test test/test_6.conf test/expected_test_6
