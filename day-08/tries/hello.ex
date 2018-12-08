defmodule Hello do
  use Application

  def hello do
    IO.puts "Hello World"
  end
end

defmodule NewMix do

  def start(_type, _args) do
    IO.puts "starting"
    # some more stuff
  end
end

