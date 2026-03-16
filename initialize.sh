#!/bin/bash

pgbouncer_ini_path="/etc/pgbouncer/pgbouncer.ini"
pgbouncer_userlist_path="/etc/pgbouncer/userlist.txt"

IFS=',' read -r -a array_db_hosts <<< "$DB_HOSTS"
IFS=',' read -r -a array_db_ports <<< "$DB_PORTS"
IFS=',' read -r -a array_db_names <<< "$DB_NAMES"
IFS=',' read -r -a array_db_users <<< "$DB_USERS"
IFS=',' read -r -a array_db_passwords <<< "$DB_PASSWORDS"

cat <<EOL > $pgbouncer_ini_path
[databases]
EOL

x=0

for db_name in "${array_db_names[@]}"; do    
    echo "$db_name = host=${array_db_hosts[$x]} port=${array_db_ports[$x]} dbname=$db_name" >> $pgbouncer_ini_path
    x=$((x + 1))
done

cat <<EOL >> $pgbouncer_ini_path
[pgbouncer]
listen_addr = ${LISTEN_ADDR:-0.0.0.0}
listen_port = ${LISTEN_PORT:-6432}
auth_type = ${AUTH_TYPE:-scram-sha-256}
auth_file = /etc/pgbouncer/userlist.txt
pool_mode = ${POOL_MODE:-transaction}
max_client_conn = ${MAX_CLIENT_CONN:-100}
default_pool_size = ${DEFAULT_POOL_SIZE:-20}
logfile = /dev/stdout
ignore_startup_parameters = extra_float_digits
EOL

y=0
for db_user in "${array_db_users[@]}"; do    
    echo "\"$db_user\" \"${array_db_passwords[$y]}\"" >> $pgbouncer_userlist_path
    y=$((y + 1))
done

exec pgbouncer /etc/pgbouncer/pgbouncer.ini