 #!/bin/dash

FILENAME="mysql_backup_"$(date +"%Y-%m-%d_%H-%M-%S")".sql";
FILEPATH="/tmp/";
GDRIVEPATH="Tardis-Backup";


#check remote backup folder exists on gdrive
GDRIVEFOLDERID=$(gdrive list --no-header | grep $GDRIVEPATH | grep dir | awk '{ print $1}')
    if [ -z "$GDRIVEFOLDERID" ]; then
        gdrive mkdir $GDRIVEPATH
        GDRIVEFOLDERID=$(gdrive list --no-header | grep $GDRIVEPATH | grep dir | awk '{ print $1}')
    fi

mysqldump -ubackup phe > $FILEPATH$FILENAME;

tar -C /tmp/ -czf $FILENAME.tar.gz $FILENAME;
rm -f $FILEPATH$FILENAME;

gdrive upload --parent $GDRIVEFOLDERID --delete $FILEPATH$FILENAME.tar.gz
