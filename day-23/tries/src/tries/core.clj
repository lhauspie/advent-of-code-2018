(ns tries.core)


(defn sayHello
  "I just say hello to anyone"
  [budy]
  (str "Hello, " budy "!")
)


(defn -main
  "I can say 'Hello World'."
  []
  (println (sayHello "World"))
)
