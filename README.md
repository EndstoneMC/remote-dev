# 🎯 Remote Development Environment for Endstone

[![Build](https://github.com/EndstoneMC/remote-dev/actions/workflows/build.yml/badge.svg)](https://github.com/EndstoneMC/remote-dev/actions/workflows/build.yml)

This is a Docker-based remote development environment that provides all the necessary toolchains and libraries required
for Endstone development on Linux. This ensures a consistent, reliable and easy-to-manage development environment for
our team and the community.

Now, power on your engines and get ready to code! 🚀

## 🛠️ What's inside the toolbox?

- Debian 12 (bookworm)
- Python 3.12 🐍
- Clang / LLVM 20 (with libc++)
- CMake 4.2.3
- Conan 2.x package manager
- Git
- Ninja build system
- OpenSSH server

Versions are pinned via build args (`LLVM_VERSION`, `CMAKE_VERSION`, `CONAN_VERSION`) — override at build time if you
need a different toolchain combination.

## 🚀 Getting started

Clone the repository and start the container:

```shell
git clone https://github.com/EndstoneMC/remote-dev.git endstone-remote-dev
cd endstone-remote-dev
docker compose up --build -d
```

The Conan package cache is mounted as a named volume (`conan-cache`), so dependencies persist across rebuilds.

## 🔍 Usage

SSH into the container:

```shell
ssh endstone@localhost
```

- Username: `endstone`
- Password: `endstone` (default — see security note below)

Your host's `~/.ssh/` is bind-mounted read-only at `/mnt/host-ssh` inside the container. On startup, the entrypoint
copies its contents into `/home/endstone/.ssh/` with the strict ownership and modes OpenSSH requires (a direct mount
fails on Docker Desktop for Windows/macOS because bind-mount permissions don't satisfy OpenSSH's checks). You get two
things for free:

- Any public key in your host's `authorized_keys` works for SSH login into the container.
- Your private keys (e.g. `id_rsa`) are usable by git/ssh inside the container, so `git clone git@github.com:...` and
  similar commands work without any extra setup.

The host's `~/.ssh/config` is intentionally **not** copied — it usually contains host-specific settings that don't
translate inside a container, and OpenSSH is especially strict about its permissions. Edit `entrypoint.sh` if you need
to opt in.

> [!WARNING]
> **Do not expose this container to untrusted networks.** It ships with a well-known default password and passwordless
> `sudo` for developer convenience. The host `~/.ssh/` mount also means a compromise of the container exposes your
> private keys. Keep the SSH port bound to `localhost` (or behind a VPN/firewall) when running on shared infrastructure,
> or change the password and disable `PasswordAuthentication` in `/etc/ssh/sshd_config_endstone` before exposing it.

### IDE integration

- **CLion**: [Connecting with JetBrains IDEs via SSH](https://www.jetbrains.com/remote-development/gateway/)
- **VS Code**: [Developing on Remote Machines or VMs using Visual Studio Code](https://code.visualstudio.com/docs/remote/ssh)
