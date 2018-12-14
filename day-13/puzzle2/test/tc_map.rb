require "test/unit"
require_relative "../src/map"

class TestMap < Test::Unit::TestCase

  def test_map_without_car
    strings = [
      "   /--\\   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   \\--/   "
    ]

    map = Map.new(strings)
    assert_equal(10, map.width)
    assert_equal(6, map.height)
  end

  def test_map_with_one_car_going_up
    strings = [
      "   /--\\   ",
      "   |  |   ",
      "   |  |   ",
      "   ^  |   ",
      "   |  |   ",
      "   \\--/   "
    ]

    map = Map.new(strings)
    assert_equal('|', map.circuit[3][3])
  end

  def test_map_with_one_car_going_down
    strings = [
      "   /--\\   ",
      "   |  v   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   \\--/   "
    ]

    map = Map.new(strings)
    assert_equal('|', map.cell(6, 1))
  end

  def test_map_with_one_car_going_left
    strings = [
      "   /-<\\   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   \\--/   "
    ]

    map = Map.new(strings)
    assert_equal('-', map.cell(5, 0))
  end

  def test_map_with_one_car_going_right
    strings = [
      "   /--\\   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   \\->/   "
    ]

    map = Map.new(strings)
    assert_equal('-', map.cell(5, 5))
  end

  def test_map_advent_of_code_example
    strings = [
      "/->-\\        ",
      "|   |  /----\\",
      "| /-+--+-\\  |",
      "| | |  | v  |",
      "\\-+-/  \\-+--/",
      "  \\------/   "
    ]

    map = Map.new(strings)
    assert_equal('-', map.cell(2, 0))
    assert_equal('|', map.cell(9, 3))
  end
end


