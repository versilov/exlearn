defmodule AccumulatorTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.{Accumulator, Manager, Notification, Store}

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

    configuration = %{
      batch_size:    2,
      data_size:     6,
      epochs:        5,
      learning_rate: 3,
      workers:       2
    }

    notification_name    = {:global, make_ref()}
    notification_args    = []
    notification_options = [name: notification_name]
    {:ok, _} = Notification.start_link(notification_args, notification_options)

    store_name    = {:global, make_ref()}
    store_args    = {network_parameters, %{notification: notification_name}}
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
      args:          args,
      configuration: configuration,
      name:          name,
      options:       options,
      store_name:    store_name
    }}
  end

  test "#ask returns the ask data", %{setup: setup} do
    %{
      args:       args,
      name:       name = {:global, reference},
      options:    options,
      store_name: store_name
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    function   = fn(x)    -> x + 1 end
    derivative = fn(_)    -> 1     end
    objective  = fn(a, b, _c) ->
      Enum.zip(b, a) |> Enum.map(fn({x, y}) -> x - y end)
    end

    network_state = %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[1, 2, 3]],
            weights:  [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[4, 5]],
            weights:  [[1, 2], [3, 4], [5, 6]]
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[6, 7]],
            weights:  [[1, 2], [3, 4]]
          },
        ],
        objective: %{error: objective}
      }
    }

    Store.set(network_state, store_name)

    data     = [[1, 2, 3], [2, 3, 4]]
    expected = [[1897.0, 2784.0], [2620.0, 3846.0]]
    result   = Accumulator.ask(data, name)

    assert result == expected

    assert Store.get(store_name) == network_state

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference
  end

  test "#train updates the network state in store", %{setup: setup} do
    %{
      args:       args,
      name:       name = {:global, reference},
      options:    options,
      store_name: store_name
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    function   = fn(x)    -> x + 1 end
    derivative = fn(_)    -> 1     end
    objective  = fn(a, b, _c) ->
      Enum.zip(b, a) |> Enum.map(fn({x, y}) -> x - y end)
    end

    configuration = %{
      batch_size:    1,
      data_size:     2,
      epochs:        1,
      learning_rate: 2,
      workers:       2
    }
    data          = [{[1, 2, 3], [1900, 2800]}, {[2, 3, 4], [2600, 3800]}]
    initial_network_state = %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[1, 2, 3]],
            weights:  [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[4, 5]],
            weights:  [[1, 2], [3, 4], [5, 6]]
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[6, 7]],
            weights:  [[1, 2], [3, 4]]
          },
        ],
        objective: %{error: objective}
      }
    }

    Store.set(initial_network_state, store_name)

    expected_network_state = %{
      network: %{
        layers: [
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[-837, -1828, -2819]],
            weights:  [
              [-2037, -4452, -6867 ],
              [-2872, -6279, -9686 ],
              [-3707, -8106, -12505]
            ]
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[-150, -337]],
            weights:  [
              [-7615,  -16798],
              [-9363,  -20654],
              [-11111, -24510]
            ]
          },
          %{
            activity: %{arity: 1, function: function, derivative: derivative},
            biases:   [[-28, -53]],
            weights:  [
              [-18935, -36562],
              [-24745, -47780]
            ]
          }
        ],
        objective: %{error: objective}
      }
    }

    :ok = Accumulator.train(data, configuration, name)

    assert Store.get(store_name) == expected_network_state

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference
  end

  test "#start returns a running process", %{setup: setup} do
    %{
      args:    args,
      name:    {:global, reference},
      options: options
    } = setup

    {:ok, accumulator_pid} = Accumulator.start(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference
  end

  test "#start_link returns a running process", %{setup: setup} do
    %{
      args:    args,
      name:    {:global, reference},
      options: options
    } = setup

    {:ok, accumulator_pid} = Accumulator.start_link(args, options)

    pid_of_reference = :global.whereis_name(reference)

    assert accumulator_pid |> is_pid
    assert accumulator_pid |> Process.alive?
    assert reference       |> is_reference
    assert accumulator_pid == pid_of_reference
  end
end
