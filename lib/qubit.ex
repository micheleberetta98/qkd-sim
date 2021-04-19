defmodule Qubit do
  alias Tensor.{Vector, Matrix}

  @hadamard_matrix Matrix.new([[1, 1], [1, -1]], 2, 2)
                   |> Matrix.mult_number(1 / :math.sqrt(2))

  @doc """
  Creates a new qubit, always as |0>
  """
  def new() do
    new(1, 0)
  end

  defp new(zero, one) do
    Matrix.new([[zero], [one]], 2, 1)
  end

  @doc """
  Returns a measured qubit
  """
  def measure(q) do
    if :random.uniform() <= prob(q, 0) do
      new(1, 0)
    else
      new(0, 1)
    end
  end

  @doc """
  Applies the hadamard transform to the qubit
  """
  def hadamard(q) do
    Matrix.product(@hadamard_matrix, q)
  end

  @doc """
  Gets the probability of `q` of being in the state `state`
  """
  def prob(q, state), do: :math.pow(q[state][0], 2)
end
