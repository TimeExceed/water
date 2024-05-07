FROM ubuntu:24.04
COPY repeat.sh /usr/local/bin/
COPY ubuntu.sources /etc/apt/sources.list.d/
WORKDIR /opt/code/

RUN repeat.sh  apt-get update

RUN DEBIAN_FRONTEND="noninteractive" repeat.sh apt-get install -y tzdata \
    && apt-get clean

# base tools
RUN repeat.sh  apt-get install -y \
    python3 python3-pip python3-termcolor python-is-python3 \
    git git-lfs file binutils curl wget tmux bat sudo fish \
    && apt-get clean

# user
ENV COLORTERM="truecolor" TERM="xterm-256color"
## for docker only
# RUN groupadd --gid 1000 ubuntu \
#     && useradd --uid 1000 --gid 1000 --shell /usr/bin/fish --create-home --system ubuntu \
#     && usermod --append --groups sudo ubuntu
## for podman only
RUN usermod --append --groups sudo ubuntu \
    && usermod --shell /usr/bin/fish ubuntu
##
COPY --chown=1000:1000 config.fish /home/ubuntu/.config/fish/
COPY sudoers /etc/

# build tools
RUN repeat.sh  apt-get install -y \
    cmake ninja-build make scons generate-ninja build-essential pkg-config \
    && apt-get clean

# tex/latex \
RUN repeat.sh  apt-get install -y \
    texlive-full \
    && apt-get clean \
    && su --command="luaotfload-tool --update" ubuntu

# documentation tool
RUN repeat.sh  apt-get install -y \
    python3-sphinx sphinx-intl \
    python3-recommonmark python3-sphinx-markdown-tables jsmath \
    python3-sphinx-rtd-theme \
    && apt-get clean

## C/C++
# RUN repeat.sh  apt-get install -y \
#     gcc g++ clang libboost-all-dev \
#     && apt-get clean
