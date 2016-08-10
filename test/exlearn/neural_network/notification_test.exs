defmodule NotificationTest do
  use    ExUnit.Case, async: true
  import ExUnit.CaptureIO

  alias ExLearn.NeuralNetwork.Notification

  setup do
    args    = []
    name    = {:global, make_ref()}
    options = [name: name]

    {:ok, setup: %{
      args:    args,
      name:    name,
      options: options
    }}
  end

  test "#done with map modifies the notification state", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, notification_pid} = Notification.start_link(args, options)

    :ok   = Notification.done(%{notification: name})
    state = Notification.pop(name)

    assert state == [:done]
    assert notification_pid |> Process.alive?
  end

  test "#done with name modifies the notification state", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, notification_pid} = Notification.start_link(args, options)

    :ok   = Notification.done(name)
    state = Notification.pop(name)

    assert state == [:done]
    assert notification_pid |> Process.alive?
  end

  test "#pop with map returns the logged state", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, notification_pid} = Notification.start_link(args, options)

    message       = "Message"
    initial_state = Notification.pop(%{notification: name})
    :ok           = Notification.push(message, name)
    new_state     = Notification.pop(%{notification: name})

    assert initial_state == []
    assert new_state     == [{:message, message}]
    assert notification_pid |> Process.alive?
  end

  test "#pop with name returns the logged state", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, notification_pid} = Notification.start_link(args, options)

    message       = "Message"
    initial_state = Notification.pop(name)
    :ok           = Notification.push(message, name)
    new_state     = Notification.pop(name)

    assert initial_state == []
    assert new_state     == [{:message, message}]
    assert notification_pid |> Process.alive?
  end

  test "#push with map modifies the notification state", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, notification_pid} = Notification.start_link(args, options)

    first_log  = "Message 1"
    second_log = "Message 2"
    :ok        = Notification.push(first_log,  %{notification: name})
    :ok        = Notification.push(second_log, %{notification: name})
    state      = Notification.pop(name)

    assert state == [{:message, first_log}, {:message, second_log}]
    assert notification_pid |> Process.alive?
  end

  test "#push with name modifies the notification state", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, notification_pid} = Notification.start_link(args, options)

    first_log  = "Message 1"
    second_log = "Message 2"
    :ok        = Notification.push(first_log,  name)
    :ok        = Notification.push(second_log, name)
    state      = Notification.pop(name)

    assert state == [{:message, first_log}, {:message, second_log}]
    assert notification_pid |> Process.alive?
  end

  test "#start returns a running process", %{setup: setup} do
    %{
      args:    args,
      name:    {:global, reference},
      options: options
    } = setup

    {:ok, notification_pid} = Notification.start(args, options)
    pid_of_reference        = :global.whereis_name(reference)

    assert notification_pid |> is_pid
    assert notification_pid |> Process.alive?
    assert reference        |> is_reference
    assert notification_pid == pid_of_reference
  end

  test "#start_link returns a running process", %{setup: setup} do
    %{
      args:    args,
      name:    {:global, reference},
      options: options
    } = setup

    {:ok, notification_pid} = Notification.start_link(args, options)
    pid_of_reference        = :global.whereis_name(reference)

    assert notification_pid |> is_pid
    assert notification_pid |> Process.alive?
    assert reference        |> is_reference
    assert notification_pid == pid_of_reference
  end

  test "#stream writes logs to stdout", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, notification_pid} = Notification.start_link(args, options)

    first_log  = "Message 1"
    second_log = "Message 2"
    :ok        = Notification.push(first_log,  name)
    :ok        = Notification.push(second_log, name)

    result = capture_io(fn ->
      Task.start(fn -> Notification.stream(name) |> Task.await end)

      # Sleeping to allow the internal loop to continue.
      Process.sleep(501)
    end)
    assert result == first_log <> "\n" <> second_log <> "\n"

    :ok = Notification.done(name)

    # Allowing the :done message to be received.
    Process.sleep(50)

    assert notification_pid |> Process.alive?
  end
end
