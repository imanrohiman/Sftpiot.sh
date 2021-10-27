#!/bin/sh
#sftpiot.sh made by ADLI-DevOps
#cron
# 15 6 * * * /home/devcrew/sftpiot.sh >/home/devcrew/sftpiot.log 2>&1


sourcesms=ToGet-SMS
sourcegprs=ToGet-GPRS
destisms=/home/devcrew/EricssonCDR/ToGet-SMS
destigprs=/home/devcrew/EricssonCDR/ToGet-GPRS
PASSericsson=Ykar?j8X
PASSiot=Xladl@123
USERericsson=XLI-DCP
USERiot=adluser
SERVERericsson=193.181.246.62
SERVERiot=172.30.251.118
TGL=$(date +%Y%m%d) #ambil tanggal hari ini
BLN=$(date +%Y%m) #ambil bulan ini

if pidof -o %PPID -x "sftpiot.sh"; then
exit 1
fi
###Download Dari sftp erricsson
##cd $destisms ##pindah directory
mkdir -p $destisms/$BLN ##Bikin folder sesuai bulan  kalo belom ada, kalo ada skip
cd $destisms/$BLN
echo
echo "Downloading...ToGet-SMS"
	lftp -e "mirror -v -n -P 100 -I *_$BLN??-*  /$sourcesms/ $destisms/$BLN; exit" -u $USERericsson,$PASSericsson sftp://$SERVERericsson ##Download ToGet-SMS
echo
echo "selesai download: `date`"
###
##cd $destigprs
mkdir -p $destigprs/$BLN ##Bikin folder sesuai bulan  kalo belom ada, kalo ada skip
cd $destigprs/$BLN
echo
echo "Downloading...ToGet-GPRS"
	lftp -e "mirror -v -n -P 100 -I *_$BLN??-*  /$sourcegprs/ $destigprs/$BLN; exit" -u $USERericsson,$PASSericsson sftp://$SERVERericsson  ##Download ToGet-GPRS
echo
echo "selesai download: `date`"
###
## Upload ke iot portal server
cd /home/devcrew/EricssonCDR
echo
echo "Uploading...ToGet-SMS"
	lftp -e "mirror -v -n -R -P 100 -I *_$BLN??-* $destisms/$BLN  /files/ToGet-SMS/; exit" -u $USERiot,$PASSiot sftp://$SERVERiot ##Upload ToGet-SMS ke server iot
echo
echo "selesai upload: `date`"
echo
echo "Uploading...ToGet-GPRS"
	lftp -e "mirror -v -n -R -P 100 -I *_$BLN??-* $destigprs/$BLN  /files/ToGet-GPRS/; exit" -u $USERiot,$PASSiot sftp://$SERVERiot ##Upload ToGet-SMS ke server iot
echo
echo "selesai upload: `date`"
exit 0
