use16
org 0x7c00


start:
    jmp main

fibonacci:
    mov     cx, ax
    xor     ax, ax
    mov     bx, 0x01

    fibonacciloop:
        cmp     cx, 0x00
        je      done
        mov     dx, ax
        mov     ax, bx
        add     bx, dx
        dec     cx
        jmp     fibonacciloop

done:
    ret

readchar:
    mov     ah, 0x00
    int     0x16
    ret

readline:
    call    readchar
    cmp     al, 0x0d
    je      eof

    stosb
    call    printchar
    jmp     readline

    eof:
        mov al, 0x00
        stosb
        ret

printchar:
    mov     ah, 0x0e
    int     0x10
    ret

printline:
    lodsb
    or      al, al
    jz      done
    call    printchar
    jmp     printline

strlen:
    xor     bx, bx

    strlenloop:
        lodsb
        or      al, al
        jz      strlendone
        inc     bx
        jmp     strlenloop

    strlendone:
        mov ax, bx
        ret


main:
    xor     ax, ax
    mov     ds, ax
    mov     es, ax

    mov     si, welcome
    call    printline

    mov     si, prompt
    call    printline

    mov     di, number
    call    readline

    cli
    hang


prompt  db  "Which fibonacci number do you want to compute?", 0x0d, 0x0a, 0
welcome db  "Welcome to fiboot, the fibonacci boot loader!", 0x0d, 0x0a, 0

number  resb    16

times 510-($-$$) db 0

dw 0xAA55  ; boot signature
