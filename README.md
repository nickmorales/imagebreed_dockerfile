# ImageBreed v3.8 Now Released

Launch your own instance of [ImageBreed](https://imagebreed.org) to manage your plant breeding field experiments, genotyping, aerial image phenotyping, and high-dimensional phenotyping (NIRS, transcriptomics, metabolomics)!

Please check the [changelog](https://github.com/nickmorales/breedbase_dockerfile/wiki/Changelog) for update information.

For a tutorials of pieces of the aerial image phenotyping system, go to the [Phenome Force Workshop](https://www.youtube.com/watch?v=yLLaF7sS2Qs) and follow the [ImageBreed Channel](https://www.youtube.com/channel/UC1FYqz6kz9pE72sSHhG7ocQ).

Please note that post-V1 releases (e.g. V2, V3) of ImageBreed are not equivalent to Breedbase and should be regarded as independent systems.

### Prerequisites

- You need Docker and docker-compose installed on a machine with at least 8GB RAM and 50GB of disk.

## Start the Service:

- To start the service, simply change directories to where the provided `docker-compose.yml` file is located (you can simply copy-paste the provided `docker-compose.yml` onto your own computer or you can `git clone` this repository), then:

    ```bash
    docker-compose up -d
    ```

- Note, it may take up to 10 minutes for the service to fully start up the first time, as it must rebuild the Node JavaScript dependencies.

- The Docker compose will fetch the container images from this [DockerHub](https://hub.docker.com/repository/docker/imagebreed/imagebreed).

- Access the Application: Once the container is running, you can access the application from your host at http://localhost:7080

- Logging In: The database has a user named `janedoe` with password `secretpw` for easy logging in from the web-interface.

- Starting with an Empty Database: When starting the service, the database is named `empty_fixture` and is loaded with SQL from [Here](https://github.com/nickmorales/sgn/blob/master/t/data/fixture/empty_fixture.sql).

### Breedbase Configuration

- TO BEGIN you don't need to change anything, but in actual production setting you will want to write an `sgn_local.conf` file specific to your service. A [template](./development/sgn_local_docker.conf) is provided in the breedbase_dockerfile repo. Your personal `sgn_local.conf` can be mounted in the `docker-compose.yml`, where a commented-out example is given.

- IMPORTANT: to maintain persistent data directories mounted, use the bind mounts via the `docker-compose.yml` and ensure the directories exist on your machine with the proper permissions. Most critically, create the `${HOME}/archive`, `${HOME}/images`, `${HOME}/pgdata` directories on your host machine! The `prepare_host.sh` script can give guidance to permissions. Example commented-out bind mounts are given in the `docker-compose.yml`. When mounting persistent data directories and/or code directories in the `docker-compose.yml`, DO NOT alter the target, only alter the source to match your host configuration.

## Helpful Commands:

- Stopping the service: This will stop all containers (both web and db). Note: You must be located in the directory where the `docker-compose.yml` file is located.

    ```bash
    docker-compose down
    ```

- Docker-compose will not delete the downloaded Docker images. Use `docker images` to view the downloaded images and then use `docker rmi IMAGEID` to delete it. The Docker images are large and can take up large amounts of disk space, and should be deleted when not in use.

### Debugging a Running Container

- To view the log on a running service:

    ```bash
    docker attach breedbase_web
    ```

- To fully debug, log into the breedbase_web container:

    ```bash
    docker exec -it breedbase_web bash
    ```

    Look at the error log using `tail -f /var/log/sgn/error.log` or `less /var/log/sgn/error.log`.

- To login to the database breedbase_db container:

    ```bash
    docker exec -it breedbase_db bash
    ```

## Updating Between Versions of This Docker Deployment:

- When updating between versions (e.g. v1.3 to v1.4), first check the [changelog](https://github.com/nickmorales/breedbase_dockerfile/wiki/Changelog).

- Database patch changes require you to run the database patch onto your database. Database patches can take long to complete, and so you should run them in a screen session. To do this, enter a screen session, then login to the running web docker using `docker exec -it breedbase_web bash`, then change directory to where the new database patch lives (e.g. `cd /home/production/cxgn/sgn/db/00129`), and finally run the patch onto your database using `mx-run NameOfPatch -H breedbase_db -D empty_fixture -u janedoe`. Notice, that the mx-run command uses NameOfPatch and not NameOfPatch.pm.

- Ontology updates require you to load the new ontology terms into your database. To do this, login to the running web docker using `docker exec -it breedbase_web bash`, then load the new ontology using `perl /home/production/cxgn/Chado/chado/bin/gmod_load_cvterms.pl -H breedbase_db -D empty_fixture -s SGNSTAT -d Pg -r postgres -p postgres /home/production/cxgn/sgn/ontology/cxgn_statistics.obo`. Notice, the `-s` argument is for the pertinent ontology name (e.g. SGNSTAT, CO_322, etc.) and the last argument is the file path to the pertinent ontology .obo file.

- New ontologies require you to first create the ontology entry and then load the new ontology terms into your database. Only do this if the ontology is relevant to you e.g. it contains terms that you intend to collect phenotypes for. To do this, first login to the running db docker using `docker exec -it breedbase_db bash`, enter Postgres using `psql -U postgres empty_fixture`, and create the new ontology identifier using `INSERT INTO db (name) VALUES ('ONT');` where ONT is the provided name of the new ontology. Then exit Postgres and the db docker using `\q` and `exit`, respectively, and login to the running web docker using `docker exec -it breedbase_web bash`, then load the new ontology using `perl /home/production/cxgn/Chado/chado/bin/gmod_load_cvterms.pl -H breedbase_db -D empty_fixture -s SGNSTAT -d Pg -r postgres -p postgres /home/production/cxgn/sgn/ontology/cxgn_statistics.obo`. Notice, the `-s` argument is for the pertinent ontology name (e.g. ONT) and the last argument is the file path to the pertinent ontology .obo file. Edit your `sgn_local.conf` by adding ONT to the `onto_root_namespaces` key. If indicated in the change log, run `perl /home/production/cxgn/sgn/bin/load_composed_cvprops.pl -H breedbase_db -D empty_fixture -T ont_cv_name` to ensure the ontology is tagged as a trait ontology; note, ont_cv_name should be the ontology key in the .obo file e.g. Alfalfa_ontology in the Alfalfa.obo. Please be sure that a new VARIABLE_OF term was not inserted into the database by querying the cvterm table. There should only be one VARIABLE_OF cvterm entry; if not, update the cvterm_relationship table to consolidate type_id into one VARIABLE_OF term and delete the unneeded entry in the cvterm table, e.g. `UPDATE cvterm_relationship SET type_id=old_cvterm_id WHERE type_id=new_cvterm_id;` followed by `DELETE FROM cvterm WHERE cvterm_id=new_cvterm_id;`.

- If you are updating across several versions (e.g. v1.3 to 1.7) and an ontology is updated in several of those versions (e.g. in v1.4 and v1.5), you only need to load the pertinent ontology once.

- If you are updating across several versions (e.g. v1.3 to 1.7) and there are many database patches to run, you can use the `run_all_patches.pl`. Database patches can take long to complete, and so you should run them in a screen session. To do this, enter a screen session, then login to the running web docker using `docker exec -it breedbase_web bash`, then change directories to `/home/production/cxgn/sgn/db`, and finally run `perl run_all_patches.pl -h breedbase_db -d empty_fixture -u postgres -p postgres -e janedoe`.

- When updating between major versions (e.g. v1 to v2) it is recommended to create database backups. Backup your database first by logging into where the database is running (e.g. `docker exec -it breedbase_db bash`) then create a backup to a file using `pg_dump -U postgres empty_fixture > breedbase_fixture_v1_10122020.sql`. Keep this backup safe!

## Using a Local PostgreSQL Database:

- The provided `docker-compose.yml` will launch a `breedbase_web` and `breedbase_db` container. If you prefer to install PostgreSQL on your host machine and avoid using the `breedbase_db` Docker, you can comment out the associated breedbase_db lines in the `docker-compose.yml`. This requires adjusting your `sgn_local.conf` to point to your host database, and adjusting your `postgresql.conf` and `pg_hba.conf` configuration to work in this network configuration. You can load SQL from [SGN](https://github.com/nickmorales/sgn/blob/master/t/data/fixture/empty_fixture.sql) as a starting point for your host database.

## Enabling OpenDroneMap Orthophotomosaic Stitching

- In the `docker-compose.yml`, uncomment the bind mount for `var/run/docker.sock`. Then, in your `sgn_local.conf` set `enable_opendronemap 1` and make sure `hostpath_archive` is set to the directory where the archive mount lives on your host e.g. `/home/user` if the archive is mounted to `/home/user/archive` as defined in `docker-compose.yml`. Make sure your machine has at least 64GB of RAM.

## Using ASREML-R Analyses

- Activate ASREML-R using your license by first entering the running `breedbase_web` container using `docker exec -it breedbase_web bash`, then enter R by typing `R` followed by entering `library(asreml); asreml.license.activate();`. ASREML-R will then prompt you to type in your license code.

## Developing With This Container:

- In the `docker-compose.yml` file you can mount the code directories you are developing, such as the sgn, DroneImageScripts, R_libs, perl-local-lib or other directories.

- In the `docker-compose.yml` add in the environment section: `MODE=DEVELOPMENT`. This will restart the service whenever code changes are made to sgn or other core directories. Note, you may need to delete sgn/js/build and allow the application to rebuild this with the correct permissions; please allow up to 10 minutes for the JS to rebuild.

## Manually Building the Image:

Alternatively, the docker image can be built from scratch. This is recommended if you would like to develop based on the image.

- Chage directory into the directory containing the `Dockerfile` and run the `prepare.sh` script. This will clone all the git repos that are needed for the build into a directory called `repos/`. You can then checkout particular branches or tags in the repo before the build.

- Build the images on your host with `docker build -t breedbase_image .`

### Please [support](https://patreon.com/nmorales) if you find this open-source software useful!
