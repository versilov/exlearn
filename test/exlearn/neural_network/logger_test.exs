defmodule LoggerTest do
  use    ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias ExLearn.NeuralNetwork.Logger

  setup do
    args = []
    name = {:global, make_ref()}

    {:ok, setup: %{
      args: args,
      name: name
    }}
  end

  test "#get" do
  end

  test "#log" do
  end

  test "#start returns a running process", %{setup: setup} do
    %{
      args: args,
      name: name = {:global, reference}
    } = setup

    {:ok, logger}    = Logger.start(args, name: name)
    pid_of_reference = :global.whereis_name(reference)

    assert logger    |> is_pid
    assert logger    |> Process.alive?
    assert reference |> is_reference
    assert logger == pid_of_reference
  end

  test "#start_link returns a running process", %{setup: setup} do
    %{
      args: args,
      name: name = {:global, reference}
    } = setup

    {:ok, logger}    = Logger.start_link(args, name: name)
    pid_of_reference = :global.whereis_name(reference)

    assert logger    |> is_pid
    assert logger    |> Process.alive?
    assert reference |> is_reference
    assert logger == pid_of_reference
  end

  test "#stream" do
  end

  test "#stream_async" do
  end
end
