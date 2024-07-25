defmodule Procs do
  def hello(count) do
    receive do
      {:crash, reason } ->
        exit(reason)
      {:quit } ->
        IO.puts "Done..."
      {:add, n} ->
        hello(count + n)
      {:reset} ->
        IO.puts "Resetting..."
        hello(0)
      msg ->
        IO.puts("#{count}: Hello #{inspect msg}")
        hello(count + 1)
    end
  end
end
