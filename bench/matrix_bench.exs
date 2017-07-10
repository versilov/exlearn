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
