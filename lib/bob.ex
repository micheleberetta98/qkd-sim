defmodule Bob do
  def init() do
    IO.inspect("BOB :: Started")
    loop([], [])
  end

  defp loop(bits, bases) do
    receive do
      {alice, :qubits, qubits} ->
        send_qubits_ok(alice)
        decode_qubits(qubits)

      {alice, :bases, alice_bases} ->
        send_bases_ok(alice, bases)
        {filtered_bits, filtered_bases} = BB84.discard_different_bases(bits, alice_bases, bases)
        loop(filtered_bits, filtered_bases)

      {alice, :check, check_bits} ->
        result = bits |> check_against(check_bits)
        send(alice, result)
        send(self(), result)
        loop(bits, bases)

      :ok ->
        IO.puts("BOB :: Protocol finished, key received")
        IO.inspect(bits)

      :abort ->
        IO.puts("BOB :: Protocol aborted")
    end
  end

  defp send_qubits_ok(alice), do: send(alice, {self(), :qubits_ok})

  defp send_bases_ok(alice, bases), do: send(alice, {self(), :bases_ok, bases})

  defp decode_qubits(qubits) do
    bases = Utils.random_bits(length(qubits))

    qubits
    |> BB84.decode(bases)
    |> loop(bases)
  end

  defp check_against(bits, check_bits) do
    if check_bits == Enum.take(bits, 10) do
      :ok
    else
      :abort
    end
  end
end
