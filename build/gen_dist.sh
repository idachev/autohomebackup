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

GIT_HASH=$(git rev-parse --short HEAD)

cd ${BASEDIR}/..
composer install
cd ${BASEDIR}

BUILD_VERSION=`cat ${BASEDIR}/version.txt`
BUILD_YEAR=$(date +"%Y")
BUILD_DATE=$(date +"%Y%m%d")
BUILD_DATE_TIME=$(date +"%Y%m%d_%H%M%S")
BUILD_NAME="autohomebackup_v${BUILD_VERSION}_${BUILD_DATE_TIME}"

DIST_DIR="${BASEDIR}/dist"
BUILD_DIR="${DIST_DIR}/${BUILD_NAME}"
mkdir -p ${BUILD_DIR}

cp -a ${BASEDIR}/../src/*sh ${BUILD_DIR}
cp -a ${BASEDIR}/../src/*php ${BUILD_DIR}
cp -a ${BASEDIR}/../src/template.dropbox_uploader_php.auth ${BUILD_DIR}/.dropbox_uploader_php.auth
cp -a ${BASEDIR}/../LICENSE ${BUILD_DIR}
cp -a ${BASEDIR}/../README.md ${BUILD_DIR}
cp -a ${BASEDIR}/../vendor ${BUILD_DIR}

function replace_versions {
  sed -i "s/#BUILD_VERSION#/${BUILD_VERSION}/g" ${1}
  sed -i "s/#GIT_HASH#/${GIT_HASH}/g" ${1}
  sed -i "s/#BUILD_DATE#/${BUILD_DATE}/g" ${1}
  sed -i "s/#BUILD_YEAR#/${BUILD_YEAR}/g" ${1}
}

replace_versions ${BUILD_DIR}/autohomebackup.sh
replace_versions ${BUILD_DIR}/dropbox_uploader_php.sh
replace_versions ${BUILD_DIR}/dropbox_v2_uploader.php

BUILD_FILE=${DIST_DIR}/${BUILD_NAME}.tar.gz
tar czf "${BUILD_FILE}" -C ${DIST_DIR} ${BUILD_NAME}
rm ${DIST_DIR}/latest 2> /dev/null
ln -s ${BUILD_NAME} ${DIST_DIR}/latest

echo -e "\nBuild generated:\n\t${BUILD_FILE}\n\t${DIST_DIR}/${BUILD_NAME}"
