FROM exlearn

RUN set -ex                                                 && \
                                                               \
    echo 'Installing python libraries'                      && \
    apt-get update                                          && \
    apt-get install -y --no-install-recommends                 \
      python-pip                                               \
      python-dev                                            && \
                                                               \
    echo 'Installing jupyter'                               && \
    pip install jupyter                                     && \
                                                               \
    echo 'Installing mix packages and kernel as notroot'    && \
    runuser notroot -c "                                       \
      cd ~                                                  && \
      git clone https://github.com/pprzetacznik/ielixir.git && \
      cd ielixir                                            && \
      mix deps.get                                          && \
      ./install_script.sh                                      \
    "                                                       && \
                                                               \
    echo 'Removing unnecessary content'                     && \
    rm -rf /var/lib/apt/lists/*

CMD jupyter notebook --ip=0.0.0.0 --notebook-dir=/work/notebooks
