.org 0         ; Reset vector at address 0
rjmp init      ; Jump to init routine
.org 0x60      ; Code section start
init:
ldi r16,0b00000101       ; Prescaler = 1024
out 0x25,r16        ; Directly write to TCCR0B — starts TIMER0 (rarely shown this way!)
sbi 4,5             ; Set D13 (onboard LED) as output
loop:
in r16, 0x15        ; Read TIFR0 (Timer Overflow Flag Register)
sbrc r16, 0         ; Skip next if overflow flag is clear
sbi 3,5             ; Toggle LED on PORTB5 (D13)
ldi r16,1
out 0x15, r16       ; Clear overflow flag by writing 1
rjmp loop           ; Repeat forever
