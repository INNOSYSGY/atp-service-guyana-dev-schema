#!/bin/bash


if [ ! -d .dbtools ];then
    echo "project init -name $SCHEMA -d . -schemas $SCHEMA" | sql /nolog
fi

git pull

mkdir -p schema

cat <<EOF > /tmp/export_${SCHEMA}.sql

set long 100000
SET LINESIZE 200
SET TRIMSPOOL ON
SET HEAD OFF
SET PAGESIZE 0
SET FEEDBACK OFF
SET VERIFY OFF
SET ECHO OFF

project export

project verify -verbose

cd schema/

lb generate-schema -split -replace -overwrite-files -sql

EOF

echo $ATP_WALLET | base64 --decode > Wallet_DEVENV.zip
sql  -cloudconfig  Wallet_DEVENV.zip $DB_USER/$DB_PASSWORD@$DB_URL @/tmp/export_${SCHEMA}.sql
