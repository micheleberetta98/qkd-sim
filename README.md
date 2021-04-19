# QKD Simultation

A simple simulation of the BB84 quantum key distribution protocol.

## How to simulate

Opening a `iex -S mix` session in the folder, use the following expression
```
iex> Sim.start(num_of_bits)
```

Or, if you want to simulate an interceptor, use
```
iex> Sim.start_with_eve(num_of_bits)
```
