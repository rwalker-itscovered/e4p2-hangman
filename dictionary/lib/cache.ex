defmodule Cache do

  @doc """
  My simple solution, leaving the cache consumer more work to do
  """

  def start(init_state) do
    Agent.start(fn -> init_state end)
  end

  def get_state(agent) do
    Agent.get(agent, &(&1))
  end

  def update_state(agent, n, val) do
    Agent.update(agent, fn state -> Map.put(state, n, val) end)
  end

  @doc """
  Dave's solution
  """
  def run(body) do
    # Hmmm, this isn't a generic solution
    {:ok, pid} = Agent.start_link(fn -> %{ 0 => 0, 1 => 1} end)
    # body is a function apparently
    result = body.(pid)
    # so this is entry and exit point for the whoole calculation
    # should I have stopped my agent, errr...
    Agent.stop(pid)
    result
  end

  def lookup(cache, n, if_not_found) do
    Agent.get(cache, fn map -> map[n] end)
    |> complete_if_not_found(cache, n, if_not_found)
  end

  # takes the result of the map[n] and calls the if_not_found function, or returns the value
  defp complete_if_not_found(nil, cache, n, if_not_found) do
    if_not_found.()
    |> set(cache, n)
  end

  defp complete_if_not_found(value, _cache, _n, _if_not_found) do
    value
  end

  defp set(val, cache, n) do
    Agent.get_and_update(cache, fn map -> {val, Map.put(map, n, val)} end)
  end

end
