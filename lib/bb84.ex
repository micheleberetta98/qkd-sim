defmodule BB84 do
  @bases1 {Qubit.new(), Qubit.new() |> Qubit.qnot()}
  @bases2 {Qubit.new() |> Qubit.hadamard(), Qubit.new() |> Qubit.qnot() |> Qubit.hadamard()}

  @doc """
  Encodes a list `as` of 0s and 1s as a list of qubit, using a second list `bs`
  """
  def encode(as, bs) when is_list(as) and is_list(bs) do
    Enum.zip(as, bs)
    |> Enum.map(&encode_qubit/1)
  end

  @doc """
  Decodes a list of qubits `qs` using a second list `bs`
  """
  def decode(qs, bs) when is_list(qs) and is_list(bs) do
    Enum.zip(qs, bs)
    |> Enum.map(&measure_qubit/1)
  end

  defp encode_qubit({0, 0}), do: elem(@bases1, 0)
  defp encode_qubit({1, 0}), do: elem(@bases1, 1)
  defp encode_qubit({0, 1}), do: elem(@bases2, 0)
  defp encode_qubit({1, 1}), do: elem(@bases2, 1)

  defp measure_qubit({q, 0}), do: Qubit.measure(q, @bases1)
  defp measure_qubit({q, 1}), do: Qubit.measure(q, @bases2)
end
