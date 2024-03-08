FROM python:3.12-slim-bullseye

LABEL maintainer="Endstone <hello@endstone.dev>"

ENV PYTHONUNBUFFERED=1 \
    PYTHONIOENCODING=UTF-8

ARG LLVM_VERSION=15

ARG CMAKE_VERSION=3.26.6

RUN apt-get update -y -q \
    && apt-get install -y -q curl lsb-release wget software-properties-common gnupg gdb git ninja-build openssh-server sudo \
    && wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh ${LLVM_VERSION} \
    && apt-get install -y -q libc++-${LLVM_VERSION}-dev libc++abi-${LLVM_VERSION}-dev \
    && update-alternatives --install /usr/bin/clang clang /usr/bin/clang-${LLVM_VERSION} 100 \
    && update-alternatives --install /usr/bin/clang++ clang++ /usr/bin/clang++-${LLVM_VERSION} 100 \
    && update-alternatives --install /usr/bin/llvm-cov llvm-cov /usr/bin/llvm-cov-${LLVM_VERSION} 100 \
    && update-alternatives --install /usr/bin/ld ld /usr/bin/ld.lld-${LLVM_VERSION} 100 \
    && rm llvm.sh \
    && wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh \
    && chmod +x cmake-${CMAKE_VERSION}-linux-x86_64.sh \
    && ./cmake-${CMAKE_VERSION}-linux-x86_64.sh --skip-license --exclude-subdir --prefix=/usr/local \
    && rm cmake-${CMAKE_VERSION}-linux-x86_64.sh \
    && python -m pip install --upgrade pip \
    && pip install conan \
    && apt-get clean -y -q \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash endstone \
    && echo "endstone:endstone" | chpasswd \
    && adduser endstone sudo \
    && echo "endstone ALL= NOPASSWD: ALL\\n" >> /etc/sudoers

COPY conan-profile /home/endstone/.conan2/profiles/default
RUN chown -R endstone:endstone /home/endstone/.conan2

RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  ) > /etc/ssh/sshd_config_endstone \
  && mkdir /run/sshd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config_endstone"]
