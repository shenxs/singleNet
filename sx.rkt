#lang racket
(require
  racket/gui
  file/sha1
  "dial.rkt"
  "getip.rkt"
  "read_save_config.rkt")

(read-config)

;;必要的头文件
; Make a frame by instantiating the frame% class
(define frame (new frame% [label "闪讯拨号器"]))
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

;放btn的pane
(define btn-area (new horizontal-pane%
                      [parent frame]
                      [alignment '(center center )]))

; Make a button in the frame
(define dail-btn (new button% [parent btn-area]
                      [label "拨号"]
                      ; Callback procedure for a button click:
                      [callback (lambda (button event)
                                  (local((define account (send (send account-text-field get-editor) get-text))
                                         (define password (send (send password-text-field get-editor) get-text))
                                         (define (good-format? account password)
                                           (if (or (string=? account "") (string=? password ""))
                                             #f
                                             #t)))
                                    (if (good-format? account password)
                                      (with-handlers ([exn? (lambda (x) (send msg set-label "账号或密码格式错误"))])
                                                     ((dial account password) (send msg set-label (getip))))
                                      (send msg set-label "账号或密码格式错误"))))]))
(define save-btn (new button%
                      [parent btn-area]
                      [label "保存"]
                      [callback (lambda (button event)
                                  (local((define account (send (send account-text-field get-editor) get-text))
                                         (define password (send (send password-text-field get-editor) get-text)))
                                    (save-config account password)))]))

; Show the frame by calling its show method
(send frame show #t)
(define enter-key-event (new key-event%
                             [key-code #\return ]))
