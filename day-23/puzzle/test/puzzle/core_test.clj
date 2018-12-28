(ns puzzle.core-test
  (:require [clojure.test :refer :all]
            [puzzle.core :refer :all]))


(deftest init-point
  (testing "Init origin"
    (let [point1 (ref (create-point 0 0 0 0))
          point2 (ref (create-point 0 0 0 0))]
      (is (hash point1) (hash point2))
      ; (is (= (:x point1) (:x point2)))
      ; (is (= (:y point1) (:y point2)))
      ; (is (= (:z point1) (:z point2)))
    )
  )
)


(deftest string-to-point
  (testing "String to Point"
    (let [point (to-point "pos=<4,5,6>, r=7")
          expected-point (create-point 4 5 6 7)]
      (is (= (hash point) (hash expected-point)))
    )
    (let [point (to-point "pos=<94756071,-6719168,42291145>, r=71380536")
          expected-point (create-point 94756071 -6719168 42291145 71380536)]
      (is (= (hash point) (hash expected-point)))
    )
  )
)

(deftest read-file-line-by-line-to-points
  (testing "Read file line by line to points"
    (with-open [r (clojure.java.io/reader "resources/input.txt")]
      (doseq [point (map to-point (line-seq r))]
        ; (println point)
      )
    )
  )
)

(deftest extract-point-with-bigger-range
  (testing "Extract point with bigger range"
    (let [max-point (max-key :r (create-point 4 5 6 7) (create-point 4 5 6 17) (create-point 4 5 6 1))
          expected-point (create-point 4 5 6 17)]
      (is (= (hash max-point) (hash expected-point)))
    )
  )
)

(deftest read-file-line-by-line-extract-higher-range
  (testing "Read file line by line extract higher range"
    (with-open [r (clojure.java.io/reader "resources/input.txt")]
      (let [max-range-point (apply max-key :r (map to-point (line-seq r)))]
        ; (println max-range-point)
        (is (= max-range-point {:x 63974573, :y -11758567, :z 105453268, :r 99725139}))
      )
    )
  )
)

(deftest point-is-in-range-of-another
  (testing "point-is-in-range-of-another"
    (let [in-range-of-0001 (partial in-range-of-first-point (create-point 0 0 0 1))] ; this is a currying of in-range-of function
      (is (in-range-of-0001 (create-point 1 0 0 0)))
      (is (not (in-range-of-0001 (create-point 1 1 0 0))))
    )
  )
)


(deftest part-one
  (testing "Part one"
    (is (= (number-of-nanobots-in-range-of-higher-range) 240))
  )
)

(deftest part-two
  (testing "Part two"
    (is (= (point-in-range-of-the-largest-number-of-nanobots) 116547949))
  )
)
