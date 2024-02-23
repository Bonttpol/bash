#!/bin/bash

log_path="/var/log/nginx/access.log"
htacs_path="/var/www/html/.htaccess"

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
attackers_ip_addresses=$(grep -r "/bitrix/admin" $log_path | awk '{print $1}') # "${vulnerable_directories[*]}"

# Сгенерировать правила для файла .htaccess
htaccess_rules=""
htaccess_cat=`cat $htacs_path`

for attacker_ip_address in "${attackers_ip_addresses[@]}"; do

  htaccess_rules+="Deny from $attacker_ip_address\n"
done

# Добавить правила в файл .htaccess
echo -e "$htaccess_rules" >> $htacs_path