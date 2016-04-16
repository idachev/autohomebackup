# Auto Home Backup

Auto Home Backup script to Dropbox using bash and [Dropbox SDK PHP](https://github.com/dropbox/dropbox-sdk-php). Ideal for full web sites backup from cPanel.

License: [GNU](LICENSE)

[Latest Release v1.0.5 - Direct Download](https://github.com/idachev/autohomebackup/releases/download/v1.0.5/autohomebackup_v1.0.5_20160416_225716.tar.gz)

[All Releases](https://github.com/idachev/autohomebackup/releases)

## Description

This is a simple script that can be run from a cron job on local Linux or a cPanel web hosting server.

What it does is to archive your home directory and upload that archive file to your Dropbox account regularly. Once the job is done it sends an email with log messages from the execution. If something goes wrong it will include the error log in the email too.

You can make several config files and several cron jobs for them. With that you can backup different parts of your server with different options. Especially useful if you have multiple web sites on a single hosting account with add-on domains.

## Buy Me a Drink

If you like my work and it save you a valuable time and effort, please buy me a drink or two here:

[:coffee: :beers: :cocktail: :tropical_drink: :wine_glass: :tea:](http://4ui.us/tpit)


## Requirements

In order to use the script you need to do the following:
 1. Have a Dropbox account
 2. Create a Dropbox App Folder - you can create such application folder from your Dropbox account here [Dropbox Apps](https://www.dropbox.com/developers/apps). 
 3. Make a Dropbox SDK PHP authentication file - steps are listed here [Dropbox SDK PHP - Get a Dropbox API key](https://github.com/dropbox/dropbox-sdk-php#get-a-dropbox-api-key).

These steps are done only once and you should do them from your local Linux box.

It is preferred to use a Dropbox App authentication, check the [Dropbox SDK PHP - Get a Dropbox API key](https://github.com/dropbox/dropbox-sdk-php#get-a-dropbox-api-key) documentation.

## Setup

Make your own config file or directly edit the config option from the script.

Check examples below.

## Required Config Options

```
DROPBOX_DST_DIR="/home-backup"
```
Destination directory on Dropbox to be uploaded to. It will be created on first upload under your Dropbox App directory.
 
```
BASE_DIR="/home
```
Base directory to what the dirs in `DIRS_TO_BACKUP` and `EXCLUDE` are relative.

```
DIRS_TO_BACKUP=("user")
```
Directories array to backup, at least one should be specified.
All directories should be relative to the `BASE_DIR`.
If you want to backup all content of `BASE_DIR` then use: `('.')`

```
EXCLUDE=('user/tmp_data' 'tmp' 'cache')
```
Exclude patterns array, check [man tar](http://www.gnu.org/software/tar/manual/tar.html) for `--exclude` option.
Do not put leading `"/"` in the patters as tar archive do not include them.
If you need to use `?` and `*` in patterns use the single-quoted: `'dir/*'`

```
BACKUP_HOST="localhost"
```
Host name to be used in files and logs.

```
BACKUP_NAME="home"
```
Backup name to be used in files and logs.

```
TMP_DIR="/home/user/tmp"
```
Temp directory to store backup file before upload.

```
LOG_DIR="/home/user/log/autohomebackup"
```
Directory location where the script will store its logs.

```
MAIL_ADDR="user@domain.com"
```
Email address to send mail to.

## Default Config Options

```
DROPBOX_UPLOADER_PHP="dropbox_uploader_php.sh"
```
`dropbox_uploader_php.sh` script location provided along with this script
  

```
DROPBOX_UPLOADER_PHP_AUTH=".dropbox_uploader_php.auth"
```
`.dropbox_uploader_php.auth` token for more info how to create a auth file check [Dropbox SDK PHP - Get a Dropbox API key](https://github.com/dropbox/dropbox-sdk-php#get-a-dropbox-api-key) documentation
  
```
MAIL_CONTENT="log"
```
Mail setup, what would you like to be mailed to you?
 - `log` - send only log file.
 - `stdout` - will simply output the log to the screen if run manually.
 - `quiet` - only send logs if an error occurs to the MAIL_ADDR.

```
MAX_ATT_SIZE="4000"
```
Set the maximum allowed email size in k. (4000 = approx 5MB email).

```
PRE_BACKUP="/etc/home-backup-pre"
```
Command to run before backups.

```
POST_BACKUP="/etc/home-backup-post"
```
Command to run after backups.

## Examples

Examples below are assuming that you uploaded the script release files to
`/home/<cpaneluser>/bin`

Also the script will look by default for `/home/<cpaneluser>/bin/.dropbox_uploader_php.auth`.
This file will be generated from [Dropbox SDK PHP - Get a Dropbox API key](https://github.com/dropbox/dropbox-sdk-php#get-a-dropbox-api-key) authentication setup.

### Cron Jobs Example

Flowing are jobs to backup of `Web Site A` and `Web Site B` once a day.
The `Server System` backup is done once a month at its 1 day.

```
0 1 * * * /home/<cpaneluser>/bin/autohomebackup.sh -c autohomebackup_site-a.conf
0 2 * * * /home/<cpaneluser>/bin/autohomebackup.sh -c autohomebackup_site-b.conf
0 3 1 * * /home/<cpaneluser>/bin/autohomebackup.sh -c autohomebackup_server-system.conf
```

### Config Example Backup Web Site A

It will backup all of the files under `/home/<cpaneluser>/public_html/site-a` and `/home/<cpaneluser>/mysql-backups/site-a`.
Excluding all cache and temp directories at any level in directories to backup.
Also will exclude and a custom directory `site-a/custom-dir` that we do not want to backup for this site.  

`/home/<cpaneluser>/bin/autohomebackup_site-a.conf`

```
DROPBOX_DST_DIR="/site-a"
BASE_DIR="/home/<cpaneluser>"
DIRS_TO_BACKUP=("public_html/site-a" "mysql-backups/site-a")
EXCLUDE=('cache' 'tmp' 'temp' 'site-a/custom-dir')
BACKUP_HOST="localhost"
BACKUP_NAME="site-a"
TMP_DIR="/home/<cpaneluser>/tmp"
LOG_DIR="/home/<cpaneluser>/logs/autohomebackup"
MAIL_ADDR="admin@site-a.com"
```

:zap: The `DROPBOX_DST_DIR` will be created in the Dropbox account `/home/Apps/Dropbox-App-Name/site-a`

:zap: The backup file that will be uploaded to your Dropbox account will be located at: `/home/Apps/Dropbox-App-Name/site-a/localhost-site-a-2016-03-02_08h55m.tar.gz`

### Config Example Backup Web Site B

It will backup all of the files under `/home/<cpaneluser>/public_html/site-b` and `/home/<cpaneluser>/mysql-backups/site-b`.
Excluding all cache and temp directories at any level in directories to backup.
Also will exclude and a custom directory `site-b/custom-dir` that we do not want to backup for this site.  

`/home/<cpaneluser>/bin/autohomebackup_site-b.conf`

```
DROPBOX_DST_DIR="/site-b"
BASE_DIR="/home/<cpaneluser>"
DIRS_TO_BACKUP=("public_html/site-b" "mysql-backups/site-b")
EXCLUDE=('cache' 'tmp' 'temp' 'site-b/custom-dir')
BACKUP_HOST="localhost"
BACKUP_NAME="site-b"
TMP_DIR="/home/<cpaneluser>/tmp"
LOG_DIR="/home/<cpaneluser>/logs/autohomebackup"
MAIL_ADDR="admin@site-a.com"
```

:zap: The `DROPBOX_DST_DIR` will be created in the Dropbox account `/home/Apps/Dropbox-App-Name/site-b`

:zap: The backup file that will be uploaded to your Dropbox account will be located at: `/home/Apps/Dropbox-App-Name/site-b/localhost-site-b-2016-03-02_08h55m.tar.gz`

### Config Example Backup Web Server System Data

Useful to backup all of your server system logs and configs without your web sites `public_html` folder.

`/home/<cpaneluser>/bin/autohomebackup_server-system.conf`

```
DROPBOX_DST_DIR="/server-system"
BASE_DIR="/home/<cpaneluser>"
DIRS_TO_BACKUP=('.')
EXCLUDE=('cache' 'tmp' 'public_html')
BACKUP_HOST="localhost"
BACKUP_NAME="server-system"
TMP_DIR="/home/<cpaneluser>/tmp"
LOG_DIR="/home/<cpaneluser>/logs/autohomebackup"
MAIL_ADDR="admin@site-a.com"
```

:zap: The `DROPBOX_DST_DIR` will be created in the Dropbox account `/home/Apps/Dropbox-App-Name/server-system`

:zap: The backup file that will be uploaded to your Dropbox account will be located at: `/home/Apps/Dropbox-App-Name/server-system/localhost-server-system-2016-03-02_08h55m.tar.gz`

### Notes
:zap: Replace the `<cpaneluser>` with your cPanel server user directory name or your local Linux home dir name.

:zap: The paths in `EXCLUDE` option must be relative to `BASE_DIR` or `BASE_DIR/DIRS_TO_BACKUP`

:zap: The `Dropbox-App-Name` will be the one that you configured from [Dropbox SDK PHP - Get a Dropbox API key](https://github.com/dropbox/dropbox-sdk-php#get-a-dropbox-api-key) authentication setup.

:zap: The `/home/<cpaneluser>/mysql-backups` from examples above is a directory where [Auto MySQL Backup](https://sourceforge.net/projects/automysqlbackup/)
is setup to regularly backup MySQL database files. Its cron job should be placed to be executed before the cron job for Auto Home Backup.

## Credits

I used some parts of the code from [Auto MySQL Backup](https://sourceforge.net/projects/automysqlbackup/)
