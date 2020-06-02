# breedbase_dockerfile
The Dockerfile for [breeDBase](https://github.com/solgenomics/sgn)

## Prereqs

### Docker
For installing on Debian/Ubuntu:

```bash
apt-get install docker-ce
```

### Breedbase Configuration

You need to write an `sgn_local.conf` file specific to your service. A [template](./sgn_local_docker.conf) is provided in the breedbase_dockerfile repo.

To begin you don't need to change anything, but in actual production setting you will want to change the configuration.

## Start the Service With `docker-compose`
Docker compose allows you to configure one or more containers and their dependencies, and then use one command to start, stop, or remove all of the containers.

- Install docker-compose

    Debian/Ubuntu: https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-18-04

- Download the Breedbase `docker-compose.yml` file

    [docker-compose.yml](./docker-compose.yml)


- Starting the service

    Change directories to where the `docker-compose.yml` file is located

    ```bash
    docker-compose up -d breedbase
    ```

- Access the application

    Once the container is running, you can access the application at http://localhost:7080

## Helpful commands:

- Stopping the service

    This will stop all containers (both web and db), but will not remove the containers.
    ```bash
    docker-compose stop breedbase
    ```

- Starting a stopped service

    This will start all containers (both web and db) that were previously created, but have been stopped
    ```bash
    docker-compose start breedbase
    ```

- Stopping and removing the service

    This will stop all containers (both web and db), AND will remove them. Note: You must be located in the directory where the `docker-compose.yml` file is located.

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

# Manually building the image

Alternatively, the docker image can be built using the Github `breedbase_dockerfile` repo, as explained below. This is recommended if you would like to develop based on the image.

### Clone the repo
```bash
git clone https://github.com/solgenomics/breedbase_dockerfile
```

### Run the prepare.sh script from within the breedbase_dockerfile dir
```
cd breedbase_dockerfile
./prepare.sh
```
This will clone all the git repos that are needed for the build into a directory called `repos/`.
You can then checkout particular branches or tags in the repo before the build.

### Build the image
```bash
docker build -t breedbase_image breedbase_dockerfile
```
