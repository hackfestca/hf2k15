#!/bin/bash

echo Backuping web01
scp -rq root@sb-web01.hf:{/etc/nginx/conf.d,/etc/nginx/nginx.conf,/var/www/htdocs,/etc/rc.local} web01/
echo Backuping web02
scp -rq root@sb-web02.hf:{/etc/nginx/conf.d,/etc/nginx/nginx.conf,/var/www/htdocs,/etc/rc.local} web02/

echo Backuping app01
scp -rq root@sb-app01.hf:{/etc/supervisord*,/var/cron/tabs,/etc/rc.local} app01/
echo Backuping app02
scp -rq root@sb-app02.hf:{/etc/supervisord*,/var/cron/tabs,/etc/rc.local} app02/

echo Backuping db01
scp -rq root@sb-db01.hf:{/var/postgresql/data/postgresql.conf,/var/postgresql/data/pg_hba.conf,/var/postgresql/data/certs,/etc/sysctl.conf,/etc/rc.local} db01/
echo Backuping db02
scp -rq root@sb-db02.hf:{/var/postgresql/data/postgresql.conf,/var/postgresql/data/pg_hba.conf,/var/postgresql/data/certs,/etc/sysctl.conf,/etc/rc.local} db01/

echo Backuping db00
scp -rq root@sb-db00.hf:{/etc/pgpool*,/etc/sysctl.conf,/etc/rc.local} db00/
