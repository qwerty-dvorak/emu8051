.area CSEG (ABS)
.org 0x0000           ; Start at address 0

start:
    mov a, #0x50      ; Load 0x50 into Accumulator (A)
    mov r0, #0x30     ; Load 0x30 into Register R0
    clr c             ; Clear the Carry flag (no borrow initially)
    setb c;
    subb a, r0        ; First subtraction: A = A - R0 - C (C = 0)
                       ; Result: A = 0x50 - 0x30 = 0x20
    mov r1, a         ; Store result (0x20) in R1

end:
    sjmp end          ; Infinite loop to end the program
