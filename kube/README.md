The 2 Pod YAML definitions work and allow the use of Podman in Podman without the use of the privileged flag.

The use of the Rootfull implementation though, still needs significant privileges to run without error.

The Rootless one though only requires to disable AppArmor.
However there still might be an issue regarding the privileges on the worker node running the pod. In order to fix execute the following command:

sudo chown -R 1000:1000 /home/podman/.local/share/containers

This will allow the podman user (1000) to access the folder and use it for storage.
 
