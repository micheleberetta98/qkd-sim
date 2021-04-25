defmodule Utils do
  @doc """
  Generates `n` random bits
  """
  def random_bits(n) do
    for _ <- 1..n, do: Enum.random(0..1)
  end
end
