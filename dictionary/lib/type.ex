defmodule Dictionary.Type do
  @type word_list :: list(word) | pid()
  @type word :: String.t()
end
