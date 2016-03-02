# Auto Home Backup v1.0.0

Auto Home Backup script to Dropbox using bash and [Dropbox PHP SDK](https://github.com/dropbox/dropbox-sdk-php). Ideal for full web sites backup from cPanel.

License: [GNU](LICENSE)

## Description

This is a simple script that can be run from a cron job on local Linux or a cPanel web hosting server.

What it does is to archive your home directory and upload that archive file to your Dropbox account regularly. Once the job is done it sends an email with log messages from the execution. If something goes wrong it will include the error log in the email too.

You can make several config files and several cron jobs for them. With that you can backup different parts of your server with different options. Especially useful if you have multiple web sites on a single hosting account with add-on domains.

## Buy Me a Drink

If you like the scripts here and they save you valuable time and efforts you can buy me a drink or two here:
:coffee: :beers: [Buy Me a Drink :cocktail:](http://4ui.us/tpit) :tropical_drink: :wine_glass: :tea:


## Requirements

Download the latest [Dropbox PHP SDK](https://github.com/dropbox/dropbox-sdk-php)

Follow the steps form [Dropbox PHP SDK - Get a Dropbox API key](https://github.com/dropbox/dropbox-sdk-php#get-a-dropbox-api-key) to make the auth config file. This is done only once and you should do it at your local Linux box.

It is preferred to use a Dropbox App authentication, check the [Dropbox PHP SDK - Get a Dropbox API key](https://github.com/dropbox/dropbox-sdk-php#get-a-dropbox-api-key) documentation.

Place the SDK files on same level as the scripts:
```
examples/                ;comes from Dropbpx PHP SDK
lib/                     ;comes from Dropbpx PHP SDK
autohomebackup.sh
dropbox_uploader_php.sh
```

## Setup

Make your own config file or directly edit the config option from the script. The script contains the config option description with simple example values.

## Examples

Examples below are assuming that you uploaded the script files and [Dropbox PHP SDK](https://github.com/dropbox/dropbox-sdk-php) to
`/home/<cpaneluser>/bin`

### Cron Jobs
```
0 1 * * * /home/<cpaneluser>/bin/autohomebackup.sh -c /home/<cpaneluser>/bin/autohomebackup_site-a.conf
0 2 * * * /home/<cpaneluser>/bin/autohomebackup.sh -c /home/<cpaneluser>/bin/autohomebackup_site-b.conf
```

### Config Example Web Site A

`/home/<cpaneluser>/bin/autohomebackup_site-a.conf`

```
DROPBOX_UPLOADER_PHP="/home/<cpaneluser>/bin/dropbox_uploader_php.sh"
DROPBOX_UPLOADER_CONFIG_PHP="/home/<cpaneluser>/bin/.dropbox_uploader_php_auth"
DROPBOX_DST_DIR="/site-a"
DIRTOBACKUP="/home/<cpaneluser>/public_html/site-a"
EXCLUDE=('home/<cpaneluser>/public_html/site-a/cache' 'home/<cpaneluser>/public_html/site-a/temp')
BACKUPHOST="localhost"
BACKUPNAME="site-a"
TMPDIR="/home/<cpaneluser>/tmp"
LOGDIR="/home/<cpaneluser>/logs/autohomebackup"
MAILCONTENT="log"
MAXATTSIZE="4000"
MAILADDR="admin@site-a.com"
```

:zap: *The DROPBOX_DST_DIR must exist in the Dropbox account /home/Apps/Dropbox-App-Name/site-a*

:zap: *The paths in EXCLUDE option must be without leading '/'*

### Config Example Web Site B

`/home/<cpaneluser>/bin/autohomebackup_site-b.conf`

```
DROPBOX_UPLOADER_PHP="/home/<cpaneluser>/bin/dropbox_uploader_php.sh"
DROPBOX_UPLOADER_CONFIG_PHP="/home/<cpaneluser>/bin/.dropbox_uploader_php_auth"
DROPBOX_DST_DIR="/site-b"
DIRTOBACKUP="/home/<cpaneluser>/public_html/site-b"
EXCLUDE=('home/<cpaneluser>/public_html/site-b/cache')
BACKUPHOST="localhost"
BACKUPNAME="site-b"
TMPDIR="/home/<cpaneluser>/tmp"
LOGDIR="/home/<cpaneluser>/logs/autohomebackup"
MAILCONTENT="log"
MAXATTSIZE="4000"
MAILADDR="admin@site-b.com"
```

:zap: *The DROPBOX_DST_DIR must exist in the Dropbox account /home/Apps/Dropbox-App-Name/site-b*

:zap: *The paths in EXCLUDE option must be without leading '/'*

### Notes
Replace the `<cpaneluser>` with your cPanel server user directory name or your local Linux home dir name.

The `/home/<cpaneluser>/bin/.dropbox_uploader_php_auth` from the configs is generated from [Dropbox PHP SDK - Get a Dropbox API key](https://github.com/dropbox/dropbox-sdk-php#get-a-dropbox-api-key) authentication setup.

The backup files that will be uploaded to your Dropbox account from the configs will be located at:
```
/home/Apps/Dropbox-App-Name/site-a/localhost-site-a-2016-03-02_08h55m.tar.gz
/home/Apps/Dropbox-App-Name/site-b/localhost-site-b-2016-03-02_08h55m.tar.gz
```

The `Dropbox-App-Name` will be the one that you configured from [Dropbox PHP SDK - Get a Dropbox API key](https://github.com/dropbox/dropbox-sdk-php#get-a-dropbox-api-key) authentication setup.

## Credits

I used the part of the code from [Auto MySQL Backup](https://sourceforge.net/projects/automysqlbackup/)
