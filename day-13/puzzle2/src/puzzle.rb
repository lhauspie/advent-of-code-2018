require_relative "engine"

strings = []
File.readlines("input.txt").each do |line|
    strings.push(line.chomp)
end

engine = Engine.new(strings)
last_car = nil
while last_car == nil
    last_car = engine.step()
end

print(last_car.to_string(), " is the last car that doesn't crashed\n")
