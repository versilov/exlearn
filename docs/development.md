# Usage with Docker

Add the following aliases to `~/.bash_profile` and source it:
```bash
# Runs a temporary container as `root`
alias docker-root-here='docker run --rm -it -v "$PWD":/work -w /work'

# Runs a temporary container as the current user
alias docker-here='docker-root-here -u `id -u`:`id -g`'

# Runs a temporary container for development purposes
alias docker-dev-here='docker-here -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v "$HOME"/.bash_profile:/home/notroot/.bash_profile -v "$HOME"/.globalrc:/home/notroot/.globalrc -v "$HOME"/.spacemacs:/home/notroot/.spacemacs -v "$HOME"/Sources:/home/notroot/Sources:ro -v "$HOME"/.emacs.d.debian:/home/notroot/.emacs.d'

# Creates a permanent container for development
alias docker-new-here='docker create -it -v "$PWD":/work -w /work -u `id -u`:`id -g` -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v "$HOME"/.bash_profile:/home/notroot/.bash_profile -v "$HOME"/.globalrc:/home/notroot/.globalrc -v "$HOME"/.spacemacs:/home/notroot/.spacemacs -v "$HOME"/Sources:/home/notroot/Sources:ro -v "$HOME"/.emacs.d.debian:/home/notroot/.emacs.d'

# Runs a temporary container for development with elevated privileges
alias docker-hack-here='docker-dev-here --security-opt seccomp=unconfined'

# Executes a command in a container as current user
alias docker-exec='docker exec -it -u `id -u`:`id -g`'

# Tails the container STDOUT
alias docker-tail='docker logs -f --tail=100'
```

## Project Container

1. Build the project container
    ```bash
    docker build                        \
      -t exlearn                        \
      --build-arg HOST_USER_UID=`id -u` \
      --build-arg HOST_USER_GID=`id -g` \
      -f docker/project/Dockerfile      \
      "$PWD"

    # OR the short version if you are user 1000:1000

    docker build -t exlearn -f docker/project/Dockerfile "$PWD"
    ```

2. Update dependencies
    ```bash
    docker-here exlearn mix deps.get
    ```

3. Compile the C shared library
    ```bash
    docker-here exlearn make
    ```

4. Run an interactive shell
    ```bash
    docker-here exlearn iex -S mix
    ```

5. Run a sample
    ```bash
    docker-here exlearn mix run samples/or.exs
    ```

6. Run tests
    ```bash
    docker-here exlearn mix test
    ```

7. Run tests with coverage report
    ```bash
    docker-here exlearn mix coveralls
    ```

## Jupyter Notebook

1. Build the notebook container, which is based on the project container above:
    ```bash
    docker build                        \
      -t exlearn-jupyter                \
      --build-arg HOST_USER_UID=`id -u` \
      --build-arg HOST_USER_GID=`id -g` \
      -f docker/notebook/Dockerfile     \
      "$PWD"

    # OR the short version if you are user 1000:1000

    docker build -t exlearn-jupyter -f docker/notebook/Dockerfile "$PWD"
    ```

2. Run the server
    ```bash
    docker-here -p 8888:8888 exlearn-jupyter
    ```

## Development Container

1. Build the project container, which is based on the project container above:
    ```bash
    docker build                        \
      -t exlearn-dev                    \
      --build-arg HOST_USER_UID=`id -u` \
      --build-arg HOST_USER_GID=`id -g` \
      -f docker/development/Dockerfile  \
      "$PWD"

    # OR the short version if you are user 1000:1000

    docker build -t exlearn-dev -f docker/development/Dockerfile "$PWD"
    ```

2. Start a temporary container with a login shell
    ```bash
    docker-dev-here exlearn-dev
    ```

3. Start a permanent container with a login shell
    ```bash
    # Create the permanent container
    docker-new-here --name exlearn_development exlearn-dev

    # Start already created container
    docker start exlearn_development

    # Execute a shell inside the container
    docker-exec exlearn_development bash -l
    ```

4. To run gdb you need to have seccomp unconfined
    ```bash
    docker-hack-here exlearn-dev

    gdb -tui ./test/c/temp/test
    ```

5. Run dialyzer
    ```bash
    docker-dev-here exlearn-dev mix dialyzer
    ```

6. Run all checks like on travis
    ```bash
    docker-dev-here exlearn-dev make ci
    ```
