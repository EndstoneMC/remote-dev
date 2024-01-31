# 🎯 Remote Development Environment for Endstone

This is a Docker-based remote development environment that provides all the necessary toolchains and libraries required
for Endstone development on Linux. This ensures a consistent, reliable and easy-to-manage development environment for
our team and the community.

Now, power on your engines and get ready to code! 🚀

## 🛠️ What's inside the toolbox?

- Python 🐍 3.12 slim-bullseye
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

You can now access the remote development environment using SSH. The username is `endstone` and the password is
also `endstone`.

### Integrating with CLion

Following the [instructions] to install a CLion backend in the remote development environment.

[instructions]: https://www.jetbrains.com/remote-development/gateway/
