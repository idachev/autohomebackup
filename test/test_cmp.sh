#!/bin/bash
#set -x

TMP_DIR=`mktemp -d`
tar xzf "${1}" -C ${TMP_DIR}
#echo "${TMP_DIR}"

diff "${2}" "${TMP_DIR}" &>/dev/null
if [ $? -ne 0 ];then
echo "Different ${2} ${TMP_DIR}"
else
echo "Test ${2} PASS"
fi
