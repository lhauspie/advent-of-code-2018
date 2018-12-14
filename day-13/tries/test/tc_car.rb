require "test/unit"
require_relative "../src/car"

class TestCar < Test::Unit::TestCase
 
  def test_car_is_going_down
    car = Car.new([0,0], 'v')
    assert_equal('v', car.instance_variable_get(:@symbol))
    assert_equal(Directions::DOWN, car.direction)
  end

  def test_car_is_going_up
    car = Car.new([0,0], '^')
    assert_equal('^', car.instance_variable_get(:@symbol))
    assert_equal(Directions::UP, car.direction)
  end

  def test_retrieve_direction_up
    dir = Directions::UP
    assert_equal(0, dir.dx)
    assert_equal(-1, dir.dy)
  end

  def test_two_dimensionnal_array_from_strings
    strings = [
      "   /--\\   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   |  |   ",
      "   \\--/   "
    ]

    m = []
    for i in 0..strings.length-1
      split = strings[i].split("")
      m.push(split)

      for j in 0..split.length-1
        print(j, ":", m[i][j])
      end
      puts("")
    end

    puts "---"
    m.each do |x|
      x.each do |y|
          print y
      end
      puts "#"
    end

    print(m[3][3])
  end

  def test_delete_element_from_array
    array = [1, 2, 3, 4, 5, 6]

    array_bis = array
    i = 0
    array.reverse_each do |a|
      print(a)
      if a == 3
        array.delete(a)
      end
      i +=1
    end
    puts("")

    print(array, "\n")
    print(array_bis, "\n")
  end
end
