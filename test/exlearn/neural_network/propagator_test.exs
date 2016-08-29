Code.require_file("test/fixtures/neural_network/propagator_fixtures.exs")

defmodule ExLearn.NeuralNetwork.PropagatorTest do
  use ExUnit.Case, async: true

  alias ExLearn.NeuralNetwork.Propagator
  alias ExLearn.NeuralNetwork.PropagatorFixtures

  test "#apply_changes returns the new state" do
    network_state = PropagatorFixtures.network_state
    configuration = PropagatorFixtures.configuration
    correction    = PropagatorFixtures.correction
    expected      = PropagatorFixtures.expected_from_correction

    assert Propagator.apply_changes(
      correction, configuration, network_state
    ) == expected
  end

  test "#apply_changes with regularization returns the new state" do
    network_state = PropagatorFixtures.network_state
    configuration = PropagatorFixtures.configuration_with_regularization
    correction    = PropagatorFixtures.correction
    expected      = PropagatorFixtures.expected_from_correction_with_regularization

    assert Propagator.apply_changes(
      correction, configuration, network_state
    ) == expected
  end

  test "#back_propagate returns the correction" do
    network_state = PropagatorFixtures.network_state

    first_forward_state  = PropagatorFixtures.first_forward_state
    first_correction     = PropagatorFixtures.first_correction
    second_forward_state = PropagatorFixtures.second_forward_state
    second_correction    = PropagatorFixtures.second_correction

    assert Propagator.back_propagate(
      first_forward_state, network_state
    ) == first_correction

    assert Propagator.back_propagate(
      second_forward_state, network_state
    ) == second_correction
  end

  test "#back_propagate with mask returns the correction" do
    network_state = PropagatorFixtures.network_state
    forward_state = PropagatorFixtures.forward_state_with_mask

    assert Propagator.back_propagate(forward_state, network_state) |> is_tuple
  end
end
