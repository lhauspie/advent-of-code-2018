(ns puzzle.core)

(defn create-point [x y z r]
  {
    :x x
    :y y
    :z z
    :r r
  }
)

(defn create-area [point r]
  {
    :p point
    :r r
  }
)

(defn parse-int [s]
  (Integer. (re-find  #"\-?\d+" s))
)

(defn to-point [str]
  (let [sequence (map parse-int (drop 1 (re-find (re-matcher #"pos=<(\-?\d+),(\-?\d+),(\-?\d+)>, r=(\d+)" str))))]
    (create-point (nth sequence 0) (nth sequence 1) (nth sequence 2) (nth sequence 3))  
    ; (create-point 0 1 2 3)
  )
)

(defn abs [n] (max n (- n)))

(defn in-range-of [point1 point2]
  (<=
    (+ (abs (- (:x point1) (:x point2)))
       (abs (- (:y point1) (:y point2)))
       (abs (- (:z point1) (:z point2)))
    )
    (:r point1)
  )
)

(defn in-range-of-first-point [point1 point2]
  (in-range-of point1 point2)
)

(defn in-range-of-second-point [point1 point2]
  (in-range-of point2 point1)
)

(defn number-of-nanobots-in-range-of-higher-range []
  (with-open [r (clojure.java.io/reader "resources/input.txt")]
    (let [points (map to-point (line-seq r))
          max-range-point (apply max-key :r points)
          in-range-of-higher-range (partial in-range-of max-range-point)]
      (count (filter in-range-of-higher-range points))
    )
  )
)


(defn count-points-in-range
  "Allow to check some points (chosed by using the `r`) in an area (delimited by min-point and max-point) are in range of a collection of points"
  [points min-point max-point r]
  (if (< r 1)
    nil
    (for [x (range (:x min-point) (+ (:x max-point) r) r)
          y (range (:y min-point) (+ (:y max-point) r) r)
          z (range (:z min-point) (+ (:z max-point) r) r)]
      (let [current-in-range-of (partial in-range-of-second-point {:x x :y y :z z :r r})]
        ; (conj 
        ;   (points min-point max-point (/ r 2))
          ; (println points)
          ; (println (filter current-match-point-range points))
          {:x x :y y :z z :count (count (filter current-in-range-of points))}
        ; )
      )
    )
  )
)

(defn count-points-in-ranges
  "Dichotomically search the points that are in range of the largest number points"
  [points min-point max-point r]
  (if (< r 1)
    nil
    (let [best (apply max-key :count (count-points-in-range points min-point max-point r))
          new-min-point {:x (- (:x best) r) :y (- (:y best) r) :z (- (:z best) r)}
          new-max-point {:x (+ (:x best) r) :y (+ (:y best) r) :z (+ (:z best) r)}]
      (conj
        (count-points-in-ranges points new-min-point new-max-point (/ r 2))
        best
      )
    )
  )
)

(defn point-in-range-of-the-largest-number-of-nanobots 
  "Find the point that is in range of largest number of points"
  []
  (with-open [input (clojure.java.io/reader "resources/input.txt")]
    (let [points (map to-point (line-seq input))
          min-point {:x (:x (apply min-key :x points)) :y (:y (apply min-key :y points)) :z (:z (apply min-key :z points))}
          max-point {:x (:x (apply max-key :x points)) :y (:y (apply max-key :y points)) :z (:z (apply max-key :z points))}
          best-point (apply max-key :count (count-points-in-ranges points min-point max-point 134217728))] ; value 134217728 is 2^27 to be able to divide by 2 indefinitely
      (+ (:x best-point) (:y best-point) (:z best-point))
    )
  )
)

(defn -main []
  (println {:part-1 (number-of-nanobots-in-range-of-higher-range)})
  (println {:part-2 (point-in-range-of-the-largest-number-of-nanobots)})
)
