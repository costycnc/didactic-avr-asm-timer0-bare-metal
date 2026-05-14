
## 🔧 Didactic-avr-asm-timer0-bare-metal

Write `OUT 0x25, 0b00000101` and the ATmega328P's Timer0 starts counting. Period.

No includes. No cryptic acronyms. No magic. Just a physical address and a number.

This repository is for those who want to see the naked silicon. No abstraction layers. No clothes.

---

## 📘 Datasheet

<a href="https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf">ATmega328P Datasheet</a>

---

## 🔧 Timer0 Setup (Step by Step)

### Page 279
To start Timer0, you need to change the last 3 bits of register `0x25` (these bits are called CS00, CS01, and CS02).  
Set them to any value **greater than 0**.

<img width="787" height="23" alt="image" src="https://github.com/user-attachments/assets/238fbb6d-9afa-4d23-9949-b6f5097a1970" />

---

### Page 87 — Table of values for Timer0 prescaler

<img width="858" height="322" alt="image" src="https://github.com/user-attachments/assets/5e95a0a1-5261-407a-9e14-c5bc13889b3a" />

---

## ⚙️ Example: Setting the value `0b00000101`

We want:
- `CS00 = 1`
- `CS01 = 0`
- `CS02 = 1`

That gives us the binary number: `0b00000101`

### But you cannot write this value directly to the register.
You must use a **temporary register**.

We will use `R16` as temporary storage.

---

## 📝 Assembly Code

```assembly
; Load the binary value into temporary register R16
ldi r16, 0b00000101

; Output the value from R16 to Timer0 control register at address 0x25
out 0x25, r16
```

<img width="887" height="28" alt="image" src="https://github.com/user-attachments/assets/dc84e6fe-6058-40f5-9839-5e814754501f" />


---

## ⏱️ What happens after uploading to Arduino?

- Register `0x26` (also called `TCNT0`) starts counting from 0 up to 255.
- Every time it reaches 255, it resets to 0.
- At that moment, bit 0 of register `0x15` (also called `TOV0`) becomes `1`.

<img width="882" height="90" alt="image" src="https://github.com/user-attachments/assets/396bda6e-64c1-4cad-bbaf-6a36e32b4eb2" />

---

## 🔁 Using this to measure time

If you keep checking bit 0 of register `0x15`, you will know when it becomes `1`.  
That means Timer0 has reached 255 and restarted.

After `TOV0` becomes `1`, you must set it back to `0` manually to detect the next overflow.

---

## 🧮 Calculation (for 16 MHz clock)

With prescaler value `0b00000101` (which means divide by 1024):

```
16,000,000 Hz / 1024 = 15,625 Hz
15,625 Hz / 256 = 61.035 Hz
```

So you get a tick every:

```
1 / 61.035 ≈ 0.01638 seconds ≈ 16.38 milliseconds
```

## 🧠 Why this matters

You are controlling the hardware directly.  
No libraries. No hidden code. Just you and the silicon.

This is how microcontrollers work at the lowest level.



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


---

## 💡 Practical Use - Explained for Beginners

Every time Timer0 overflows (every ~16 ms), the code checks and counts.  
After 32 overflows, the LED toggles (turns on or off).

### How the blink speed is calculated:


                    Clock speed: 16,000,000 Hz
                    Prescaler: 1024
                    Timer max value: 256
                    
                    Overflow frequency = 16,000,000 / 1024 / 256 = 61 Hz
                    One overflow = 1 / 61 = 0.01638 seconds ≈ 16.38 ms
                    
                    32 overflows = 32 × 16.38 ms = 524 ms ≈ 0.5 seconds


### What each register means:

| Register | Address | Name | Purpose |
|----------|---------|------|---------|
| TCCR0B | 0x25 | Timer0 Control Register B | Sets the prescaler (clock speed divider) |
| TIFR0 | 0x15 | Timer0 Interrupt Flag Register | Tells you when Timer0 overflows |
| PINB | 0x03 | Port B Input Pins | Writing here toggles the LED |
| DDRB | 0x04 | Port B Data Direction Register | Sets pin as output (1) or input (0) |

### This is "bare metal" because:
- No `delay()` function
- No `pinMode()` or `digitalWrite()`
- No Arduino libraries at all
- Just you, the CPU registers, and the datasheet
           

## ✨ Test it online — No installation required

You don’t need to install Arduino IDE, compilers, or drivers.

You can **assemble and upload this exact code from your browser**:

👉 **[costycnc.github.io/avr-compiler-js](https://costycnc.github.io/avr-compiler-js)** 👈

### How it works:

1. Open the link above
2. Copy the assembly code from this README
3. Paste it into the online editor
4. Click **"Assemble"** (the site generates the HEX file in your browser — no server, no magic)
5. Connect your Arduino UNO (or Nano) via USB
6. Click the **"Upload"** button (it uses Web Serial API)
7. Select the correct COM port / USB port
8. Watch the LED on pin 13 (PB5) blink **immediately**

No IDE configuration.  
No board selection.  
No drivers to install.  
Just your code and the naked silicon.

### Compare for yourself:

| Feature | Arduino IDE | costycnc.github.io/avr-compiler-js |
|---------|-------------|-------------------------------------|
| Installation | Yes (IDE + drivers) | **None** — works in the browser |
| Configuration | Select board, port, chip | **Nothing** — plug and go |
| First LED code | `setup()`, `loop()`, `digitalWrite()` | `sbi 0x3, 5` — the LED turns on/off (toggle)|
| Libraries | Many, but often hide everything | **None** — you see the actual registers |
| Learning curve | Softer, but less transparent | More direct — you learn how it really works |

**You see the registers. You touch the silicon. No magic. No excuses.**

Now go write `OUT 0x25, 0b00000101` and watch Timer0 count — live, in your browser, on real hardware.
         
            


