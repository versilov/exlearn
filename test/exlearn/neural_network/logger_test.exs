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

  test "#get returns the logged state", %{setup: setup} do
    %{
      args: args,
      name: name = {:global, reference}
    } = setup

    message = "Message"

    {:ok, logger} = Logger.start(args, name: name)
    initial_state = Logger.get(name)
    :ok           = Logger.log(message, name)
    new_state     = Logger.get(name)

    assert initial_state == []
    assert new_state     == [message]
  end

  test "#log modifies the logger state", %{setup: setup} do
    %{
      args: args,
      name: name = {:global, reference}
    } = setup

    first_log  = "Message 1"
    second_log = "Message 2"

    {:ok, logger} = Logger.start(args, name: name)

    :ok = Logger.log(first_log,  name)
    :ok = Logger.log(second_log, name)

    state = Logger.get(name)

    assert state == [second_log, first_log]
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
