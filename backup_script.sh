#!/bin/bash
#Author : Kalidoss
#location : Bangalore
#email : kalidossbtech@gmail.com

#example locations and IP

set -x
DATE=`date`
# CVS_R&D RSYNC backup
rsync -rv root@192.168.2.8:/usr2 /BACKUP_1/SERVER/cvs_r_and_d/CVSRSYNC > /var/log/backup_RandD.log
if (($?)); then
{

        echo "$DATE  \ "This is error generated, when backing up the RandD CVS data"\ " >> /var/log/backupmail.log
        mail -s "CVS_R&D RSYNC BACKUP ERROR" kalidossbtech@gmail.com < /var/log/backupmail.log
#        exit;
}
else
{
        tail /var/log/backup_RandD.log > /var/log/CVSRD.txt && mail -s "CVS_R&D RSYNC BACKUP is successfull($DATE)" admin@jvselectronics.in,noc_team@ahana.co.in < /var/log/CVSRD.txt
#       tail backup_RandD.log > CVSRD.txt && mail -s "Test Mail" kalidossbtech@gmail.com < /var/log/CVSRD.txt
}
fi


#CVS_Production RSYNC backup
rsync -rv -e "ssh -p 3333" root@192.168.1.8:/cvs /BACKUP_1/SERVER/cvs_production/CVSRSYNC > /var/log/backup_production.log
if (($?)); then
{

        echo "$DATE  \ "This is error generated, when backing up the Production CVS data"\ " >> /var/log/backupmail.log
        mail -s "CVS_Production RSYNC BACKUP ERROR" kalidossbtech@gmail.com < /var/log/backupmail.log
#        exit;
}
else
{
tail /var/log/backup_production.log > /var/log/CVSPRO.txt && mail -s "CVS_Production RSYNC BACKUP is successfull($DATE)" admin@jvselectronics.in,noc_team@ahana.co.in < /var/log/CVSPRO.txt
#tail backup_production.log > CVSPRO.txt && mail -s "Test Mail" kalidossbtech@gmail.com < /var/log/CVSPRO.txt
}
fi

