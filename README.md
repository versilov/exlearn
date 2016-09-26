# ExLearn

[![Build Status](https://travis-ci.org/sdwolf/exlearn.svg?branch=master)](https://travis-ci.org/sdwolf/exlearn)
[![Coverage Status](https://coveralls.io/repos/github/sdwolf/exlearn/badge.svg?branch=master)](https://coveralls.io/github/sdwolf/exlearn?branch=master)

Elixir Machine Learning library. (Extreemly early pre pre alpha!!!)

## Example

```elixir
alias ExLearn.Matrix
alias ExLearn.NeuralNetwork, as: NN

structure_parameters = %{
  layers: %{
    input:   %{size: 2},
    hidden: [%{activity: :logistic, name: "First Hidden", size: 4}],
    output:  %{activity: :softmax,  name: "Output",       size: 2}
  },
  objective:    :negative_log_likelihood,
  presentation: :argmax
}

network = NN.create(structure_parameters)

initialization_parameters = %{
  distribution: :normal,
  deviation:    1,
  mean:         0,
  modifier:     fn(value, inputs, _outputs) -> value / :math.sqrt(inputs) end
}

NN.initialize(initialization_parameters, network)

training_data = [
  {Matrix.new(1, 2, [[0, 0]]), Matrix.new(1, 2, [[1, 0]])},
  {Matrix.new(1, 2, [[0, 1]]), Matrix.new(1, 2, [[0, 1]])},
  {Matrix.new(1, 2, [[1, 0]]), Matrix.new(1, 2, [[0, 1]])},
  {Matrix.new(1, 2, [[1, 1]]), Matrix.new(1, 2, [[1, 0]])}
]

prediction_data = [
  {0, Matrix.new(1, 2, [[0, 0]])},
  {1, Matrix.new(1, 2, [[0, 1]])},
  {2, Matrix.new(1, 2, [[1, 0]])},
  {3, Matrix.new(1, 2, [[1, 1]])}
]

data = %{
  train:   %{data: training_data,   size: 4},
  predict: %{data: prediction_data, size: 4}
}

parameters = %{
  batch_size:    2,
  epochs:        600,
  learning_rate: 0.4,
  workers:       2
}

NN.process(data, parameters, network) |> NN.result

|> Enum.map(fn({id, output}) ->
  IO.puts "------------------------------"
  IO.puts "Input ID: #{id}"
  IO.puts "Output: #{output}"
end)
```

For a more complex example check out
[samples/mnist-digits/digits-feedforward.exs](samples/mnist-digits/digits-feedforward.exs).

## Usage with Docker

Add the following aliases to `~/.bash_profile` and source it:

```bash
alias docker-here='docker run --rm -it -u `id -u`:`id -g` -v "$PWD":/work -w /work'
alias docker-dev-here='docker run --rm -it -u `id -u`:`id -g` -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v "$PWD":/work -v "$HOME"/.bash_profile:/home/notroot/.bash_profile -v "$HOME"/.globalrc:/home/notroot/.globalrc -v "$HOME"/.spacemacs:/home/notroot/.spacemacs -v "$HOME"/Sources:/home/notroot/Sources:ro -v "$HOME"/.emacs.d:/home/notroot/.emacs.d -w /work'
alias docker-root-here='docker run --rm -it -v "$PWD":/work -w /work'
```

## Jupyter Notebook

1. Build the notebook container
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

## Development Container

1. Build the project container
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

2. Start the container with a login shell
    ```bash
    docker-dev-here exlearn-dev bash -l
    ```

3. To run gdb you need to give seccomp permissions
    ```bash
    docker-dev-here --security-opt seccomp=unconfined exlearn-dev bash -l

    gdb
    ```

4. Run dialyzer
    ```bash
    docker-dev-here exlearn-dev mix dialyzer
    ```

## LICENSE

This plugin is covered by the BSD license, see [LICENSE](LICENSE) for details.
