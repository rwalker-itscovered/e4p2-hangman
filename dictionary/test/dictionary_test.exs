defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "word_list returns a list of words" do
    [ first | _] = Dictionary.word_list()
    assert first == "that"
  end

  test "random_word returns a random word from the list" do
    :rand.seed(:exsss, {100, 101, 102})
    assert Dictionary.random_word() == "launches"
  end
end
