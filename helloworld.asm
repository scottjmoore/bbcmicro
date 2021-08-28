OSWRCH:            equ $ffee

lxy macro
    ldx #<\1
    ldy #>\1
endm

PrintStringPtr:   equ $70

    org $3000

Start:
    lda #22
    jsr OSWRCH
    lda #6
    jsr OSWRCH
    lxy Message
    jsr PrintString
    rts

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

Message:
    db  "Hello World! With More Text!",13,10,255