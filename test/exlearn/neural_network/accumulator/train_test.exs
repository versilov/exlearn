Code.require_file("test/test_util.exs")
Code.require_file("test/fixtures/neural_network/accumulator_fixtures.exs")

defmodule ExLearn.NeuralNetwork.Accumulator.TrainTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.{Accumulator, Manager, Notification, Store}

  alias ExLearn.TestUtil
  alias ExLearn.NeuralNetwork.AccumulatorFixtures

  setup do
    notification_name    = {:global, make_ref()}
    notification_args    = []
    notification_options = [name: notification_name]
    {:ok, _} = Notification.start_link(notification_args, notification_options)

    store_name    = {:global, make_ref()}
    store_args    = %{notification: notification_name}
    store_options = [name: store_name]
    {:ok, _} = Store.start_link(store_args, store_options)

    manager_name    = {:global, make_ref()}
    manager_args    = []
    manager_options = [name: manager_name]
    {:ok, _} = Manager.start_link(manager_args, manager_options)

    name = {:global, make_ref()}
    args = %{
      manager:      manager_name,
      notification: notification_name,
      store:        store_name
    }
    options = [name: name]

    {:ok, setup: %{
      args:       args,
      name:       name,
      options:    options,
      store_name: store_name
    }}
  end

  test "#train with data in file updates the network state", %{setup: setup} do
    %{
      args:       args,
      name:       name = {:global, reference},
      options:    options,
      store_name: store_name
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    data = [
      {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])},
      {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}
    ]

    path = TestUtil.temp_file_path("neural_network-accumulator_test")
    TestUtils.write_to_file_as_binary(data, path)

    learning_data = %{
      training: %{
        data:      path,
        data_size: 2,
      }
    }

    learning_parameters = %{
      batch_size:     2,
      epochs:         1,
      learning_rate:  4,
      workers:        2
    }

    initial_network_state = AccumulatorFixtures.initial_network_state
    Store.set(initial_network_state, store_name)

    expected_network_state = AccumulatorFixtures.expected_network_state

    :ok = Accumulator.train(learning_data, learning_parameters, name)

    assert Store.get(store_name) == expected_network_state

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference

    :ok = File.rm(path)
  end

  test "#train with data in memory updates the network state", %{setup: setup} do
    %{
      args:       args,
      name:       name = {:global, reference},
      options:    options,
      store_name: store_name
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    training_data = [
      {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])},
      {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}
    ]

    learning_data = %{
      training: %{
        data:      training_data,
        data_size: 2
      }
    }

    learning_parameters = %{
      batch_size:    2,
      epochs:        1,
      learning_rate: 4,
      workers:       2
    }

    initial_network_state = AccumulatorFixtures.initial_network_state
    Store.set(initial_network_state, store_name)

    expected_network_state = AccumulatorFixtures.expected_network_state

    :ok = Accumulator.train(learning_data, learning_parameters, name)

    assert Store.get(store_name) == expected_network_state

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference
  end

  test "#train with data with L1 regularization updates the network state", %{setup: setup} do
    %{
      args:       args,
      name:       name = {:global, reference},
      options:    options,
      store_name: store_name
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    training_data = [
      {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])},
      {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}
    ]

    learning_data = %{
      training: %{
        data:      training_data,
        data_size: 2
      }
    }

    learning_parameters = %{
      batch_size:     2,
      epochs:         1,
      learning_rate:  4,
      regularization: %{type: :L1, rate: 2},
      workers:        2
    }

    initial_network_state = AccumulatorFixtures.initial_network_state
    Store.set(initial_network_state, store_name)

    expected_network_state = AccumulatorFixtures.expected_network_states_for_l1

    :ok = Accumulator.train(learning_data, learning_parameters, name)

    assert Store.get(store_name) == expected_network_state

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference
  end

  test "#train with data with L2 regularization updates the network state", %{setup: setup} do
    %{
      args:       args,
      name:       name = {:global, reference},
      options:    options,
      store_name: store_name
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    training_data = [
      {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])},
      {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}
    ]

    learning_data = %{
      training: %{
        data:      training_data,
        data_size: 2
      }
    }

    learning_parameters = %{
      batch_size:     2,
      epochs:         1,
      learning_rate:  4,
      regularization: %{type: :L2, rate: 2},
      workers:        2
    }

    initial_network_state = AccumulatorFixtures.initial_network_state
    Store.set(initial_network_state, store_name)

    expected_network_state = AccumulatorFixtures.expected_network_states_for_l2
    :ok = Accumulator.train(learning_data, learning_parameters, name)

    assert Store.get(store_name) == expected_network_state

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference
  end
end
