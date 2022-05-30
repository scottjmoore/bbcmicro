OSWRCH:            equ $ffee

lxy macro
    ldx #<\1
    ldy #>\1
endm

PrintStringPtr:     equ $70
PalettePtr:         equ $72

    org $2000

Start:
    lda #2
    jsr SetMode

.Loop:
    ldx TextColour
    inx
    txa
    and #%00000111
    sta TextColour
    jsr SetTextColour
    cmp #0
    bne .SkipBackgroundColour
    ldx BackgroundColour
    inx
    txa
    and #%00000111
    sta BackgroundColour
    ora #%10000000
    jsr SetTextColour

.SkipBackgroundColour:
    lxy Message
    jsr PrintString
    jmp .Loop

    rts

TextColour:
    db $00

BackgroundColour:
    db $00

SetTextColour:
    pha
    lda #17
    jsr OSWRCH
    pla 
    jsr OSWRCH
    rts

SetMode:
    pha
    lda #22
    jsr OSWRCH
    pla
    jsr OSWRCH
    rts

PrintString:
    txa 
    sta PrintStringPtr
    tya 
    sta PrintStringPtr + 1
    ldy #0
.Loop:
    lda (PrintStringPtr),y
    beq PrintStringDone
    jsr OSWRCH
    iny 
    jmp .Loop
PrintStringDone:
    rts 

Message:
    db  "abcdefghijklmnopqrst",0
    ; db  "*** Hello World! ***",0

