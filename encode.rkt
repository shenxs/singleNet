#lang racket
(require file/md5
         rnrs/arithmetic/bitwise-6)
;;账号加密
;;输入账号给出加密后的账号

(define (encode 账号)
  (define RAD "singlenet01")
  ;;简化定义
  (define >> bitwise-arithmetic-shift-right)
  (define << bitwise-arithmetic-shift-left)
  (define & bitwise-and)
  (define ior bitwise-ior)
  (define pin1 (list->string (list (integer->char 13) (integer->char 10))));pin的前两位
  (define realUserName (substring 账号 0 11));取出手机号码
  (define unixStamp (current-seconds));;当前时间
  (define time/5 (floor (/ unixStamp 5)))
  ;l ->list n->第n个 w-> what 变成什么
  ;将链表l中的 第n个元素变成n+w

  (define (add-to l n w)
    (cond
      [(= n 1) (cons (+ w (first l)) (rest l))]
      [else (cons (first l) (add-to (rest l) (- n 1) w))]))
  (define timehash (list 0 0 0 0))
  ;timeHash[i]=timeHash[i]+(((timedivbyfive>>(i+4*j))&1)<<(7-j))
  (define  (time_hash i j)
    (<< (& (>> time/5 (+ (- i 1) (* 4 (- j 1)))) 1) (- 7 (- j 1))))
  (define (循环替换 l i j)
    (local
      (
       (define new-l  (add-to l i  (time_hash i j)))
       (define new-i (if (= j 1) (- i 1) i))
       (define new-j (if (= j 1) 8 (- j 1)))
       )
      (if (and ( =  i 1) (= j 1))
        new-l
        (循环替换 new-l new-i new-j))))
  (define timehased (循环替换 timehash 4 8))
  (define zero (first timehased))
  (define one (second timehased))
  (define two (third timehased))
  (define three (fourth timehased))
  (define pin27-0 (& (>> zero 2) 63))
  (define pin27-1 (ior (&(<<(& zero 3) 4) 255) (&(>> one 4) 15)))
  (define pin27-2 (ior (&(<<(& one 15) 2) 255) (&(>> two 6) 3)))
  (define pin27-3 (& two 63))
  (define pin27-4 (& (>> three 2) 63))
  (define pin27-5 (& (<<(& three 3) 4) 255))
  (define pin27 (list pin27-0 pin27-1 pin27-2 pin27-3 pin27-4 pin27-5))
  (define (调整pin l)
    (cond
      [(empty? l) '()]
      [else (cons
              (if (>= (+(first l) 32) 64) (+(first l) 33) (+(first l) 32))
              (调整pin (rest l))
              )]))
  (define pin2 (list->string (map integer->char (调整pin pin27))))

  (define tmp_bytes (integer->integer-bytes time/5 4 false true))
  (define bm (bytes-append  tmp_bytes
                            (string->bytes/utf-8 realUserName)
                            (string->bytes/utf-8 RAD) ))
  (define pin3 (bytes->string/utf-8 (subbytes (md5 bm) 0 2)))

  (string-append pin1 pin2 pin3 账号))

(provide encode)

