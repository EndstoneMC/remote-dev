# syntax=docker/dockerfile:1.7
FROM python:3.12-slim-bookworm

LABEL maintainer="Endstone <hello@endstone.dev>" \
      org.opencontainers.image.source="https://github.com/EndstoneMC/remote-dev" \
      org.opencontainers.image.description="Remote development environment for Endstone" \
      org.opencontainers.image.licenses="Apache-2.0"

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8 \
    DEBIAN_FRONTEND=noninteractive

ARG LLVM_VERSION=20
ARG CMAKE_VERSION=4.2.3
ARG CONAN_VERSION=2.9.2

# hadolint ignore=DL3008,DL3015
RUN set -eux \
    && apt-get update -y -q \
    && apt-get install -y -q --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        gdb \
        git \
        gnupg \
        lsb-release \
        ninja-build \
        openssh-server \
        software-properties-common \
        sudo \
        wget \
    && wget -q https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh "${LLVM_VERSION}" \
    && apt-get install -y -q --no-install-recommends \
        "libc++-${LLVM_VERSION}-dev" \
        "libc++abi-${LLVM_VERSION}-dev" \
        "clang-tools-${LLVM_VERSION}" \
    && update-alternatives --install /usr/bin/clang     clang     "/usr/bin/clang-${LLVM_VERSION}"     100 \
    && update-alternatives --install /usr/bin/clang++   clang++   "/usr/bin/clang++-${LLVM_VERSION}"   100 \
    && update-alternatives --install /usr/bin/llvm-cov  llvm-cov  "/usr/bin/llvm-cov-${LLVM_VERSION}"  100 \
    && update-alternatives --install /usr/bin/ld        ld        "/usr/bin/ld.lld-${LLVM_VERSION}"    100 \
    && rm llvm.sh \
    && wget -q "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh" \
    && chmod +x "cmake-${CMAKE_VERSION}-linux-x86_64.sh" \
    && "./cmake-${CMAKE_VERSION}-linux-x86_64.sh" --skip-license --exclude-subdir --prefix=/usr/local \
    && rm "cmake-${CMAKE_VERSION}-linux-x86_64.sh" \
    && python -m pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir "conan==${CONAN_VERSION}" \
    && apt-get clean -y -q \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash endstone \
    && echo "endstone:endstone" | chpasswd \
    && usermod -aG sudo endstone \
    && echo "endstone ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/endstone \
    && chmod 0440 /etc/sudoers.d/endstone \
    && visudo -c -f /etc/sudoers.d/endstone \
    && install -d -o endstone -g endstone -m 0700 /home/endstone/.ssh

COPY --chown=endstone:endstone conan-profile /home/endstone/.conan2/profiles/default

RUN { \
        echo 'export CC=clang'; \
        echo 'export CXX=clang++'; \
        echo 'export PATH=$PATH:/home/endstone/.local/bin'; \
    } >> /home/endstone/.bashrc \
    && chown endstone:endstone /home/endstone/.bashrc

RUN { \
        echo 'LogLevel DEBUG2'; \
        echo 'PasswordAuthentication yes'; \
        echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
    } > /etc/ssh/sshd_config_endstone \
    && mkdir -p /run/sshd

WORKDIR /home/endstone

EXPOSE 22

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD pgrep -x sshd > /dev/null || exit 1

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config_endstone"]
