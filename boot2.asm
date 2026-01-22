;; This is example boot code for the absolute example.

;; this code is stored at page 0, offset 0, and will be executed when the 
;; cart is started
org &0000
jp start

;; 0,GREEN,RED,BLUE,
palette:
  defw &0786; TRANS
  defw &0796 ; RED
  defw &08a6 ; BLACK
  defw &0665 ; BROWN  
  defw &08b6 ; RED
  defw &0fff ; BLUE
  defw &0ff9 ; YELLOW 
  defw &09e7 ; ORANGE
  defw &0af7 ; PURPLE
  defw &0bf8 ; LIGHT BLUE
  defw &09d7 ; MED BLUE
  defw &0675 ; SEA GREEN
  defw &0896 ; DARK GREEN
  defw &08a7 ; BORDER
  defw &0cf8 ; BORDER
  defw &08c6 ; RED
  defw &0000 ; BORDER

crtc_data: defb &3f,&28,&2e,&8e,&26,&00,&19,&1e,&00,&07,&00,&00,&30,&00,&c0,&00
end_crtc_data:

;; sequence to unlock asic
sequence: defb &ff,&00,&ff,&77,&b3,&51,&a8,&d4,&62,&39,&9c,&46,&2b,&15,&8a,&cd,&ee

boot_game:
  ;; OO-IULMM
  ;; disable upper and lower rom
  ld bc,&7f00+%10001100
  out (c),c
 
  jp &0100;&C100 ;7a00		;; and execute game
end_boot_game:

start:
di					;; disable interrupts
im 1					;; set interrupt mode 1
ld bc,&f782			;; setup initial PPI port directions
out (c),c
ld bc,&f400			;; set initial PPI port A (AY)
out (c),c
ld bc,&f600			;; set initial PPI port C (AY direction)
out (c),c

ld bc,&7fc0			;; set initial RAM configuration
out (c),c

;; unlock ASIC so we can access ASIC registers
ld b,&bc
ld hl,sequence
ld e,17
seq:
ld a,(hl)
out (c),a
inc hl
dec e
jr nz,seq

;; set initial CRTC settings (screen dimensions etc)
ld hl,end_crtc_data
ld bc,&bc0f
crtc_loop:
out (c),c
dec hl
ld a,(hl)
inc b
out (c),a
dec b
dec c
jp p,crtc_loop


  ; MOVE SCREEN MEMORY TO 8000-BFFF
  ld hl,0        ;; get scroll offset
  ld a,h
  or &20                    ;; This defines the "base" of the screen in 16k units.
                            ;; &00 -> screen uses &0000-&3fff
                            ;; &10 -> screen uses &4000-&7fff
                            ;; &20 -> screen uses &8000-&bfff
                            ;; &30 -> screen uses &c000-&ffff
  ld h,a
  ld bc,&bc0c                ;; select CRTC register 12
  out (c),c
  inc b                    ;; B = &BD
  out (c),h                ;; write to CRTC register 12
  dec b
  inc c                    ;; BC = &BC0D
  out (c),c                ;; select CRTC register 13
  inc b
  out (c),l                ;; write to CRTC register 13 

;; select page screen is in.
ld bc,&df81
out (c),c
ld hl,&c000		;; copy from ROM
ld de,&8000		;; to RAM &8000
ld bc,&4000
ldir

; SET STACK POINTER
ld sp,&C100;8000
; SET INTERRUPT FUNCTION?
;ld a,&c9 ;(RET)
;ld hl,&0038
;ld (hl),a

  ld bc,&7fb8 ; PAGE IN PLUS REGISTERS
  out (c),c   ; ASIC RAMBANK AT 4000-7FF

  ld de,&6400
  ld hl,palette
  ld bc,34
  ldir

  ld bc,&7fa0 ; PAGE OUT PLUS REGISTERS
  out (c),c

;; COPY BANKS OF CODE TO RAM
ld bc,&df82
out (c),c
ld hl,&c000		        ;; copy from ROM
ld de,&0100;&C100		;; to RAM under ROM
ld bc,&3F00;&3E00     
ldir

;; COPY BANKS OF CODE TO RAM
ld bc,&df83
out (c),c
ld hl,&c000		        ;; copy from ROM
ld de,&C100;&0100		;; to RAM under ROM
ld bc,&3F00             ;; LEAVE 100 FOR STACK
ldir

;; COPY BANKS OF CODE TO RAM
ld bc,&df84
out (c),c
ld hl,&c000		        ;; copy from ROM
ld de,&4000	         	;; to RAM under ROM
ld bc,&4000             
ldir


;ld sp,&C100
;; COPY BOOT CODE TO RAM
;; BOOT CODE MUST NOT BE IN UPPER OR LOWER ROM AREAS
;; ALSO MUST NOT BE OVERWRITTEN BY ABOVE GAME CODE
ld bc,&df80
out (c),c
ld hl,boot_game
ld de,&7f00
ld bc,end_boot_game-boot_game
ldir

;; JUMP TO BOOT FUNCTION
ld bc,&df80 ; SET MEMORY BACK TO STANDARD
out (c),c
jp &7f00

;end start
