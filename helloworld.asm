OSWRCH:            equ $ffee

lxy macro
    ldx #<\1
    ldy #>\1
endm

PrintStringPtr:   equ $70

    org $2000

Start:
    lda #22
    jsr OSWRCH
    lda #2
    jsr OSWRCH
Loop:
    ldx TextColour
    inx
    txa
    and #%00000111
    sta TextColour
    jsr SetTextColour
    cmp #0
    bne SkipBackgroundColour
    ldx BackgroundColour
    inx
    txa
    and #%00000111
    sta BackgroundColour
    ora #%10000000
    jsr SetTextColour

SkipBackgroundColour:
    lxy Message
    jsr PrintString
    jmp Loop

    rts

TextColour:
    db $00

BackgroundColour:
    db $00

PrintString:
    txa
    sta PrintStringPtr
    tya
    sta PrintStringPtr + 1
    ldy #0
PrintStringLoop:
    lda (PrintStringPtr),y
    cmp #255
    beq PrintStringDone
    jsr OSWRCH
    iny
    jmp PrintStringLoop
PrintStringDone:
    rts

SetTextColour:
    pha
    lda #17
    jsr OSWRCH
    pla 
    jsr OSWRCH
    rts

Message:
    db  "*** Hello World ***",13,10,255
