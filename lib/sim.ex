defmodule Sim do
  def start(n) do
    start(n, false)
  end

  def start_with_eve(n) do
    start(n, true)
  end

  defp start(n, with_eve) do
    bits = for _ <- 1..n, do: Enum.random(0..1)
    IO.puts("Generated #{n} random bits")

    bob = start_bob()

    if with_eve do
      eve = start_eve(bob)
      start_alice(bits, eve)
    else
      start_alice(bits, bob)
    end
  end

  defp start_alice(bits, bob_pid) when is_list(bits) do
    spawn(fn -> init_alice(bits, bob_pid) end)
  end

  defp start_bob() do
    spawn(fn -> bob([], []) end)
  end

  defp start_eve(bob_pid) do
    spawn(fn -> eve(bob_pid) end)
  end

  defp init_alice(bits, bob_pid) do
    bases = Utils.random_bits(length(bits))
    qs = BB84.encode(bits, bases)
    IO.puts("ALICE :: Sending to bob")
    send(bob_pid, {self(), :qubits, qs})
    alice(bits, bases)
  end

  defp alice(bits, bases) do
    receive do
      {sender, :qubits_received} ->
        send(sender, {self(), :bases, bases})
        IO.puts("ALICE :: Qubits ok, sent bases")
        alice(bits, bases)

      {sender, :bases_received, bob_bases} ->
        {filtered_bits, filtered_bases} = BB84.discard_different_bases(bits, bases, bob_bases)
        send(sender, {self(), :check, Enum.take(filtered_bits, 10)})
        IO.puts("ALICE :: Bases ok, sent check")
        alice(filtered_bits, filtered_bases)

      :ok ->
        IO.puts("ALICE :: Protocol finished, key received")
        IO.inspect(bits)

      :abort ->
        IO.puts("ALICE :: Protocol aborted")
    end
  end

  defp bob(bits, bases) do
    receive do
      {sender, :qubits, qs} ->
        IO.puts("BOB :: Received qubits")
        send(sender, {self(), :qubits_received})
        bases = Utils.random_bits(length(qs))

        qs
        |> BB84.decode(bases)
        |> bob(bases)

      {sender, :bases, alice_bases} ->
        IO.puts("BOB :: Bases received, sending my bases")
        send(sender, {self(), :bases_received, bases})
        {filtered_bits, filtered_bases} = BB84.discard_different_bases(bits, alice_bases, bases)
        bob(filtered_bits, filtered_bases)

      {sender, :check, alice_bits} ->
        IO.puts("BOB :: Checking bits")

        if alice_bits == Enum.take(bits, 10) do
          send(sender, :ok)
          IO.puts("BOB :: Protocol finished, key received")
          IO.inspect(bits)
        else
          send(sender, :abort)
          IO.puts("BOB :: Protocol aborted")
        end

      :abort ->
        IO.puts("BOB :: Protocol aborted")
    end
  end

  def eve(bob) do
    receive do
      {sender, :qubits, qs} ->
        IO.puts("EVE :: Intercepting qubits...")
        bases = Utils.random_bits(length(qs))
        qs1 = BB84.measure(qs, bases)
        IO.puts("EVE :: Measured the qubits")
        send(bob, {sender, :qubits, qs1})
    end
  end
end
