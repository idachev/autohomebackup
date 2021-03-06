#!/bin/bash
#
# Copyright (c) 2016 Ivan Dachev
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
#=====================================================================
#set -x

BASEDIR=$(readlink -f $0)
BASEDIR=$(dirname ${BASEDIR})
cd ${BASEDIR}/..

TEST_TAR_GZ="./tmp/test.tar.gz"

function execute_test()
{
./src/autohomebackup.sh -c "./${1}"
./test/test_cmp.sh "${TEST_TAR_GZ}" "./${2}"
if [ $? -ne 0 ];then
exit 1
fi
}

execute_test test/test_1.conf test/expected_test_1
execute_test test/test_2.conf test/expected_test_2
execute_test test/test_3.conf test/expected_test_3
execute_test test/test_4.conf test/expected_test_4
execute_test test/test_5.conf test/expected_test_5
execute_test test/test_6.conf test/expected_test_6

rm -f "${TEST_TAR_GZ}" 2> /dev/null

${BASEDIR}/test_it.sh

exit 0
