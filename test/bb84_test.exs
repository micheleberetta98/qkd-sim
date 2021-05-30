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

    assert q1 == 0
    assert q2 == 1

    assert q3 == 0
    assert q4 == 1
  end

  test "it can check against different bases used" do
    as = [0, 1, 0, 1, 0, 0, 1, 1]
    b1 = [0, 0, 1, 1, 1, 1, 0, 0]
    b2 = [0, 1, 1, 0, 0, 1, 0, 1]

    qs = BB84.encode(as, b1) |> BB84.decode(b2)

    as1 = BB84.discard_different_bases(as, b1, b2)
    as2 = BB84.discard_different_bases(qs, b1, b2)

    assert length(as1) <= length(as)
    assert length(as2) <= length(as)

    assert as1 == as2
  end

  test "it can generates check bits" do
    bits = [0, 1, 0, 1, 0, 0, 1, 1]
    {check, rest} = BB84.partition_check_bits(bits, 2)

    assert length(check) == length(bits)
    check = check |> Enum.filter(&(&1 != nil))
    assert length(check) == 2
    assert length(rest) == length(bits) - 2
  end
end
