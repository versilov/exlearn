FROM exlearn

# Installs and caches tools and configures the working environment
RUN set -ex                                                 && \
                                                               \
    echo 'Giving notroot sudo rights'                       && \
    usermod -aG sudo notroot                                && \
    passwd -d notroot                                       && \
                                                               \
    echo 'Installing libraries'                             && \
    apt-get update                                          && \
    apt-get install -y --no-install-recommends                 \
      bison                                                    \
      emacs                                                    \
      flex                                                     \
      gdb                                                      \
      gperf                                                    \
      less                                                     \
      libtool-bin                                              \
      sudo                                                     \
      texinfo                                                  \
      vim                                                      \
      xclip                                                 && \
                                                               \
    echo 'Installing ctags'                                 && \
    git clone https://github.com/universal-ctags/ctags.git  && \
    cd ctags                                                && \
    ./autogen.sh                                            && \
    ./configure                                             && \
    make                                                    && \
    make install                                            && \
    cd ..                                                   && \
                                                               \
    echo 'Installing global'                                && \
    wget http://tamacom.com/global/global-6.5.6.tar.gz      && \
    tar -xzf global-6.5.6.tar.gz                            && \
    cd global-6.5.6                                         && \
    sh reconf.sh                                            && \
    ./configure --with-exuberant-ctags=/usr/local/bin/ctags && \
    make                                                    && \
    make install                                            && \
    cd ..                                                   && \
                                                               \
    echo 'Removing unnecessary content'                     && \
    rm -rf global-6.5.6* ctags /var/lib/apt/lists/*

# Dialyzer and dependencies
ADD mix.* /work/
RUN set -ex                                && \
                                              \
    echo 'Setting up dialyzer for notroot' && \
    chown -R notroot:notroot /work         && \
    runuser notroot -c "                      \
      cd /work                             && \
      mix deps.get                         && \
      mix dialyzer.plt                        \
    "

ENV SHELL=/bin/bash

CMD bash -l
