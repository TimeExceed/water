FROM ubuntu:20.04
COPY my_ps1.sh /etc/profile.d/
ENV PS1='\n\e[1;37m[\e[m\e[1;32m\h\e[m\e[1;33m@\e[m\e[1;35m`date -Iseconds`\e[m \e[4m`pwd`\e[m\e[1;37m]\e[m\e[1;36m\e[m\n\$'
COPY repeat.py /opt/
WORKDIR /opt/code/

RUN apt-get update

RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y \
    tzdata \
    && apt-get clean

RUN apt-get install -y \
    python3 apt-utils \
    && apt-get clean

RUN /opt/repeat.py apt-get install -y \
    # base tools \
    python3 python3-dev python3-pip ipython3 python3-pygments \
    git git-lfs file binutils curl wget tmux locales-all less \
    # build tools \
    cmake ninja-build make scons \
    # C/C++ \
    gcc g++ clang \
    # documentation tool
    python3-sphinx python3-sphinx-rtd-theme jsmath \
    && apt-get clean

# tex/latex \
RUN /opt/repeat.py apt-get install -y \
    texlive \
    texlive-lang-chinese \
    texlive-pictures \
    texlive-latex-extra \
    texlive-luatex \
    texlive-xetex \
    && apt-get clean
