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
    hidden: [%{activity: :logistic, name: "First Hidden", size: 2}],
    output:  %{activity: :logistic, name: "Output",       size: 1}
  },
  objective: :cross_entropy
}

network = NN.create(structure_parameters)

initialization_parameters = %{
  distribution: :normal,
  deviation:    1,
  mean:         0
}

NN.initialize(initialization_parameters, network)

training_data = [
  {Matrix.new(1, 2, [[0, 0]]), Matrix.new(1, 2, [[0]])},
  {Matrix.new(1, 2, [[0, 1]]), Matrix.new(1, 2, [[1]])},
  {Matrix.new(1, 2, [[1, 0]]), Matrix.new(1, 2, [[1]])},
  {Matrix.new(1, 2, [[1, 1]]), Matrix.new(1, 2, [[1]])}
]

learning_parameters = %{
  training: %{
    batch_size:     2,
    data:           training_data,
    data_size:      4,
    epochs:         50,
    learning_rate:  4.5,
    regularization: :none
  },
  workers: 2
}

NN.train(learning_parameters, network) |> Task.await(:infinity)

ask_data = [
  Matrix.new(1, 2, [[0, 0]]),
  Matrix.new(1, 2, [[0, 1]]),
  Matrix.new(1, 2, [[1, 0]]),
  Matrix.new(1, 2, [[1, 1]])
]

NN.ask(ask_data, network) |> Task.await(:infinity) |> Enum.map(&Matrix.inspect/1)
```

## Usage with Docker

Add the following aliases to `~/.bash_profile` and source it:

```bash
alias docker-here='docker run --rm -it -u `id -u`:`id -g` -v "$PWD":/work -w /work'
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

## Development

2. Build the project container
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

3. Update dependencies
    ```bash
    docker-here exlearn mix deps.get
    ```

4. Compile the C shared library
    ```bash
    docker-here exlearn make
    ```

5. Run an interactive shell
    ```bash
    docker-here exlearn iex -S mix
    ```

6. Run a sample
    ```bash
    docker-here exlearn mix run samples/or.exs
    ```

7. Run tests
    ```bash
    docker-here exlearn mix test
    ```

8. Run tests with coverage report
    ```bash
    docker-here exlearn mix coveralls
    ```

9. Run dialyzer
    ```bash
    docker-here exlearn mix dialyzer
    ```

## LICENSE

This plugin is covered by the BSD license, see [LICENSE](LICENSE) for details.
