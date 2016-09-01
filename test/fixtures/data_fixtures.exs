defmodule ExLearn.DataFixtures do
  alias ExLearn.Matrix

  def first_sample do
    <<
      1 :: float-little-32, # version
      1 :: float-little-32, # number of elements
      5 :: float-little-32, # length of input
      4 :: float-little-32, # length of label
      1 :: float-little-32  # length of step
    >>
    <> Matrix.new(1, 3, [[1, 2, 3]]) <> Matrix.new(1, 2, [[1900, 2800]])
  end

  def second_sample do
    <<
      1 :: float-little-32, # version
      1 :: float-little-32, # number of elements
      5 :: float-little-32, # length of input
      4 :: float-little-32, # length of label
      1 :: float-little-32  # length of step
    >>
    <> Matrix.new(1, 3, [[2, 3, 4]]) <> Matrix.new(1, 2, [[2600, 3800]])
  end

  def both_samples do
    <<
      1 :: float-little-32, # version
      2 :: float-little-32, # number of elements
      5 :: float-little-32, # length of input
      4 :: float-little-32, # length of label
      1 :: float-little-32  # length of step
    >>
    <> Matrix.new(1, 3, [[1, 2, 3]]) <> Matrix.new(1, 2, [[1900, 2800]])
    <> Matrix.new(1, 3, [[2, 3, 4]]) <> Matrix.new(1, 2, [[2600, 3800]])
  end

  def first_predict do
    <<
      1 :: float-little-32, # version
      1 :: float-little-32, # number of elements
      1 :: float-little-32, # length of ID
      5 :: float-little-32, # length of sample
      1 :: float-little-32  # length of step
    >>
    <> <<1 :: float-little-32>> <> Matrix.new(1, 3, [[1, 2, 3]])
  end
end
