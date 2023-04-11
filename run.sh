#!/bin/bash

# This script is used to run the rootless and rootfull implementations of nested podman in podman or podman in docker. Both of these 2 cases are without the privileged flag.

ENV_PATH=~/Desktop/podman/

# Check user input
echo Please select rootless or rootfull run: [rootless] , [rootfull]

read varstate

echo You have chosen $varstate

if [ $varstate = "rootless" ]
then
   echo You chose the rootless run. It runs Rootless podman in a Rootless Podman without --privileged.
   
   echo !!!!!!!!This works!!!!!!!!!!!!!!!!
   echo -e "################################################################## \n"
   
   # No need to add dangerous sys-admin and mknod. --user podman makes it rootless, Need SELinux disabled or mounting will be blocked. Need --device /dev/fuse to use fuse-overlayfs. It works!
   podman run --security-opt label=disable --user podman --device /dev/fuse quay.io/podman/stable podman run alpine echo hello
   
   echo -e "################################################################## \n"
   
   # Re-trying by using podman in docker. Didn't work.
   # Error: cannot clone: Operation not permitted Error: cannot re-exec process

   docker run --security-opt label=disable --device /dev/fuse --user podman mgoltzsche/podman:rootless podman run alpine echo hello from nested container
   
elif [ $varstate = "rootfull" ]
then 
   echo You chose the rootfull run.  This Rootfull Podman is run in Docker without --privileged.
   
   # Need to create a volume to mount for Podman to use for storage. Need to disable SELinux. Also disabled Docker seccomp and use the Podman one to go for a slightly less strict security policy. Did not work due to docker permissions!
   # Error: mount /var/lib/containers/storage/overlay:/var/lib/containers/storage/overlay, flags: 0x1000: permission denied
   docker run --cap-add=sys_admin --cap-add mknod --device=/dev/fuse --security-opt seccomp=/usr/share/containers/seccomp.json --security-opt label=disable quay.io/podman/stable podman run ubi8-minimal echo hello
   
   echo !!!!!!!!This works!!!!!!!!!!!!!!!!
   echo -e "################################################################## \n"
   
   # However this one works! Since it doesn't have the docker permission issue.
   podman run --cap-add=sys_admin --cap-add mknod --device=/dev/fuse --security-opt seccomp=/usr/share/containers/seccomp.json --security-opt label=disable quay.io/podman/stable podman run ubi8-minimal echo hello
   
   echo -e "################################################################## \n"
   
   # Tried with podman in docker image, still the same result! Not working!
   # Error: mount /var/lib/containers/storage/overlay:/var/lib/containers/storage/overlay, flags: 0x1000: permission denied

   docker run --cap-add=sys_admin --cap-add mknod --security-opt label=disable --device /dev/fuse --security-opt seccomp=unconfined mgoltzsche/podman podman run alpine  echo hello from nested container
   
else
   echo Wrong input. Please re-run and type rootless or rootfull as input.
   exit 1
fi

echo We can run rootless and rootfull podman containers inside podman without the need of priviledge. However to do that we need the redhat image provided by https://github.com/containers/podman/blob/main/contrib/podmanimage/stable/Containerfile


