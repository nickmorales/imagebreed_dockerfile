# ImageBreed v8.6 Now Released

Launch your own instance of [ImageBreed](https://imagebreed.org) to manage your plant breeding field experiments, genotyping, aerial image phenotyping, and high-dimensional phenotyping (NIRS, transcriptomics, metabolomics)!

Please check the [changelog](https://github.com/nickmorales/imagebreed_dockerfile/wiki/Changelog) for update information.

For a tutorials of pieces of the aerial image phenotyping system, follow the [ImageBreed Channel](https://www.youtube.com/channel/UC1FYqz6kz9pE72sSHhG7ocQ).

Now integrated with [OpenDroneMap](https://www.opendronemap.org/odm/) for creating orthophotomosaics directly into the database!

### Prerequisites

- You need Docker, docker-compose, and nginx installed on a machine with at least 8GB RAM and 50GB of disk. Though it is not necessary, ideally, the computer has >8 CPU cores, >96GB RAM, and >4TB disk space, and the disk space should be fast (Thunderbolt if NAS used).

- Check the speed of your disks and [ensure a write speed >1 GB/s](https://github.com/nickmorales/imagebreed_dockerfile/wiki/Check-Disk-Speed).

## Start the Service:

- To start the service, simply change directories to where the provided `docker-compose.yml` file is located (you can simply copy-paste the provided `docker-compose.yml` onto your own computer or you can `git clone` this repository), then:

    ```bash
    docker-compose up -d
    ```

- Note, it may take up to 10 minutes for the service to fully start up the first time, as it must rebuild the Node JavaScript dependencies.

- The Docker compose will fetch the container images from this [DockerHub](https://hub.docker.com/repository/docker/imagebreed/imagebreed).

- Access the Application: Once the container is running, you can access the application from your host at http://localhost:7080

- Logging In: The database has a user named `janedoe` with password `secretpw` for easy logging in from the web-interface.

- Starting with an Empty Database: When starting the service, the database is named `empty_fixture` and is loaded with SQL from [Here](https://github.com/nickmorales/imagebreed/blob/master/t/data/fixture/empty_fixture.sql).

- Note, if `RUN_DB_PATCHES=TRUE` in the `docker-compose.yml`, then the service will wait 1 minute before checking if all database patches have been run. The `RUN_DB_PATCHES=TRUE` option is important when updating between versions (e.g. V4.0 to V4.1) and can be set to FALSE when not needed to avoid waiting an additional minute.

### ImageBreed Configuration

- IMPORTANT: to maintain persistent data directories mounted, use the bind mounts via the `docker-compose.yml` and ensure the directories exist on your machine with the [proper permissions](https://github.com/nickmorales/imagebreed_dockerfile/wiki/File-Permissions). Most critically, create the `${HOME}/archive`, `${HOME}/images`, `${HOME}/pgdata` directories on your host machine! DO NOT alter the target, only alter the source to match your host configuration.

- TO BEGIN you don't need to change anything, but in actual production setting you will want to write an `sgn_local.conf` file specific to your service. A [template](./development/sgn_local_docker.conf) is provided. Your personal `sgn_local.conf` can be mounted in the `docker-compose.yml`, where a commented-out example is given.

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

- When updating between versions, first check the [changelog](https://github.com/nickmorales/imagebreed_dockerfile/wiki/Changelog). The changelog will tell you if you need to modify the `docker-compose.yml` to enable database updating. Then, simply change the imagebreed and imagebreedpg image versions in the `docker-compose.yml` e.g. imagebreed/imagebreed:v6.2 and imagebreed/imagebreedpg:v6.2 to imagebreed/imagebreed:v6.3 and imagebreed/imagebreedpg:v6.3. Then start the Docker containers using `docker-compose up -d`.

- Beginning with the v7.0 release of this Docker, ontology updates can automatically be run on startup. In the `docker-compose.yml` make sure to set the appropriate `RUN_DB_ONTOLOGY_XXX_UPDATES=TRUE` and provide the database parameters as is done in the provided example. Beginning with v4.0, database patches can automatically be run on startup. In the `docker-compose.yml` make sure to set `RUN_DB_PATCHES=TRUE` and provide the database parameters. Note, setting either of these keys to TRUE will cause the service to wait 1 minute, so to save time this should be set to FALSE when an update in versions is not underway.

- If you need to manually run database patches or load new ontologies, please view [the database patch wiki](https://github.com/nickmorales/imagebreed_dockerfile/wiki/Database-Patches) and [the ontology update wiki](https://github.com/nickmorales/imagebreed_dockerfile/wiki/Ontology-Updates).

## Using a Local PostgreSQL Database:

- The provided `docker-compose.yml` will launch a `breedbase_web` and `breedbase_db` container. If you prefer to install PostgreSQL on your host machine and avoid using the `breedbase_db` Docker, you can comment out the associated breedbase_db lines in the `docker-compose.yml`. This requires adjusting your `sgn_local.conf` to point to your host database, and adjusting your `postgresql.conf` and `pg_hba.conf` configuration to work in this network configuration. You can load SQL from [SGN](https://github.com/nickmorales/imagebreed/blob/master/t/data/fixture/empty_fixture.sql) as a starting point for your host database.

- If you choose to not use the database Docker, please use PostgreSQL version 12.

## Enabling OpenDroneMap Orthophotomosaic Stitching

- Only works on Linux machines as far as I know. On Mac and Windows, Docker is installed with a GUI that creates symbolic links to /var/run/docker.sock, which causes problems when ImageBreed runs ODM. If you can install only the command line Docker this may work; check the permissions of and make sure there are no symbolic links to /var/run/docker.sock on your machine.

- In the `docker-compose.yml`, uncomment the bind mounts for `/var/run/docker.sock` and `sgn_local.conf`. Then, in your `sgn_local.conf` set `enable_opendronemap 1` and make sure `hostpath_archive` is set to the directory where the archive mount lives on your host e.g. `/home/user` if the archive is mounted to `/home/user/archive` as the source as defined in `docker-compose.yml`. Make sure your machine has at least 64GB of RAM. You can also change `opendronemap_max_processes` to allow for greater numbers of parallel OpenDroneMap processes, if your hardware is capable.

## Developing With This Container:

- In the `docker-compose.yml` file you can mount the code directories you are developing, such as the sgn, DroneImageScripts, R_libs, perl-local-lib or other directories. If you mount the sgn directory, you must also mount in the sgn_local.conf file.

- In the `docker-compose.yml` add in the environment section: `MODE=DEVELOPMENT`. This will restart the service whenever code changes are made to sgn or other core directories. Note, you may need to delete sgn/js/build and allow the application to rebuild this with the correct permissions; please allow up to 10 minutes for the JS to rebuild. Note, you may need to delete the sgn/static/documents/tempfiles directory.

## Manually Building the Image:

Alternatively, the docker image can be built from scratch. This is recommended if you would like to develop based on the image.

- Chage directory into the directory containing the `Dockerfile` and run the `prepare.sh` script. This will clone all the git repos that are needed for the build into a directory called `repos/`. You can then checkout particular branches or tags in the repo before the build.

- Build the images on your host with `docker build -t breedbase_image .`

### Please [support](https://patreon.com/nmorales) or [Buy ImageBreed a Coffee](https://www.buymeacoffee.com/imagebreed) if you find this open-source software useful!
