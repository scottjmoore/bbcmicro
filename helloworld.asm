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
    jsr SetPalette

.Loop:
    ldx TextColour
    inx
    txa
    and #%00001111
    sta TextColour
    jsr SetTextColour
    cmp #0
    bne .SkipBackgroundColour
    ldx BackgroundColour
    inx
    txa
    and #%00001111
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

SetPalette:
    lda #<Palette
    sta PalettePtr
    lda #>Palette
    sta PalettePtr+1

    ldx #0
    ldy #0
.Loop:
    lda #19
    jsr OSWRCH
    lda #0
    jsr OSWRCH
    txa 
    jsr OSWRCH
    lda (PalettePtr),y
    jsr OSWRCH
    iny 
    lda (PalettePtr),y
    jsr OSWRCH
    iny 
    lda (PalettePtr),y
    jsr OSWRCH
    iny 
    inx 
    cpx #16
    bne .Loop

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

Palette:
    db 0,0,0
    db 64,64,64
    db 128,128,128
    db 255,255,255
    db 32,0,0
    db 64,0,0
    db 128,0,0
    db 255,0,0
    db 0,32,0
    db 0,64,0
    db 0,128,0
    db 0,255,0
    db 0,0,32
    db 0,0,64
    db 0,0,128
    db 0,0,255

Message:
    db  "abcdefghijklmnopqrst",0
    ; db  "*** Hello World! ***",0

