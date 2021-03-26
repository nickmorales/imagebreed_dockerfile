#!/bin/bash
sed -i s/localhost/$HOSTNAME/g /etc/slurm-llnl/slurm.conf
/etc/init.d/postfix start
/etc/init.d/munge start
/etc/init.d/slurmctld start
/etc/init.d/slurmd start
/etc/init.d/postgresql start

if [ "$RUN_DB_PATCHES" == "TRUE" ]; then
    sleep 1m
    cd /home/production/cxgn/sgn/db/ && bash -c "echo -ne $DATABASE_PASSWORD | ./run_all_patches.pl -h $DATABASE_HOST -d $DATABASE_NAME -u $DATABASE_USER -p $DATABASE_PASSWORD -e $DATABASE_OPERATOR"
    cd /home/production/cxgn/sgn
fi

if [ "$MODE" == "DEVELOPMENT" ]; then
	/home/production/cxgn/sgn/bin/sgn_server.pl --fork -r -d -p 8080
else
  /etc/init.d/sgn start
  chmod 777 /var/log/sgn/error.log
  tail -f /var/log/sgn/error.log
fi
