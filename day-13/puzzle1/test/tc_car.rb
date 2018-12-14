require "test/unit"
require_relative "../src/car"

class TestCar < Test::Unit::TestCase
 
  def test_car_is_going_down
    car = Car.new(9, 0, 0, 'v')
    assert_equal(Directions::DOWN, car.direction)
  end

  def test_car_is_going_up
    car = Car.new(9, 0, 0, '^')
    assert_equal(Directions::UP, car.direction)
  end

  def test_car_is_going_right
    car = Car.new(9, 0, 0, '>')
    assert_equal(Directions::RIGHT, car.direction)
  end

  def test_car_is_going_left
    car = Car.new(9, 0, 0, '<')
    assert_equal(Directions::LEFT, car.direction)
  end

  def test_car_turns_left
    car = Car.new(9, 0, 0, '<')
    car.turn_left
    assert_equal(Directions::DOWN, car.direction)
    car.turn_left
    assert_equal(Directions::RIGHT, car.direction)
    car.turn_left
    assert_equal(Directions::UP, car.direction)
    car.turn_left
    assert_equal(Directions::LEFT, car.direction)
  end

  def test_car_turns_right
    car = Car.new(9, 0, 0, '<')
    car.turn_right
    assert_equal(Directions::UP, car.direction)
    car.turn_right
    assert_equal(Directions::RIGHT, car.direction)
    car.turn_right
    assert_equal(Directions::DOWN, car.direction)
    car.turn_right
    assert_equal(Directions::LEFT, car.direction)
  end

  def test_car_straight
    car = Car.new(9, 0, 0, '<')
    car.straight
    assert_equal(Directions::LEFT, car.direction)
    car.straight
    assert_equal(Directions::LEFT, car.direction)
    car.straight
    assert_equal(Directions::LEFT, car.direction)
  end

  def test_car_move_forward_to_left
    car = Car.new(9, 0, 0, '<')
    car.move_forward
    assert_equal(Directions::LEFT, car.direction)
    assert_equal(-1, car.x)
    assert_equal(0, car.y)
  end

  def test_car_move_forward_to_right
    car = Car.new(9, 0, 0, '>')
    car.move_forward
    assert_equal(Directions::RIGHT, car.direction)
    assert_equal(1, car.x)
    assert_equal(0, car.y)
  end

  def test_car_move_forward_to_top
    car = Car.new(9, 0, 0, '^')
    car.move_forward
    assert_equal(Directions::UP, car.direction)
    assert_equal(0, car.x)
    assert_equal(-1, car.y)
  end

  def test_car_move_forward_to_bottom
    car = Car.new(9, 0, 0, 'v')
    car.move_forward
    assert_equal(Directions::DOWN, car.direction)
    assert_equal(0, car.x)
    assert_equal(1, car.y)
  end

  def test_car_turn_on_crossroads
    car = Car.new(9, 0, 0, 'v')
    car.turn # turn to left the first time
    assert_equal(Directions::RIGHT, car.direction)
    assert_equal(0, car.x)
    assert_equal(0, car.y)
    car.turn # straight the second time
    assert_equal(Directions::RIGHT, car.direction)
    assert_equal(0, car.x)
    assert_equal(0, car.y)
    car.turn # turn to right the third time
    assert_equal(Directions::DOWN, car.direction)
    assert_equal(0, car.x)
    assert_equal(0, car.y)
    car.turn # turn to left the fourth time
    assert_equal(Directions::RIGHT, car.direction)
    assert_equal(0, car.x)
    assert_equal(0, car.y)
  end

  def test_delete_car_from_array
    cars = [
      Car.new(1, 0, 0, "v"),
      Car.new(2, 0, 0, "v"),
      Car.new(3, 0, 0, "v"),
      Car.new(4, 0, 0, "v"),
      Car.new(5, 0, 0, "v"),
      Car.new(6, 0, 0, "v"),
      Car.new(7, 0, 0, "v"),
      Car.new(8, 0, 0, "v")
    ]

    result = [
      Car.new(1, 0, 0, "v"),
      Car.new(2, 0, 0, "v"),
      Car.new(3, 0, 0, "v"),
      Car.new(4, 0, 0, "v"),
      Car.new(6, 0, 0, "v"),
      Car.new(7, 0, 0, "v"),
      Car.new(8, 0, 0, "v")
    ]

    cars.reverse_each do |car|
      if car.id == 5
        cars.delete(car)
      end
    end

    assert_equal(7, cars.length)
    assert_equal(6, cars[4].id)
  end

  def test_retrieve_direction_up
    dir = Directions::UP
    assert_equal(0, dir.x)
    assert_equal(-1, dir.y)
    assert_equal('^', dir.symbol)
  end
end


