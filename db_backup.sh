#!/bin/bash


FILENAME="mysql_backup_"$(date +"%Y-%m-%d_%H-%M-%S")".sql"
FILEPATH="/tmp/"
GDRIVEPATH="Tardis-Backup"
PRINT_HELP=0
DATABASENAME="phe"


##### Arguments
GIVEN_ARGS=$#

while getopts p:G:d:h opt; do
    case $opt in
	p)
		FILEPATH=${OPTARG}
        ;;
	G)
		GDRIVEPATH=${OPTARG}
        ;;
    d)
        DATABASENAME=${OPTARG}
        ;;
    h)
        PRINT_HELP=1
        ;;
    *)
        PRINT_HELP=1
        ;;
    esac
done

if [ $GIVEN_ARGS -eq 0 -o $PRINT_HELP -eq 1 ]; then
    echo ""
    echo "### Backup to Google Drive ###"
    echo "usage: db_backup [-p FILEPATH] [-G GDRIVEPATH] [-h]"
    echo ""
    echo "-p [FILEPATH] path to archive"
    echo "-G [GDRIVEPATH] path at google drive"
    echo "-d [DATABASENAME] database name"
    echo "-h print help"
    echo ""
    exit 1
fi


#check remote backup folder exists on gdrive
GDRIVEFOLDERID=$(gdrive list --no-header | grep $GDRIVEPATH | grep dir | awk '{ print $1}')
    if [ -z "$GDRIVEFOLDERID" ]; then
        gdrive mkdir $GDRIVEPATH
        GDRIVEFOLDERID=$(gdrive list --no-header | grep $GDRIVEPATH | grep dir | awk '{ print $1}')
    fi

mysqldump -ubackup $DATABASENAME > $FILENAME;


tar -C /tmp/ -czf $FILENAME.tar.gz $FILENAME;
rm -f $FILEPATH$FILENAME;

gdrive upload --parent $GDRIVEFOLDERID --delete $FILEPATH$FILENAME.tar.gz
