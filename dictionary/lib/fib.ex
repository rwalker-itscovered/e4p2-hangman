defmodule Fib do
  alias Cache

  def fib(n) do
    {:ok, cache} = Cache.start(%{0 => 0, 1 => 1})
    fib(cache, n)
  end

  def fib(cache, n) do
    state = Cache.get_state(cache)

    case Map.has_key?(state, n) do
      true ->
        Map.get(state, n)

      _ ->
        sum = fib(cache, n - 1) + fib(cache, n - 2)
        Cache.update_state(cache, n, sum)
        sum
    end
  end

  # Daves solution

  def cached_fib(n) do
    Cache.run(fn cache -> cached_fib(n, cache) end)
  end

  def cached_fib(n, cache) do
    Cache.lookup(cache, n, fn -> cached_fib(n - 2, cache) + cached_fib(n - 1, cache) end)
  end
end
