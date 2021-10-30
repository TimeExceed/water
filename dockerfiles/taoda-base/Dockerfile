FROM ubuntu:20.04
COPY my_ps1.sh /etc/profile.d/
ENV PS1='\n\e[1;37m[\e[m\e[1;32m\h\e[m\e[1;33m@\e[m\e[1;35m`date -Iseconds`\e[m \e[4m`pwd`\e[m\e[1;37m]\e[m\e[1;36m\e[m\n\$'
COPY repeat.sh /usr/local/bin/
WORKDIR /opt/code/

RUN /usr/local/bin/repeat.sh apt-get update

RUN DEBIAN_FRONTEND="noninteractive" /usr/local/bin/repeat.sh apt-get install -y \
    tzdata \
    && apt-get clean

RUN /usr/local/bin/repeat.sh apt-get install -y \
    python3 apt-utils \
    && apt-get clean

RUN /usr/local/bin/repeat.sh  apt-get install -y \
    # base tools \
    python3 python3-dev python3-pip \ 
    git git-lfs file binutils curl wget tmux locales-all less \
    # build tools \
    cmake ninja-build make scons generate-ninja \
    # C/C++ \
    gcc g++ clang \
    && apt-get clean

# tex/latex \
RUN /usr/local/bin/repeat.sh  apt-get install -y \
    texlive \
    texlive-lang-chinese \
    texlive-pictures \
    texlive-latex-extra \
    texlive-luatex \
    texlive-xetex \
    && apt-get clean

# documentation tool
COPY requirements.txt /opt/
RUN /usr/local/bin/repeat.sh  pip install --requirement /opt/requirements.txt
