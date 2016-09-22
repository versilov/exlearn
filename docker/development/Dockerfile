FROM exlearn

RUN set -ex                                                 && \
                                                               \
    echo 'Giving notroot sudo rights'                       && \
    usermod -aG sudo notroot                                && \
                                                               \
    echo 'Installing libraries'                             && \
    apt-get update                                          && \
    apt-get install -y --no-install-recommends                 \
      bison                                                    \
      emacs                                                    \
      flex                                                     \
      gdb                                                      \
      gperf                                                    \
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
    wget http://tamacom.com/global/global-6.5.4.tar.gz      && \
    tar -xzf global-6.5.4.tar.gz                            && \
    cd global-6.5.4                                         && \
    sh reconf.sh                                            && \
    ./configure --with-exuberant-ctags=/usr/local/bin/ctags && \
    make                                                    && \
    make install                                            && \
    cd ..                                                   && \
                                                               \
    echo 'Removing unnecessary content'                     && \
    rm -rf global-6.5.4* ctags /var/lib/apt/lists/*

CMD bash -l
