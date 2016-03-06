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
BASEDIR=${BASEDIR}/..

cd ${BASEDIR}
${BASEDIR}/build/dist/latest/autohomebackup.sh -c ${BASEDIR}/test/test_it.conf

if [ $? -ne 0 ];then
echo "Integration test FAILED"
exit 1
else
echo "Integration test PASS"
exit 0
fi
