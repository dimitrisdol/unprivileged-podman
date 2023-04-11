FROM mgoltzsche/podman

USER root
RUN mkdir -p /podman/.config/cni && \
    chown -R podman:podman /podman/.config && \
    mkdir -m 755 -p /dev/net && \
    mknod /dev/net/tun c 10 200 && \
    chmod 0666 /dev/net/tun
USER podman

