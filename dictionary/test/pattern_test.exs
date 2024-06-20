defmodule PatternTest do
  use ExUnit.Case

  test "swap/1" do
    assert Pattern.swap({3, 2}) == {2, 3}
  end

  describe "same/2" do
    test "same returns true if matching" do
      assert Pattern.same({3}, {3})
      refute Pattern.same(:nope, {4})
    end
  end
end
