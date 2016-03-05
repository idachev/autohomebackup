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

TMP_DIR=`mktemp -d`
tar xzf "${1}" -C ${TMP_DIR}
#echo "${TMP_DIR}"

diff "${2}" "${TMP_DIR}" &>/dev/null
if [ $? -ne 0 ];then
echo "Different ${2} ${TMP_DIR}"
exit 1
else
echo "Test ${2} PASS"
exit 0
fi
