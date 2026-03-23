# Remote Development Environment for Endstone

[![Build](https://github.com/EndstoneMC/remote-dev/actions/workflows/build.yml/badge.svg)](https://github.com/EndstoneMC/remote-dev/actions/workflows/build.yml)

A Docker-based remote development environment with all toolchains and libraries required for
[Endstone](https://github.com/EndstoneMC/endstone) C++ development on Linux.

## What's Included

- Debian 12 (bookworm)
- Python 3.12
- Clang 20 with libc++
- CMake 4.2.3
- Conan 2.x package manager
- Ninja build system
- Git, GDB, SSH server

Port 19132/udp is exposed for running a Bedrock Dedicated Server inside the container.

## Getting Started

Clone and start the container:

```bash
git clone https://github.com/EndstoneMC/remote-dev.git
cd remote-dev
docker compose up --build -d
```

Connect via SSH:

- Host: `localhost`
- Username: `endstone`
- Password: `endstone`

## IDE Integration

**CLion**: Use [Remote Development via SSH](https://www.jetbrains.com/remote-development/gateway/)
to connect to the container.

**VS Code**: Use the [Remote - SSH](https://code.visualstudio.com/docs/remote/ssh) extension
to connect to the container.

## License

[MIT License](LICENSE)
