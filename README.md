# didactic-avr-asm-timer0-bare-metal
Write OUT 0x25, 0b00000101 and the ATmega328P's Timer1 starts counting. Period.  No includes. No cryptic acronyms. No magic. Just a physical address and a number.  This repository is for those who want to see the naked silicon. No abstraction layers. No clothes.

<a href="https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf">Datasheet atmega328 </a> Page 279
            
             For activate counter need to modify the last 3 bit of register 25 (CS00,CS01 and CS02) with a value more big than 0

<img width="916" height="151" alt="image" src="https://github.com/user-attachments/assets/bf6ac584-2643-4e7b-907e-a48002f4e936" />

<img width="858" height="322" alt="image" src="https://github.com/user-attachments/assets/5e95a0a1-5261-407a-9e14-c5bc13889b3a" />


