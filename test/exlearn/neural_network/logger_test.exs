defmodule LoggerTest do
  use    ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias ExLearn.NeuralNetwork.Logger

  setup do
    args = []
    name = {:global, make_ref()}

    {:ok, setup: %{args: args, name: name}}
  end

  test "#get returns the logged state", %{setup: setup} do
    %{args: args, name: name} = setup

    message = "Message"

    {:ok, logger} = Logger.start(args, name: name)
    initial_state = Logger.get(logger)
    :ok           = Logger.log(message, logger)
    new_state     = Logger.get(logger)

    assert initial_state == []
    assert new_state     == [message]
  end

  test "#log modifies the logger state", %{setup: setup} do
    %{args: args, name: name} = setup

    first_log  = "Message 1"
    second_log = "Message 2"

    {:ok, logger} = Logger.start(args, name: name)

    :ok = Logger.log(first_log,  logger)
    :ok = Logger.log(second_log, logger)

    state = Logger.get(name)

    assert state == [first_log, second_log]
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

  test "#stream writes logs to stdout", %{setup: setup} do
    %{args: args, name: name} = setup

    first_log  = "Message 1"
    second_log = "Message 2"

    {:ok, logger} = Logger.start(args, name: name)

    :ok = Logger.log(first_log,  name)
    :ok = Logger.log(second_log, name)

    result = capture_io(fn ->
      Task.start(fn -> Logger.stream(logger) |> Task.await end)

      Process.sleep(501)
    end)

    assert result == first_log <> "\n" <> second_log <> "\n"
  end
end
