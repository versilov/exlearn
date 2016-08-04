defmodule ExLearn.NeuralNetwork.StoreTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.{Notification, Store}

  setup do
    network_parameters = %{
      layers: %{
        input:  %{size: 1},
        hidden: [
          %{
            activity: :identity,
            name:     "First Hidden",
            size:     1
          }
        ],
        output: %{
          activity: :identity,
          name:     "Output",
          size:     1
        }
      },
      objective: :quadratic,
      random: %{
        distribution: :uniform,
        range:        {-1, 1}
      }
    }

    notification_name    = {:global, make_ref()}
    notification_args    = []
    notification_options = [name: notification_name]
    {:ok, _} = Notification.start_link(notification_args, notification_options)

    name    = {:global, make_ref()}
    args    = {network_parameters, %{notification: notification_name}}
    options = [name: name]

    {:ok, setup: %{
      args:    args,
      name:    name,
      options: options,
    }}
  end

  test "#start returns a running process", %{setup: setup} do
    %{
      args:    args,
      name:    {:global, reference},
      options: options
    } = setup

    {:ok, store_pid} = Store.start(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert store_pid |> is_pid
    assert store_pid |> Process.alive?
    assert reference  |> is_reference
    assert store_pid == pid_of_reference
  end

  test "#start_link returns a running process", %{setup: setup} do
    %{
      args:    args,
      name:    {:global, reference},
      options: options
    } = setup

    {:ok, store_pid} = Store.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert store_pid |> is_pid
    assert store_pid |> Process.alive?
    assert reference  |> is_reference
    assert store_pid == pid_of_reference
  end

  test "#get with map returns the state", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, store_pid} = Store.start_link(args, options)

    result = Store.get(%{store: name})

    assert result    |> is_map
    assert store_pid |> Process.alive?
  end

  test "#get with name returns the state", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, store_pid} = Store.start_link(args, options)

    result = Store.get(name)

    assert result    |> is_map
    assert store_pid |> Process.alive?
  end

  test "#set with map returns the state", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, store_pid} = Store.start_link(args, options)

    result = Store.set([], %{store: name})

    assert result == :ok
    assert store_pid |> Process.alive?
  end

  test "#set with name returns the state", %{setup: setup} do
    %{
      args:    args,
      name:    name,
      options: options
    } = setup

    {:ok, store_pid} = Store.start_link(args, options)

    result = Store.set([], name)

    assert result == :ok
    assert store_pid |> Process.alive?
  end
end

