#lang racket
(require
  racket/gui
  file/sha1
  "dial.rkt"
  "getip.rkt"
  "read_save_config.rkt")

;从文件读取配置文件
(read-config)
;;必要的头文件
; Make a frame by instantiating the frame% class
(define frame (new (class frame% (super-new)
        (define/augment (on-close)
          (kill-thread dial-thread)))
      [label "闪讯拨号器"]))

; Make a static text message in the frame
(define msg (new message% [parent frame]
                 [label "请输入闪讯密码\n然后按拨号(点一下就好)"]))
(define account-text-field (new text-field%
                                [label "账号"]
                                [parent frame]
                                [init-value account]))

;建立一个输入框
(define password-text-field (new text-field%
                                 [label "密码"]
                                 [parent frame]
                                 [init-value password]))
(define rt-pass-field (new text-field%
                                [label "路由密码"]
                                [parent frame]
                                [init-value router-password]))


;放btn的pane
(define btn-area (new horizontal-pane%
                      [parent frame]
                      [alignment '(center center )]))

(define dial-thread
  (thread (lambda ()
            (let loop ()
              (match (thread-receive)
                [(list acc pass rt-pass)
                 (dial acc pass rt-pass)
                 (loop)]
                [else (loop)])))))


(define (button-event)
  (local((define account (send (send account-text-field get-editor) get-text))
         (define password (send (send password-text-field get-editor) get-text))
         (define rt-pass (send (send rt-pass-field get-editor) get-text))
         (define (good-format? account password)
           (if (or (string=? account "") (string=? password ""))
               #f
               #t)))
    (if (good-format? account password)
        (with-handlers ([exn:fail:network? (lambda (x) (send msg set-label "未能获得当前ip地址"))])
          ((thread-send dial-thread (list account password  rt-pass))
           (sleep 2)
           (send msg set-label (getip))))
        (send msg set-label "账号或密码格式错误"))))

; Make a button in the frame
(define dail-btn (new button%
                      [parent btn-area]
                      [label "拨号"]
                      ; Callback procedure for a button click:
                      [callback (lambda (button event)
                                  (button-event))]))


(define save-btn (new button%
                      [parent btn-area]
                      [label "保存"]
                      [callback (lambda (button event)
                                  (local((define account (send (send account-text-field get-editor) get-text))
                                         (define password (send (send password-text-field get-editor) get-text))
                                         (define rt-pass (send (send rt-pass-field get-editor) get-text)))
                                    (save-config account password rt-pass)))]))

; Show the frame by calling its show method
(send frame show #t)
(define enter-key-event (new key-event%
                             [key-code #\return ]))
