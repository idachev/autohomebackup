#!/bin/bash
#
# Auto Home Backup Script
# VER. 1.0.0 - http://todo
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

# Default config file
CONFIG_FILE="~/.autohomebackup.conf"
PROGNAME=`basename $0`

VERSION=1.0.0             # Version Number
CODE_LINK="http://TODO"   # Linik to the code
DONATE_LINK="http://TODO" # Link to donate
DEBUG=0

# Look for optional config file parameter
while [ $# -gt 0 ]; do
  case $1 in
    -c)
      CONFIG_FILE="$2"
      shift 2
      ;;
    -d)
      DEBUG=1
      shift 1
      ;;
    --help)
      echo "Usage: ${PROGNAME} [-d] [-c CONFIG_FILE]"
      echo -e "\t-d: Start dump debug info and messages."
      echo -e "\t-c CONFIG_FILE: Config file to load.\n\t\tIf ommit will use values from ${CONFIG_FILE}"
      exit 0
      ;;
    *)
      echo "Unknown Option \"$1\""
      exit 2
      ;;
  esac
done

if [[ $DEBUG != 0 ]]; then
    echo $VERSION
    uname -a 2> /dev/null
    cat /etc/issue 2> /dev/null
    set -x
fi

#=====================================================================
# Set the following variables to your system needs
# (Detailed instructions below variables)
#=====================================================================

if [ -r ${CONFIG_FILE} ]; then
  # Read the configfile if it's existing and readable
  source ${CONFIG_FILE}
else
  # do inline-config otherwise
  # To create a configfile just copy the code between
  # "### START CFG ###" and "### END CFG ###" to .autohomebackup.conf
  # After that you're able to upgrade this script
  # (copy a new version to its location) without the need for editing it.

  ### START CFG ###

  # dropbox_uploader_php.sh script location provided along with this script
  DROPBOX_UPLOADER_PHP="dropbox_uploader_php.sh"

  # .dropbox_uploader_php auth token for more info how to create a auth file check
  # https://github.com/dropbox/dropbox-sdk-php
  DROPBOX_UPLOADER_CONFIG_PHP=".dropbox_uploader_php"

  # Destination directory on dropbox to be uploaded to, must exist
  DROPBOX_DST_DIR="/"

  # Directory to backup
  DIRTOBACKUP="/home/user"

  # Exclude patterns array, check man tar for --esclude option
  # Do not put leading "/" in the patters as tar archive do not include them
  EXCLUDE=('home/user/tmp' 'home/user/cache')

  # Host name to be used in files and logs
  BACKUPHOST="localhost"

  # Backup name to be used in files and logs
  BACKUPNAME="home"

  # Temp directory to store backup file before upload
  TMPDIR="/home/user/tmp"

  # Log directory location e.g /log/autohomebackup
  LOGDIR="/home/user/log/autohomebackup"

  # Mail setup
  # What would you like to be mailed to you?
  # - log   : send only log file
  # - stdout : will simply output the log to the screen if run manually.
  # - quiet : Only send logs if an error occurs to the MAILADDR.
  MAILCONTENT="log"

  # Set the maximum allowed email size in k. (4000 = approx 5MB email [see docs])
  MAXATTSIZE="4000"

  # Email Address to send mail to? (user@domain.com)
  MAILADDR="user@domain.com"

  # ============================================================
  # === ADVANCED OPTIONS ( Read the doc's below for details )===
  #=============================================================

  # Command to run before backups (uncomment to use)
  #PREBACKUP="/etc/home-backup-pre"

  # Command run after backups (uncomment to use)
  #POSTBACKUP="/etc/home-backup-post"

  ### END CFG ###
fi

