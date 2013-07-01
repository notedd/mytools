#! /bin/sh

#-------------arguments-----------#
DB_HOST="192.168.24.83"
DB_USR="flight_tmp"
DB_PWD="G5AcwHbE8Oqi"
DB_CONN="-u$DB_USR -p$DB_PWD -h$DB_HOST"
DEFAULT_DB="tts"
OTA_DB="com_qunar_trade_xia"

#------------tools,time,file name of backup---------#
BF_CMD="/home/q/mysql/bin/mysqldump"
EXEC_CMD="/home/q/mysql/bin/mysql"
BF_TIME=$(date +%Y%m%d-%H%M)
NAME_1="$DEFAULT_DB-$BF_TIME"
NAME_2="$OTA_DB-$BF_TIME"

#----------export .sql scripts---#
cd ~
$BF_CMD $DB_CONN -no-data --lock-tables=false $DEFAULT_DB > $NAME_1.sql
$BF_CMD $DB_CONN -no-data $OTA_DB > $NAME_2.sql

#----------create database and tables----------#
$EXEC_CMD $DB_CONN -e"create database tts"
$EXEC_CMD $DB_CONN tts < $NAME_1.sql
$EXEC_CMD $DB_CONN -e"create database tts_gn1"
$EXEC_CMD $DB_CONN tts_gn1 < $NAME_2.sql

#------------insert default data-------------#
$BF_CMD $DB_CONN $DEFAULT_DB client_shard > client_shard.sql
$EXEC_CMD $DB_CONN tts < client_shard.sql
$BF_CMD $DB_CONN $DEFAULT_DB qss_client_information > qss_client_information.sql
$EXEC_CMD $DB_CONN tts < qss_client_information.sql

