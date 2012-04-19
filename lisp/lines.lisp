;;;; lines.lisp - functions for testing colinearity of 3 points, from Beautiful Code
;;;;

;;;; points are p, q and r, represented as x and y coordinates
;;;; px, py are the x and y coordinates of point p.

(defun naive-collinear (px py qx qy rx ry)
  "Determine if points P Q and R are colinear."
  ;; compute slope and intercept of line pq
  (let ((m (slope px py qx qy))
	(b (y-intercept px py qx qy)))
    ;; if ry = m*rx +b, then the points are colinear
    (= ry (+ (* m rx) b))))

(defun slope (px py qx qy)
  "Compute the slope of the line running through points p and q."
  (if (= px qx)				; this would result in infinite slope
      nil
    (/ (- py qy) (- px qx))))

(defun y-intercept (px py qx qy)
  "Compute the y-intercept of the line pq."
  (let ((m (slope px py qx qy)))
    (if (not m)				; slope is infinite
	nil				; no y-intercept
      (- py (* m px)))))

(defun less-naive-collinear (px py qx qy rx ry)
  "Determine if P Q and R are colinear. Catch infinite slope case and treat it special."
  (let ((m (slope px py qx qy))
	(b (y-intercept px py qx qy)))
    (if (numberp m)
	(= ry (+ (* m rx) b))		; slope exists, test for colinearity
      (= px rx))))

(defun mm-collinear (px py qx qy rx ry)
  "Test if P Q and R are colinear, sidestep special cases."
  (equalp (slope px py qx qy)
	  (slope qx qy rx ry)))

(defun triangle-collinear (px py qx qy rx ry)
  "Use triangle inequality to verify if P Q and R are colinear or form a triangle."
  (let ((pq (distance px py qx qy))
	(qr (distance qx qy rx ry))
	(pr (distance px py rx ry)))
    (let ((sidelist (sort (list pq qr pr) #'>)))
      (= (first sidelist)
	 (+ (second sidelist) (third sidelist))))))

(defun distance (px py qx qy)
  "Determine the euclidean distance between two points (using Pythagorean theorem)."
  (let ((dx (- px qx))
	(dy (- py qy)))
    (sqrt (+ (* dx dx) (* dy dy)))))

(defun area-collinear (px py qx qy rx ry)
  "Determine if P Q and R are colinear by computing the area of the triangle."
  (= (* (- px rx) (- qy ry))
     (* (- qx rx) (- py ry))))

      
;;; tests, should be T
(triangle-collinear 0 1 1 2 2 3)

;; should be T
(triangle-collinear 0 0 0 0 0 1)

;; should be no, but broken
(triangle-collinear 0 0 3 3 10000 10001)

;; correctly returns nil
(area-collinear 0 0 3 3 10000 10001)