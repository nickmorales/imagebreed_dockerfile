# Nick's Breedbase Dockerfile

Nick's version of the Dockerfile for [breeDBase](https://github.com/solgenomics/sgn)

## Prereqs

### Docker
For installing on Debian/Ubuntu:

```bash
apt-get install docker-ce
```

### Breedbase Configuration

- You need to write an `sgn_local.conf` file specific to your service. A [template](./sgn_local_docker.conf) is provided in the breedbase_dockerfile repo. To begin you don't need to change anything, but in actual production setting you will want to change the configuration.

- Prepare the host by running the `prepare_host.sh` script. This ensures the persistent data directories mounted via the `docker-compose.yml` exist on your machine with the proper permissions.

## Start the Service

- Change directories to where the `docker-compose.yml` file is located

    ```bash
    docker-compose up -d breedbase
    ```

- Access the Application

    Once the container is running, you can access the application at http://localhost:7080

- Easy Logging In

    The database is named `empty_fixture` and is loaded with SQL from [SGN](https://github.com/solgenomics/sgn/blob/master/t/data/fixture/empty_fixture.sql).
    The database has a user named 'janedoe' with password 'secretpw' for easy logging in.

## Helpful commands:

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
