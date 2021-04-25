defmodule BB84 do
  @bases1 {Qubit.new(), Qubit.new() |> Qubit.qnot()}
  @bases2 {
    Qubit.new() |> Qubit.hadamard(),
    Qubit.new() |> Qubit.qnot() |> Qubit.hadamard()
  }

  @doc """
  Encodes a list `bits` of 0s and 1s as a list of qubit, using a second list `bases`
  """
  def encode(bits, bases) when is_list(bits) and is_list(bases) do
    Enum.zip(bits, bases)
    |> Enum.map(&encode_qubit/1)
  end

  @doc """
  Decodes a list of qubits `qubits` using a second list `bases`
  """
  def decode(qubits, bases) when is_list(qubits) and is_list(bases) do
    Enum.zip(qubits, bases)
    |> Enum.map(&decode_qubit/1)
  end

  @doc """
  Measures a list `qubits` of qubits using the bases in `bases`
  """
  def measure(qubits, bases) when is_list(qubits) and is_list(bases) do
    Enum.zip(qubits, bases)
    |> Enum.map(&measure_qubit/1)
  end

  @doc """
  Keeps only the qubits (or bits) in `qubits` measured with the same bases (`bases1` and `bases2` are the two bases' lists)
  """
  def discard_different_bases(qubits, bases1, bases2) do
    Enum.zip([qubits, bases1, bases2])
    |> Enum.filter(fn {_, b1, b2} -> b1 == b2 end)
    |> Enum.map(fn {q, b, _} -> {q, b} end)
    |> Enum.unzip()
  end

  @doc """
  It returns a random subset of `bits` for the check phase.
  Every bit has a probability of 40% of being chosen.

  For example:
    iex> BB84.random_check_bits([0, 1, 1, 0, 0, 1, 0, 0, 0])
    {[0, 1, nil, nil, nil, 1, nil, nil, 0]}
  """
  def random_check_bits(bits) do
    for b <- bits do
      if :random.uniform() <= 0.4 do
        b
      else
        nil
      end
    end
  end

  defp encode_qubit({0, 0}), do: elem(@bases1, 0)
  defp encode_qubit({1, 0}), do: elem(@bases1, 1)
  defp encode_qubit({0, 1}), do: elem(@bases2, 0)
  defp encode_qubit({1, 1}), do: elem(@bases2, 1)

  defp measure_qubit({q, 0}), do: Qubit.measure(q, @bases1)
  defp measure_qubit({q, 1}), do: Qubit.measure(q, @bases2)

  defp decode_qubit({q, 0}), do: Qubit.to_bit(q, @bases1)
  defp decode_qubit({q, 1}), do: Qubit.to_bit(q, @bases2)
end
