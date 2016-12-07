[
  "test/elixir/test_util.exs",
]
|> Enum.map(&Code.require_file/1)

defmodule ExLearn.NeuralNetwork.Worker.NifsTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Worker

  test "#create_worker_resource can be called" do
    worker_resource = Worker.create_worker_resource()

    assert worker_resource != nil
  end
end
