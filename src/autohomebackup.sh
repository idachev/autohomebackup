#!/bin/bash
#
# Auto Home Backup Script
# v#BUILD_VERSION# #BUILD_DATE# #GIT_HASH#
# https://github.com/idachev/autohomebackup
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

#=====================================================================
# Do inline-config otherwise set the following variables to your system needs
#
# To create a config file just copy the code to autohomebackup.conf between
# "### START OF CONFIG ###" and "### END OF CONFIG ###"
#
# After that you're able to upgrade this script
# (copy a new version to its location) without the need for editing it.
#=====================================================================

#=====================================================================
### START OF CONFIG ###

# Destination directory on dropbox to be uploaded to
DROPBOX_DST_DIR="/home-backup"

# Base directory to what the dirs in DIRS_TO_BACKUP and EXCLUDE are relative
BASE_DIR="/home"

# Directories array to backup, at least one should be specified
# All directories should be relative to the BASE_DIR
# If you want to backup all content of BASE_DIR then use: ('.')
DIRS_TO_BACKUP=("user")

# Exclude patterns array, check man tar for --exclude option
# Do not put leading "/" in the patters as tar archive do not include them
# If you need to use ? and * in patterns use the single-quoted: 'dir/*'
EXCLUDE=('user/tmp_data' 'tmp' 'cache')

# Host name to be used in files and logs
BACKUP_HOST="localhost"

# Backup name to be used in files and logs
BACKUP_NAME="home"

# Email Address to send mail to? (user@domain.com)
MAIL_ADDR="user@domain.com"

# Temp directory to store backup file before upload
TMP_DIR="/home/user/tmp"

# Log directory location
LOG_DIR="/home/user/logs/autohomebackup"

# dropbox_uploader_php.sh script location provided along with this script
DROPBOX_UPLOADER_PHP="dropbox_uploader_php.sh"

# .dropbox_uploader_php auth token for more info how to create an
# auth file check: https://github.com/dropbox/dropbox-sdk-php
DROPBOX_UPLOADER_PHP_AUTH=".dropbox_uploader_php.auth"

# Mail setup
# What would you like to be mailed to you?
# - log   : send only log file
# - stdout : will simply output the log to the screen if run manually.
# - quiet : Only send logs if an error occurs to the MAIL_ADDR.
MAIL_CONTENT="log"

# Set the maximum allowed email size in k. (4000 = approx 5MB email)
MAX_ATT_SIZE="4000"

# Command to run before backups (uncomment to use)
#PRE_BACKUP="/etc/home-backup-pre"

# Command to run after backups (uncomment to use)
#POST_BACKUP="/etc/home-backup-post"

### END OF CONFIG ###
#=====================================================================

#=====================================================================
# Please Notes
#=====================================================================
#
# I take no responsibility for any data loss or corruption when using
# this script.
#
# This script will not help in the event of a hard drive crash. If a
# copy of the backup has not be stored offline or on another PC.
#
# You should copy your backups offline regularly for best protection.
#
# Happy backing up...
#
#=====================================================================
# Restoring
#=====================================================================
# Uncompress the backup file:
# tar xzf file.tar.gz
#
# Lets hope you never have to use this. :)
#
#=====================================================================
# Change Log
#=====================================================================
#
# VER 1.0.5 - (2016-04-16)
#     - Changed to store with year-month sub dir on destination backup
# VER 1.0.4 - (2016-03-07)
#     - Fixed to have separate dropbox-sdk-php directory
# VER 1.0.3 - (2016-03-06)
#     - Fixed to have only one section of config options
# VER 1.0.2 - (2016-03-05)
#     - Fixed to use Dropbox SDK PHP v1.1.6
#     - Separate config options to required and default ones
# VER 1.0.1 - (2016-03-05)
#     - Introduced build releases that include Dropbox SDK PHP
# VER 1.0.0 - (2016-03-02)
#     - Initial
#
#=====================================================================
#=====================================================================
#=====================================================================
#
# Should not need to be modified from here down!!!
#
#=====================================================================
#=====================================================================
#=====================================================================

# Full pathname to binaries to avoid problems with aliases etc.
WHICH="`which which`"
if [ "x${WHICH}" = "x" ]; then
    WHICH="which"
fi

AWK="`${WHICH} gawk`"
if [ "x${AWK}" = "x" ]; then
    AWK="gawk"
fi

LOGGER="`${WHICH} logger`"
if [ "x${LOGGER}" = "x" ]; then
    LOGGER="logger"
fi

ECHO="`${WHICH} echo`"
if [ "x${ECHO}" = "x" ]; then
    ECHO="echo"
fi

