# Nick's Breedbase Dockerfile

Nick's version of the Dockerfile for [breeDBase](https://github.com/solgenomics/sgn)

## Prereqs

### Docker
For installing on Debian/Ubuntu:

```bash
apt-get install docker-ce
```

### Breedbase Configuration

- Git clone this repository onto a host machine with Docker and Docker-compose installed.

- IMPORTANT: to maintain persistent data directories mounted, use the bind mounts via the `docker-compose.yml` and ensure the directories exist on your machine with the proper permissions. Most critically, create the `${HOME}/archive`, `${HOME}/images`, `${HOME}/pgdata` directories on your host machine! The `prepare_host.sh` script can give guidance to permissions.

- To begin you don't need to change anything, but in actual production setting you will want to write an `sgn_local.conf` file specific to your service. A [template](./sgn_local_docker.conf) is provided in the breedbase_dockerfile repo.

## Start the Service

- Change directories to where the `docker-compose.yml` file is located, then:

    ```bash
    docker-compose up -d breedbase
    ```

- The Docker compose will fetch the container images from this [DockerHub](https://hub.docker.com/repository/docker/nmorales3142/nicksbreedbase).

- Access the Application

    Once the container is running, you can access the application from your host at http://localhost:7080

- Easy Logging In

    The database is named `empty_fixture` and is loaded with SQL from [SGN](https://github.com/solgenomics/sgn/blob/master/t/data/fixture/empty_fixture.sql).
    The database has a user named 'janedoe' with password 'secretpw' for easy logging in.

## Helpful commands:

- Stopping and removing the service

    This will stop all containers (both web and db). Note: You must be located in the directory where the `docker-compose.yml` file is located.

    ```bash
    docker-compose down
    ```

## Debugging a running container

- To view the log on a running service:

    ```bash
    docker attach breedbase_web
    ```

- To fully debug, log into the container. You can find the container id using

    ```bash
    docker ps
    ```

    then
    ```bash
    docker exec -it <container_id> bash
    ```

    Look at the error log using `tail -f /var/log/sgn/error.log` or `less /var/log/sgn/error.log`.

## Developing with this container

- In the `docker-compose.yml` file you can mount the code directories you are developing, such as the sgn, DroneImageScripts, R_libs, perl-local-lib or other directories.

- In the `docker-compose.yml` add in the environment section: `MODE=DEVELOPMENT`. This will restart the service whenever code changes are made to sgn or other core directories. Note, you may need to delete sgn/js/build and allow the application to rebuild this with the correct permissions.

# Manually building the image

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
