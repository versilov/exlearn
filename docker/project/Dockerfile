FROM elixir:1.4.2

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000

RUN set -ex                                                    && \
                                                                  \
    echo 'Creates notroot user and group from host'            && \
    groupadd -g $HOST_USER_GID notroot                         && \
    useradd -lm -u $HOST_USER_UID -g $HOST_USER_GID notroot    && \
                                                                  \
    echo 'Creates /work for notroot'                           && \
    mkdir /work                                                && \
    chown -R notroot:notroot /work                             && \
                                                                  \
    echo 'Adds the TINI init system'                           && \
    TINI_VERSION=v0.13.2                                       && \
    TINI_URL=https://github.com/krallin/tini/releases/download && \
    curl -fSL $TINI_URL/$TINI_VERSION/tini     -o /tini        && \
    curl -fSL $TINI_URL/$TINI_VERSION/tini.asc -o /tini.asc    && \
    gpg                                                           \
      --keyserver ha.pool.sks-keyservers.net                      \
      --recv-keys 595E85A6B1B4779EA4DAAEC70B588DFF0527A9B7     && \
    gpg --verify /tini.asc                                     && \
    chmod +x /tini                                             && \
                                                                  \
    echo 'Installs debugger and libraries'                     && \
    apt-get update                                             && \
    apt-get install -y --no-install-recommends                    \
      lcov                                                        \
      libblas-dev                                                 \
      libgsl0-dev                                              && \
                                                                  \
    echo 'Setts up hex and rebar for notroot'                  && \
    runuser notroot -c "                                          \
      mix local.hex --force                                    && \
      mix local.rebar --force                                     \
    "                                                          && \
                                                                  \
    echo 'Removes unnecessary content'                         && \
    rm -rf /var/lib/apt/lists/* /tini.asc

ENTRYPOINT ["/tini", "--"]

CMD ["iex", "-S", "mix"]
