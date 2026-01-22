
; THIS LOADER KEEPS ASIC PAGED IN AT 4000. USEFUL IF WE DO NOT HAVE A BIG GAME
; AND WANT TO KEEP THE ASIC PAGED IN ALL THE TIME FOR CONVENIENCE
; ----------------------------------------------------------------------------

; SAVE "OHMUMMY.BIN",b,&0900,&01F0,&0980

; AMSDOS HEADER
;Byte 00- User number (value from 0 to 15 or #E5 for deleted entries)
;Byte 01 to 08- filename (fill unused char with spaces)
;Byte 09 to 11- Extension (fill unused char with spaces)
;Byte 16- first block (tape only)
;Byte 17- first block (tape only)
;Byte 18- file type (0-basic 1-protected 2-binary)
;Byte 21 and 22- loading address LSB first
;Byte 23- first block (tape only?)
;Byte 24 and 25- file length LSB first
;Byte 26 and 27- execution address for machine code program LSB first
;Byte 64 and 66- 24 bits file length LSB first. Just a copy, not used!
;Byte 67 and 68- checksum for bytes 00-66 stored LSB first
;Byte 69 to 127- undefined content, free to use

;To calculate the checksum just add all bytes from 00 up to and including byte 66 together.

;This is only a summary. All details are in Firmware Guide chapter 9, page 4. 

;iscassetteloader equ 1 ; NEEDS TO BE HERE, RASM DOESN'T PROCESS THESE BEFORE COMPILATION


kl_rom_walk   equ &bccb

cas_in_open   equ &BC77
cas_in_direct equ &BC83
cas_in_close  equ &BC7A
cas_noisy     equ &BC6B

scr_set_mode    equ &bc0e
scr_set_border  equ &bc38

org &0900

nolist

; HEADER
defb 0           ; 0 - User number (value from 0 to 15 or #E5 for deleted entries)
defb "OHMUMMY "  ; 1-8 - filename (fill unused char with spaces)
defb "BIN"       ; 9-11 - Extension (fill unused char with spaces)
defb 0           ; 12
defb 0           ; 13
defb 0           ; 14
defb 0           ; 15
defb 0           ; 16 - first block (tape only)
defb 0           ; 17 - first block (tape only)
defb 2           ; 18 - file type (0 basic 1 protected 2 binary)
defw 0           ; 19-20
defw &0980       ; 21-22 - loading address LSB first
defb 0           ; 23 - first block (tape only?)
defw &0133       ; 24-25 - file length LSB first excluding header record
defw &0980       ; 26-27 - execution address for machine code program LSB first
defw 0           ; 28-29
defw 0           ; 30-31
defw 0           ; 32-33
defw 0           ; 34-35
defw 0           ; 36-37
defw 0           ; 38-39
defw 0           ; 40-41
defw 0           ; 42-43
defw 0           ; 44-45
defw 0           ; 46-47
defw 0           ; 48-49
defw 0           ; 50-51
defw 0           ; 52-53
defw 0           ; 54-55
defw 0           ; 56-57
defw 0           ; 58-59
defw 0           ; 60-61
defw 0           ; 62-63
defw &0133       ; 64 - bits file length LSB first. Just a copy, not used! 
defb 0           ; 66 - bits file length LSB first. Just a copy, not used!
defw &0482       ; 67-68 - checksum for bytes 00-66 stored LSB first
defw 0           ; 69
defw 0           ; 71
defw 0           ; 73
defw 0           ; 75
defw 0           ; 77
defw 0           ; 79
defw 0           ; 81
defw 0           ; 83
defw 0           ; 85
defw 0           ; 87
defw 0           ; 89
defw 0           ; 91
defw 0           ; 93
defw 0           ; 95
defw 0           ; 97
defw 0           ; 99
defw 0           ; 101
defw 0           ; 103
defw 0           ; 105
defw 0           ; 107
defw 0           ; 109
defw 0           ; 111
defw 0           ; 113
defw 0           ; 115
defw 0           ; 117
defw 0           ; 119
defw 0           ; 121
defw 0           ; 123
defw 0           ; 125
defb 0           ; 127

org &0980

ifdef iscassetteloader
  ld bc,&f610		; cassette motor on
  out (c),c
endif

ifndef iscassetteloader

  ;;------------------------------------------------------------------------
  ;; store the drive number the loader was run from
  ld hl,(&be7d)
  ld a,(hl)                  
  ld (drive+1),a

  ld c,&ff            ; DISABLE ALL ROMS
  call kl_rom_walk    ; ENABLE ROMS - NEED AMSDOS FOR LOADING SCREEN

  ;;------------------------------------------------------------------------
  ;; when AMSDOS is enabled, the drive reverts back to drive 0!
  ;; This will restore the drive number to the drive the loader was run from
  drive: 
    ld a,0
    ld hl,(&be7d)
    ld (hl),a		  

  endif

  ld bc,0             ; SET BORDER
  call scr_set_border
  xor a
  call scr_set_mode   ; SET SCREEN MODE

  ; LOADING SCREEN
  ld hl,picstr
  ld b,picstrl
  ld de,&C000
  ; LOAD FILE
  ld a,1
  call cas_noisy     ; DISABLE LOADING MESSAGES 
  push de
  call cas_in_open
  pop de
  ex de,hl
  call cas_in_direct
  call cas_in_close

  ; LOAD SECONDARY GAME CODE IN 4000
  ld hl,ohmummy1bin
  ld b,gamestrl2
  ld de,&4100
  ; LOAD FILE
  ld a,1
  call cas_noisy     ; DISABLE LOADING MESSAGES 
  push de
  call cas_in_open
  pop de
  ex de,hl
  call cas_in_direct
  call cas_in_close

  ld hl,pens
  ld de,&3FE0
  ld bc,32
  ldir

  ; COPY REMAINDER OF LOADER FUNCTION TO SPARE MEMORY SO WE CAN LOAD REST OF GAME
  ; OTHERWISE WE WILL OVERWRITE OURSELVES

  ld hl,ohmummy2bin
  ld de,&0040
  ld bc,&0100
  ldir
  ld hl,&0040 + 12+17; + 12;+32
  jp (hl) ; FINISH OFF LOADING REST OF GAME

pens: 
  ;   RB-G LEN 32
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
  ;defw &0000 ; BORDER

picstr:
  defb "LOADSCR.BIN"
picstrl equ 11

ohmummy1bin:
  defb "OHMUMMY1.BIN"
gamestrl2 equ 12

; START OF LOADER TO FINISH LOADING GAME

ohmummy2bin:
  defb "OHMUMMY2.BIN" ; LEN 12 - NAME OF FILE
  
;ohmummy3bin:
;  defb "OHMUMMY3.BIN" ; LEN 12 - NAME OF FILE

;; sequence to unlock asic LEN 17
sequence: defb &ff,&00,&ff,&77,&b3,&51,&a8,&d4,&62,&39,&9c,&46,&2b,&15,&8a,&cd,&ee

; STACK IS AT &BFFF
remainderloadercode:
  ; COPY FIRST GAME CODE TO 0100
  ld hl,&4100
  ld de,&0100
  ld bc,&3EDF ; LEAVE ROOM FOR PALETTE AT 3FE0. IT'S HERE BECAUSE WE CAN'T FIT IN IT OUR RELOCATED CODE BETWEEN 0040 and 0100
  ldir

  ; LOAD SECOND GAME CODE TO 4100
  ld hl,&0040 ; NAME
  ld b,12     ; STR LEN
  ld de,&4100
  ld a,1
  call cas_noisy     ; DISABLE LOADING MESSAGES 
  push de
  call cas_in_open
  pop de
  ex de,hl
  call cas_in_direct
  call cas_in_close

  di
  ; SET INTERRUPT FUNCTION - STOPS BASIC RE-LOCKING ASIC
  ld a,&c9 ;(RET)
  ld hl,&0038
  ld (hl),a
  ld b,&bc
  ld hl,&0040+12;sequence
  ld e,17
  seq:
    ld a,(hl)
    out (c),a
    inc hl
    dec e
  jr nz,seq
  ei

  ld bc,&7fb8 ; PAGE IN PLUS REGISTERS
  out (c),c   ; ASIC RAMBANK AT 4000-7FFF

  ; LOAD PALETTE INTO ASIC
  ld de,&6400
  ld hl,&3FE0;&0040+12+17
  ld bc,32
  ldir

  ld bc,&7fa0 ; PAGE OUT PLUS REGISTERS
  out (c),c

  ; COPY SCREEN MEMORY TO 8000
  ; OVERWRITES FIRMWARE!!
  ld hl,&C000
  ld de,&8000
  ld bc,&4000
  ldir

  ; MOVE SCREEN MEMORY TO 8000-BFFF
  ld hl,0        ;; get scroll offset
  ld a,h
  or &20                   ;; This defines the "base" of the screen in 16k units.
  ld h,a
  ld bc,&bc0c              ;; select CRTC register 12
  out (c),c
  inc b                    ;; B = &BD
  out (c),h                ;; write to CRTC register 12
  dec b
  inc c                    ;; BC = &BC0D
  out (c),c                ;; select CRTC register 13
  inc b
  out (c),l                ;; write to CRTC register 13 

  ; COPY GAME CODE AT 4100 TO C100
  ld hl,&4100
  ld de,&C100
  ld bc,&3E00
  ldir

  ; OO-IULMM
  ; disable upper and lower rom
  ;ld bc,&7f00+%10001100
  ;out (c),c

  ; NEED TO SET STACK HERE FIT IN 100 
  ld hl,&C000
  ld (hl),0
  ld de,&C001
  ld bc,&00FF
  ldir
  ld sp,&C100

;ld a,"3"
;ld (&0047),a ; CHANGE FILENAME
;  ; LOAD THIRD GAME CODE TO 4000
;  ld hl,&0040 ; NAME
;  ld b,12     ; STR LEN
;  ld de,&4000
;  ld a,1
;  call cas_noisy     ; DISABLE LOADING MESSAGES 
;  push de
;  call cas_in_open
;  pop de
;  ex de,hl
;  call cas_in_direct
;  call cas_in_close

ifdef iscassetteloader
  ld bc,&f600		; cassette motor off
  out (c),c
endif

  jp &0100 ;&C100  ; LAUNCH GAME

; NOTE!!!!!!!!
; WINAPE'S SAVE DIRECT FUNCTION CREATES A FAULTY LOADER
; USE BASIC'S SAVE FUNCTION INSTEAD
; SAVE "HARRIER.BIN",B,&0900,&01D0,&0980

;ifdef iscassetteloader
;SAVE "HARRIER.BIN",&0900,&01D0,&0980
;endif