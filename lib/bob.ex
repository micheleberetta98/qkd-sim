defmodule Bob do
  def init(n) do
    IO.inspect("BOB :: Started")
    loop([], n, [])
  end

  defp loop(bits, n, bases) do
    receive do
      {alice, :qubits, qubits} ->
        send_qubits_ok(alice)
        {bits, bases} = decode_qubits(qubits)
        loop(bits, n, bases)

      {alice, :bases, alice_bases} ->
        send_bases_ok(alice, bases)
        {filtered_bits, _filtered_bases} = BB84.discard_different_bases(bits, alice_bases, bases)

        if length(filtered_bits) < 2 * n do
          send(alice, :abort)
          send(self(), :abort)
        end

        loop(filtered_bits, n, [])

      {alice, :check, check_bits} ->
        result = bits |> check_against(check_bits)
        send(alice, result)
        send(self(), result)

        bits
        |> Enum.zip(check_bits)
        |> Enum.filter(fn {_, cb} -> cb == nil end)
        |> Enum.map(fn {b, _} -> b end)
        |> loop(n, bases)

      :ok ->
        IO.puts("BOB :: Protocol finished, key of length #{length(bits)} received")

        IO.puts(
          ["BOB :: " | for(b <- bits, do: "#{b}")]
          |> Enum.join("")
        )

      :abort ->
        IO.puts("BOB :: Protocol aborted")
    end
  end

  defp send_qubits_ok(alice), do: send(alice, {self(), :qubits_ok})

  defp send_bases_ok(alice, bases), do: send(alice, {self(), :bases_ok, bases})

  defp decode_qubits(qubits) do
    bases = Utils.random_bits(length(qubits))

    {qubits |> BB84.decode(bases), bases}
  end

  defp check_against(bits, check_bits) do
    different_bits =
      bits
      |> Enum.zip(check_bits)
      |> Enum.filter(fn {a, b} -> a != b && b != nil end)

    case different_bits do
      [] -> :ok
      _ -> :abort
    end
  end
end
