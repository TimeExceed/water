FROM alpine:3.13
COPY repositories /etc/apk/
COPY my_ps1.sh /etc/profile.d/
ENV PS1='\n\e[1;37m[\e[m\e[1;32m\h\e[m\e[1;33m@\e[m\e[1;35m`date -Iseconds`\e[m \e[4m`pwd`\e[m\e[1;37m]\e[m\e[1;36m\e[m\n\$'
WORKDIR /opt/code/

# base tools
RUN apk add \
    python3 python3-dev py3-pip ipython py3-pygments \
    git file binutils curl wget tmux musl-locales less

# build tools
RUN apk add \
    cmake samurai make scons

# C/C++
RUN apk add \
    gcc g++ clang

# tex/latex
RUN apk add \
    texlive texlive-luatex texmf-dist-latexextra

# documentation tool
RUN apk add \
    py3-sphinx py3-sphinx_rtd_theme py3-sphinxcontrib-jsmath

