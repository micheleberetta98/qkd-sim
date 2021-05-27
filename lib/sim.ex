defmodule Sim do
  def start(n, delta \\ 1) do
    bob = spawn_bob(n)
    spawn_alice(n, delta, bob)
    :started
  end

  def start_with_eve(n, delta \\ 1) do
    bob = spawn_bob(n)
    eve = spawn(Eve, :init, [bob])
    spawn_alice(n, delta, eve)
    :started_with_eve
  end

  defp spawn_bob(n), do: spawn(Bob, :init, [n])

  defp spawn_alice(n, delta, dest), do: spawn(Alice, :init, [n, delta, dest])
end
