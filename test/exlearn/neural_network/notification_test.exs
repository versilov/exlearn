defmodule NotificationTest do
  use    ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias ExLearn.NeuralNetwork.Notification

  setup do
    args = []
    name = {:global, make_ref()}

    {:ok, setup: %{args: args, name: name}}
  end

  test "#done modifies the notification state", %{setup: setup} do
    %{args: args, name: name} = setup

    {:ok, notification} = Notification.start(args, name: name)

    :ok   = Notification.done(notification)
    state = Notification.pop(name)

    assert state == [:done]
  end

  test "#pop returns the logged state", %{setup: setup} do
    %{args: args, name: name} = setup

    message = "Message"

    {:ok, notification} = Notification.start(args, name: name)

    initial_state = Notification.pop(notification)
    :ok           = Notification.push(message, notification)
    new_state     = Notification.pop(notification)

    assert initial_state == []
    assert new_state     == [{:message, message}]
  end

  test "#push modifies the notification state", %{setup: setup} do
    %{args: args, name: name} = setup

    first_log  = "Message 1"
    second_log = "Message 2"

    {:ok, notification} = Notification.start(args, name: name)

    :ok = Notification.push(first_log,  notification)
    :ok = Notification.push(second_log, notification)

    state = Notification.pop(name)

    assert state == [{:message, first_log}, {:message, second_log}]
  end

  test "#start returns a running process", %{setup: setup} do
    %{
      args: args,
      name: name = {:global, reference}
    } = setup

    {:ok, notification} = Notification.start(args, name: name)
    pid_of_reference    = :global.whereis_name(reference)

    assert notification |> is_pid
    assert notification |> Process.alive?
    assert reference    |> is_reference
    assert notification == pid_of_reference
  end

  test "#start_link returns a running process", %{setup: setup} do
    %{
      args: args,
      name: name = {:global, reference}
    } = setup

    {:ok, notification}    = Notification.start_link(args, name: name)
    pid_of_reference = :global.whereis_name(reference)

    assert notification |> is_pid
    assert notification |> Process.alive?
    assert reference    |> is_reference
    assert notification == pid_of_reference
  end

  test "#stream writes logs to stdout", %{setup: setup} do
    %{args: args, name: name} = setup

    first_log  = "Message 1"
    second_log = "Message 2"

    {:ok, notification} = Notification.start(args, name: name)

    :ok = Notification.push(first_log,  name)
    :ok = Notification.push(second_log, name)

    result = capture_io(fn ->
      Task.start(fn -> Notification.stream(notification) |> Task.await end)

      Process.sleep(501)
    end)

    assert result == first_log <> "\n" <> second_log <> "\n"

    :ok = Notification.done(notification)
  end
end
