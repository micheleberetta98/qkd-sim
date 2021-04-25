defmodule Alice do
  def init(num_bits, bob) do
    IO.inspect("ALICE :: Started")
    bits = Utils.random_bits(num_bits)
    bases = Utils.random_bits(num_bits)
    qubits = BB84.encode(bits, bases)

    send_qubits(bob, qubits)
    loop(bits, bases)
  end

  defp loop(bits, bases) do
    receive do
      {bob, :qubits_ok} ->
        send_bases(bob, bases)
        loop(bits, bases)

      {bob, :bases_ok, bob_bases} ->
        {filtered_bits, filtered_bases} = BB84.discard_different_bases(bits, bases, bob_bases)
        send_check(bob, filtered_bits)
        loop(filtered_bits, filtered_bases)

      :ok ->
        IO.puts("ALICE :: Protocol finished, key received")
        IO.inspect(bits)

      :abort ->
        IO.puts("ALICE :: Protocol aborted")
    end
  end

  defp send_qubits(bob, qubits), do: send(bob, {self(), :qubits, qubits})

  defp send_bases(bob, bases), do: send(bob, {self(), :bases, bases})

  defp send_check(bob, filtered_bits) do
    send(bob, {self(), :check, Enum.take(filtered_bits, 10)})
  end
end
