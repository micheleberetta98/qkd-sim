# QKD Simulation

A simple simulation of the BB84 quantum key distribution protocol.

## What you'll need

You'll need Elixir:

* On *Linux* (Ubuntu or Debian)
  * Add Erlang Solutions repository `wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && sudo dpkg -i erlang-solutions_2.0_all.deb`
  * `sudo apt update`
  * `sudo apt install esl-erlang`
  * `sudo apt install elixir`
* On *macOS*
  * `brew install elixir` or `sudo port install elixir`

For other systems there are instructions and links at https://elixir-lang.org/install.html.

## How to simulate

Opening a `iex -S mix` session in the folder, use the following
```
iex> Sim.start(n)
```
to start the simulation and obtain a key of `n` bits.

If you want to simulate an eavesdropper listening on the channel and measuring the qubits, use
```
iex> Sim.start_with_eve(n)
```

Since the generated qubits will be `(4 + delta)n`, you can set `delta` as the second parameter
in `Sim.start/2` or `Sim.start_with_eve/2`. The default is `delta = 1`.
