;; Title: Decentralized Video Streaming Platform
;; Description: Initial setup for video streaming platform

;; Constants and Error Codes
(define-constant contract-owner tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-ALREADY-EXISTS (err u102))


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

;; New Maps
(define-map content-creators principal bool)
(define-data-var next-video-id uint u0)

;; Content Storage
(define-map videos 
    { video-id: uint }
    {
        creator: principal,
        title: (string-utf8 256),
        content-hash: (buff 32),
        price: uint,
        created-at: uint,
        is-active: bool
    }
)

;; Creator Functions
(define-private (is-creator)
    (default-to false (map-get? content-creators tx-sender)))

(define-public (register-as-creator)
    (begin
        (asserts! (not (is-creator)) ERR-ALREADY-EXISTS)
        (ok (map-set content-creators tx-sender true))))

(define-public (upload-video (title (string-utf8 256)) 
                           (content-hash (buff 32)) 
                           (price uint))
    (let ((video-id (var-get next-video-id)))
        (asserts! (is-creator) ERR-NOT-AUTHORIZED)
        (map-set videos
            { video-id: video-id }
            {
                creator: tx-sender,
                title: title,
                content-hash: content-hash,
                price: price,
                created-at: block-height,
                is-active: true
            }
        )
        (var-set next-video-id (+ video-id u1))
        (ok video-id)))

;; Enhanced Video Map
(define-map videos 
    { video-id: uint }
    {
        creator: principal,
        title: (string-utf8 256),
        content-hash: (buff 32),
        price: uint,
        created-at: uint,
        views: uint,
        revenue: uint,
        is-active: bool
    }
)

;; Revenue Tracking
(define-map creator-revenue principal uint)
(define-map platform-revenue (string-ascii 10) uint)

;; Purchase Function
(define-public (purchase-video (video-id uint))
    (let ((video (unwrap! (map-get? videos { video-id: video-id }) ERR-NOT-FOUND)))
        (asserts! (get is-active video) ERR-NOT-FOUND)
        (try! (stx-transfer? (get price video) tx-sender (get creator video)))
        (map-set videos 
            { video-id: video-id }
            (merge video { 
                revenue: (+ (get revenue video) (get price video)),
                views: (+ (get views video) u1)
            })
        )
        (ok true)))

;; [Previous code remains the same]

;; Governance
(define-map governance-proposals
    uint 
    {
        title: (string-utf8 256),
        description: (string-utf8 1024),
        proposer: principal,
        votes-for: uint,
        votes-against: uint,
        end-height: uint,
        executed: bool
    }
)

;; Enhanced Video struct with description
(define-map videos 
    { video-id: uint }
    {
        creator: principal,
        title: (string-utf8 256),
        description: (string-utf8 1024),
        content-hash: (buff 32),
        price: uint,
        created-at: uint,
        views: uint,
        revenue: uint,
        is-active: bool
    }
)
