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

SSH into the container with the default password to get started:

```shell
ssh endstone@localhost   # password: endstone
```

Then install your public key for password-less access on subsequent connections:

```shell
ssh-copy-id endstone@localhost
```

The container's `~/.ssh/` lives on a named volume (`ssh-data`), so your `authorized_keys` survives container rebuilds
and recreates — you only need to run `ssh-copy-id` once.

> [!WARNING]
> **Do not expose this container to untrusted networks.** It ships with a well-known default password and passwordless
> `sudo` for developer convenience. Keep the SSH port bound to `localhost` (or behind a VPN/firewall) when running on
> shared infrastructure, or change the password and disable `PasswordAuthentication` in `/etc/ssh/sshd_config_endstone`
> before exposing it.

### IDE integration

- **CLion**: [Connecting with JetBrains IDEs via SSH](https://www.jetbrains.com/remote-development/gateway/)
- **VS Code**: [Developing on Remote Machines or VMs using Visual Studio Code](https://code.visualstudio.com/docs/remote/ssh)
