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

  def test_engine_resolve_following_cars_to_left_dont_collide()
    strings = [
      "/-<<\\  ",
      "|   |  ",
      "| /-+-\\",
      "| | | |",
      "\\-+-/ |",
      "  |   |",
      "  \\---/"
    ]

    engine = Engine.new(strings)
    engine.step()
    assert_false(engine.get_car_by_id(0).crashed)
    assert_false(engine.get_car_by_id(1).crashed)
  end

  def test_engine_resolve_following_cars_to_left_collide()
    strings = [
      "/->>\\  ",
      "|   |  ",
      "| /-+-\\",
      "| | | |",
      "\\-+-/ |",
      "  |   |",
      "  \\---/"
    ]

    engine = Engine.new(strings)
    engine.step()
    assert_true(engine.get_car_by_id(0).crashed)
    assert_true(engine.get_car_by_id(1).crashed)
  end

  def test_engine_resolve_crossing_cars_collide()
    strings = [
      "/-><\\  ",
      "|   |  ",
      "| /-+-\\",
      "| | | |",
      "\\-+-/ |",
      "  |   |",
      "  \\---/"
    ]

    engine = Engine.new(strings)
    engine.step()
    assert_equal(true, engine.cars[0].crashed)
    assert_equal(true, engine.cars[1].crashed)
  end

  def test_engine_resolve_puzzle()
    strings = [
      "/>-<\\  ",
      "|   |  ",
      "| /<+-\\",
      "| | | v",
      "\\>+</ |",
      "  |   ^",
      "  \\<->/"
    ]

    engine = Engine.new(strings)
    engine.step()
    assert_true(engine.get_car_by_id(0).crashed)
    assert_true(engine.get_car_by_id(1).crashed)
    assert_true(engine.get_car_by_id(3).crashed)
    assert_true(engine.get_car_by_id(4).crashed)
    assert_true(engine.get_car_by_id(5).crashed)
    assert_true(engine.get_car_by_id(6).crashed)
    assert_false(engine.get_car_by_id(2).crashed)
    assert_false(engine.get_car_by_id(7).crashed)
    assert_false(engine.get_car_by_id(8).crashed)
    engine.step()
    assert_false(engine.get_car_by_id(2).crashed)
    assert_false(engine.get_car_by_id(7).crashed)
    assert_false(engine.get_car_by_id(8).crashed)
    last_car = engine.step()
    assert_true(engine.get_car_by_id(2).crashed)
    assert_true(engine.get_car_by_id(7).crashed)
    assert_false(engine.get_car_by_id(8).crashed)
    assert_equal(8, last_car.id)
    assert_equal(6, last_car.x)
    assert_equal(4, last_car.y)
  end
end


