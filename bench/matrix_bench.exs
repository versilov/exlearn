defmodule MatrixBench.RandomMatrix do
    @doc """
    Generates a random matrix just so we can test large matrices
    """
    @spec random(integer, integer, integer) :: [[number]]
    def random(rows, cols, max) do
      ExLearn.Matrix.new(rows, cols, fn -> :rand.uniform(max) end)
    end
end


defmodule MatrixBench do
  @moduledoc """
  Benchfella module to compare matrix operations performance with a115/exmatrix

  Below are results for MacBookPro, 1 core used, 16 GB memory.
  ExLearn shows about 1 000 times better performance in dot product
  and is 20 times faster in transposing.

  ## ExMatrix
  ```
  Finished in 52.3 seconds

  benchmark name                iterations   average time
  transpose a 100x100 matrix          5000   763.27 µs/op
  transpose a 200x200 matrix          1000   2704.82 µs/op
  transpose a 400x400 matrix           100   13543.31 µs/op
  50x50 matrices dot product            20   79386.05 µs/op
  100x100 matrices dot product           2   615565.00 µs/op
  200x200 matrices dot product           1   4383168.00 µs/op
  400x400 matrices dot product           1   34386453.00 µs/op
  ```


  ## ExLearn.Matrix
  ```
  Finished in 19.3 seconds

  ## MatrixBench
  benchmark name                iterations   average time
  50x50 matrices dot product        500000   6.89 µs/op
  transpose a 100x100 matrix        100000   28.55 µs/op
  100x100 matrices dot product       50000   37.50 µs/op
  200x200 matrices dot product       10000   124.31 µs/op
  transpose a 200x200 matrix         10000   126.82 µs/op
  transpose a 400x400 matrix          5000   441.10 µs/op
  400x400 matrices dot product        5000   673.23 µs/op

  ```
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