#=====================================================================
# Options documantation
#=====================================================================
# TODO
#
# Finally copy autohomebackup.sh to anywhere on your server and make sure
# to set executable permission. You can also copy the script to
# /etc/cron.daily to have it execute automatically every night or simply
# place a symlink in /etc/cron.daily to the file if you wish to keep it
# somwhere else.
#
# NOTE:On Debian copy the file with no extention for it to be run
# by cron e.g just name the file "autohomebackup"
#
# Thats it..
#
# === Advanced options doc's ===
#
# Use PREBACKUP and POSTBACKUP to specify Per and Post backup commands
# or scripts to perform tasks either before or after the backup process.
#
#=====================================================================
# Please Note!!
#=====================================================================
#
# I take no resposibility for any data loss or corruption when using
# this script..
# This script will not help in the event of a hard drive crash. If a
# copy of the backup has not be stored offline or on another PC..
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
# Lets hope you never have to use this.. :)
#
#=====================================================================
# Change Log
#=====================================================================
#
# VER 1.0.0 - (2016-03-02)
#     - Initial
#
#=====================================================================
#=====================================================================
#=====================================================================
#
# Should not need to be modified from here down!!
#
#=====================================================================
#=====================================================================
#=====================================================================
#
# Full pathname to binaries to avoid problems with aliases and builtins etc.
#
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

BASENAME="`${WHICH} basename`"
if [ "x${BASENAME}" = "x" ]; then
    BASENAME="basename"
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

SED="`${WHICH} sed`"
if [ "x${SED}" = "x" ]; then
    SED="sed"
fi

GREP="`${WHICH} grep`"
if [ "x${GREP}" = "x" ]; then
    GREP="grep"
fi

export LC_ALL=C

PATH=/usr/local/bin:/usr/bin:/bin

DATE=`${DATEC} +%Y-%m-%d_%Hh%Mm` # Datestamp e.g 2002-09-21
DOW=`${DATEC} +%A`               # Day of the week e.g. Monday
DNOW=`${DATEC} +%u`              # Day number of the week 1 to 7 where 1 represents Monday
DOM=`${DATEC} +%d`               # Date of the Month e.g. 27
M=`${DATEC} +%B`                 # Month e.g January
W=`${DATEC} +%V`                 # Week Number e.g 37

LOGFILE=${LOGDIR}/${BACKUPHOST}-${BACKUPNAME}-${DATE}.log       # Logfile Name
LOGERR=${LOGDIR}/${BACKUPHOST}-${BACKUPNAME}-${DATE}_ERRORS.log # Error Logfile Name

BACKUPFILENAME=${BACKUPHOST}-${BACKUPNAME}-${DATE}.tar.gz
BACKUPFILE=${TMPDIR}/${BACKUPFILENAME}
DST_BACKUPFILE=${DROPBOX_DST_DIR}/${BACKUPFILENAME}

TAR_OPT="czpf"

# Create required directories
if [ ! -e "${LOGDIR}" ]; then
  mkdir -p "${LOGDIR}"
fi

# IO redirection for logging.
touch ${LOGFILE}
exec 6>&1           # Link file descriptor #6 with stdout.
                    # Saves stdout.
exec > ${LOGFILE}   # stdout replaced with file ${LOGFILE}.
touch ${LOGERR}
exec 7>&2           # Link file descriptor #7 with stderr.
                    # Saves stderr.
exec 2> ${LOGERR}   # stderr replaced with file ${LOGERR}.


# Run command before we begin
if [ "${PREBACKUP}" ]; then
  ${ECHO} ======================================================================
  ${ECHO} "Prebackup command output."
  ${ECHO}
  eval ${PREBACKUP}
  ${ECHO}
  ${ECHO} ======================================================================
  ${ECHO}
fi


# Hostname for LOG information
if [ "${BACKUPHOST}" = "localhost" ]; then
  HOST=`${HOSTNAMEC}`
  if [ "${SOCKET}" ]; then
    OPT="${OPT} --socket=${SOCKET}"
  fi
else
  HOST=${BACKUPHOST}
fi

