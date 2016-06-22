#!/bin/bash
source /home/cdadmin/.bash_profile
DATE=$(date +"%Y%m%d%H%M")

cd /opt/ConnectDirect/ndm/bin/
for a in `ls /sendfile/directory/`; do

cat > /opt/ConnectDirect/ndm/bin/wildcard.cd <<EOL
WILDCARD PROCESS

      SNODE=EXAMPLE.SOURCE
      SNODEID=(USERNAME,PASSWORD)



WILDCARD COPY

from
(
file = /sendfile/directory/${a}
sysopts=":strip.blanks=no:"
pnode
)

ckpt = 2M
compress extended

to
(
FILE=DESTINATION.FILENAME
DCB=(RECFM=FB,LRECL=137)
snode
disp = rpl
)

pend;
EOL

/opt/ConnectDirect/ndm/bin/direct << EOJ
submit file = wildcard.cd;
quit;
EOJ

sleep 30

LOGFILE=$(date +"%Y%m%d").001
RCODE=$(cat /opt/ConnectDirect/work/EXAMPLE.NODE/S$LOGFILE | grep CCOD= |tail -1 |awk -F 'CCOD=' '{print $2}' |awk -F '|' '{print $1}')

if [ $RCODE -eq 0 ]
then
        echo "Connect:Direct file $a successfully sent on `date`." | mailx -s "Connect:Direct file send success" user@example.com
        mv /sendfile/directory/$a /sendfile/directory/sendhistory/$DATE-$a
else
        echo "Connect:Direct file $a failed to send on `date`." | mailx -s "Connect:Direct file send failed" user@example.com
fi

sleep 5

done

exit 0
