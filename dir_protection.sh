#!/bin/bash

log_path="/var/log/nginx/access.log"
htacs_path="/var/www/html/.htaccess"  #"/var/www/html/.htaccess"

# Список уязвимых директорий
echo "
  /bitrix/admin
  /bitrix/components
  /bitrix/modules
  /bitrix/templates
  /bitrix/cache
  /bitrix/managed_cache
" >> vulnerable_directories

# Получить список всех IP-адресов, обращавшихся к уязвимым директориям
attackers_ip_addresses=$(grep -f ./vulnerable_directories $log_path | awk '{print $1}') 

# Сгенерировать правила для файла .htaccess
htaccess_rules=""

for attacker_ip_address in ${attackers_ip_addresses[*]}; do
    htacs=`cat $htacs_path`
    if [[ ! $htacs =~ $attacker_ip_address ]]; then 
        echo "Deny from $attacker_ip_address" >> $htacs_path
    fi
done

rm ./vulnerable_directories