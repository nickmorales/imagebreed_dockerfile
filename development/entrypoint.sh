#!/bin/bash
sed -i s/localhost/$HOSTNAME/g /etc/slurm-llnl/slurm.conf
/etc/init.d/postfix start
/etc/init.d/munge start
/etc/init.d/slurmctld start
/etc/init.d/slurmd start
/etc/init.d/postgresql start

if [[ "$RUN_DB_PATCHES" == "TRUE" || "$RUN_DB_ONTOLOGY_UPDATES" == "TRUE" ]];
then
    sleep 1m

    if [ "$RUN_DB_PATCHES" == "TRUE" ]; then
        cd /home/production/cxgn/sgn/db/ && bash -c "echo -ne $DATABASE_PASSWORD | ./run_all_patches.pl -h $DATABASE_HOST -d $DATABASE_NAME -u $DATABASE_USER -p $DATABASE_PASSWORD -e $DATABASE_OPERATOR"
        cd /home/production/cxgn/sgn
    fi

    if [ "$RUN_DB_ONTOLOGY_SGNSTAT_UPDATES" == "TRUE" ]; then
        perl /home/production/cxgn/Chado/chado/bin/gmod_load_cvterms.pl -H $DATABASE_HOST -D $DATABASE_NAME -u -s SGNSTAT -d Pg -r $DATABASE_USER -p $DATABASE_PASSWORD /home/production/cxgn/sgn/ontology/cxgn_statistics.obo
        perl /home/production/cxgn/sgn/bin/ensure_only_one_variable_of_cvterm.pl -H $DATABASE_HOST -D $DATABASE_NAME -U $DATABASE_USER -P $DATABASE_PASSWORD
    fi
    if [ "$RUN_DB_ONTOLOGY_TIME_UPDATES" == "TRUE" ]; then
        perl /home/production/cxgn/Chado/chado/bin/gmod_load_cvterms.pl -H $DATABASE_HOST -D $DATABASE_NAME -u -s TIME -d Pg -r $DATABASE_USER -p $DATABASE_PASSWORD /home/production/cxgn/sgn/ontology/cxgn_time.obo
        perl /home/production/cxgn/sgn/bin/ensure_only_one_variable_of_cvterm.pl -H $DATABASE_HOST -D $DATABASE_NAME -U $DATABASE_USER -P $DATABASE_PASSWORD
    fi
    if [ "$RUN_DB_ONTOLOGY_UO_UPDATES" == "TRUE" ]; then
        perl /home/production/cxgn/Chado/chado/bin/gmod_load_cvterms.pl -H $DATABASE_HOST -D $DATABASE_NAME -u -s UO -d Pg -r $DATABASE_USER -p $DATABASE_PASSWORD /home/production/cxgn/sgn/ontology/cxgn_units.obo
        perl /home/production/cxgn/sgn/bin/ensure_only_one_variable_of_cvterm.pl -H $DATABASE_HOST -D $DATABASE_NAME -U $DATABASE_USER -P $DATABASE_PASSWORD
    fi
    if [ "$RUN_DB_ONTOLOGY_ISOL_UPDATES" == "TRUE" ]; then
        perl /home/production/cxgn/Chado/chado/bin/gmod_load_cvterms.pl -H $DATABASE_HOST -D $DATABASE_NAME -u -s ISOL -d Pg -r $DATABASE_USER -p $DATABASE_PASSWORD /home/production/cxgn/sgn/ontology/imagesol.obo
        perl /home/production/cxgn/sgn/bin/ensure_only_one_variable_of_cvterm.pl -H $DATABASE_HOST -D $DATABASE_NAME -U $DATABASE_USER -P $DATABASE_PASSWORD
    fi
    if [ "$RUN_DB_ONTOLOGY_G2F_UPDATES" == "TRUE" ]; then
        perl /home/production/cxgn/Chado/chado/bin/gmod_load_cvterms.pl -H $DATABASE_HOST -D $DATABASE_NAME -u -s G2F -d Pg -r $DATABASE_USER -p $DATABASE_PASSWORD /home/production/cxgn/sgn/ontology/G2F.obo
        perl /home/production/cxgn/sgn/bin/ensure_only_one_variable_of_cvterm.pl -H $DATABASE_HOST -D $DATABASE_NAME -U $DATABASE_USER -P $DATABASE_PASSWORD
    fi
    if [ "$RUN_DB_ONTOLOGY_ALF_UPDATES" == "TRUE" ]; then
        perl /home/production/cxgn/Chado/chado/bin/gmod_load_cvterms.pl -H $DATABASE_HOST -D $DATABASE_NAME -u -s ALF -d Pg -r $DATABASE_USER -p $DATABASE_PASSWORD /home/production/cxgn/sgn/ontology/Alfalfa.obo
        perl /home/production/cxgn/sgn/bin/ensure_only_one_variable_of_cvterm.pl -H $DATABASE_HOST -D $DATABASE_NAME -U $DATABASE_USER -P $DATABASE_PASSWORD
    fi
fi

if [ "$MODE" == "DEVELOPMENT" ]; then
	/home/production/cxgn/sgn/bin/sgn_server.pl --fork -r -d -p 8080
else
  /etc/init.d/sgn start
  chmod 777 /var/log/sgn/error.log
  tail -f /var/log/sgn/error.log
fi
