require_relative "engine"

strings = []
File.readlines("input.txt").each do |line|
    strings.push(line.chomp)
end

engine = Engine.new(strings)
collision = nil
while collision == nil
    collision = engine.step()
end

print(collision, "\n")
