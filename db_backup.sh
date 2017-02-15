FILENAME="mysql_backup_"$(date +"%Y-%m-%d_%H-%M-%S")".sql";
FILEPATH="/tmp/";
GDRIVEPATH="Tardis-Backup";

cd $FILEPATH;


#check remote backup folder exists on gdrive
GDRIVEFOLDERID=$(gdrive list --no-header | grep $GDRIVEPATH | grep dir | awk '{ print $1}')
    if [ -z "$GDRIVEFOLDERID" ]; then
        gdrive mkdir $GDRIVEPATH
        GDRIVEFOLDERID=$(gdrive list --no-header | grep $GDRIVEPATH | grep dir | awk '{ print $1}')
    fi

mysqldump -ubackup phe > $FILENAME;

tar -czf $FILENAME.tar.gz $FILENAME;
rm -f $FILENAME;

gdrive upload --parent $GDRIVEFOLDERID --delete $FILENAME.tar.gz
