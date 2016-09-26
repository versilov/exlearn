FROM elixir:1.3.2

ARG HOST_USER_UID=1000
ARG HOST_USER_GID=1000

RUN set -ex                                                 && \
                                                               \
    echo 'Creating notroot user and group from host'        && \
    groupadd -g $HOST_USER_GID notroot                      && \
    useradd -lm -u $HOST_USER_UID -g $HOST_USER_GID notroot && \
                                                               \
    echo 'Creating /work for notroot'                       && \
    mkdir /work                                             && \
    chown -R notroot:notroot /work                          && \
                                                               \
    echo 'Installing debugger and libraries'                && \
    apt-get update                                          && \
    apt-get install -y --no-install-recommends                 \
      libblas-dev                                              \
      libgsl0-dev                                           && \
                                                               \
    echo 'Setting up hex and rebar for notroot'             && \
    runuser notroot -c "                                       \
      mix local.hex --force                                 && \
      mix local.rebar --force                                  \
    "                                                       && \
                                                               \
    echo 'Removing unnecessary content'                     && \
    rm -rf /var/lib/apt/lists/*

CMD iex -S mix
