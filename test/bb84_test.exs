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

  test "it can check against different bases used" do
    as = [0, 1, 0, 1, 0, 0, 1, 1]
    b1 = [0, 0, 1, 1, 1, 1, 0, 0]
    b2 = [0, 1, 1, 0, 0, 1, 0, 1]

    qs = BB84.encode(as, b1)
    qs_decoded = BB84.decode(qs, b2)

    {qs1, common_bases1} = BB84.discard_different_bases(qs, b1, b2)
    {qs2, common_bases2} = BB84.discard_different_bases(qs_decoded, b1, b2)

    assert common_bases1 == common_bases2
    assert length(qs1) <= length(as)
    assert length(qs2) <= length(as)

    assert qs1 == qs2
  end
end
