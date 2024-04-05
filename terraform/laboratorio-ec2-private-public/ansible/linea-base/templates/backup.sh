#!/bin/sh
DIRECTORY_REMOTE="/backup"
DIRECTORY_ORIGEN="/objetive"
SERVER_REMOTE="monitoreo"
USER_REMOTE="administrator"
PRIVATE_KEY="${HOME}/.ssh/id_rsa"
DATE_FILE=$(date +%d-%m-%Y)
LOG_FILE="/var/log/backup_${DATE_FILE}.log"
LOG_FILE_ERROR="${LOG_FILE}.error"
RSYNC=$(which rsync)
PORT=5040

if [[ ! -f ${LOG_FILE} ]]; then
  sudo touch ${LOG_FILE}
  sudo chown administrator:administrator ${LOG_FILE}
fi
__respaldo() {
  echo "------- INICIO del BACKUP ------" > ${LOG_FILE}
  echo "--------- ${DATE_FILE} -----------" > ${LOG_FILE}
  echo "" >> ${LOG_FILE}
  $RSYNC -avzp -e "ssh -i $PRIVATE_KEY -p $PORT" $DIRECTORY_ORIGEN $USER_REMOTE@$SERVER_REMOTE:$DIRECTORY_REMOTE 1 >>${LOG_FILE} 2>${LOG_FILE_ERROR}
  echo "------ FIN del BACKUP ---------" >> ${LOG_FILE}
}
__respaldo
