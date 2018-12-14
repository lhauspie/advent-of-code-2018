require "test/unit"
require_relative "../src/engine"

class TestEngine < Test::Unit::TestCase

  def test_engine_with_one_car_going_up
    strings = [
      "   /--\\   ",
      "   |  |   ",
      "   |  |   ",
      "   ^  |   ",
      "   |  |   ",
      "   \\--/   "
    ]

    engine = Engine.new(strings)
    assert_equal(3, engine.cars[0].x)
    assert_equal(3, engine.cars[0].y)
    assert_equal(Directions::UP, engine.cars[0].direction)
  end

  def test_engine_with_one_car_going_down
    strings = [
      "   /--\\   ",
      "   |  v   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   \\--/   "
    ]

    engine = Engine.new(strings)
    assert_equal(6, engine.cars[0].x)
    assert_equal(1, engine.cars[0].y)
    assert_equal(Directions::DOWN, engine.cars[0].direction)
  end

  def test_engine_with_one_car_going_left
    strings = [
      "   /-<\\   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   \\--/   "
    ]

    engine = Engine.new(strings)
    assert_equal(5, engine.cars[0].x)
    assert_equal(0, engine.cars[0].y)
    assert_equal(Directions::LEFT, engine.cars[0].direction)
  end

  def test_engine_with_one_car_going_right
    strings = [
      "   /--\\   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   \\->/   "
    ]

    engine = Engine.new(strings)
    assert_equal(5, engine.cars[0].x)
    assert_equal(5, engine.cars[0].y)
    assert_equal(Directions::RIGHT, engine.cars[0].direction)
  end

  def test_engine_advent_of_code_example
    strings = [
      "/->-\\        ",
      "|   |  /----\\",
      "| /-+--+-\\  |",
      "| | |  | v  |",
      "\\-+-/  \\-+--/",
      "  \\------/   "
    ]

    engine = Engine.new(strings)
    assert_equal(2, engine.cars.length)
    assert_equal(2, engine.cars[0].x)
    assert_equal(0, engine.cars[0].y)
    assert_equal(Directions::RIGHT, engine.cars[0].direction)
    assert_equal(9, engine.cars[1].x)
    assert_equal(3, engine.cars[1].y)
    assert_equal(Directions::DOWN, engine.cars[1].direction)
  end

  def test_engine_advent_of_code_example_step1
    strings = [
      "/->-\\        ",
      "|   |  /----\\",
      "| /-+--+-\\  |",
      "| | |  | v  |",
      "\\-+-/  \\-+--/",
      "  \\------/   "
    ]

    engine = Engine.new(strings)
    collision = engine.step()
    assert_equal(nil, collision)
    assert_equal(3, engine.cars[0].x)
    assert_equal(0, engine.cars[0].y)
    assert_equal(Directions::RIGHT, engine.cars[0].direction)
    assert_equal(9, engine.cars[1].x)
    assert_equal(4, engine.cars[1].y)
    assert_equal(Directions::RIGHT, engine.cars[1].direction)
  end

  def test_engine_advent_of_code_example_step2
    strings = [
      "/->-\\        ",
      "|   |  /----\\",
      "| /-+--+-\\  |",
      "| | |  | v  |",
      "\\-+-/  \\-+--/",
      "  \\------/   "
    ]

    engine = Engine.new(strings)
    collision = engine.step()
    collision = engine.step()
    assert_equal(nil, collision)
    assert_equal(4, engine.cars[0].x)
    assert_equal(0, engine.cars[0].y)
    assert_equal(Directions::DOWN, engine.cars[0].direction)
    assert_equal(10, engine.cars[1].x)
    assert_equal(4, engine.cars[1].y)
    assert_equal(Directions::RIGHT, engine.cars[1].direction)
  end

  def test_engine_advent_of_code_example_step14
    strings = [
      "/->-\\        ",
      "|   |  /----\\",
      "| /-+--+-\\  |",
      "| | |  | v  |",
      "\\-+-/  \\-+--/",
      "  \\------/   "
    ]

    engine = Engine.new(strings)
    for i in 1..14
      collision = engine.step()
    end
    assert_equal([7,3], collision)
    car_0 = engine.get_car_by_id(0)
    assert_equal(7, car_0.x)
    assert_equal(3, car_0.y)
    assert_equal(Directions::UP, car_0.direction)

    car_1 = engine.get_car_by_id(1)
    assert_equal(7, car_1.x)
    assert_equal(3, car_1.y)
    assert_equal(Directions::DOWN, car_1.direction)
  end

  def test_engine_resolve_puzzle()
    strings = [
      "/->-\\             ",
      "|   |  /----\\     ",
      "| /-+--+-\\  |     ",
      "| | |  | v  |      ",
      "\\-+-/  \\-+--/    ",
      "  \\------/        "
    ]

    engine = Engine.new(strings)
    collision = nil
    loop do
      collision = engine.step()
      break if collision != nil
    end
    assert_equal([7,3], collision)
  end

end


