Code.require_file("test/fixtures/neural_network/forwarder_fixtures.exs")

defmodule ExLearn.NeuralNetwork.ForwarderTest do
  use ExUnit.Case, async: true

  alias ExLearn.Matrix
  alias ExLearn.NeuralNetwork.Forwarder

  alias ExLearn.NeuralNetwork.ForwarderFixtures

  test "#forward_for_activity returns the activities" do
    network_state = ForwarderFixtures.network_state

    first_input  = {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}
    second_input = {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}

    first_activity  = ForwarderFixtures.first_activity
    second_activity = ForwarderFixtures.second_activity

    assert Forwarder.forward_for_activity(
      first_input, network_state
    ) == first_activity

    assert Forwarder.forward_for_activity(
      second_input, network_state
    ) == second_activity
  end

  test "#forward_for_activity with dropout returns the activities" do
    network_state = ForwarderFixtures.network_state_with_dropout

    first_input  = {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}
    second_input = {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}

    assert Forwarder.forward_for_activity(
      first_input, network_state
    ) |> is_map

    assert Forwarder.forward_for_activity(
      second_input, network_state
    ) |> is_map
  end

  test "#forward_for_output returns the outputs" do
    network_state = ForwarderFixtures.network_state

    first_input  = {1, Matrix.new(1, 3, [[1, 2, 3]])}
    second_input = {2, Matrix.new(1, 3, [[2, 3, 4]])}

    first_expected  = {1, Matrix.new(1, 2, [[1897, 2784]])}
    second_expected = {2, Matrix.new(1, 2, [[2620, 3846]])}

    assert Forwarder.forward_for_output(
      first_input, network_state
    ) == first_expected

    assert Forwarder.forward_for_output(
      second_input, network_state
    ) == second_expected
  end

  test "#forward_for_test returns the error and match" do
    network_state = ForwarderFixtures.network_state

    first_input  = {Matrix.new(1, 3, [[1, 2, 3]]), Matrix.new(1, 2, [[1900, 2800]])}
    second_input = {Matrix.new(1, 3, [[2, 3, 4]]), Matrix.new(1, 2, [[2600, 3800]])}

    first_expected  = {-19, false}
    second_expected = { 66, false}

    assert Forwarder.forward_for_test(
      first_input, network_state
    ) == first_expected
    assert Forwarder.forward_for_test(
      second_input, network_state
    ) == second_expected
  end
end
