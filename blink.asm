                .org 0
                rjmp start
                .org 0x60
                
                start:
                  ; Set PIN D13 (LED onboard) as output pin
                  sbi 4, 5              ; 4 = DDRB, bit 5 = PB5 (Arduino pin 13)
                  
                  ; Set up Timer0 with prescaler 1024
                  ldi r16, 0b00000101
                  out 0x25, r16         ; 0x25 = TCCR0B (Timer0 control register)
                
                main_loop1:
                  ldi r17, 32           ; Blink speed: 16,000,000 / 1024 / 256 * 32 = ~0.5 seconds
                
                main_loop:
                  ; Check if TOV0 flag is set
                  in r16, 0x15          ; 0x15 = TIFR0 (Timer0 interrupt flag register)
                  sbrs r16, 0           ; Skip next instruction if bit 0 (TOV0) = 1
                  rjmp main_loop        ; If not set, keep checking
                
                  ; Clear TOV0 flag by writing 1 to bit 0
                  ldi r16, 0b00000001
                  out 0x15, r16
                
                  dec r17               ; Decrease counter
                  brne main_loop        ; If not zero, wait for next overflow
                
                  ; TOV0 has overflowed 32 times → toggle LED on PB5
                  sbi 0x03, 5           ; 0x03 = PINB (toggle bit 5 = PB5)
                  rjmp main_loop1       ; Reset counter and repeat
