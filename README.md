# 🎯 Remote Development Environment for Endstone

[![CI](https://github.com/EndstoneMC/remote-dev/actions/workflows/build.yml/badge.svg)](https://github.com/EndstoneMC/remote-dev/actions/workflows/ci.yml)

This is a Docker-based remote development environment that provides all the necessary toolchains and libraries required
for Endstone development on Linux. This ensures a consistent, reliable and easy-to-manage development environment for
our team and the community.

Now, power on your engines and get ready to code! 🚀

## 🛠️ What's inside the toolbox?

- Debian 11 (bullseye)
- Python 3.12 🐍
- Clang (with LLVM version 15)
- CMake 3.26.6
- Conan package manager 2.0
- Git
- Ninja build system
- SSH Server
- libc++ standard library

## 🚀 Getting started

First, clone this project and navigate into the project folder:

```shell
git clone https://github.com/EndstoneMC/remote-dev.git endstone-remote-dev
cd endstone-remote-dev
```

Then, simply run:

```shell
docker compose up --build -d
```

## 🔍 Usage

You can now access the remote development environment using SSH:

- username: `endstone`
- password: `endstone`

### Integration

- **CLion**: Integrating with CLion? Here's a helping hand, follow the guide available on JetBrains
  website: [Connecting with JetBrains IDEs via SSH](https://www.jetbrains.com/remote-development/gateway/).

- **VSCode**: If you're a fan of VSCode, here's a detailed guide to help you get
  started: [Developing on Remote Machines or VMs using Visual Studio Code](https://code.visualstudio.com/docs/remote/ssh).