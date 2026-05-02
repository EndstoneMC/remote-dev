#!/bin/sh
# Copies host SSH material from the read-only bind mount at /mnt/host-ssh
# into /home/endstone/.ssh with the strict ownership and modes that OpenSSH
# requires. Needed because Docker Desktop on Windows/macOS surfaces bind-mounted
# files with permissions OpenSSH refuses to use (notably for ~/.ssh/config).
set -eu

HOST_SSH=/mnt/host-ssh
USER_SSH=/home/endstone/.ssh

if [ -d "${HOST_SSH}" ]; then
    install -d -o endstone -g endstone -m 0700 "${USER_SSH}"

    # Copy regular files only; dereference symlinks. Skip 'config' — host SSH
    # config rarely makes sense inside a container and tends to trip strict
    # mode checks. Add it explicitly here if you need it.
    for src in "${HOST_SSH}"/*; do
        [ -e "${src}" ] || continue
        name=$(basename "${src}")
        case "${name}" in
            config) continue ;;
        esac
        cp -Lf "${src}" "${USER_SSH}/${name}"
    done

    chown -R endstone:endstone "${USER_SSH}"
    find "${USER_SSH}" -type f -exec chmod 0600 {} +
    # Public material can be world-readable.
    for pub in "${USER_SSH}"/*.pub "${USER_SSH}/known_hosts" "${USER_SSH}/authorized_keys"; do
        [ -f "${pub}" ] && chmod 0644 "${pub}"
    done
fi

exec "$@"
