defmodule BB84Test do
  use ExUnit.Case

  test "it can encode a string of qubits" do
    a = [0, 1, 0, 1]
    b = [0, 0, 1, 1]

    [q1, q2, q3, q4] = BB84.encode(a, b)
    assert Qubit.prob(q1, 0) == 1
    assert Qubit.prob(q2, 1) == 1

    assert Qubit.prob(q3, 0) > 0.5 - 1 / 1_000_000 && Qubit.prob(q3, 0) < 0.5 + 1 / 1_000_000
    assert Qubit.prob(q3, 1) > 0.5 - 1 / 1_000_000 && Qubit.prob(q3, 1) < 0.5 + 1 / 1_000_000

    assert Qubit.prob(q4, 0) > 0.5 - 1 / 1_000_000 && Qubit.prob(q4, 0) < 0.5 + 1 / 1_000_000
    assert Qubit.prob(q4, 1) > 0.5 - 1 / 1_000_000 && Qubit.prob(q4, 1) < 0.5 + 1 / 1_000_000
  end

  test "it can decode a string of qubits" do
    a = [0, 1, 0, 1]
    b = [0, 0, 1, 1]

    [q1, q2, q3, q4] =
      BB84.encode(a, b)
      |> BB84.decode(b)

    assert Qubit.prob(q1, 0) == 1
    assert Qubit.prob(q2, 1) == 1

    assert Qubit.prob(q3, 0) > 0.5 - 1 / 1_000_000 && Qubit.prob(q3, 0) < 0.5 + 1 / 1_000_000
    assert Qubit.prob(q3, 1) > 0.5 - 1 / 1_000_000 && Qubit.prob(q3, 1) < 0.5 + 1 / 1_000_000

    assert Qubit.prob(q4, 0) > 0.5 - 1 / 1_000_000 && Qubit.prob(q4, 0) < 0.5 + 1 / 1_000_000
    assert Qubit.prob(q4, 1) > 0.5 - 1 / 1_000_000 && Qubit.prob(q4, 1) < 0.5 + 1 / 1_000_000
  end
end
