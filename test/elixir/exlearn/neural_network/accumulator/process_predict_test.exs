[
  "test/elixir/test_util.exs",
  "test/elixir/fixtures/data_fixtures.exs",
  "test/elixir/fixtures/neural_network/accumulator_fixtures.exs"
]
|> Enum.map(&Code.require_file/1)

defmodule ExLearn.NeuralNetwork.Accumulator.ProcessPredictTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Accumulator
  alias ExLearn.NeuralNetwork.Manager
  alias ExLearn.NeuralNetwork.Notification
  alias ExLearn.NeuralNetwork.Store

  alias ExLearn.TestUtil
  alias ExLearn.DataFixtures
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

  test "#process|:predict with data in file returns the prediction data", %{setup: setup} do
    %{
      args:       args,
      name:       accumulator = {:global, reference},
      options:    options,
      store_name: store_name
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    network_state = AccumulatorFixtures.initial_network_state
    Store.set(network_state, store_name)

    data     = DataFixtures.both_predict
    expected = DataFixtures.both_expected

    path = TestUtil.temp_file_path("exlearn-neural_network-accumulator-process_predict_test")
    :ok  = File.write(path, data)

    data       = %{predict: %{data: path, size: 2}}
    parameters = %{}

    :ok = Accumulator.process(data, parameters, accumulator)
    assert Accumulator.get(accumulator) == expected
    assert Store.get(store_name)        == network_state

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference

    :ok = File.rm(path)
  end

  test "#process|:predict with data in memory returns the prediction data", %{setup: setup} do
    %{
      args:       args,
      name:       accumulator = {:global, reference},
      options:    options,
      store_name: store_name
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    network_state = AccumulatorFixtures.initial_network_state
    Store.set(network_state, store_name)

    first_sample  = {1, Matrix.new(1, 3, [[1, 2, 3]])}
    second_sample = {2, Matrix.new(1, 3, [[2, 3, 4]])}

    first_expected  = {1, Matrix.new(1, 2, [[1897, 2784]])}
    second_expected = {2, Matrix.new(1, 2, [[2620, 3846]])}

    data_samples = [first_sample,    second_sample ]
    expected     = [second_expected, first_expected]

    data       = %{predict: %{data: data_samples, size: 2}}
    parameters = %{}

    :ok = Accumulator.process(data, parameters, accumulator)
    assert Accumulator.get(accumulator) == expected
    assert Store.get(store_name)        == network_state

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference
  end
end
