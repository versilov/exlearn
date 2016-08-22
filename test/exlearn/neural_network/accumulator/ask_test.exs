Code.require_file("test/test_util.exs")
Code.require_file("test/fixtures/neural_network/accumulator_fixtures.exs")

defmodule ExLearn.NeuralNetwork.Accumulator.AskTest do
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

  test "#ask with data in file returns the ask data", %{setup: setup} do
    %{
      args:       args,
      name:       name = {:global, reference},
      options:    options,
      store_name: store_name
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    network_state = AccumulatorFixtures.initial_network_state
    Store.set(network_state, store_name)

    first_sample  = Matrix.new(1, 3, [[1, 2, 3]])
    second_sample = Matrix.new(1, 3, [[2, 3, 4]])

    first_expected  = %{
      input:  first_sample,
      output: Matrix.new(1, 2, [[1897, 2784]])
    }

    second_expected = %{
      input:  second_sample,
      output: Matrix.new(1, 2, [[2620, 3846]])
    }

    data     = [first_sample,   second_sample  ]
    expected = [first_expected, second_expected]

    path = TestUtil.temp_file_path()
    TestUtil.write_to_file_as_binary(data, path)

    assert Accumulator.ask(path, name) == expected
    assert Store.get(store_name)       == network_state

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference

    :ok = File.rm(path)
  end

  test "#ask with data in memory returns the ask data", %{setup: setup} do
    %{
      args:       args,
      name:       name = {:global, reference},
      options:    options,
      store_name: store_name
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    network_state = AccumulatorFixtures.initial_network_state
    Store.set(network_state, store_name)

    first_sample  = Matrix.new(1, 3, [[1, 2, 3]])
    second_sample = Matrix.new(1, 3, [[2, 3, 4]])

    first_expected  = %{
      input:  first_sample,
      output: Matrix.new(1, 2, [[1897, 2784]])
    }

    second_expected = %{
      input:  second_sample,
      output: Matrix.new(1, 2, [[2620, 3846]])
    }

    data     = [first_sample,    second_sample ]
    expected = [second_expected, first_expected]

    assert Accumulator.ask(data, name) == expected
    assert Store.get(store_name)       == network_state

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference
  end
end
