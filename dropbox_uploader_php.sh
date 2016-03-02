#!/bin/bash
#
# Auto Home Backup Dropbox Uploader PHP Script
# It uses the https://github.com/dropbox/dropbox-sdk-php
# Copyright (c) 2016 i_dachev@yahoo.co.uk
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

WHICH="`which which`"
if [ "x${WHICH}" = "x" ]; then
    WHICH="which"
fi

PHP="`${WHICH} php`"
if [ "x${PHP}" = "x" ]; then
    PHP="php"
fi

READLINK="`${WHICH} readlink`"
if [ "x${READLINK}" = "x" ]; then
    READLINK="readlink"
fi

DIRNAME="`${WHICH} dirname`"
if [ "x${DIRNAME}" = "x" ]; then
    DIRNAME="dirname"
fi

BASEDIR=$(${READLINK} -f $0)
BASEDIR=$(${DIRNAME} ${BASEDIR})

php "${BASEDIR}/examples/upload-file.php" "$1" "$2" "$3"
