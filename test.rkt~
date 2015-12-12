#lang racket
(require file/md5)
(require rnrs/arithmetic/bitwise-6)

(bitwise-ior 4 4)
(define time/5 (floor ( / (current-seconds)5)))

(bitwise-bit-field 256 1 8)

(define one (bitwise-bit-field time/5 24 29))
(define two (bitwise-bit-field time/5 16 24))
(define three (bitwise-bit-field time/5 8 16))
(define four (bitwise-bit-field time/5 0 8))
(bytes one two three four)
(md5 (format "1212312~a~a" "哈哈"  "yes"))
(md5 "admin" )
(md5 "adminisitor" )
(integer->char 10)