#!/bin/bash

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
attackers_ip_addresses=$(grep -r "${vulnerable_directories[*]}" /var/log/nginx/access.log | awk '{print $1}')

# Сгенерировать правила для файла .htaccess
htaccess_rules=""
for attacker_ip_address in "${attackers_ip_addresses[@]}"; do
  htaccess_rules+="deny $attacker_ip_address;\n"
done

# Добавить правила в файл .htaccess
echo -e "$htaccess_rules" >> /home/bitrix/www/.htaccess