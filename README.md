In this repo we tried to create a containerized envirnoment capable of running other containers without the use of the --priviledged flag.

We all know that nested containerized environments using Docker-in-Docker require that. However we tried to implement a way of doing it without enforcing priviledge, testing different nested containers.

The podman container image provided by: https://hub.docker.com/r/mgoltzsche/podman does not seem to work without the use of the --priviledged flag.
However the Containerfile provided by Redhat here: https://github.com/containers/podman/blob/main/contrib/podmanimage/stable/Containerfile is working in nested podman environments. 

Such ideas are tested under the run.sh script. 

There, the successful runs are only as such when we use the Redhat provided image. This image allows the use of podman in podman containers without the need of the '--priviledged' flag.

However, every other time we tried to implement docker or the official podman image, we are under many permission errors.
