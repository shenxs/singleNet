#lang racket
(require net/url
         json
         file/md5
         file/sha1)
 (require rnrs/arithmetic/bitwise-6)
;;必要的头文件

(define 账号 "15381089274@GDPF.XY")
(define 密码 "653928")
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
(define (url->json url)
  (call/input-url (string->url url) get-pure-port read-json))

(define (url->string url)
  (call/input-url (string->url url) get-pure-port port->string))
;;l ->list n->第n个 w-> what 变成什么
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
(define tmp0 (bitwise-bit-field time/5 24 29))
(define tmp1 (bitwise-bit-field time/5 16 24))
(define tmp2 (bitwise-bit-field time/5 8 16))
(define tmp3 (bitwise-bit-field time/5 0 8))
(define tmp_list (list tmp0 tmp1 tmp2 tmp3 ))
(define tmp_str (list->string (map integer->char tmp_list)))
(define bm (string-append  tmp_str  realUserName RAD ))
(define pin3 (bytes->string/utf-8 (subbytes (md5 bm) 0 2)))
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
(define encode
  (string-append pin1 pin2 pin3 账号 ))
(define 拨号字段 (string->url (format "http://192.168.1.1/userRpm/PPPoECfgRpm.htm?wan=0&wantype=2&acc=~a&psw=~a&confirm=~a&SecType=0&sta_ip=0.0.0.0&sta_mask=0.0.0.0&linktype=4&waittime2=0&Connect=%C1%AC+%BD%D3 HTTP/1.1"  encode 密码 密码 )))
(define (拨号 账号 密码)
  (port->string (get-pure-port
                 拨号字段
               '(
                "Host: 192.168.1.1"
                "Authorization: Basic YWRtaW46MTk5NjAxMDE="
                "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                "User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/29.0.1547.76 Safari/537.36"
                "Referer: http://192.168.1.1/userRpm/PPPoECfgRpm.htm?wan=0&wantype=2&acc=~a&psw=~a&confirm=~a&SecType=0&sta_ip=0.0.0.0&sta_mask=0.0.0.0&linktype=4&waittime2=0&Disconnect=%B6%CF+%CF%DF"
                "Accept-Encoding: gzip,deflate,sdch"
                "Cookie: Authorization=Basic YWRtaW46MTk5NjAxMDE="
                "Accept-Language: zh-CN,zh;q=0.8,en;q=0.6"
                )
                #:redirections 0)))
(define (run)
  (拨号 账号 密码))
(display encode)
;(run)
(display "\n")
;(url->string "http://ipinfo.io/ip")
(url->json "http://www.trackip.net/ip?json")
