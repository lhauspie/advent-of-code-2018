(ns tries.core-test
  (:require [clojure.test :refer :all]
            [tries.core :refer :all]))

(use 'clojure.data)

(deftest say-hello-to-someone
  (testing "Say hello to Budy"
    (is (= (sayHello "Budy") "Hello, Budy!"))
  )
  (testing "Say hello to Logan"
    (is (= (sayHello "Logan") "Hello, Logan!"))
  )
)


(deftest read-file-line-by-line
  (testing "Read file line by line"
    (with-open [r (clojure.java.io/reader "resources/input.txt")]
      (is (= (count (line-seq r)) 1000))
    )
  )
)

(deftest max-key-count
  (testing "max-key count"
    (is (= (max-key :b {:a "asd", :b 3} {:a "long word", :b 9} {:a "bsd", :b 3} {:a "dsd", :b 3}) {:a "long word", :b 9}))
  )
)


(def game-state
  (let [game '[[0 _ _ _]
               [1 1 _ _]
               [5 1 _ 8]
               [1 1 _ 8]]]
    (for [[i row] (map-indexed list game)
          [j cell] (map-indexed list row)
          :when (not= '_ cell)]
      {:x j :y i :value cell}
    )
  )
)
(defn value-equals-to [value obj]
  (= (:value obj) value)
)
(deftest max-key-game-state
  (testing "max-key game-state"
    (let [max-value (apply max-key :value game-state)
          value-equals-to-max (partial value-equals-to (:value max-value))]
      (is (= (:value max-value) 8))
      (println (filter value-equals-to-max game-state))
    )
  )
)



; VERY BAD IDEA because we are flooding the Memory for high range
; (defn point-to-3d-matrix [point]
;   (for [x (range (- (:x point) (:r point)) (+ (:x point) (:r point) 1))
;         y (range (- (:y point) (:r point)) (+ (:y point) (:r point) 1))
;         z (range (- (:z point) (:r point)) (+ (:z point) (:r point) 1))]
;     {:x x :y y :z z :value 1}
;   )
; )

; (deftest simple-point-to-3d-matrix
;   (testing "point-to-3d-matrix"
;     (let [matrix (point-to-3d-matrix {:x 10, :y 10, :z 10, :r 100})]
;       (println matrix)
;     )
;   )
; )


(defn range-dividing_by_2 [n]
  (if (< n 1)
    nil
    (conj (range-dividing_by_2 (/ n 2)) n)
  )
)

(defn range-multiplying_by_2 
  ([n]
    (range-multiplying_by_2 n 1)
  )
  ([n acc]
    (if (> acc n)
      nil
      (conj (range-multiplying_by_2 n (* acc 2)) acc)
    )
  )
)

(deftest range-multiplying_by_2-until-2000000000
  (testing "range-multiplying_by_2-until-2000000000"
    (println (range-multiplying_by_2 2000000000))
  )
)
