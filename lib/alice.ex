defmodule Alice do
  def init(n, bob) do
    IO.inspect("ALICE :: Started")
    k = (4 + 1) * n
    bits = Utils.random_bits(k)
    bases = Utils.random_bits(k)
    IO.puts("ALICE :: Given n = #{n}, generated k = #{k} random bits")
    qubits = BB84.encode(bits, bases)

    send_qubits(bob, qubits)
    loop(bits, n, bases)
  end

  defp loop(bits, n, bases) do
    receive do
      {bob, :qubits_ok} ->
        send_bases(bob, bases)
        loop(bits, n, bases)

      {bob, :bases_ok, bob_bases} ->
        {filtered_bits, filtered_bases} = BB84.discard_different_bases(bits, bases, bob_bases)

        if length(filtered_bits) < 2 * n do
          send(bob, :abort)
          send(self(), :abort)
        else
          send_check(bob, filtered_bits)
        end

        loop(filtered_bits, n, filtered_bases)

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
    check_bits = BB84.random_check_bits(filtered_bits)
    send(bob, {self(), :check, check_bits})
  end
end
