defmodule ExLearn.NeuralNetwork.Worker.NifsTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Worker

  test "#create_worker_data can be called" do
    assert Worker.create_worker_data(["/path/to/file1", "/path/to/file2"]) != []
  end
end