CAT="`${WHICH} cat`"
if [ "x${CAT}" = "x" ]; then
    CAT="cat"
fi

READLINK="`${WHICH} readlink`"
if [ "x${READLINK}" = "x" ]; then
    READLINK="readlink"
fi

BASENAME="`${WHICH} basename`"
if [ "x${BASENAME}" = "x" ]; then
    BASENAME="basename"
fi

DIRNAME="`${WHICH} dirname`"
if [ "x${DIRNAME}" = "x" ]; then
    DIRNAME="dirname"
fi

DATEC="`${WHICH} date`"
if [ "x${DATEC}" = "x" ]; then
    DATEC="date"
fi

DU="`${WHICH} du`"
if [ "x${DU}" = "x" ]; then
    DU="du"
fi

EXPR="`${WHICH} expr`"
if [ "x${EXPR}" = "x" ]; then
    EXPR="expr"
fi

FIND="`${WHICH} find`"
if [ "x${FIND}" = "x" ]; then
    FIND="find"
fi

RM="`${WHICH} rm`"
if [ "x${RM}" = "x" ]; then
    RM="rm"
fi

TAR="`${WHICH} tar`"
if [ "x${TAR}" = "x" ]; then
    TAR="tar"
fi

CP="`${WHICH} cp`"
if [ "x${CP}" = "x" ]; then
    CP="cp"
fi

HOSTNAMEC="`${WHICH} hostname`"
if [ "x${HOSTNAMEC}" = "x" ]; then
    HOSTNAMEC="hostname"
fi

UNAME="`${WHICH} uname`"
if [ "x${UNAME}" = "x" ]; then
    UNAME="uname"
fi

SED="`${WHICH} sed`"
if [ "x${SED}" = "x" ]; then
    SED="sed"
fi

GREP="`${WHICH} grep`"
if [ "x${GREP}" = "x" ]; then
    GREP="grep"
fi

NICE="`${WHICH} nice`"
if [ "x${NICE}" = "x" ]; then
    NICE="nice"
fi

IONICE="`${WHICH} ionice`"
if [ "x${IONICE}" = "x" ]; then
    IONICE="ionice"
fi

SCRIPT_LOC=$(${READLINK} -f $0)
SCRIPT_NAME=$(${BASENAME} ${SCRIPT_LOC})
SCRIPT_DIR=$(${DIRNAME} ${SCRIPT_LOC})

# Default config file
CONFIG_FILE="autohomebackup.conf"

VERSION="v#BUILD_VERSION# #BUILD_DATE# #GIT_HASH#"     # Version
CODE_LINK="https://github.com/idachev/autohomebackup"  # Link to the code
DONATE_LINK="http://4ui.us/yqso"                       # Link to donate
DEBUG=0

# Look for optional config file parameter
while [ ${#} -gt 0 ]; do
  case ${1} in
    -c)
      CONFIG_FILE="${2}"
      shift 2
      ;;
    -d)
      DEBUG=1
      shift 1
      ;;
    --help)
      ${ECHO} "Usage: ${SCRIPT_NAME} [-d] [-c CONFIG_FILE]"
      ${ECHO} -e "\t-d: Start dump debug info and messages."
      ${ECHO} -e "\t-c CONFIG_FILE: Config file to load.\n\t\tIf ommit will use values from ${CONFIG_FILE}"
      exit 0
      ;;
    *)
      ${ECHO} "Unknown Option \"${1}\""
      exit 2
      ;;
  esac
done

if [[ ${DEBUG} != 0 ]]; then
    ${ECHO} ${VERSION}
    ${UNAME} -a 2> /dev/null
    ${CAT} /etc/issue 2> /dev/null
    set -x
fi

export LC_ALL=C

PATH=/usr/local/bin:/usr/bin:/bin

# Helper functions
function strip_comma()
{
  local l="${1}"
  l=`${ECHO} "${l}" | sed 's/^[ ]*//g'`
  l=`${ECHO} "${l}" | sed 's/[ ]*$//g'`
  l=`${ECHO} "${l}" | sed 's/^,[ ]*//g'`
  l=`${ECHO} "${l}" | sed 's/[ ]*,$//g'`
  ${ECHO} "${l}"
}

