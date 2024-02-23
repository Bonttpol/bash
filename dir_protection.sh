#!/bin/bash

log_path="/var/log/nginx/access.log"
htacs_path="/root/bash/test"  #"/var/www/html/.htaccess"

# Список уязвимых директорий
vulnerable_directories=(
  "/bitrix/admin"
  "/bitrix/components"
  "/bitrix/modules"
  "/bitrix/templates"
  "/bitrix/cache"
  "/bitrix/managed_cache"
)

# Получить список всех IP-адресов, обращавшихся к уязвимым директориям
attackers_ip_addresses=$(grep -v "${vulnerable_directories[*]}" $log_path | awk '{print $1}') 

# Сгенерировать правила для файла .htaccess
htaccess_rules=""

for attacker_ip_address in "${attackers_ip_addresses[*]}"; do

    htacs=`cat $htacs_path`
    if [[ ! $htacs =~ $attacker_ip_address ]]; then 
        echo "IP - $attacker_ip_address"
        htaccess_rules+="Deny from $attacker_ip_address\n"
    fi
done

# Добавить правила в файл .htaccess
echo $htaccess_rules #>> $htacs_path