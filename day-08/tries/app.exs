def application do
  [
    # this is the name of any module implementing the Application behaviour
    mod: {Hello, [:word = "coucou"]}, 
    applications: [:logger]]
end
