defmodule QubitTest do
  use ExUnit.Case

  test "a qubit can be measured" do
    q = Qubit.new()
    assert Qubit.prob(q, 0) == 1
    assert Qubit.prob(q, 1) == 0

    q1 = q |> Qubit.hadamard()
    b1 = Qubit.new() |> Qubit.hadamard()
    b2 = Qubit.new() |> Qubit.qnot() |> Qubit.hadamard()

    assert Qubit.measure(q1, {b1, b2}) == b1
  end

  test "a qubit can be taken into a superposition" do
    q = Qubit.new() |> Qubit.hadamard()
    assert Qubit.prob(q, 0) > 0.5 - 1 / 1_000_000 && Qubit.prob(q, 0) < 0.5 + 1 / 1_000_000
    assert Qubit.prob(q, 1) > 0.5 - 1 / 1_000_000 && Qubit.prob(q, 1) < 0.5 + 1 / 1_000_000
  end

  test "a qubit can be flipped" do
    q = Qubit.new() |> Qubit.qnot()
    assert Qubit.prob(q, 0) == 0
    assert Qubit.prob(q, 1) == 1
  end
end
