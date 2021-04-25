defmodule Sim do
  def start(n) do
    start(n, false)
  end

  def start_with_eve(n) do
    start(n, true)
  end

  defp start(n, with_eve) do
    bob = start_bob()

    if with_eve do
      eve = spawn(Eve, :init, [bob])
      spawn(Alice, :init, [n, eve])
    else
      spawn(Alice, :init, [n, bob])
    end

    :ok
  end

  defp start_bob() do
    spawn(Bob, :init, [])
  end
end