function suffix_pwd()
{
  local l=`strip_comma "${1}"`
  if [[ ${l} != /* ]]; then
    l="${PWD}/${l}"
  fi
  ${ECHO} "${l}"
}

function resolve_file()
{
  local file=`strip_comma "${1}"`
  local origin=${file}
  if [ ! -r ${file} ]; then
    file="${SCRIPT_DIR}/${file}"
    if [ ! -r ${file} ]; then
      file=`suffix_pwd "${origin}"`
    fi
  fi
  if [ -r ${file} ]; then
    ${ECHO} "${file}"
  else
    ${ECHO} "${origin}"
  fi
}

CONFIG_FILE=`resolve_file "${CONFIG_FILE}"`
if [ -r ${CONFIG_FILE} ]; then
  # Read the config file if it's existing and readable
  source ${CONFIG_FILE}
fi

DATE=`${DATEC} +%Y-%m-%d_%Hh%Mm` # Datestamp e.g 2002-09-21
YM=`${DATEC} +%Y-%m`             # Year-Month e.g 2002-09
DOW=`${DATEC} +%A`               # Day of the week e.g. Monday
DNOW=`${DATEC} +%u`              # Day number of the week 1 to 7 where 1 represents Monday
DOM=`${DATEC} +%d`               # Date of the Month e.g. 27
M=`${DATEC} +%B`                 # Month e.g January
W=`${DATEC} +%V`                 # Week Number e.g 37

BASE_DIR=`suffix_pwd "${BASE_DIR}"`
TMP_DIR=`suffix_pwd "${TMP_DIR}"`
LOG_DIR=`suffix_pwd "${LOG_DIR}"`

LOG_FILE=${LOG_DIR}/${BACKUP_HOST}-${BACKUP_NAME}-${DATE}.log       # Logfile Name
LOG_ERR=${LOG_DIR}/${BACKUP_HOST}-${BACKUP_NAME}-${DATE}_ERRORS.log # Error Logfile Name

BACKUP_FILE_NAME=${BACKUP_HOST}-${BACKUP_NAME}-${DATE}.tar.gz
BACKUP_FILE=${TMP_DIR}/${BACKUP_FILE_NAME}
DST_BACKUPFILE=${DROPBOX_DST_DIR}/${YM}/${BACKUP_FILE_NAME}

TAR_OPT="czpf"

NICENESS="${NICE} -n19 ${IONICE} -c2 -n7"

# Create required directories
if [ ! -e "${LOG_DIR}" ]; then
  mkdir -p "${LOG_DIR}"
fi

# IO redirection for logging.
touch ${LOG_FILE}
exec 6>&1           # Link file descriptor #6 with stdout.
                    # Saves stdout.
exec > ${LOG_FILE}   # stdout replaced with file ${LOGFILE}.
touch ${LOG_ERR}
exec 7>&2           # Link file descriptor #7 with stderr.
                    # Saves stderr.
exec 2> ${LOG_ERR}   # stderr replaced with file ${LOGERR}.

# Check some required files
DROPBOX_UPLOADER_PHP=`resolve_file "${DROPBOX_UPLOADER_PHP}"`
if [ ! -r ${DROPBOX_UPLOADER_PHP} ]; then
  ${ECHO} -e "ERROR: DROPBOX_UPLOADER_PHP file not found:\n\t${DROPBOX_UPLOADER_PHP}"
fi

DROPBOX_UPLOADER_PHP_AUTH=`resolve_file "${DROPBOX_UPLOADER_PHP_AUTH}"`
if [ ! -r ${DROPBOX_UPLOADER_PHP_AUTH} ]; then
  ${ECHO} -e "ERROR: DROPBOX_UPLOADER_PHP_AUTH file not found:\n\t${DROPBOX_UPLOADER_PHP_AUTH}"
fi

# Run command before we begin
if [ "${PRE_BACKUP}" ]; then
  ${ECHO} ======================================================================
  ${ECHO} "Pre backup command output."
  ${ECHO}
  eval ${PRE_BACKUP}
  ${ECHO}
  ${ECHO} ======================================================================
  ${ECHO}
fi

# Hostname for LOG information
if [ "${BACKUP_HOST}" = "localhost" ]; then
  HOST=`${HOSTNAMEC}`
  if [ "${SOCKET}" ]; then
    OPT="${OPT} --socket=${SOCKET}"
  fi
else
  HOST=${BACKUP_HOST}
fi

# Build tar exclude options
OPT_EXCLUDE=()
OPT_EXCLUDE_LOG=""
for i in "${EXCLUDE[@]}"; do
  i=`strip_comma "${i}"`
  if [ ! "x${i}" = "x" ]; then
    OPT_EXCLUDE+=("--exclude=${i}")
    OPT_EXCLUDE_LOG="${OPT_EXCLUDE_LOG}\n\t${i}"
  fi
done

# Build tar directory list to backup
DIRS_LIST=(-C "${BASE_DIR}")
DIRS_LIST_LOG=""
for i in "${DIRS_TO_BACKUP[@]}"; do
  i=`strip_comma "${i}"`
  if [ ! "x${i}" = "x" ]; then
    DIRS_LIST+=("${i}")
    DIRS_LIST_LOG="${DIRS_LIST_LOG}\n\t${i}"
  fi
done

if [ "x${DIRS_LIST_LOG}" = "x" ]; then
  DIRS_LIST+=(".")
  DIRS_LIST_LOG="\n\t."
fi
DIRS_LIST_LOG="\n${BASE_DIR}${DIRS_LIST_LOG}"

${ECHO} ======================================================================
${ECHO} Auto Home Backup Script
${ECHO} ${VERSION}
${ECHO} ${CODE_LINK}
${ECHO}
${ECHO} Backup of ${BACKUP_NAME} at ${HOST}
${ECHO} ======================================================================
${ECHO} Backup Start Time `${DATEC}`
${ECHO}
${ECHO} -e Backup to ${BACKUP_FILE}${DIRS_LIST_LOG}

if [ ! "x${OPT_EXCLUDE_LOG}" = "x" ]; then
${ECHO}
${ECHO} -e Exclude${OPT_EXCLUDE_LOG}
fi

OLD_PWD="${PWD}"
cd "${BASE_DIR}"
${NICENESS} ${TAR} ${TAR_OPT} "${BACKUP_FILE}" "${OPT_EXCLUDE[@]}" "${DIRS_LIST[@]}"
cd "${OLD_PWD}"

${ECHO}
${ECHO} Uploading to Dropbox Start Time `${DATEC}`
${ECHO} `${DU} -hs "${BACKUP_FILE}"`
#${NICENESS} ${DROPBOX_UPLOADER} -f "${DROPBOX_UPLOADER_AUTH}" upload "${BACKUP_FILE}" "${DST_BACKUPFILE}"
${NICENESS} ${DROPBOX_UPLOADER_PHP} "${DROPBOX_UPLOADER_PHP_AUTH}" "${BACKUP_FILE}" "${DST_BACKUPFILE}"
${ECHO}
if [ ! -s "${LOG_ERR}" ]
then
  ${ECHO} Remove ${BACKUP_FILE}
  eval ${RM} -f "${BACKUP_FILE}"
  ${ECHO}
fi
${ECHO} Backup End Time `${DATEC}`
${ECHO} ======================================================================
${ECHO} If you find AutoHomeBackup valuable please buy me a drink or two at
${ECHO} ${DONATE_LINK}
${ECHO} ======================================================================

# Run command when we're done
if [ "${POST_BACKUP}" ]
  then
  ${ECHO} ======================================================================
  ${ECHO} "Post backup command output."
  ${ECHO}
  eval ${POST_BACKUP}
  ${ECHO}
  ${ECHO} ======================================================================
fi

#Clean up IO redirection
exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.
exec 2>&7 7>&-      # Restore stdout and close file descriptor #7.

if [ "${MAIL_CONTENT}" = "log" ]
then
  ${CAT} "${LOG_FILE}" | mail -s "Backup Log for ${BACKUP_NAME} at ${HOST} - ${DATE}" ${MAIL_ADDR}
  if [ -s "${LOG_ERR}" ]
    then
      ${CAT} "${LOG_ERR}" | mail -s "ERRORS REPORTED: Backup error Log for ${BACKUP_NAME} at ${HOST} - ${DATE}" ${MAIL_ADDR}
  fi
elif [ "${MAIL_CONTENT}" = "quiet" ]
then
  if [ -s "${LOG_ERR}" ]
    then
      ${CAT} "${LOG_ERR}" | mail -s "ERRORS REPORTED: Backup error Log for ${BACKUP_NAME} at ${HOST} - ${DATE}" ${MAIL_ADDR}
      ${CAT} "${LOG_FILE}" | mail -s "Backup Log for ${BACKUP_NAME} at ${HOST} - ${DATE}" ${MAIL_ADDR}
  fi
else
  if [ -s "${LOG_ERR}" ]
    then
      ${CAT} "${LOG_FILE}"
      ${ECHO}
      ${ECHO} "###### WARNING ######"
      ${ECHO} "Errors reported during AutoHomeBackup execution... Backup failed"
      ${ECHO} "Error log below..."
      ${CAT} "${LOG_ERR}"
  else
    ${CAT} "${LOG_FILE}"
  fi
fi

if [ -s "${LOG_ERR}" ]
  then
    STATUS=1
  else
    STATUS=0
fi

# Clean up Logfile
# eval ${RM} -f "${LOGFILE}"
# eval ${RM} -f "${LOGERR}"

exit ${STATUS}
