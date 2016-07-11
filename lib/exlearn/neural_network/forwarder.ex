defmodule ExLearn.NeuralNetwork.Forwarder do
  @moduledoc """
  Feed forward functionality
  """

  alias ExLearn.Matrix

  @doc """
  Propagates input forward trough a network and return the output
  """
  @spec forward_for_output([[number]], map) :: [[number]]
  def forward_for_output(batch, state) do
    %{network: %{layers: layers}} = state

    calculate_output(batch, layers)
  end

  defp calculate_output(output, []) do
    output
  end

  defp calculate_output(batch_input, [layer|rest]) do
    %{
      activity: %{function: function},
      biases:   biases,
      weights:  weights
    } = layer

    batch_output = Enum.map(batch_input, fn (sample) ->
      Matrix.dot([sample], weights)
        |> Matrix.add(biases)
        |> Matrix.apply(function)
        |> List.first()
    end)

    calculate_output(batch_output, rest)
  end

  @doc """
  Propagates input forward trough a network and return the activity
  """
  @spec forward_for_activity([number], map) :: [map]
  def forward_for_activity(batch, state) do
    batch
      |> full_network(state)
      |> calculate_activity([])
  end

  @spec calculate_activity(map, [map]) :: map
  defp calculate_activity(network, activities) do
    case network do
      %{weights: [_|[]]} ->
        Matrix.transpose(activities)
          |> Enum.map(fn (element) ->
            [%{output: [out]}|_] = element
            result = Enum.reverse(element)

            %{activity: result, output: out}
          end)
      %{weights: [batch, w|ws], biases: [b|bs], activity: [a|as]} ->
        %{function: f, derivative: d} = a

        activity = Enum.map(batch, fn (sample) ->
          input  = Matrix.dot(sample, w) |> Matrix.add(b)
          output = input |> Matrix.apply(f)

          %{derivative: d, input: input, output: output}
        end)

        output      = Enum.map(activity, fn (element) -> element[:output] end)
        new_network = %{weights: [output|ws], biases: bs, activity: as}

        calculate_activity(new_network, [activity|activities])
    end
  end

  # Prepends the input as a matrix to the weight list
  @spec full_network([[number]], map) :: map
  defp full_network(batch, state) do
    %{network: network} = state
    %{weights: weights} = network

    input_list = Enum.map(batch, fn (sample) ->
      case sample do
        {input, _} -> [input]
        input when is_list(input) -> [input]
      end
    end)

    put_in(network, [:weights], [input_list|weights])
  end
end