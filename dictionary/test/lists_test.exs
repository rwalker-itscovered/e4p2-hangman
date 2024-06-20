defmodule ListsTest do
  use ExUnit.Case

  describe "len/1" do
    test "returns length of the list" do
      assert Lists.len([]) == 0
      assert Lists.len([1, 3, 5]) == 3
    end
  end

  describe "sum/1" do
    test "returns sum of the list" do
      assert Lists.sum([]) == 0
      assert Lists.sum([1, 3, 5]) == 9
    end
  end

  describe "square/1" do
    test "returns the squares of the elements in the list" do
      assert Lists.square([]) == []
      assert Lists.square([1, 3, 5]) == [1, 9, 25]
    end
  end

  describe "double/1" do
    test "returns the squares of the elements in the list" do
      assert Lists.double([]) == []
      assert Lists.double([1, 3, 5]) == [2, 6, 10]
    end
  end

  describe "map/2" do
    test "tripling using map" do
      assert Lists.map([], fn x -> 3 * x end) == []
      assert Lists.map([1, 3, 5], fn x -> 3 * x end) == [3, 9, 15]
    end

    test "using the & notation" do
      assert Lists.map( [2, 8, 16], &(&1 / 2)) == [1, 4, 8]
    end
  end

  describe "sum_pairs/1" do
    test "returns the sums of pairs" do
      assert Lists.sum_pairs([]) == []
      assert Lists.sum_pairs([1, 3, 5, 7]) == [4, 12]
      assert Lists.sum_pairs([1, 3, 5, 7, 9]) == [4, 12, 9]
    end
  end

  describe "even_length/1" do
    test "returns true if even number of elements" do
      assert Lists.even_length([])
      assert Lists.even_length([1,2])
      refute Lists.even_length([1, 3, 5])
    end
  end

end
