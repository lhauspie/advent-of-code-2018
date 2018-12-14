require_relative 'car'
require_relative 'map'


class Engine
    def initialize(strings)
        @map = Map.new(strings)

        car_id = 0
        @cars = []
        for i in 0..strings.length-1
            for j in 0..strings[0].length-1
                c = strings[i][j]
                if ['v', '<', '^', '>'].include? c
                    @cars.push(Car.new(car_id, j, i, c))
                    car_id += 1
                end
            end
        end
    end

    def map
        return @map
    end

    def cars
        return @cars
    end


    def step
        @cars = @cars.sort_by {|car| [car.y, car.x]}
        cars.each do |car|
            if !car.crashed
                car.move_forward
                c = @map.cell(car.x, car.y)
                if c == '/'
                    if car.direction == Directions::UP || car.direction == Directions::DOWN
                        car.turn_right
                    elsif car.direction == Directions::LEFT || car.direction == Directions::RIGHT
                        car.turn_left
                    end
                elsif c == '\\'
                    if car.direction == Directions::UP || car.direction == Directions::DOWN
                        car.turn_left
                    elsif car.direction == Directions::LEFT || car.direction == Directions::RIGHT
                        car.turn_right
                    end
                elsif c == '+'
                    car.turn
                end

                crashed = false
                cars.each do |a_car|
                    if !a_car.crashed && a_car.id != car.id && a_car.x == car.x && a_car.y == car.y
                        return [car.x, car.y]
                    end
                end
            end
        end
        return nil
    end

    def display
        puts("=======================")
        for y in 0..@map.height-1
            for x in 0..@map.width-1
                to_be_displayed = @map.cell(x, y)
                @cars.each do |car|
                    if x == car.x && y == car.y
                        to_be_displayed = car.direction.symbol
                    end
                end
                print(to_be_displayed)
            end
            puts("")
        end
    end

    def get_car_by_id(car_id)
        @cars.each do |a_car|
            if a_car.id == car_id
                return a_car
            end
        end
    end
end