defmodule ExLearn.FileFixtures do
  def first_data_bundle do
    <<
      1 :: integer-little-32, # one
      1 :: integer-little-32, # version
      1 :: integer-little-32, # count
      3 :: integer-little-32, # first_length
      3 :: integer-little-32, # second_length
      1 :: integer-little-32, # maximum_step
      0 :: integer-little-32, # discard
      # sample one: first
      1 :: float-little-32,
      1 :: float-little-32,
      3 :: float-little-32,
      # sample one: second
      1 :: float-little-32,
      1 :: float-little-32,
      6 :: float-little-32
    >>
  end

  def second_data_bundle do
    <<
      1 :: integer-little-32, # one
      1 :: integer-little-32, # version
      2 :: integer-little-32, # count
      4 :: integer-little-32, # first_length
      3 :: integer-little-32, # second_length
      1 :: integer-little-32, # maximum_step
      0 :: integer-little-32, # discard
      # sample one: first
      1 :: float-little-32,
      2 :: float-little-32,
      3 :: float-little-32,
      4 :: float-little-32,
      # sample one: second
      1 :: float-little-32,
      1 :: float-little-32,
      1 :: float-little-32,
      # sample two: first
      1  :: float-little-32,
      2  :: float-little-32,
      9  :: float-little-32,
      10 :: float-little-32,
      # sample two: second
      1 :: float-little-32,
      1 :: float-little-32,
      1 :: float-little-32
    >>
  end

  def data_bundle_3x1 do
    <<
      1 :: integer-little-32, # one
      1 :: integer-little-32, # version
      2 :: integer-little-32, # count
      5 :: integer-little-32, # first_length
      3 :: integer-little-32, # second_length
      1 :: integer-little-32, # maximum_step
      0 :: integer-little-32, # discard
      # sample one: first
      1 :: float-little-32,
      3 :: float-little-32,
      1 :: float-little-32,
      2 :: float-little-32,
      3 :: float-little-32,
      # sample one: second
      1 :: float-little-32,
      1 :: float-little-32,
      1 :: float-little-32,
      # sample two: first
      1 :: float-little-32,
      3 :: float-little-32,
      1 :: float-little-32,
      2 :: float-little-32,
      4 :: float-little-32,
      # sample two: second
      1 :: float-little-32,
      1 :: float-little-32,
      2 :: float-little-32
    >>
  end
end
