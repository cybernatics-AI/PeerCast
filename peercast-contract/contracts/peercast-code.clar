;; Title: Decentralized Video Streaming Platform
;; Version: 0.1.0
;; Description: Initial setup for video streaming platform

;; Constants and Error Codes
(define-constant contract-owner tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-NOT-FOUND (err u101))

;; Platform State
(define-data-var contract-paused bool false)
(define-data-var platform-fee uint u50)

;; Access Control Maps
(define-map administrators principal bool)

;; Authorization
(define-private (is-admin)
    (default-to false (map-get? administrators tx-sender)))

(define-private (is-contract-owner)
    (is-eq tx-sender contract-owner))

;; Admin Functions
(define-public (set-platform-fee (new-fee uint))
    (begin
        (asserts! (is-admin) ERR-NOT-AUTHORIZED)
        (ok (var-set platform-fee new-fee))))

(define-public (add-administrator (admin principal))
    (begin
        (asserts! (is-admin) ERR-NOT-AUTHORIZED)
        (ok (map-set administrators admin true))))

;; Initialize contract owner as first administrator
(map-set administrators contract-owner true)
