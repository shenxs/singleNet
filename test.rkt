#lang racket
(require file/md5)
(require rnrs/arithmetic/bitwise-6)

(define (replace l n w)
  (cond
    [(= n 1) (cons w (rest l))]
    [else (cons (first l) (replace (rest l) (- n 1) w))]))

(define (foo l i j)
  (local
    (
     (define new-l (replace l i (list i j)))
     (define new-i (if (= j 1) (- i 1) i))
     (define new-j (if (= j 1) 8 (- j 1)))
     )
    (if (and ( = i 1) (= j 1))
        new-l
     (foo new-l new-i new-j))))
(define (add-to l n w)
  (cond
    [(= n 1) (cons (+ w (first l)) (rest l))]
    [else (cons (first l) (add-to (rest l) (- n 1) w))]))

(add-to '(1 2 3 4 5 6) 4 2)
(foo '(1 2 3 4) 4 8)
(replace '(1 2 3 4 5 6) 3 6)
(md5 "admin")