defmodule ExLearn.NeuralNetwork.BuilderTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Builder

  setup do
    activity_function   = fn(x)       -> x + 1 end
    activity_derivative = fn(_)       -> 1     end
    objective_function  = fn(a, _, _) -> a     end
    objective_error     = fn(a, _)    -> a     end

    structure_parameters = %{
      layers: %{
        input:  %{size: 20},
        hidden: [
          %{
            activity: %{
              function:   activity_function,
              derivative: activity_derivative
            },
            name: "First Hidden",
            size: 3
          },
          %{
            activity: %{
              function:   activity_function,
              derivative: activity_derivative
            },
            name: "Second Hidden",
            size: 4
          }
        ],
        output: %{
          activity: %{
            function:   activity_function,
            derivative: activity_derivative
          },
          name: "Output",
          size: 5
        }
      },
      objective: %{
        function: objective_function,
        error:    objective_error
      }
    }

    {:ok, setup: %{
      activity_function:         activity_function,
      activity_derivative:       activity_derivative,
      objective_function:        objective_function,
      objective_error:           objective_error,
      structure_parameters:      structure_parameters
    }}
  end

  test "#create returns the uninitialized network state", %{setup: setup} do
    %{
      activity_function:    activity_function,
      activity_derivative:  activity_derivative,
      objective_function:   objective_function,
      objective_error:      objective_error,
      structure_parameters: structure_parameters
    } = setup

    expected = %{
      network: %{
        layers: [
          %{
            activity: %{
              function:   activity_function,
              derivative: activity_derivative
            },
            biases:  :not_initialized,
            columns: 3,
            name:    "First Hidden",
            rows:    20,
            weights: :not_initialized
          },
          %{
            activity: %{
              function:   activity_function,
              derivative: activity_derivative
            },
            biases:  :not_initialized,
            columns: 4,
            name:    "Second Hidden",
            rows:    3,
            weights: :not_initialized
          },
          %{
            activity: %{
              function:   activity_function,
              derivative: activity_derivative
            },
            biases:  :not_initialized,
            columns: 5,
            name:    "Output",
            rows:    4,
            weights: :not_initialized
          }
        ],
        objective: %{
          function: objective_function,
          error:    objective_error
        }
      },
      structure: structure_parameters
    }

    assert Builder.create(structure_parameters) == expected
  end

  test "#initialize with normal return a map", %{setup: setup} do
    %{structure_parameters: structure_parameters} = setup

    initialization_parameters = %{
      distribution: :normal,
      deviation:    2,
      mean:         3
    }

    network_state = Builder.create(structure_parameters)
    result        = Builder.initialize(network_state, initialization_parameters)
    %{network: %{layers: layers}} = result

    assert length(layers) == 3
    Enum.each(layers, fn(layer) ->
      %{
        biases:  biases,
        weights: weights
      } = layer

      assert biases  |> is_binary
      assert weights |> is_binary
    end)
  end

  test "#initialize with normal and modifier return a map", %{setup: setup} do
    %{structure_parameters: structure_parameters} = setup

    initialization_parameters = %{
      distribution: :normal,
      deviation:    2,
      mean:         3,
      modifier:     fn(x, a ,b) -> x + a + b end
    }

    network_state = Builder.create(structure_parameters)
    result        = Builder.initialize(network_state, initialization_parameters)
    %{network: %{layers: layers}} = result

    assert length(layers) == 3
    Enum.each(layers, fn(layer) ->
      %{
        biases:  biases,
        weights: weights
      } = layer

      assert biases  |> is_binary
      assert weights |> is_binary
    end)
  end

  test "#initialize with uniform return a map", %{setup: setup} do
    %{structure_parameters: structure_parameters} = setup

    initialization_parameters = %{
      distribution: :uniform,
      maximum:        1,
      minimum:       -1
    }

    network_state = Builder.create(structure_parameters)
    result        = Builder.initialize(network_state, initialization_parameters)
    %{network: %{layers: layers}} = result

    assert length(layers) == 3
    Enum.each(layers, fn(layer) ->
      %{
        biases:  biases,
        weights: weights
      } = layer

      assert biases  |> is_binary
      assert weights |> is_binary
    end)
  end

  test "#initialize with uniform and modifier return a map", %{setup: setup} do
    %{structure_parameters: structure_parameters} = setup

    initialization_parameters = %{
      distribution: :uniform,
      maximum:        1,
      minimum:       -1,
      modifier:     fn(x, a ,b) -> x + a + b end
    }

    network_state = Builder.create(structure_parameters)
    result        = Builder.initialize(network_state, initialization_parameters)
    %{network: %{layers: layers}} = result

    assert length(layers) == 3
    Enum.each(layers, fn(layer) ->
      %{
        biases:  biases,
        weights: weights
      } = layer

      assert biases  |> is_binary
      assert weights |> is_binary
    end)
  end
end
