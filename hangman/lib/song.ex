defmodule Song do
  def bottle(0), do: "no more bottles of beer"
  def bottle(1), do: "one bottle of beer"
  def bottle(n), do: "#{n} bottles of beer"

  def beer_bottle(0), do: :ok
  def beer_bottle(n) do
    IO.puts ~s{
      #{bottle(n)} on the wall,
      #{bottle(n)},
      take one down and pass it around,
      and there's #{bottle(n-1)}.
    }
    beer_bottle(n-1)
  end
end
