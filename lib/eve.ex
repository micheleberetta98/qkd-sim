defmodule Eve do
  def init(bob_pid) do
    receive do
      {sender, :qubits, qs} ->
        IO.puts("EVE :: Intercepting qubits...")
        bases = Utils.random_bits(length(qs))
        qs1 = BB84.measure(qs, bases)
        IO.puts("EVE :: Measured the qubits")
        send(bob_pid, {sender, :qubits, qs1})
    end
  end
end
