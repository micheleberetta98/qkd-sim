defmodule QubitTest do
  use ExUnit.Case

  alias Tensor.Vector

  test "a qubit can be measured" do
    q = Qubit.new()
    assert Qubit.prob(q, 0) == 1
    assert Qubit.prob(q, 1) == 0
  end

  test "a qubit can be taken in a superposition" do
    q = Qubit.new() |> Qubit.hadamard()
    assert Qubit.prob(q, 0) > 0.5 - 1 / 1_000_000 && Qubit.prob(q, 0) < 0.5 + 1 / 1_000_000
    assert Qubit.prob(q, 1) > 0.5 - 1 / 1_000_000 && Qubit.prob(q, 1) < 0.5 + 1 / 1_000_000
  end
end
