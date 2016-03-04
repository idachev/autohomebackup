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

DROPBOX_PHP_SDK=https://www.dropbox.com/developers/downloads/sdks/core/php/v1.1.5.zip

GIT_HASH=$(git rev-parse --short HEAD)

BUILD_VERSION=`cat ${BASEDIR}/version.txt`
BUILD_DATE=$(date +"%Y%m%d")
BUILD_DATE_TIME=$(date +"%Y%m%d_%H%M%S")
BUILD_NAME="autohomebackup_v${BUILD_VERSION}_${BUILD_DATE_TIME}"

DIST_DIR="${BASEDIR}/dist"
BUILD_DIR="${DIST_DIR}/${BUILD_NAME}"
mkdir -p ${BUILD_DIR}

cp -a ${BASEDIR}/../src/*sh ${BUILD_DIR}

sed -i "s/#BUILD_VERSION#/${BUILD_VERSION}/g" ${BUILD_DIR}/autohomebackup.sh
sed -i "s/#BUILD_VERSION#/${BUILD_VERSION}/g" ${BUILD_DIR}/dropbox_uploader_php.sh
sed -i "s/#GIT_HASH#/${GIT_HASH}/g" ${BUILD_DIR}/autohomebackup.sh
sed -i "s/#GIT_HASH#/${GIT_HASH}/g" ${BUILD_DIR}/dropbox_uploader_php.sh
sed -i "s/#BUILD_DATE#/${BUILD_DATE}/g" ${BUILD_DIR}/autohomebackup.sh
sed -i "s/#BUILD_DATE#/${BUILD_DATE}/g" ${BUILD_DIR}/dropbox_uploader_php.sh

cd ${DIST_DIR}
tar czf "${DIST_DIR}/${BUILD_NAME}.tar.gz" ${BUILD_NAME}
rm latest 2> /dev/null
ln -s ./${BUILD_NAME} latest
cd ${BASEDIR}

echo -e "Build generated\n${DIST_DIR}/${BUILD_NAME}"
