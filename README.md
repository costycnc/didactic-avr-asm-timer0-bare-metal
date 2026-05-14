# didactic-avr-asm-timer0-bare-metal
Write OUT 0x25, 0b00000101 and the ATmega328P's Timer1 starts counting. Period.  No includes. No cryptic acronyms. No magic. Just a physical address and a number.  This repository is for those who want to see the naked silicon. No abstraction layers. No clothes.

<a href="https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf">Datasheet atmega328 </a> 
            
             Page 279
             For Timer0 need to modify the last 3 bit of register 0x25 (CS00,CS01 and CS02) with a value more big than 0

             

<img width="916" height="151" alt="image" src="https://github.com/user-attachments/assets/bf6ac584-2643-4e7b-907e-a48002f4e936" />

<a href="https://ww1.microchip.com/downloads/en/DeviceDoc/Atmel-7810-Automotive-Microcontrollers-ATmega328P_Datasheet.pdf">Datasheet atmega328 </a>

             Page 87
             The table values to set TIMER0

<img width="858" height="322" alt="image" src="https://github.com/user-attachments/assets/5e95a0a1-5261-407a-9e14-c5bc13889b3a" />

            So ... for most last value of Timer0 CS00=1  CS01=0 and CS02=1 so 0b00000101 in binary
            But you can't write this value directly to register ... so need to use a temporary register
            Will use temporary register R16 ... so will upload this value to r16
            
            Ldi r16,0b00000101

            And now can put value of r16 to reg 0x25 (TIMER0) ... so OUT 0x25,r16 

<img width="898" height="61" alt="image" src="https://github.com/user-attachments/assets/f524179c-0283-4f4a-bb19-7694f89aef36" />

           If upload the code to arduino the register 0x26 alias TCNT0 will begin incremented untill arrive a 255 

<img width="882" height="90" alt="image" src="https://github.com/user-attachments/assets/396bda6e-64c1-4cad-bbaf-6a36e32b4eb2" />

           When arrive a 255 begin 0 and register 0x15 bit0 alias TOV0 is set to 1 and counter begin count again
           So if check this bit continuous we know when bit is set 1 , and can use this information for measure time
           After TOV0 is set to 1 will set again to 0 to know when arrive again to 1
           In this mode any 16000000/1024/256 will have a tick ,than can control a function can make a blink
           

            
            