# Build tar esclude options
OPT_EXCLUDE=""
for i in "${EXCLUDE[@]}"
do
  OPT_EXCLUDE="${OPT_EXCLUDE} --exclude=${i}"
done

${ECHO} ======================================================================
${ECHO} AutoHomeBackup v${VERSION}
${ECHO} ${CODE_LINK}
${ECHO}
${ECHO} Backup of ${BACKUPNAME} at ${HOST}
${ECHO} ======================================================================
${ECHO} Backup Start Time `${DATEC}`
${ECHO}
${ECHO} Backup ${DIRTOBACKUP} to ${BACKUPFILE}
if [ ! "x${OPT_EXCLUDE}" = "x" ]; then
${ECHO} Exclude ${OPT_EXCLUDE}
fi

if [[ ${DIRTOBACKUP} == /* ]]; then
DIRTOBACKUP="${DIRTOBACKUP:1:${#DIRTOBACKUP}}"
fi
${TAR} ${TAR_OPT} "${BACKUPFILE}" ${OPT_EXCLUDE} -C / "${DIRTOBACKUP}"

${ECHO}
${ECHO} Uploading to Dropbox `${DU} -hs "${BACKUPFILE}"`
#${DROPBOX_UPLOADER} -f "${DROPBOX_UPLOADER_CONFIG}" upload "${BACKUPFILE}" "${DST_BACKUPFILE}"
${DROPBOX_UPLOADER_PHP} "${DROPBOX_UPLOADER_CONFIG_PHP}" "${BACKUPFILE}" "${DST_BACKUPFILE}"
${ECHO}
if [ ! -s "${LOGERR}" ]
then
  ${ECHO} Remove ${BACKUPFILE}
  eval ${RM} -f "${BACKUPFILE}"
  ${ECHO}
fi
${ECHO} Backup End Time `${DATEC}`
${ECHO} ======================================================================
${ECHO} If you find AutoHomeBackup valuable please make a donation at
${ECHO} ${DONATE_LINK}
${ECHO} ======================================================================

# Run command when we're done
if [ "${POSTBACKUP}" ]
  then
  ${ECHO} ======================================================================
  ${ECHO} "Postbackup command output."
  ${ECHO}
  eval ${POSTBACKUP}
  ${ECHO}
  ${ECHO} ======================================================================
fi

#Clean up IO redirection
exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.
exec 2>&7 7>&-      # Restore stdout and close file descriptor #7.

if [ "${MAILCONTENT}" = "log" ]
then
  ${CAT} "${LOGFILE}" | mail -s "Backup Log for ${HOST} - ${DATE}" ${MAILADDR}
  if [ -s "${LOGERR}" ]
    then
      ${CAT} "${LOGERR}" | mail -s "ERRORS REPORTED: Backup error Log for ${HOST} - ${DATE}" ${MAILADDR}
  fi
elif [ "${MAILCONTENT}" = "quiet" ]
then
  if [ -s "${LOGERR}" ]
    then
      ${CAT} "${LOGERR}" | mail -s "ERRORS REPORTED: Backup error Log for ${HOST} - ${DATE}" ${MAILADDR}
      ${CAT} "${LOGFILE}" | mail -s "Backup Log for ${HOST} - ${DATE}" ${MAILADDR}
  fi
else
  if [ -s "${LOGERR}" ]
    then
      ${CAT} "${LOGFILE}"
      ${ECHO}
      ${ECHO} "###### WARNING ######"
      ${ECHO} "Errors reported during AutoHomeBackup execution.. Backup failed"
      ${ECHO} "Error log below.."
      ${CAT} "${LOGERR}"
  else
    ${CAT} "${LOGFILE}"
  fi
fi

if [ -s "${LOGERR}" ]
  then
    STATUS=1
  else
    STATUS=0
fi

# Clean up Logfile
# eval ${RM} -f "${LOGFILE}"
# eval ${RM} -f "${LOGERR}"

exit ${STATUS}
