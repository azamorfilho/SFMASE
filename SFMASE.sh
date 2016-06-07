#!/bin/bash
clear
########################################################################################################################
#         Observação: O arquivo hosts.txt sempre deverá ter uma linha em branco no final.							   #
########################################################################################################################

DATE=$(date +'%Y%m%d')
HOUR=$(date +'%H:%M:%S')
LOGNAME="SFMASE_$DATE.log"

notificaEmail(){
	MAILPROGRAM='/bin/mail'
	ADMINMAIL='root@localhost'
	
	echo "$IP:$PORTA - is DOWN ($SERVICO) ($DATE $HOUR)" | $MAILPROGRAM -s "$IP:$PORTA is DOWN ($SERVICO)" $ADMINMAIL
}

notificaJabber(){
	echo "EM BREVE NOTIFICAÇÃO VIA JABBER"
}

notificaSMS(){
	echo "EM BREVE NOTIFICAÇÃO VIA SMS"
}

notificaTelegram(){
	echo "EM BREVE NOTIFICAÇÃO VIA TELEGRAM"
}

notificaIFTTT(){
	echo "EM BREVE NOTIFICAÇÃO VIA IFTTT"
}


emiteNotificacao(){
	notificaEmail
	notificaTelegram
	notificaJabber
	notificaSMS
	notificaIFTTT
}

verificaPgsqlStatus(){
	CHECKPOSTGRESPROGRAM='/usr/lib64/nagios/plugins/check_pgsql'
	SERVICO="POSTGRES"		
	
	echo "EM BREVE VERIFICAÇÃO DE POSTGRES"
}

verificaMysqlStatus(){
	CHECKMYSQLPROGRAM='/usr/lib64/nagios/plugins/check_mysql'
	SERVICO="MYSQL"		
	
	echo "EM BREVE VERIFICAÇÃO DE MYSQL"
}

verificaDnsStatus(){
	CHECKDNSPROGRAM='/usr/lib64/nagios/plugins/check_dns'
	SERVICO="DNS"		
	
	echo "EM BREVE VERIFICAÇÃO DE DNS"
}

verificaFtpStatus(){
	CHECKFTPPROGRAM='/usr/lib64/nagios/plugins/check_ftp'
	SERVICO="FTP"		
	
	echo "EM BREVE VERIFICAÇÃO DE FTP"
}

verificaSshStatus(){
	CHECKSSHPROGRAM='/usr/lib64/nagios/plugins/check_ssh'
	SERVICO="SSH"	
	
	echo "EM BREVE VERIFICAÇÃO DE SSH"
}

verificaHttpStatus(){
	CHECKHTTPROGRAM='/usr/lib64/nagios/plugins/check_http'
	SERVICO="HTTP"
	
	for ((FALHAS=1;FALHAS<=4;FALHAS++))	
	  do
		CHECKHTTP=$($CHECKHTTPROGRAM -H $IP)
		if [[ "`echo "$CHECKHTTP"|cut  -d" " -f 2 | cut -c1-2`" = "OK" ]]
		  then 
			echo "$HOUR - $IP:$PORTA - OK" >> $LOGNAME ;
			FALHAS=5
		  else
			echo "$HOUR - $IP:$PORTA - FAIL" >> $LOGNAME;
			if [[ "$FALHAS" = "4" ]]
			  then
				emiteNotificacao
			fi
		fi
	done
}

verificaTcpStatus()
{
	CHECKTCPPROGRAM='/usr/lib64/nagios/plugins/check_tcp'
	SERVICO="TCP"	
	
	for ((FALHAS=1;FALHAS<=4;FALHAS++))	
	  do
		CHECKTCP=$($CHECKTCPPROGRAM -H $IP -p $PORTA)
		
		if [[ "$`echo "$CHECKTCP"|cut -d" " -f 2`" = "OK" ]]
		  then 
			echo "$HOUR - $IP:$PORTA - OK" >> $LOGNAME ;
			FALHAS=5
		  else
			echo "$HOUR - $IP:$PORTA - FAIL" >> $LOGNAME;
			if [[ "$FALHAS" = "4" ]]
			  then
				emiteNotificacao
			fi
		fi
	done
}
	
while read LINHA;
	do
	campos="$LINHA"
	for ((i=2;i<=65536;i++))
		do
		IP=(`echo "$campos"|cut -d"|" -f 1`)
		PORTA=(`echo "$campos"|cut -d"|" -f $i`)
			if test -z $PORTA
				then
					i=65537
				else 
					case "$PORTA" in
						21) verificaFtpStatus ;;
						22) verificaSshStatus ;;
						53) verificaDnsStatus ;;
						80) verificaHttpStatus ;;
						3306) verificaMysqlStatus ;;
						5432) verificaPgsqlStatus ;;
						*)verificaTcpStatus
					esac
			fi
	done
done < hosts.txt
