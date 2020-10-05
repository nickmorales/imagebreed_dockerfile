# Nick's Breedbase v1.7 Now Released

Please check the [changelog](https://github.com/nickmorales/breedbase_dockerfile/wiki/Changelog) for update information.

### Prerequisites

- You need Docker and docker-compose installed on a machine with at least 8GB RAM and 50GB of disk.

## Start the Service

- To start the service, simply change directories to where the provided `docker-compose.yml` file is located (you can simply copy-paste the provided `docker-compose.yml` onto your own computer or you can git clone this repository), then:

    ```bash
    docker-compose up -d
    ```

- Note, it may take up to 10 minutes for the service to start up the first time, as it must rebuild to Node javascript dependencies.

- The Docker compose will fetch the container images from this [DockerHub](https://hub.docker.com/repository/docker/nmorales3142/nicksbreedbase).

- Access the Application: Once the container is running, you can access the application from your host at http://localhost:7080

- Logging In: The database has a user named `janedoe` with password `secretpw` for easy logging in from the web-interface.

- Starting with an Empty Database: When starting the service, the database is named `empty_fixture` and is loaded with SQL from [SGN](https://github.com/solgenomics/sgn/blob/master/t/data/fixture/empty_fixture.sql).

### Breedbase Configuration

- TO BEGIN you don't need to change anything, but in actual production setting you will want to write an `sgn_local.conf` file specific to your service. A [template](./development/sgn_local_docker.conf) is provided in the breedbase_dockerfile repo. Your personal `sgn_local.conf` can be mounted in the `docker-compose.yml`, where a commented-out example is given.

- IMPORTANT: to maintain persistent data directories mounted, use the bind mounts via the `docker-compose.yml` and ensure the directories exist on your machine with the proper permissions. Most critically, create the `${HOME}/archive`, `${HOME}/images`, `${HOME}/pgdata` directories on your host machine! The `prepare_host.sh` script can give guidance to permissions. Example commented-out bind mounts are given in the `docker-compose.yml`.

- When mounting persistent data directories and/or code directories in the `docker-compose.yml`, DO NOT alter the target, only alter the source to match your host configuration.

## Helpful commands:

- Stopping and removing the service

    This will stop all containers (both web and db). Note: You must be located in the directory where the `docker-compose.yml` file is located.

    ```bash
    docker-compose down
    ```

### Debugging a running container

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

## Updating between versions of this Docker deployment

- When updating between versions (e.g. v1.3 to v1.4), first check the [changelog](https://github.com/nickmorales/breedbase_dockerfile/wiki/Changelog).

- Database patch changes require you to run the database patch onto your database. To do this, login to the running web docker using `docker exec -it breedbase_web bash`, then change directory to where the new database patch lives (e.g. `cd /home/production/cxgn/sgn/db/00129`), and finally run the patch onto your database using `mx-run NameOfPatch -H breedbase_db -D empty_fixture -u janedoe`. Notice, that the mx-run command uses NameOfPatch and not NameOfPatch.pm.

- Ontology changes require you to load the new ontology terms into your database. To do this, login to the running web docker using `docker exec -it breedbase_web bash`, then load the new ontology using `perl /home/production/cxgn/Chado/chado/bin/gmod_load_cvterms.pl -H breedbase_db -D empty_fixture -s SGNSTAT -d Pg -r postgres -p postgres /home/production/cxgn/sgn/ontology/cxgn_statistics.obo`. Notice, the `-s` argument is for the database prefix of the pertinent ontology (e.g. SGNSTAT, CO_322, etc.) and the last argument is the file path to the pertinent ontology .obo file.

## Developing with this container

- In the `docker-compose.yml` file you can mount the code directories you are developing, such as the sgn, DroneImageScripts, R_libs, perl-local-lib or other directories.

- In the `docker-compose.yml` add in the environment section: `MODE=DEVELOPMENT`. This will restart the service whenever code changes are made to sgn or other core directories. Note, you may need to delete sgn/js/build and allow the application to rebuild this with the correct permissions.

## Manually building the image

Alternatively, the docker image can be built from scratch. This is recommended if you would like to develop based on the image.

### Run the prepare.sh script

- Chage directory into the directory containing the `Dockerfile`.

```bash
./prepare.sh
```

This will clone all the git repos that are needed for the build into a directory called `repos/`.
You can then checkout particular branches or tags in the repo before the build.

### Build the image

```bash
docker build -t breedbase_image .
```
