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

  defp encode_qubit({0, 0}), do: elem(@bases1, 0)
  defp encode_qubit({1, 0}), do: elem(@bases1, 1)
  defp encode_qubit({0, 1}), do: elem(@bases2, 0)
  defp encode_qubit({1, 1}), do: elem(@bases2, 1)

  defp measure_qubit({q, 0}), do: Qubit.measure(q, @bases1)
  defp measure_qubit({q, 1}), do: Qubit.measure(q, @bases2)

  defp decode_qubit({q, 0}), do: Qubit.to_bit(q, @bases1)
  defp decode_qubit({q, 1}), do: Qubit.to_bit(q, @bases2)
end
