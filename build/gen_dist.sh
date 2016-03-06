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

DROPBOX_SDK_PHP_VERSION=`cat ${BASEDIR}/dropbox-sdk-php-version.txt`
DROPBOX_SDK_PHP="https://codeload.github.com/dropbox/dropbox-sdk-php/zip/v${DROPBOX_SDK_PHP_VERSION}"

echo -e "Downloading Dropbox SDK PHP\n${DROPBOX_SDK_PHP}"
TMP_DIR=`mktemp -d`
DST_ZIP="${TMP_DIR}/phpsdk.zip"
curl -s -S -o "${DST_ZIP}" ${DROPBOX_SDK_PHP}
if [ $? -ne 0 ];then
  echo "\nDropbox SDK PHP download failed!"
  exit 1
fi

TMP_DIR_ZIP=`mktemp -d`
unzip -qq "${DST_ZIP}" -d "${TMP_DIR_ZIP}"
if [ $? -ne 0 ];then
  echo -e "\nFailed to extract\n\t${DST_ZIP}\nto\n\t${TMP_DIR_ZIP}"
  exit 1
fi

GIT_HASH=$(git rev-parse --short HEAD)

BUILD_VERSION=`cat ${BASEDIR}/version.txt`
BUILD_DATE=$(date +"%Y%m%d")
BUILD_DATE_TIME=$(date +"%Y%m%d_%H%M%S")
BUILD_NAME="autohomebackup_v${BUILD_VERSION}_${BUILD_DATE_TIME}"

DIST_DIR="${BASEDIR}/dist"
BUILD_DIR="${DIST_DIR}/${BUILD_NAME}"
DROPBOX_SDK_PHP_DIR="${BUILD_DIR}/dropbox-sdk-php"
mkdir -p ${BUILD_DIR}
mkdir -p ${DROPBOX_SDK_PHP_DIR}

cp -a ${BASEDIR}/../src/*sh ${BUILD_DIR}
cp -a ${BASEDIR}/../LICENSE ${BUILD_DIR}
cp -a ${BASEDIR}/../README.md ${BUILD_DIR}
cp -a "${TMP_DIR_ZIP}/dropbox-sdk-php-${DROPBOX_SDK_PHP_VERSION}/lib" ${DROPBOX_SDK_PHP_DIR}
cp -a "${TMP_DIR_ZIP}/dropbox-sdk-php-${DROPBOX_SDK_PHP_VERSION}/examples" ${DROPBOX_SDK_PHP_DIR}
cp -a "${TMP_DIR_ZIP}/dropbox-sdk-php-${DROPBOX_SDK_PHP_VERSION}/License.txt" ${DROPBOX_SDK_PHP_DIR}
touch ${DROPBOX_SDK_PHP_DIR}/v${DROPBOX_SDK_PHP_VERSION}

sed -i "s/#BUILD_VERSION#/${BUILD_VERSION}/g" ${BUILD_DIR}/autohomebackup.sh
sed -i "s/#BUILD_VERSION#/${BUILD_VERSION}/g" ${BUILD_DIR}/dropbox_uploader_php.sh
sed -i "s/#GIT_HASH#/${GIT_HASH}/g" ${BUILD_DIR}/autohomebackup.sh
sed -i "s/#GIT_HASH#/${GIT_HASH}/g" ${BUILD_DIR}/dropbox_uploader_php.sh
sed -i "s/#BUILD_DATE#/${BUILD_DATE}/g" ${BUILD_DIR}/autohomebackup.sh
sed -i "s/#BUILD_DATE#/${BUILD_DATE}/g" ${BUILD_DIR}/dropbox_uploader_php.sh

BUILD_FILE=${DIST_DIR}/${BUILD_NAME}.tar.gz
tar czf "${BUILD_FILE}" -C ${DIST_DIR} ${BUILD_NAME}
rm ${DIST_DIR}/latest 2> /dev/null
ln -s ${BUILD_NAME} ${DIST_DIR}/latest

echo -e "\nBuild generated:\n\t${BUILD_FILE}\n\t${DIST_DIR}/${BUILD_NAME}"
