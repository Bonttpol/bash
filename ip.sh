#!/bin/bash

log_path="/var/log/nginx/access.log"
htacs_path="/home/bitrix/www/.htaccess"

tail -n0 -f $log_path | grep --line-buffered -E '^([1-9]{1,3}\.){3}[1-9]{1,3}' | while read line 
    do 
       ip=` echo $line | cut -d' ' -f1 | tr -s '\r\n' ' '`
       cnt=` whois $ip | grep "ountry:" | head -n1 | cut -d ':' -f2`
       htacs=`cat $htacs_path`

       if [[ ! $htacs =~ $ip ]] && [[ $cnt =~ "RU" ]]
       then 
            echo "Deny from $ip" >> $htacs_path
       fi
    done