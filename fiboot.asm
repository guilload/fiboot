use16
org 0x7c00


start:
    jmp main

fibonacci:
    mov     cx, ax                  ; n
    mov     ax, 0x00                ; a = fib(0) = 0
    mov     bx, 0x01                ; b = fib(1) = 1

    fibonacciloop:
        cmp     cx, 0x00            ; if n == 0, we're done
        je      done
        mov     dx, ax              ; save current value in dx
        mov     ax, bx              ; a = b
        add     bx, dx              ; b = a + b
        dec     cx                  ; n--
        jmp     fibonacciloop

done:
    ret

readchar:
    mov     ah, 0x00
    int     0x16
    ret

readline:
    call    readchar
    cmp     al, 0x0d                ; carriage return >> end of line
    je      eol

    stosb
    call    printchar
    jmp     readline

    eol:
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

ascii2int:
    mov     ax, 0x00
    mov     bx, 0x00                ; bx = 0, accumulator
    mov     cl, 0x0a                ; cx = 10, multiplier

    ascii2intloop:
        lodsb                       ; al = char
        or      al, al
        jz      ascii2intdone       ; if null char, we're done

        sub     ax, '0'             ; char to int
        mov     dx, ax              ; dx = int

        mov     ax, bx              ; ax = bx (accumulator)
        mul     cl                  ; ax = ax * cx = ax * 10

        add     dx, ax
        mov     bx, dx

        jmp     ascii2intloop

    ascii2intdone:
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

    mov     si, number
    call    ascii2int

    call    fibonacci

    cli
    hlt


prompt  db  "Which fibonacci number do you want to compute?", 0x0d, 0x0a, 0
welcome db  "Welcome to fiboot, the fibonacci boot loader!", 0x0d, 0x0a, 0

number  resb    16

times 510-($-$$) db 0

dw 0xAA55  ; boot signature
