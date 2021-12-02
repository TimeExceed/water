FROM ubuntu:21.10
COPY repeat.sh /usr/local/bin/
COPY sources.list /etc/apt/
WORKDIR /opt/code/

RUN repeat.sh  apt-get update

RUN DEBIAN_FRONTEND="noninteractive" repeat.sh apt-get install -y tzdata \
    && apt-get clean

# base tools
RUN repeat.sh  apt-get install -y \
    python3 python3-pip python3-termcolor \ 
    git git-lfs file binutils curl wget tmux less sudo \
    && apt-get clean

# build tools
RUN repeat.sh  apt-get install -y \
    cmake ninja-build make scons generate-ninja build-essential pkg-config \
    && apt-get clean

# C/C++
RUN repeat.sh  apt-get install -y \
    gcc g++ clang libboost-all-dev python3-dev \
    && apt-get clean

# tex/latex \
RUN repeat.sh  apt-get install -y \
    texlive texlive-lang-chinese texlive-pictures texlive-latex-extra \
    texlive-luatex texlive-science \
    && apt-get clean

# documentation tool
# COPY requirements.txt /opt/
# RUN /usr/local/bin/repeat.sh  pip install --requirement /opt/requirements.txt
RUN repeat.sh  apt-get install -y \
    python3-sphinx sphinx-intl \
    python3-recommonmark python3-sphinx-markdown-tables jsmath \
    python3-sphinx-rtd-theme \
    && apt-get clean

# user
ENV COLORTERM="truecolor" TERM="xterm-256color"
RUN groupadd --gid 1000 dockeruser \
    && useradd --uid 1000 --gid 1000 --shell /bin/bash --create-home --system dockeruser \
    && usermod --append --groups sudo dockeruser
COPY --chown=1000:1000 bashrc /home/dockeruser/.bash_profile
COPY --chown=1000:1000 bashrc /home/dockeruser/.bashrc
COPY sudoers /etc/
