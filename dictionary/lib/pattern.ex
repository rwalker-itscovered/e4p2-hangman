defmodule Pattern do
  def two({a, b}) do
    {b, a}
  end

  def same(a, a), do: true

  def same(_, _), do: false

end
