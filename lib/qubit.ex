defmodule Qubit do
  alias Tensor.{Vector, Matrix}

  @hadamard_matrix Matrix.new([[1, 1], [1, -1]], 2, 2)
                   |> Matrix.mult_number(1 / :math.sqrt(2))
  @not_matrix Matrix.new([[0, 1], [1, 0]], 2, 2)

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
  Transforms a qubit `q` into the "equivalent" bit, according to some base
  """
  def to_bit(q, {base0, base1}) do
    if Qubit.measure(q, {base0, base1}) == base0 do
      0
    else
      1
    end
  end

  @doc """
  Returns a measured qubit
  """
  def measure(q) do
    q |> measure({new(1, 0), new(0, 1)})
  end

  @doc """
  Returns a measured qubit in a specified base
  """
  def measure(q, {base0, base1}) do
    q = Matrix.column(q, 0)
    vbase0 = Matrix.column(base0, 0)
    prob0 = Vector.dot_product(q, vbase0) |> :math.pow(2)

    if :rand.uniform() <= prob0 do
      base0
    else
      base1
    end
  end

  @doc """
  Applies the hadamard transform to the qubit
  """
  def hadamard(q) do
    Matrix.product(@hadamard_matrix, q)
  end

  @doc """
  Applies the NOT gate to the qubit
  """
  def qnot(q) do
    Matrix.product(@not_matrix, q)
  end

  @doc """
  Gets the probability of `q` of being in the state `state`
  """
  def prob(q, state), do: :math.pow(q[state][0], 2)
end
