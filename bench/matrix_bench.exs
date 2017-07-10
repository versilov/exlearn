defmodule MatrixBench.RandomMatrix do
    @doc """
    Generates a random matrix just so we can test large matrices
    """
    @spec random(integer, integer, integer) :: [[number]]
    def random(rows, cols, max) do
      IO.puts "Random #{rows}, #{cols}."
      ExLearn.Matrix.new(rows, cols, fn -> :rand.uniform(max) end)
    end
end


defmodule MatrixBench do
  @moduledoc """
  Benchfella module to compare matrix operations performance with a115/exmatrix

  Below are results for MacBookPro, 8 cores, 16 GB memory.
  ExLearn used only a fraction of CPU, because it does not use parallel computation.
  So, actual performance advantage of ExLearn will be an order of magnitude greater.

  ## ExMatrix

  Finished in 29.04 seconds

  benchmark name                iterations   average time
  transpose a 100x100 matrix        5000   719.77 µs/op
  transpose a 200x200 matrix         500   2828.41 µs/op
  transpose a 400x400 matrix         100   14057.79 µs/op
  50x50 matrix in parallel            50   29563.38 µs/op
  100x100 matrix in parallel          10   195277.70 µs/op
  200x200 matrix in parallel           1   1585938.00 µs/op
  400x400 matrix in parallel           1   15745453.00 µs/op


  ## ExLearn.Matrix

  Finished in 19.57 seconds

  benchmark name                iterations   average time
  transpose a 100x100 matrix        100000   27.47 µs/op
  50x50 matrices dot product         20000   95.70 µs/op
  transpose a 200x200 matrix         10000   120.89 µs/op
  transpose a 400x400 matrix          5000   418.17 µs/op
  100x100 matrices dot product        5000   674.94 µs/op
  200x200 matrices dot product         500   4998.85 µs/op
  400x400 matrices dot product          50   38847.84 µs/op

  """

  use Benchfella
  import ExLearn.Matrix
  import MatrixBench.RandomMatrix

  @random_a random(50, 50, 100)
  @random_b random(50, 50, 100)
  @random_a_large random(100, 100, 100)
  @random_b_large random(100, 100, 100)
  @random_a_qlarge random(200, 200, 100)
  @random_b_qlarge random(200, 200, 100)
  @random_a_vlarge random(400, 400, 100)
  @random_b_vlarge random(400, 400, 100)

  bench "transpose a 100x100 matrix" do
    transpose(@random_a_large)
  end

  bench "transpose a 200x200 matrix" do
    transpose(@random_a_qlarge)
  end

  bench "transpose a 400x400 matrix" do
    transpose(@random_a_vlarge)
  end

  bench "50x50 matrices dot product" do
    dot(@random_a, @random_b)
  end

  bench "100x100 matrices dot product" do
    dot(@random_a_large, @random_b_large)
  end

  bench "200x200 matrices dot product" do
    dot(@random_a_qlarge, @random_b_qlarge)
  end

  bench "400x400 matrices dot product" do
    dot(@random_a_vlarge, @random_b_vlarge)
  end
end
