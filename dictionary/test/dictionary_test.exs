defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "random_word returns a random word from the list" do
    :rand.seed(:exsss, {100, 101, 102})
    assert Dictionary.random_word() == "launches"
  end
end
