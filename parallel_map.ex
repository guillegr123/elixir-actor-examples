defmodule Example.Parallel do
  def map(collection, fun) do
    parent = self()
    processes = Enum.map(collection, fn(e) ->
      spawn_link(fn() ->
        send(parent, { self(), fun.(e) })
      end)
    end)
    Enum.map(processes, fn(pid) ->
      receive do
        {^pid, result} -> result
      end
    end)
  end
end

# iex> c "parallel_map.ex"  # Compile module
# iex> Example.Parallel.map([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], fn(e) -> :timer.sleep(1000); e + e end)  # Try it!
# iex> Enum.map([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], fn(e) -> :timer.sleep(1000); e + e end)  # Compare with normal map
