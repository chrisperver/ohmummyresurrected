ifndef ISCART
  ;read "buildworld2.asm"    ; CODE 4000-7FFF
  ; TEST OUR OWN ROUTINES IN THE MAIN PROGRAM
  read "AMSTRADFONT6.asm"  ; CODE C100-FF00
endif

org #0100
nolist

; JUMP TABLE
playsound_all_channelsf equ &C300  ;39
initmusicf equ playsound_all_channelsf + 3
playmusicf equ initmusicf + 3
playsound_a equ playmusicf + 3
playsound_b equ playsound_a + 3
playsound_c equ playsound_b + 3
initsoundf equ playsound_c + 3
docleansweepnoise equ initsoundf + 3
dolazerboltnoise equ docleansweepnoise + 3
dodiednoise equ dolazerboltnoise + 3
setupplussprites equ dodiednoise + 3
hideallplussprites equ setupplussprites + 3
moveplussprite2 equ hideallplussprites + 3
updateplayersprite equ moveplussprite2 + 3
updateplayer2sprite equ updateplayersprite + 3
updatemummysprite equ updateplayer2sprite + 3
drawmummyspritenomovement equ updatemummysprite + 3
hideplussprite equ drawmummyspritenomovement + 3
playgameovermusic equ hideplussprite + 3

; IMAGES
image_torch       equ playgameovermusic + 3
image_key         equ image_torch + 2
image_sarcophagus equ image_key + 2
image_scroll      equ image_sarcophagus + 2
image_treasure    equ image_scroll + 2
image_ankh        equ image_treasure + 2
image_elixir      equ image_ankh + 2

screenptrtable    equ &F700
my_data_objectmap equ &F900

; JUMP TABLE FOR AMSTRADFONT4

jp start
jp my_txt_set_window
jp my_txt_clear_window
jp txt_set_paper
jp txt_set_pen
jp scr_next_line_hl
jp getscreenaddress
jp mygetobjectmaplocationfromde
jp locatetextf
jp writelineplainf
jp drawbox
jp scr_set_ink
jp dodrawsprite
jp getobjectmaplocationfromde

defb "Oh Mummy Resurrected - CPSoft 09.11.2025"

km_wait_key_id:
  call mc_wait_flyback
  call km_read_key_id
  jr nc,km_wait_key_id
ret

km_read_key_id:
;  call read_matrix                 ; MATRIX READ VIA INTERRUPT EVERY 50TH SECOND
  ld hl,matrix_buffer+10
  ld b,10
  doloopy2:
    dec hl
    ld a,(hl)
	cp 255                          ; FIND FIRST KEY IN BUFFER THAT HAS BEEN PRESSED (NOT 255)
	jr z,donextline2
	
    ; WE FOUND A KEY	
    ld c,0	
	bit 0,a
	jr z,foundbit
	inc c
	bit 1,a
	jr z,foundbit
	inc c
	bit 2,a
	jr z,foundbit
	inc c
	bit 3,a
	jr z,foundbit
	inc c
	bit 4,a
	jr z,foundbit
	inc c
	bit 5,a
	jr z,foundbit
	inc c
	bit 6,a
	jr z,foundbit
	inc c
	bit 7,a
	jr z,foundbit
	
	donextline2:
  djnz doloopy2
  xor a ; CLEAR CARRY
ret

foundbit:
  scf
ret

km_read_key:
;  call read_matrix                 ; MATRIX READ VIA INTERRUPT EVERY 50TH SECOND
  ld hl,matrix_buffer+9
  ld b,10
  doloopy:
    ld a,(hl)
	cp 255                          ; FIND FIRST KEY IN BUFFER THAT HAS BEEN PRESSED (NOT 255)
	jr z,donextline
	
    ; WE FOUND A KEY	
    ld c,0	
	bit 0,a
	jr z,returncharfromkeymap
	inc c
	bit 1,a
	jr z,returncharfromkeymap
	inc c
	bit 2,a
	jr z,returncharfromkeymap
	inc c
	bit 3,a
	jr z,returncharfromkeymap
	inc c
	bit 4,a
	jr z,returncharfromkeymap
	inc c
	bit 5,a
	jr z,returncharfromkeymap
	inc c
	bit 6,a
	jr z,returncharfromkeymap
	inc c
	bit 7,a
	jr z,returncharfromkeymap
	
	donextline:
	dec hl
  djnz doloopy
  xor a ; CLEAR CARRY
ret

returncharfromkeymap:
  ld hl,keyboard_translation_tables
  ld a,b
  ld b,0
  add hl,bc ; MOVE HORIZONTAL BIT COLUMN IN DATA TABLE
  push hl
  ld hl,convertsinglestotens
  ld b,0
  ld c,a
  dec c     ; START FROM LINE 0 NOT 1
  add hl,bc ; MOVE VERTICAL LINE IN TABLE
  ld c,(hl)
  pop hl
  add hl,bc
  ;xor a
  ;ld (keyrelease),a                 ; CLEAR KEYRELEASE BUFFER
  ld a,1                             ; RECORD THAT KEY HAS BEEN PRESSED
  ld (keyrelease),a
  ld a,(hl) ; GET KEYPRESS
  ld (charbuffer),a                 ; LOAD CHARACTER INTO BUFFER SO WE CAN CHECK IT EVEN AFTER PLAYER RELEASES KEY
  scf       ; SET CARRY
ret

convertsinglestotens: defb 0,8,16,24,32,40,48,56,64,72,80

; =============================
; KEYBOARD
; -----------------------------

;;+------------------------------------------------------
;; keyboard translation tables
;Translates keyboard row/columns to key values

;Normal key table

;;----------------------------------------------------------
keyboard_translation_tables:      ;{{Addr=$1eef Data Calls/jump count 0 Data use count 1}}
     ; BIT  0,  1,  2,  3,  4,  5,  6,  7 
		db "u","r","d","9","6","3",10, "."  ; 0 CURSOR UP, CURSOR RIGHT, CURSOR DOWN, f9, f6, f3, Enter, f.
		db "l","c","7","8","5","1","2","0"  ; 1 CURSOR LEFT, COPY, f7, f8, f5, f1, f2, f0
		db "c","[",13 ,"]","4","s",&5C,"c"  ; 2 CLEAR, [, RETURN, ], f4, SHIFT, \ (&5C), CTRL
		db "^","-","@","P",";",":","/",","  ; 3 £,=,BAR,P,;,colon,/,COMMA
		db "0","9","O","I","L","K","M","."  ; 4 0,9,O,I,L,K,M,DOT
		db "8","7","U","Y","H","J","N"," "  ; 5 8,7,U,Y,H,J,N,SPACE
		db "6","5","R","T","G","F","B","V"  ; 6 6,5,R,T,G,F,B,V
		db "4","3","E","W","S","D","C","X"  ; 7 4,3,E,W,S,D,C,X
		db "1","2","e","Q","t","A","c","Z"  ; 8 1,2,ESC,Q,TAB,A,CAPS,Z
		db "u","d","l","r","f","g","h",&7f  ; 9 UP, DOWN, LEFT, RIGHT, FIRE 1, FIRE 2, UNUSED, DELETE
end_keyboard_translation_tables:

read_matrix:
  ;call waitvsync
  ; WAIT FLYBACK
  ld b,&f5
  v1b2:
  in a,(c)
  rra
  jr nc,v1b2

keyscan:
        ;di              ;1 ##%%## C P C   VERSION ##%%##
        ld hl,matrix_buffer    ;3
        ld bc,#f782     ;3
        out (c),c       ;4
        ld bc,#f40e     ;3
        ld e,b          ;1
        out (c),c       ;4
        ld bc,#f6c0     ;3
        ld d,b          ;1
        out (c),c       ;4
        ld c,0          ;2
        out (c),c       ;4
        ld bc,#f792     ;3
        out (c),c       ;4
        ld a,#40        ;2
        ld c,#4a        ;2 44
loopa:  ld b,d          ;1
        out (c),a       ;4 select line
        ld b,e          ;1
        ini             ;5 read bits and write into KEYMAP
        inc a           ;1
        cp c            ;1
        jr c,loopa      ;2/3 9*16+1*15=159
        ld bc,#f782     ;3
        out (c),c       ;4
        ;ei              ;1 8 =211 microseconds
        ret

waitanykey:
  call read_matrix
  ld hl,matrix_buffer
  ld b,10
  dokeyloop:
    ld a,(hl)
	cp 255
	ret nz
	inc hl
  djnz dokeyloop
jr waitanykey

unlockasic:
  ; SET INTERRUPT FUNCTION - STOPS BASIC RE-LOCKING ASIC
  di
  ld a,&C9 ; C9 = RET, C3 = JP
  ld hl,&0038
  ld (hl),a

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
  ei 
ret

;; sequence to unlock asic
sequence: defb &ff,&00,&ff,&77,&b3,&51,&a8,&d4,&62,&39,&9c,&46,&2b,&15,&8a,&cd,&ee

start:
  call unlockasic
 
  ; page-in asic registers to &4000-&7fff
  ld bc,&7fb8
  out (c),c
  call setupplussprites
  
  call waitanykey
  call installinterrupt
  
  call enablemusic           ; ENABLE INTERRUPT TO PLAY MUSIC
  call setjoystickbits       ; SET JOYSTICK CONTROL BY DEFAULT

  resetgame:
  call disablefirefootprints ; MAKE SURE FIRE FOOTPRINTS ARE NOT STILL ENABLED AFTER PLAYER DIES
  call my_kl_time_please
  ld (currenttime),hl
  call wipeobjectmaps
  ld a,6
  ld (totalnumberofmummies),a
  xor a
  ld (lastmummyidused),a
  ld (isscoreboardmenu),a
  ld hl,txt_setupscreen
  call printstring
 
  ; GET ARRAY OF PTRS TO FIRST BYTE IN EACH LINE IN SCREEN
  ld de,screenptrtable
  ld hl,scr_addr
  ld b,200
  loopy:
    ex de,hl
    ld (hl),e
	inc hl
	ld (hl),d
	inc hl
	ex de,hl
    call scr_next_line_hl
  djnz loopy
  
  ld hl,txt_title
  call printstring
  ld hl,#0203
  ld de,#2604
  call drawbox
  ld hl,#0408
  ld de,#2409
  call drawbox
  ld hl,#040d
  ld de,#080e
  call drawbox
  ld hl,#0d0d
  ld de,#1b0e
  call drawbox
  ld hl,#200d
  ld de,#240e
  call drawbox
  ld hl,#0412  
  ld de,#2413
  call drawbox
  ld hl,#0417
  ld de,#2418
  call drawbox
  ld hl,#0205
  ld de,#0318
  call drawbox
  ld hl,#0905
  ld de,#0a18
  call drawbox
  ld hl,#1005
  ld de,#1107
  call drawbox
  ld hl,#1705
  ld de,#1807
  call drawbox
  ld hl,#1e05
  ld de,#1f18
  call drawbox
  ld hl,#2505
  ld de,#2618
  call drawbox
  ld hl,#1014
  ld de,#1116
  call drawbox
  ld hl,#1714
  ld de,#1816
  call drawbox
  
  ld hl,#0000
  ld de,#2718
  call my_txt_set_window

  ld hl,#2808
  call uncover_sarcophagus_sarcophagus
  ld hl,#2816
  call fillpatternbox_orangebrown
  ld hl,#2824
  call uncover_sarcophagus_elixir
  ld hl,#2832
  call fillpatternbox_blueblack
  ld hl,#2840
  call uncover_sarcophagus_key
  ld hl,#5008
  call uncover_sarcophagus_treasure
  ld hl,txt_ohmummylargeletters
  call printstring
  
  ld hl,&0f0c
  call locatetextf
  ld (currenttxtpos),hl
  ld hl,txt_resurrected
  call printstring_old
  
  ld hl,#5040
  call fillpatternbox_standard
  ld hl,#7808
  call fillpatternbox_standard
  ld hl,txt_pressctocontinue
  call printstring
  ld hl,#7840
  call uncover_sarcophagus_treasure
  ld hl,#a008
  call uncover_sarcophagus_torch
  ld hl,#a016
  call fillpatternbox_yellowblack
  ld hl,#a024
  call uncover_sarcophagus_scroll
  ld hl,#a032
  call fillpatternbox_mauveblue
  ld hl,#a040
  call uncover_sarcophagus_ankh
  
  ld hl,l860f
  ld (l8645),hl
  call spawn_multiple_mummies
  ld hl,#6828 
  ld (playerspritexy),hl
  ld a,2
  ld (playerspritedirection),a
  
  ; WAIT FOR USER TO PRESS A KEY TO CONTINUE
  waitkeypressloop:
    ; SET SPEED OF GAME FOR WALKING
    ld a,(mummymovementok)        ; WAIT UNTIL INTERRUPT TELLS US TO MOVE MUMMIES
    or a
    jr nz,skipmovemummiesmenua    ; WE HAVE MOVED MUMMIES ALREADY
    ld a,1                        ; MARK THAT WE HAVE COMPLETED DELAY
    ld (mummymovementok),a	
	
	; RECORD WHETHER WE ARE TO MOVE ODD OR EVEN MUMMIES IN THIS LOOP
	; WE NEED TO DO THIS TO KEEP GAME SPEED REGULAR
	
	ld a,(moveoddevenmummies)
	xor 1
	ld (moveoddevenmummies),a
	or a
	jr z,moveevenmummies2
  
    ld b,1                        ; MOVE ODD MUMMIES
	jr domovemummies2
    moveevenmummies2:
    ld b,2                        ; MOVE EVEN MUMMIES
	domovemummies2:
    call domummymovements
    call automoveplayersprite     ; MOVE PLAYER SPRITE 2nd ANIMATION
	
	skipmovemummiesmenua:

	call km_read_key
	jr c,showmainmenu
  jr waitkeypressloop

showmainmenu:
  call hideallplussprites
  ld hl,txt_setuphighscorescreen
  call printstring

  drawmainmenu:
  
  call wipeobjectmaps
  xor a
  ld (lastmummyidused),a
  ld a,6
  ld (totalnumberofmummies),a

  ; ORANGE BORDER
  ld hl,#0803
  ld de,#1f14
  call my_txt_set_window
  call my_txt_clear_window
  xor a
  call txt_set_paper
  ; YELLOW TITLE BACKGROUND
  ld hl,#0c05
  ld de,#1b07
  call my_txt_set_window
  call my_txt_clear_window
  ; YELLOW SCOREBOARD
  ld hl,#0a08
  ld de,#1d12
  call my_txt_set_window
  call my_txt_clear_window
  
  ; DRAW PLAYER 1 SPRITE
  ld de,#2812
  ; DEFAULT SPRITE DIRECTION
  ld a,2
  ld (playerspritedirection),a
  ld a,1
  ld (playerwalkinganimation),a
  ld (playerwalkinganimation2),a
  push de
  ld h,d
  ld l,e
  xor a;ld a,15                   
  call moveplussprite2
  pop de
  ; DRAW BLANK TILE FOR ENTRANCE
  push de
  ld a,32 
  call dodrawsprite
  pop de
  ; 1 PLAYER SPRITE
  ld a,65 
  call dodrawsprite
  
  ; DRAW PLAYER 2 SPRITE
  ld de,#283a
  ; DEFAULT SPRITE DIRECTION
  ld a,4
  ld (playerspritedirection2),a
  push de
  ld h,d
  ld l,e
  ld a,15                   
  call moveplussprite2
  pop de
  ; DRAW BLANK TILE FOR ENTRANCE
  push de
  ld a,32 
  call dodrawsprite
  pop de
  ; 1 PLAYER SPRITE
  ld a,66
  call dodrawsprite

  ld a,1
  call txt_set_paper
  
  ; DRAW MUMMY PATHS
  ld hl,#0601
  ld de,#0716
  call drawbox
  ld hl,#2001
  ld de,#2116
  call drawbox
  ld hl,#0801
  ld de,#1f02
  call drawbox
  ld hl,#0815
  ld de,#1f16
  call drawbox
  ld hl,#0000
  ld de,#2718
  call my_txt_set_window
  
  ld hl,l8637
  ld (l8645),hl
  call spawn_multiple_mummies

  mainmenudrawhighscoretable:
  call setmainmenu        ; SET MENU SELECTION POINTERS  

  ld hl,txt_highscoretable
  call printstring
  
  ld hl,#0c0a
  call my_txt_set_cursor
  ld hl,(scoreboard_score1)
  call printscore
  ld hl,txt_score_stupendous
  call printstring
  
  ld hl,#0c0b
  call my_txt_set_cursor
  ld hl,(scoreboard_score2)
  call printscore
  ld hl,txt_score_excellent
  call printstring
  
  ld hl,#0c0c
  call my_txt_set_cursor
  ld hl,(scoreboard_score3)
  call printscore
  ld hl,txt_score_verygood
  call printstring
  
  ld hl,#0c0d
  call my_txt_set_cursor
  ld hl,(scoreboard_score4)
  call printscore
  ld hl,txt_score_quitegood
  call printstring
  
  ld hl,#0c0e
  call my_txt_set_cursor
  ld hl,(scoreboard_score5)
  call printscore
  ld hl,txt_score_notbad
  call printstring
  
  ld hl,#0c0f
  call my_txt_set_cursor
  ld hl,txt_score_empty
  call printstring
  
  ld a,(isscoreboardmenu)
  or a
  jr z,doenternamescoreboard
  ld hl,txt_score_entername
  call printstring
  
  xor a
  call txt_set_paper
  
  ld hl,(playerscoreentryposition) ; COORDINATE ON SCREEN TO START PRINTING NAME
  dec h
  dec l
  call locatetextf
  ld d,h
  ld e,l
  ld hl,(playernameentryinmemory)  ; NAME ENTRY POSITION IN MEMORY
jp printscores

doenternamescoreboard:
  ld hl,txt_menu_userinput
  call printstring
  call km_wait_keyrelease ; MAKE SURE WE AREN'T HOLDING KEY DOWN
  dowaitnextscoreboardkeypress:

    ; SET SPEED OF GAME FOR WALKING
    ld a,(mummymovementok)        ; WAIT UNTIL INTERRUPT TELLS US TO MOVE MUMMIES
    or a
    jr nz,skipmovemummiesmenu2    ; WE HAVE MOVED MUMMIES ALREADY
    ld a,1                        ; MARK THAT WE HAVE COMPLETED DELAY
    ld (mummymovementok),a	
	
	; RECORD WHETHER WE ARE TO MOVE ODD OR EVEN MUMMIES IN THIS LOOP
	; WE NEED TO DO THIS TO KEEP GAME SPEED REGULAR
	
	ld a,(moveoddevenmummies)
	xor 1
	ld (moveoddevenmummies),a
	or a
	jr z,moveevenmummies5
  
  ld b,1                      ; MOVE ODD MUMMIES
  jr domovemummies5
  moveevenmummies5:
  ld b,2                      ; MOVE EVEN MUMMIES
  domovemummies5:
  call domummymovements
  
  skipmovemummiesmenu2:
  
  ld a,(isscoreboardmenu)
  or a
  jp z,waitmainmenukeypress

finishedscoreboardnameentry2:
  xor a
  ld (isscoreboardmenu),a
  ld (charbuffer),a
    
  ld hl,txt_menu_clearentername   ; ERASE ENTER NAME TEXT IF WE WERE ON SCOREBOARD
  call printstring
  
  ld a,3
  call txt_set_paper
jp doenternamescoreboard

waitmainmenukeypress:
  call km_read_key
  call km_check_keyrelease;km_wait_keyrelease ; MAKE SURE WE AREN'T HOLDING KEY DOWN
  ;or a
  jp nc,dowaitnextscoreboardkeypress
  ld hl,charbuffer
  ld a,(hl)         ; GET KEY PRESSED
  ld (hl),0

  cp "u";#50
  jp z,selectup
  cp "d"
  jp z,selectdown
  cp "f"
  jp z,selectfire
  cp " "
  jp z,selectfire
  cp 10
  jp z,selectfire
  cp 13
  jp z,selectfire
  
  cp "P";#50
  jp z,playthegame
  cp "I";#49
  jp z,showinstructions
  cp "O";#4f
  jp z,showoptions
jp dowaitnextscoreboardkeypress

showoptions:
  call setoptionmenu
  ld hl,txt_setupoptionscreen2
  call printstring
  ld hl,txt_options2
  call printstring

  ld hl,txt_optionsblank3
  call printstring
  call displaypointer
  
  dowaitnextscoreboardkeypress2:
    ; SET SPEED OF GAME FOR WALKING
    ld a,(mummymovementok)        ; WAIT UNTIL INTERRUPT TELLS US TO MOVE MUMMIES
    or a
    jr nz,skipmovemummiesmenu3    ; WE HAVE MOVED MUMMIES ALREADY
    ld a,1                        ; MARK THAT WE HAVE COMPLETED DELAY
    ld (mummymovementok),a	
	
	; RECORD WHETHER WE ARE TO MOVE ODD OR EVEN MUMMIES IN THIS LOOP
	; WE NEED TO DO THIS TO KEEP GAME SPEED REGULAR
	
	ld a,(moveoddevenmummies)
	xor 1
	ld (moveoddevenmummies),a
	or a
	jr z,moveevenmummies3
  
    ld b,1
    jr domovemummies3
	moveevenmummies3:
    ld b,2
	domovemummies3:
    call domummymovements    ; MOVE EVEN MUMMIES
	
	skipmovemummiesmenu3:
	
    call km_read_key
	call km_check_keyrelease          ; CHECK FOR KEY RELEASE WITHOUT WAITING
  jr nc,dowaitnextscoreboardkeypress2 ; NO KEY RELEASE
  
  ; GET KEYPRESS FROM BUFFER
  ld hl,charbuffer
  ld a,(hl)
  ld (hl),0
  
  cp "u";#50
  jp z,selectup
  cp "d"
  jp z,selectdown
  cp "l"
  jp z,selectleft
  cp "r"
  jp z,selectright
  cp "f"
  jp z,selectfire
  cp " "
  jp z,selectfire
  cp 10
  jp z,selectfire
  cp 13
  jp z,selectfire
  cp "e"
  jp z,returntomainmenu
jp dowaitnextscoreboardkeypress2
  
setentranceleft:
  ; SET DEFAULT START POSITION OF PLAYER - Y, X
  ld de,#6800
  ld (playerspritexy),de
  ; DEFAULT SPRITE DIRECTION
  ld a,2
  ld (playerspritedirection),a
  jr finishentrance
  
setentranceright:
  ; SET DEFAULT START POSITION OF PLAYER - Y, X
  ld de,#684c
  ld (playerspritexy),de
  ; DEFAULT SPRITE DIRECTION
  ld a,4
  ld (playerspritedirection),a
  jr finishentrance
   
setentrancetop:
  ; RESET SWEEPER MUMMY TIMER
  ld a,150
  ld (sweepermummytimer-1),a
  xor a
  ld (gotmummysweeper-1),a

  ; SET DEFAULT START POSITION OF PLAYER - Y, X - IF STILL ALIVE!
  ld a,(player1alive)
  or a
  jr z,skipsetplayeroneposition
  
  ld de,#0820
  ld (playerspritexy),de
  ; DEFAULT SPRITE DIRECTION
  ld a,3
  ld (playerspritedirection),a
  
  ; DRAW PLAYER 1 SPRITE
  push de
  ld h,d
  ld l,e
  xor a                   
  call moveplussprite2
  pop de
  
  skipsetplayeroneposition:
  
  ; SET DEFAULT START POSITION OF PLAYER 2 - Y, X
  ld a,(player2alive)
  or a
  jr z,finishentrance
  
  ld de,#0820
  ld (playerspritexy2),de
  ; DEFAULT SPRITE DIRECTION
  ld a,3
  ld (playerspritedirection2),a
  
  ; DRAW PLAYER 2 SPRITE
  push de
  ld h,d
  ld l,e
  ld a,15                   
  call moveplussprite2
  pop de
  push de
  ld a,66 ; 2 PLAYER SPRITE
  call dodrawsprite
  pop de
  
  finishentrance:

  ; DRAW BLANK TILE FOR ENTRANCE
  push de
  ld a,32 
  call dodrawsprite
  pop de

  ; SET PATH OBJECT SO PLAYER CAN MOVE
  call getobjectmaplocationfromde
  ld a,20 
  ld (hl),a
  inc hl
  ld (hl),a
  ld bc,40
  add hl,bc
  dec hl
  ld (hl),a
  inc hl
  ld (hl),a
  
  ; SET EXIT OBJECT (NEED KEY AND ROYAL MUMMY)
  ld de,(playerspritexy)
  call mygetobjectmaplocationfromde
  ld a,241 
  ld (hl),a

  jp finishsetentrance
  
drawheader:
  ; DRAW BIGGER SPRITES
  ld a,16
  ld (setspriteheightmod),a
  ld a,4
  ld (spritewidthmodifier),a

  ; PRINT HEADER
  ld hl,txt_scorelives
  call printstring
  call printcurrentscore
  ld a,1
  call txt_set_paper

  ; DRAW NUMBER OF LIVES LEFT
  ld a,(numberoflives)
  ld b,a
  ld de,#0034
  xor a
  
  drawlivesmeterloop:
    push bc
	or a
	jr z,doplayerimage1
	ld iy,image_playerright2
    jr drawlivessprite
	doplayerimage1:
	ld iy,image_playerright
	drawlivessprite:
	push af
    call drawsprite
	pop af

	ld hl,#0004
    add hl,de
	ex de,hl

	xor 1
    pop bc
  djnz drawlivesmeterloop
  
  ; PYRAMID ROOM NUMBER
  jp printpyramidroomnumber
  
pyramidroomscompleted: defb 0
  
totalnumberofmummiesallowed equ 14   ; 16 PLUS SPRITES MINUS TWO PLAYER SPRITES
 
playthegame: 
  call setlinesandbits       ; COPY INPUT KEYS TO FUNCTIONS
  call dosetdifficulty       ; MAKE SURE WE RESET GAME DIFFICULTY TO WHAT USER HAS CHOSEN
                             
  ld a,5                     ; RESET LIVES
  ld (numberoflives),a
  ld hl,0                    ; RESET SCORE
  ld (playerscore),hl
   
  ; RESET NUMBER OF MUMMIES
  xor a
  ld (totalnumberofmummies),a
  ld (pyramidroomscompleted),a
  ; RESET PYRAMID ROOMS COMPLETED
  ld (pyramidroomnumber),a

  ; SET PLAYER FUNCTIONS IN MAIN GAME LOOP
  call enableoneplayergame
  ld a,(istwoplayer)
  cp 1
  jr z,myplaynextlevel
  call enabletwoplayergame

  myplaynextlevel:
  ; HIDE MENU MUMMIES
  call hideallplussprites
  
  ; INCREMENT NUMBER OF MUMMIES
  ld a,(totalnumberofmummies)
  cp totalnumberofmummiesallowed ; DON'T GO OVER 14 AS WE ONLY HAVE 16 HARDWARE SPRITES
  jr z,skipincreasetotalmummies
  inc a
  ld (totalnumberofmummies),a
  skipincreasetotalmummies:
   
  ; INCREMENT ROOM NUMBER
  ld a,(pyramidroomnumber)
  inc a
  ld (pyramidroomnumber),a
  cp 6
  jp z,levelcompleted

  call wipeobjectmaps
  
  ; ERASE ALL POWERUPS
  xor a
  ld (lastmummyidused),a
  ld (gotguardianmummy),a ; RESET GUARDIAN MUMMY
  ld (gotscroll),a        ; RESET SCROLL
  ld (gotexitkey),a       ; RESET EXIT KEY
  ld (gotroyalmummy),a    ; RESET ROYAL MUMMY
  ld (gottorch),a         ; RESET TORCH
  ld (gotankh),a          ; RESET ANKH
  ld (gotelixir),a        ; RESET ELIXIR
  ; DISABLE FIRE FOOTPRINTS IF WE HAD TORCH
  call disablefirefootprints
  ld (l8171),a            ; UNUSED?
  ld (playerwalkinganimation),a
  
  ; RESET SOME DATA AT TOP OF OBJECT MAP
  ld hl,l81de
  ld a,#60
  ld (hl),a
  ld de,l81df
  ld bc,#0019
  ldir
  
  ; FILL BOXES WITH RANDOM TREASURES
  xor a
  ld iy,data_treasureboxes
  ld (iy+#0d),a
  ld (iy+#0e),a
  ld (iy+#14),a
  ld (iy+#15),a
  ld (iy+#1b),a
  ld (iy+#1c),a
  ld b,14 ;#0e ; NUMBER OF TREASURES TO PLANT IN BOXES
  ld a,16 ;#10
  filltreasureboxesloop:
    push bc
    push af
    filltreasureboxesloop2:
      ld a,26 ;#1a
      call getrandomnumber
      ld b,8
      add b
      ld hl,data_treasureboxes
      ld b,0
      ld c,a
      add hl,bc
      ld a,(hl)
      cp 96 ;#60
    jr nz,filltreasureboxesloop2
    pop af
    ld (hl),a
    pop bc
    cp 80 ;#50
    jr z,l65d0
    add 16 ;#10
    l65d0:
  djnz filltreasureboxesloop
  
  ; ERASE OLD PATHS OF HALLWAY FROM NEW GAME SCREEN
  ld a,0
  call txt_set_paper
  ld hl,#0000
  ld de,#2718
  call my_txt_set_window
  call my_txt_clear_window

  call drawheader

  ld a,1
  call txt_set_paper 
 
  ; DRAW LEVEL LAYOUT - PATHS
  ; HORIZONTAL
  ld hl,#0203
  ld de,#2604 ;
  call drawbox
  ld hl,#0408
  ld de,#2409
  call drawbox
  ld hl,#040d
  ld de,#240e
  call drawbox
  ld hl,#0412
  ld de,#2413
  call drawbox
  ld hl,#0217
  ld de,#2618
  call drawbox
  
  ; VERTICAL y, x
  ld hl,#0205
  ld de,#0316
  call drawbox
  ld hl,#0905
  ld de,#0a16
  call drawbox
  ld hl,#1003 ; ENTRANCE PATH
  ld de,#1116
  call drawbox
  ld hl,#1705
  ld de,#1816
  call drawbox
  ld hl,#1e05
  ld de,#1f16
  call drawbox
  ld hl,#2505
  ld de,#2616
  call drawbox 
  
  ld hl,#0000
  ld de,#2718
  call my_txt_set_window
  ; CYCLE COLOURS BASED ON ROOM NUMBER
  ld a,(pyramidroomnumber)
  cp 2
  jr c,do_fillpatternbox_standard
  jr z,do_fillpatternbox_yellowblack
  cp 4
  jr c,do_fillpatternbox_tealgreen
  jr z,do_fillpatternbox_orangebrown
  ld hl,fillpatternbox_blueblack
  jr do_fillpatternbox

do_fillpatternbox_orangebrown:
  ld hl,fillpatternbox_orangebrown
jr do_fillpatternbox
do_fillpatternbox_tealgreen:
  ld hl,fillpatternbox_tealgreen
jr do_fillpatternbox
do_fillpatternbox_yellowblack:
  ld hl,fillpatternbox_yellowblack
jr do_fillpatternbox

moveoddevenmummies: defb 0

do_fillpatternbox_standard:
  ld hl,fillpatternbox_standard ; SET FILL PATTERN FOR ALL BOXES AS STANDARD
  do_fillpatternbox:
  ld (l66ba),hl 
  ld b,4
  ld hl,#2808  ; VERTICAL, HORIZONTAL START POSITION FOR BOXES
  l66b3:
    push bc
    push hl
    ld b,5
    l66b7:  
      push bc
      push hl
      l66ba equ $ + 1 ; SELF MODIFYING
      call fillpatternbox_standard
      pop hl
      ld bc,#000e
      add hl,bc
      pop bc
    djnz l66b7
    pop hl
    ld bc,#2800
    add hl,bc
    pop bc
  djnz l66b3
  
  ld hl,l860f
  ld (l8645),hl
  call spawn_multiple_mummies
 
  jp setentrancetop
  
  finishsetentrance:
  xor a
  call txt_set_paper
  
  gameloop:
    ; SET SPEED OF GAME FOR WALKING
    ld a,(mummymovementok)   ; WAIT UNTIL INTERRUPT TELLS US TO MOVE MUMMIES
    or a
    jr nz,gameloop           ; WE HAVE MOVED MUMMIES ALREADY
    ld a,1                   ; MARK THAT WE HAVE COMPLETED DELAY
    ld (mummymovementok),a	
	
	; RECORD WHETHER WE ARE TO MOVE ODD OR EVEN MUMMIES IN THIS LOOP
	; WE NEED TO DO THIS TO KEEP GAME SPEED REGULAR
	
	ld a,(moveoddevenmummies)
	xor 1
	ld (moveoddevenmummies),a
	or a
	jr z,moveevenmummies
	
	; PLAYER NEEDS TO MOVE TWICE AS FAST AS MUMMIES
	; THIS IS WHY PLAYER MOVEMENT IS CHECKED TWICE AND MUMMIES MOVEMENT IS SPLIT BETWEEN TWO GROUPS
	
    ld b,1                   ; MOVE ODD MUMMIES
	jr domovemummies
	moveevenmummies:
    ld b,2                   ; MOVE EVEN MUMMIES
	domovemummies:
	  ; ------------------ MOVE MUMMIES ------------------
      call domummymovements

	  ; PLAYER 1 FUNCTIONS - DISABLE WHEN KILLED
	  defb 0:p1callcmd1 ;call checkplayer1collidedwithmummy
	  defw 0:p1func1
	  defb 0:p1callcmd2 ;jp c,gameover
	  defw 0:p1func2
	
	  ; PLAYER 2 FUNCTIONS - DISABLE WHEN KILLED
	  defb 0:callcmd1 ;call checkplayer2collidedwithmummy
	  defw 0:func1
	  defb 0:callcmd2 ;jp c,gameover
	  defw 0:func2
	  
	  ; ------------------ MOVE PLAYERS ------------------
	  
	  ; DECREMENT TORCH TIMER IF WE HAVE IT
	  call decrementtorchtimer
	  ; THIS VALUE IS ALTERED WHEN WE HAVE THE ELIXIR.
	  ; IT CAUSES PLAYER MOVEMENT INPUT TO BE CHECKED TWICE TO MOVE AT DOUBLE SPEED
	  call decrementelixirtimer
	  ld b,1:loopforelixirspeed
	  
      elixirspeedloop:	
	  push bc
	  call mc_wait_flyback ; SLOW SCREEN UPDATE DOWN SO ELIXIR MOVEMENT ANIMATION LOOKS BETTER
	  pop bc
      push bc	  
	  ; PLAYER 1 FUNCTIONS - DISABLE WHEN KILLED
	  defb 0:p1callcmd3 ;call checkplayer1input
	  defw 0:p1func3
	  defb 0:p1callcmd4 ;call checkplayer1collidedwithmummy
	  defw 0:p1func4
	  defb 0:p1callcmd5 ;jp c,gameover
	  defw 0:p1func5

	  defb 0:p1callcmd6 ;call checkhasboxbeenwalkedroundplayer
	  defw 0:p1func6
	
	  ; PLAYER 2 FUNCTIONS - DISABLE WHEN KILLED
	  defb 0:callcmd3 ;call checkplayer2input
	  defw 0:func3
	  defb 0:callcmd4 ;call checkplayer2collidedwithmummy
	  defw 0:func4
	  defb 0:callcmd5 ;jp c,gameover
	  defw 0:func5
	  
	  defb 0:callcmd6 ;call checkhasboxbeenwalkedroundplayer2
	  defw 0:func6
	
	call hasplayerfoundkeyandroyalmummy
	call eraselastburnp1 ; IF WE HAVE BURNS TO ERASE, DO IT
	call eraselastburnp2 ; IF WE HAVE BURNS TO ERASE, DO IT
	pop bc
	djnz elixirspeedloop
	
    call checkpausegame
	
	ld a,(gotguardianmummy)
    or a
    call nz,revealguardianmummy
	
	; DECREMENT SWEEPER MUMMY TIMER
	ld a,0:sweepermummytimer
	dec a
	ld (sweepermummytimer-1),a
	or a
	jr nz,gameloop
	
	ld a,0:gotmummysweeper
	or a
	jr nz,gameloop
	inc a
	ld (gotmummysweeper-1),a
	call launch_mummy_sweeper
 jr gameloop

; ENABLE OR DISABLE TWO PLAYER FUNCTIONS IN MAIN GAME LOOP
enabletwoplayergame:
  ld a,1
  ld (player2alive),a
  ; CALL  = &CD
  ; JP C, = &DA
  ld a,&cd
  ld (callcmd1-1),a
  ld (callcmd3-1),a
  ld (callcmd4-1),a
  ld (callcmd6-1),a
  ld a,&da
  ld (callcmd2-1),a
  ld (callcmd5-1),a
  
  ld bc,checkplayer2collidedwithmummy
  ld (func1-2),bc
  ld (func4-2),bc
  ld bc,gameover
  ld (func2-2),bc
  ld (func5-2),bc
  ld bc,checkplayer2input
  ld (func3-2),bc
  ld bc,checkhasboxbeenwalkedroundplayer2
  ld (func6-2),bc
ret
enableoneplayergame:
  ld a,1
  ld (player1alive),a
  ; CALL  = &CD
  ; JP C, = &DA
  ld a,&cd
  ld (p1callcmd1-1),a
  ld (p1callcmd3-1),a
  ld (p1callcmd4-1),a
  ld (p1callcmd6-1),a
  ld a,&da
  ld (p1callcmd2-1),a
  ld (p1callcmd5-1),a
  
  ld bc,checkplayer1collidedwithmummy
  ld (p1func1-2),bc
  ld (p1func4-2),bc
  ld bc,gameover
  ld (p1func2-2),bc
  ld (p1func5-2),bc
  ld bc,checkplayer1input
  ld (p1func3-2),bc
  ld bc,checkhasboxbeenwalkedroundplayer1
  ld (p1func6-2),bc
ret

disabletwoplayergame:
  xor a
  ld (player2alive),a
  ld bc,0
  ld (callcmd1-1),a
  ld (callcmd2-1),a
  ld (callcmd3-1),a
  ld (callcmd4-1),a
  ld (callcmd5-1),a
  ld (callcmd6-1),a
  
  ld (func1-2),bc
  ld (func2-2),bc
  ld (func3-2),bc
  ld (func4-2),bc
  ld (func5-2),bc
  ld (func6-2),bc
ret
disableoneplayergame:
  xor a
  ld (player1alive),a
  ld bc,0
  ld (p1callcmd1-1),a
  ld (p1callcmd2-1),a
  ld (p1callcmd3-1),a
  ld (p1callcmd4-1),a
  ld (p1callcmd5-1),a
  ld (p1callcmd6-1),a
  
  ld (p1func1-2),bc
  ld (p1func2-2),bc
  ld (p1func3-2),bc
  ld (p1func4-2),bc
  ld (p1func5-2),bc
  ld (p1func6-2),bc
ret

levelcompleted:
  ; RESET PYRAMID ROOMS COMPLETED
  xor a
  ld (pyramidroomnumber),a
  ; INCREMENT PYRAMID NUMBER
  ld a,(pyramidroomscompleted)
  inc a
  ld (pyramidroomscompleted),a
  ; INCREASE DIFFICULTY
  ;ld hl,(playerscore)
  ;ld a,h
  ;or l
  ;jr z,skipincreasedifficulty
  ; INCREASE DIFFICULTY FOR NEW ROOM IF PLAYER COMPLETED A LEVEL ALREADY
  ld a,(gamedifficulty)
  srl a
  or #03                   
  ld (gamedifficulty),a
  ;skipincreasedifficulty:
  
  ld hl,txt_setuplevelcompleted
  call printstring
  ld hl,txt_stoppress
  call printstring
  ld hl,txt_britishmuseum
  call printstring
  ld hl,txt_extraman
  call printstring
  ld hl,l809d
  call printstring
  ld a,2
  call getrandomnumber
  or a
  jr z,l677e
  rewardpointsinsteadoflives:
  ld hl,(playerscore)
  ld bc,#00c8
  add hl,bc
  ld (playerscore),hl
  ld hl,l80b8
  call printstring
  ld hl,l80c2
  call printstring
jp l6795

l677e:
  ld a,(numberoflives)
  cp 7
  jr z,rewardpointsinsteadoflives
  
  ; REWARD LIVES - IF TWO PLAYER, THEN ENABLE BOTH PLAYERS AS ONE WAS KILLED
  inc a
  ld (numberoflives),a
  
  ld a,(istwoplayer)
  cp 1
  jr z,skipenablebothplayers
  
  call enableoneplayergame
  call enabletwoplayergame
  
  skipenablebothplayers:
  
  ld hl,l80e0
  call printstring
  ld hl,l80ea
  call printstring
  l6795:
  call showcontinueinstructiontext
  jp myplaynextlevel

; ENTER HIGH SCORE?
gameover:
  call playgameovermusic

  ld hl,txt_gameoverboxcolours
  call printstring
  ld hl,#090a
  ld de,#1f11
  call drawbox
  ld hl,#0000
  ld de,#2718
  call my_txt_set_window
  ld hl,#0d0e
  call my_txt_set_cursor
  
  ld hl,txt_gameover
  ld b,9
  gameoverloop:
    push bc
    push hl
	
    ld b,150;200
    gameoverdelayloop:
	  push bc
	  call mc_wait_flyback
	  call mc_wait_flyback
	  pop bc
    djnz gameoverdelayloop
	
    pop hl
    ld a,(hl)
    inc hl
    call my_txt_output
    ld a," ";#20
    call my_txt_output
    pop bc
  djnz gameoverloop
  
  ld b,255
  gameoverdelayloop2:
	push bc
	call mc_wait_flyback
	call mc_wait_flyback
	call mc_wait_flyback
	call mc_wait_flyback
	call mc_wait_flyback
	call mc_wait_flyback
	call mc_wait_flyback
	call mc_wait_flyback
	call mc_wait_flyback
	pop bc
  djnz gameoverdelayloop2
  
  call hideallplussprites
  
  xor a
  ld hl,(playerscore)
  ld bc,(scoreboard_score5)
  sbc hl,bc
  jp c,resetgame
  ld a,1
  ld (isscoreboardmenu),a
  ld de,#0012
  ld ix,scoreboard_score5
  xor a
  ld b,5
  l681f:
    push bc
    ld hl,(playerscore)
    ld c,(ix+#00)
    ld b,(ix+#01)
    sbc hl,bc
    pop bc
    jr z,l683b
    jr c,l683a
    push ix
    pop hl
    sbc hl,de
    push hl
    pop ix
  djnz l681f
  l683a:
  inc b
  l683b:
  
  ; GET POSITION OF ENTRY
  ld a,b
  ;add a ; DOUBLE IF SCOREBOARD SPACED OUT
  inc a  ; DON'T DOUBLE AS WE HAVE COMPACTED ENTRIES
  add 8
  ld h,#12
  ld l,a
  ld (playerscoreentryposition),hl
  
  ld hl,scoreboard_score5
  ld a,5
  cp b
  jr z,l6893
  sub b
  ld b,a
  push bc
  pop bc
  
  ; MAKE ROOM FOR NEW ENTRY
  ld hl,scoreboard_score4
  ld de,scoreboard_score5
  l685a:
    push bc
    ld bc,#0012
    ldir
    xor a
    ld bc,#0024
    sbc hl,bc
    ex de,hl
    sbc hl,bc
    ex de,hl
    pop bc
  djnz l685a
  
  push hl
  pop hl
  ld bc,#0012
  add hl,bc
  push hl
  ; PRINT SCORES
  ld hl,txt_score_stupendous2
  ld a,#0a
  ld (hl),a
  add hl,bc
  inc a;ld a,#0b
  ld (hl),a
  add hl,bc
  inc a;ld a,#0c
  ld (hl),a
  add hl,bc
  inc a;ld a,#0d
  ld (hl),a
  add hl,bc
  inc a;ld a,#0e
  ld (hl),a
  ld hl,txt_score_notbad
  dec a
  ld (hl),a
  pop hl
  
  l6893:
  ld de,(playerscore)
  ld (hl),e
  inc hl
  ld (hl),d
  ld bc,#0005
  add hl,bc
  ld (playernameentryinmemory),hl
  ld a," ";#20
  ld (hl),a
  push hl
  pop de
  inc de
  ld bc,#000b
  ldir
jp showmainmenu

; PLAYER PRESSED ESCAPE
;playerpressedescape:
;  jp continuegame     ; SET TO DO NOTHING

showinstructions:
  ; HIDE MENU MUMMIES
  call hideallplussprites
  
  ld hl,txt_setupscreeninstructions
  call printstring
  call clearinstructionswindow
  ld hl,#0004
  call uncover_sarcophagus_sarcophagus
  ld hl,#0042
  call uncover_sarcophagus_key
  
  ; SCENARIO PAGE 1 - YOU HAVE BEEN
  ld hl,txt_instructionstitle
  call printstring
  ld hl,l6a0f
  call printstring
  ld hl,l6aba
  call printstring
  call showcontinueinstructiontext
  
  ; SCENARIO PAGE 2 - EACH LEVEL
  call clearinstructionswindow
  ld hl,l6b78
  call printstring
  ld hl,l6bec
  call printstring
  ld hl,l6c75
  call printstring
  call showcontinueinstructiontext
  
  ; SCENARIO PAGE 3 - GRID OF 20 BOXES
  call clearinstructionswindow
  ld hl,l6ce0
  call printstring
  ld hl,l6d3a
  call printstring
  ld hl,l6da2
  call printstring
  call showcontinueinstructiontext
  
  ; SCENARIO PAGE 4 - EACH LEVEL CONTAINS
  call clearinstructionswindow
  ld hl,l6e0a
  call printstring
  ld hl,l6e96
  call printstring
  call showcontinueinstructiontext

  ; SCENARIO PAGE 5 - THE MAGIC SCROLL
  call clearinstructionswindow 
  ld hl,l6f7d
  call printstring
  ld hl,l703c
  call printstring
  call showcontinueinstructiontext

  call clearinstructionswindow
  ld hl,l70ae
  call printstring
  ld hl,l7170
  call printstring
  call showcontinueinstructiontext
  
  call clearinstructionswindow
  ld hl,l71f4
  call printstring
  ld hl,l7288
  call printstring
  call showcontinueinstructiontext
  
  call clearinstructionswindow
  ld hl,l736e
l6966: 
  call printstring
  ld hl,l738d
  call printstring
  ld hl,l73dd
  call printstring
  ld hl,l7424
  call printstring
  ld hl,l74e7
  call printstring
  call showcontinueinstructiontext
  call setwindowfullscreen
jp showmainmenu

clearinstructionswindow:
  ld hl,#0005
  ld de,#2718
  call my_txt_set_window
  call my_txt_clear_window
setwindowfullscreen:
  ld hl,#0000
  ld de,#2718
  jp my_txt_set_window

showcontinueinstructiontext:
  ld hl,txt_presscorfirebutton
  call printstring
  call km_wait_key   ; GET KEYPRESS
  jp km_wait_keyrelease

; DATA - INSTRUCTIONS

txt_setupscreeninstructions:
db 8                    ; NUMBER OF CHARS TO PRINT
db #0e,#00              ; SET PAPER
db #0c                  ; CLS
db #1d,#18,#18          ; BORDER
db #0e,#01              ; SET PAPER
txt_instructionstitle:
db #1a                  ; NUMBER OF CHARS TO PRINT
db #0e,#00              ; SET PAPER
db #0f,#03              ; SET PEN
db #1f,#0c,#02          ; LOCATE
db "OH MUMMY - SCENARIO"
l6a0f:
db #a9                  ; NUMBER OF CHARS TO PRINT
db #0e,#01              ; PAPER
db #0f,#00              ; PEN
db #1f,#05,#08,"You have been appointed head of an"
db #1f,#03,#09,"archeological expedition, sponsored"
db #1f,#03,#0a,"by the British Museum, and have been"
db #1f,#03,#0b,"sent to Egypt to explore newly found"
db #1f,#03,#0c,"pyramids."
l6aba: 
db #bc                  ; NUMBER OF CHARS TO PRINT
db #1f,#05,#0f,"Your party, initially, consists of"
db #1f,#03,#10,"five members. Your task is to enter"
db #1f,#03,#11,"the five levels of each pyramid, and"
db #1f,#03,#12,"recover from them five Royal Mummies"
db #1f,#03,#13,"and as much treasure as you can."
l6b78: 
db "s"
db #1f,#05,#08
db #0f,#00,"Each level has already been partly"
db #1f,#03,#09,"uncovered by local workers and it is"
db #1f,#03,#0a,"up to your team to finish the dig."
l6bec:
db #88
db #1f,#05,#0d,"Unfortunately, the workers digging"
db #1f,#03,#0e,"aroused Guardians left behind by the"
db #1f,#03,#0f,"ancient Egyptian Pharaohs to protect"
db #1f,#03,#10,"their royal tombs."
l6c75:
db #6a
db #1f,#05,#13,"Each level has 2 Guardian Mummies,"
db #1f,#03,#14,"one lies hidden while the other goes"
db #1f,#03,#15,"in search of the intruders."
l6ce0: 
db #59
db #1f,#05,#08
db #0f,#00,"The partly excavated levels are in"
db #1f,#03,#09,"the form of a grid made up of twenty"
db #1f,#03,#0a,"'boxes'."
l6d3a: 
db "g"
db #1f,#05,#0d,"To uncover a 'box', move your team"
db #1f,#03,#0e,"along the four sides of the box from"
db #1f,#03,#0f,"each corner to the next."
l6da2:
db "g"
db #1f,#05,#12,"Not all boxes need to be uncovered"
db #1f,#03,#13,"to enable you to go through the exit"
db #1f,#03,#14,"and into the next level."
l6e0a:
db #8a
db #1f,#05,#08
db #0f,#00,"Each level contains, ten Treasure"
db #1f,#03,#09,"boxes, six empty boxes, and the rest"
db #1f,#03,#0a,"hold a Royal Mummy, a Guardian Mummy"
db #1f,#03,#0b,"a Key and a Scroll."
l6e96:
db #e4
db #1f,#05,#0e,"If you uncover the box holding the"
db #1f,#03,#0f,"Guardian Mummy, it will dig its way"
db #1f,#03,#10,"out and pursue you. Being caught by"
db #1f,#03,#11,"a Guardian Mummy kills one member of"
db #1f,#03,#12,"your team and the Mummy, unless that"
db #1f,#03,#13,"is, you have uncovered the Scroll."
l6f7d:
db #bd
db #1f,#05,#08
db #0f,#00,"The Magic Scroll will allow you to"
db #1f,#03,#09,"be caught by a Guardian, without any"
db #1f,#03,#0a,"harm to your team. The Scroll works"
db #1f,#03,#0b,"only on the level on which found, it"
db #1f,#03,#0c,"will only destroy one Guardian."
l703c:
db #71
db #1f,#05,#0f,"There are two ways to gain points,"
db #1f,#03,#10,"one is by uncovering the Royal Mummy"
db #1f,#03,#11,"the other, by uncovering Treasure."
l70ae:
db #c1
db #1f,#05,#08
db #0f,#00,"When the boxes holding the Key and"
db #1f,#03,#09,"the Royal Mummy have been uncovered,"
db #1f,#03,#0a,"you will be able to leave the level."
db #1f,#03,#0b,"Any remaining Guardians will be able"
db #1f,#03,#0c,"to follow you onto the next level."
l7170:
db #83
db #1f,#05,#0f,"After completing all 5 levels of a"
db #1f,#03,#10,"pyramid you will, when you leave the"
db #1f,#03,#11,"fifth level, move to level 1, of the"
db #1f,#03,#12,"next pyramid."
l71f4:
db #93
db #1f,#05,#08
db #0f,#00,"When you have completed a pyramid,"
db #1f,#03,#09,"your success will be rewarded either"
db #1f,#03,#0a,"by bonus points or the arrival of an"
db #1f,#03,#0b,"extra member for your team."
l7288:
db #e5
db #1f,#05,#0e,"The Guardians in the next pyramid,"
db #1f,#03,#0f,"having been warned by those you have"
db #1f,#03,#10,"escaped from, will be more alert, so"
db #1f,#03,#11,"although the Guardians cannot follow"
db #1f,#03,#12,"you from one pyramid to the next, it"
db #1f,#03,#13,"will pay to be even more careful."
l736e:
db #1e
db #0e,#00
db #0f,#03
db #1f,#0a,#02,"OH MUMMY - INSTRUCTIONS"
l738d:
db #4f
db #1f,#05,#08
db #0e,#01
db #0f,#00,"You can control your team by using"
db #1f,#03,#09,"either a joystick, or the keyboard."
l73dd:
db 82
db #1f,#05,#0b,"The keyboard keys can be redefined"
db #1f,#02,#0c,"in the option screen to suit the"
db #1f,#02,#0d,"player."
l7424: 
db #c1
db #0f,#00
db #1f,#05,#0f,"The game has 5 skill levels, these"
db #1f,#03,#10,"determine how 'clever' the Guardians"
db #1f,#03,#11,"are at the beginning of a game. You"
db #1f,#03,#12,"may choose between 5 different speed"
db #1f,#03,#13,"levels, from moderate to murderous."
l74e7:
db #2b
db #1f,#02,#15
db #0f,#03,"May Ankh-Sun-Ahmun guide your steps .."


; END OF DATA?

revealguardianmummy:
  dec a
  ld (gotguardianmummy),a
  sra a
  ret c
  ld h,0
  ld l,a
  add hl,hl
  add hl,hl
  ex de,hl
  
  ; REVEAL GUARDIAN MUMMY IMAGE IN TOMB
  ld iy,image_mummyup
  add iy,de
  ld hl,(guardianmummyxy)
  add h
  ld h,a
  call getscreenaddress
  ld b,4
  l7530:
    ld a,(iy+#00)
    ld (hl),a
    inc iy
    inc hl
  djnz l7530
  ld a,(gotguardianmummy)
  or a
  ret nz
  
  ; SPAWN GUARDIAN MUMMY
  ld de,(guardianmummyxy)
  call getobjectmaplocationfromde
  ld a,#20  ; INSERT ID FOR OBJECT MAP?
  ld (hl),a
  inc hl
  ld (hl),a
  ld de,#0028
  add hl,de
  ld (hl),a
  dec hl
  ld (hl),a
  
  ld a,(totalnumberofmummies)
  inc a
  ld (totalnumberofmummies),a
  call spawn_mummy
  ld de,(guardianmummyxy)
  ld (ix+2),d
  ld (ix+3),e
  
  ; CLEAR OLD MUMMY IMAGE AND USE PLUS SPRITE
  ; DRAW BIGGER SPRITES
  ld a,16
  ld (setspriteheightmod),a
  ld a,4
  ld (spritewidthmodifier),a
  
  ld iy,image_blank
  jp drawsprite

launch_mummy_sweeper:
  ; WE ONLY HAVE 16 HARDWARE SPRITES SO WE LIMIT NUMBER OF MUMMIES
  ld a,(totalnumberofmummies)
  cp totalnumberofmummiesallowed
  ret z
  inc a
  ld (totalnumberofmummies),a
  ; SET DEFAULT START POSITION OF PLAYER - Y, X
  ld de,#0820
  ld (sweepermummyxy),de
  call spawn_mummy_sweeper
  ld de,(sweepermummyxy)
  ld (ix+2),d
  ld (ix+3),e
ret

hasplayerfoundkeyandroyalmummy:
  ld a,(gotroyalmummy)
  ld hl,gotexitkey
  and (hl)              ; HAS PLAYER GOT KEY AND MUMMY?
  ret z
  
  ; CHECK IF PLAYER 1 IS ALIVE, IF TWO PLAYER GAME
  ; HAVE THEY REACHED EXIT?
  ; MARK AS SAFE
  
  ld a,(player2alive)
  or a
  jr z,skipcheckplayertwoexit
  
  ld de,(playerspritexy2)
  call mygetobjectmaplocationfromde
  ld a,(hl)
  cp 241       ; REACHED EXIT
  ret nz
  
  skipcheckplayertwoexit:
  
  ; CHECK IF PLAYER 2 IS ALIVE, IF TWO PLAYER GAME
  ; HAVE THEY REACHED EXIT?
  ; MARK AS SAFE
  
  ld a,(player1alive)
  or a
  jr z,skipcheckplayeroneexit

  ld de,(playerspritexy)
  call mygetobjectmaplocationfromde
  ld a,(hl)
  cp 241       ; REACHED EXIT
  ret nz
  
  skipcheckplayeroneexit:

  pop hl
  jp myplaynextlevel

  ; GO TO NEXT LEVEL - NOT ANY MORE SINCE WE MOVE TO MAIN HALL
;  pop hl
;jp skipincreasedifficulty
checkplayercollided: defb 0

checkplayer2collidedwithmummy:
  ld a,2
  ld (checkplayercollided),a
  ld de,(playerspritexy2)
  jr docheckplayercollidedwithmummy
checkplayer1collidedwithmummy:
  ld a,1
  ld (checkplayercollided),a
  ld de,(playerspritexy)
  docheckplayercollidedwithmummy:
  ld iy,gotguardianmummy
  ld a,(lastmummyidused)
  ld b,a
l7584:
  push bc
  ld bc,mummydatablocksize
  add iy,bc
  
  ld a,(iy+#00)
  or (iy+#01)
  jp z,continueplayinggamenolifelost        ; IS MUMMY ALIVE?
  
  ld a,(iy+#02)
  sub d
  cp #f8
  jr z,l75a3
  cp 8
  jr z,l75a3
  or a
  jp nz,continueplayinggamenolifelost
  l75a3:
  ld a,(iy+#03)
  sub e
  cp #fe
  jr z,l75b2
  cp 2
  jr z,l75b2
  or a
  jp nz,continueplayinggamenolifelost
  l75b2:
  
  ; CHECK IF WE HAVE ANKH, IF SO, COLLISION HAS NO EFFECT
  ld a,(gotankh)
  or a
  jr nz,continueplayinggamenolifelost
  
  ld a,16 ; SET NUMBER OF SPRITE CHANGES TO MAKE AS MUMMY SINKS INTO GROUND
  ld (iy+6),a
  
  ; KILL MUMMY
  xor a
  ld (iy+#00),a       
  ld (iy+#01),a
  ld d,(iy+#02)
  ld e,(iy+#03)
  
  ; ERASE MUMMY OBJECT FROM MAP - REDRAWING FOOTPRINTS IF NECESSARY - NOT NEEDED FOR PLUS SPRITES
;  call getobjectmaplocationfromde
;  ld a,(hl)
;  call clearspritetrail
;  inc e
;  inc e
;  call getobjectmaplocationfromde
;  ld a,(hl)
;  call clearspritetrail
;  ld a,8
;  add d
;  ld d,a
;  call getobjectmaplocationfromde
;  ld a,(hl)
;  call clearspritetrail
;  dec e  
;  dec e
;  call getobjectmaplocationfromde
;  ld a,(hl)
;  call clearspritetrail
  
  ; MUMMY DIES COLLIDING WITH PLAYER
  ld hl,totalnumberofmummies
  dec (hl)
  
  ; ERASE SCROLL POWER IF WE HAVE IT
  ld a,(gotscroll)
  or a
  jr z,lifelost
  xor a          
  ld (gotscroll),a       

  call txt_set_paper
  ld a,3
  call txt_set_pen
  push iy
  call printcurrentscore
  pop iy
  jr continueplayinggamenolifelost

  ; PLAYER DIED?
  lifelost:
  ld hl,numberoflives
  dec (hl)
  ld a,(hl)  
  add a
  add a
  add #34
  ld d,0
  ld e,a
  ld a,32; #20 BLANK IMAGE
  call dodrawsprite
  
  ld a,(soundeffects)
  cp "Y"
  call z,dodiednoise;sound_queue
  ld a,(numberoflives)
  or a
  jr nz,continueplayinggamelifelost
  ; NO MORE LIVES
  pop bc
  scf
ret

; CONTINUE GAME AFTER LIFE LOST?
continueplayinggamelifelost:
  cp 1 ; ONLY ONE LIFE LEFT - IF TWO PLAYER GAME, KILL OFF ONE PLAYER
  jr z,killofftwoplayergame

  doflashplayer:
  ld a,(checkplayercollided)
  cp 1
  call z,enableflashplayer1sprite
  cp 2
  call z,enableflashplayer2sprite
; CONTINUE GAME AFTER LIFE LOST
continueplayinggamenolifelost:
  pop bc
  dec b
  jp nz,l7584
  xor a
ret

killofftwoplayergame:
  ld a,(istwoplayer)
  cp 1
  jr z,doflashplayer
  
  ; KILL OFF ONE PLAYER
  ld a,(checkplayercollided)
  cp 1
  jr z,killplayer1
  ; KILL PLAYER 2
  ld b,15
  call hideplussprite
  call disabletwoplayergame
  jr continueplayinggamenolifelost
  killplayer1:
  ld b,0
  call hideplussprite
  call disableoneplayergame
  jr continueplayinggamenolifelost

; CHECK IF BOX HAS BEEN WALKED AROUND
; --------------------------------------
; NEED TO DO OPPOSITE FOR MUMMY SWEEPER
; ANY LENGTH AT ALL CANCELS OUT PLAYER'S WALK



; PATH COORDINATE OFFSETS FOR BOX SIDES FROM TOP LEFT FROM SCREEN
; ADD 1 X AND 1 Y FOR EACH COLUMN
; TO MOVE DOWN A ROW, ADD 7 Y FOR EACH ROW

;        224,217           225,218              226,219              227,220             228,221
 
; 224,223   .    225,224      .      226,225       .       227,226      .       228,227     .      229,228

;        231,224           232,225              233,226              234,227             235,228					   

; 231,230   .    232,231      .      233,232       .       234,233      .       235,234     .      236,235             


; STEPS TO DISABLING BOX PLAYER HAS WALKED AROUND
; 
; 1 - WORK OUT IF MUMMY SPRITE IS IN A ROW OR A COLUMN BASED ON COORDINATE
;     IF BOTH MATCH, WE ARE IN A JUNCTION - DO NOTHING
;     WE WANT TO IMMEDIATELY DISABLE ANY BOX SIDES WE ARE TOUCHING

; 4, 18, 32, 46, 60, 74 - COLUMN X COORDINATES TO CHECK FOR
; 24, 64, 104, 144, 184 - ROW Y COORDINATES TO CHECK FOR

; 2 - WORK OUT WHICH ROW OR COLUMN WE ARE IN
; 3 - USE LOOKUP TABLE TO DISABLE APPROPRIATE BOX SIDE



; TABLES FOR CONVERTING CHAR BLOCK POSITION ROW / COL TO CLOSES TREASURE BOX ID
; IDs 10 OR OVER IS JUNCTION
; IF BOTH X AND Y POSITIONS ARE OVER 10, FUNCTION SHOULD NOT RUN
chartocolumn: defb 15,5,5,5,5,5,5,14,4,4,4,4,4,4,13,3,3,3,3,3,3,12,2,2,2,2,2,2,11,1,1,1,1,1,1,10,0,0,0,0,0,0,10
chartorow:    defb 255,255,255,14,4,4,4,4,13,3,3,3,3,12,2,2,2,2,11,1,1,1,1,10,0,0,0,0,10

checkhasboxbeenwalkedround_mummy:
  ; CHECK IF BOX HAS BEEN WALKED AROUND?
  ld hl,(mummyspriteposition)  ; GET PLAYER POSITION
  
  ; CHANGE PIXEL ROW / BYTE COORDINATES TO CHARACTER BLOCKS
  srl h ; Y POSITION
  srl h
  srl h
  
  dec l ; X POSITION - START FROM 0 INSTEAD OF 4
  dec l
  dec l
  dec l
  
  srl l ; CONVERT BYTES TO BLOCK
  
;  call debugprinthl
  
  ; CONVERT CHARACTER BLOCK TO TREASURE BOX ID
  ; JUNCTION POSITIONS - Y - 3,8,13,18,23
  ; JUNCTION POSITIONS - X - 0,7,14,21,28,35 

  ld ix,chartorow
  ld b,0
  ld c,h
  add ix,bc
  ld d,(ix+0)
  
  ld ix,chartocolumn
  ld b,0
  ld c,l
  add ix,bc
  ld c,(ix+0)

  ; IF BOTH IDs 10 OR OVER (MARKERS FOR JUNCTIONS), QUIT FUNCTION AS WE ARE IN MIDDLE OF JUNCTION
  ld a,c
  sub 9
  jr c,skipsecondcheck
  ld a,d
  sub 9
  ret nc 
  skipsecondcheck:
  
  ; CORRECT IDs THAT ARE 10 OR OVER SO THEY REFER TO THE CORRECT BOX ID
  ld a,c
  sub 9
  jr c,skipdeduction_c
  dec c
  dec c
  dec c
  dec c
  dec c
  dec c
  dec c
  dec c
  dec c
  dec c
  skipdeduction_c:
  ld a,d
  sub 9
  jr c,skipdeduction_d
  dec d
  dec d
  dec d
  dec d
  dec d
  dec d
  dec d
  dec d
  dec d
  dec d
  skipdeduction_d:
  
;  ld h,d
;  ld l,c
;  call debugprinthl
  
  ; INPUTS
  ; C = COLUMN WE ARE CURRENTLY IN NUMBERED FROM LEFT 5,4,3,2,1,0
  ; D =    ROW WE ARE CURRENTLY IN NUMBERED FROM TOP  4,3,2,1,0

  ld a,4 
  sub d  
  ld d,a
  add a
  add a
  add a
  sub d
  ld d,a
  
  ld a,5
  sub c
  add d
  ld h,a
  ld l,a      

  ; RESULT
  ; H,L IS A UNIQUE NUMBER FOR EACH ROW / COL COMBINATION FROM 21 TO 8

  ; JUNCTIONS NUMBERED TOP LEFT TO RIGHT, HL = &0000, &0101, &0202, &0303, &0404  

  ; WORK OUT WHICH TREASURE BOX WE JUST PASSED BASED ON CURRENT PLAYER DIRECTION
  ; AND ADD OFFSET TO SPECIFY WHICH SIDE IS BEING UNCOVERED BASED ON PLAYER DIRECTION
  
  ld a,(mummyspritedirection)
  cp 2
  jr c,l7689a
  jr z,l7684a
  cp 3
  jr z,l767fa
  
  ld bc,#0108
  jr l768ca
  l767fa:
  ld bc,#0001
  jr l768ca
  l7684a:
  ld bc,#0007
  jr l768ca
  l7689a:
  ld bc,#0708
  
  l768ca:
  add hl,bc
  ld ix,data_treasureboxes ; BOXES TO LEFT OF PLAYER? - &2ACE
  ld iy,data_treasureboxes ; BOXED TO RIGHT OF PLAYER? - &2ACE
  ld d,0
  ld e,l
  ld b,0 
  ld c,h                                     

; PATH COORDINATE OFFSETS FOR BOX SIDES FROM TOP LEFT FROM SCREEN
; ADD 1 X AND 1 Y FOR EACH COLUMN
; TO MOVE DOWN A ROW, ADD 7 Y FOR EACH ROW

;        224,217           225,218              226,219              227,220             228,221
 
; 224,223        225,224             226,225               227,226              228,227            229,228

;        231,224           232,225              233,226              234,227             235,228					   

; 231,230        232,231             233,232               234,233              235,234            236,235             

;  
    
  
  add ix,bc
  add iy,de
  
  ; COORDINATES - TOP LEFT SIDES OF BOX = SAME VALUE AS BOTTOM RIGHT SIDES OF BOX BUT ON OPPOSITE REGISTER
  
  ; CLEAR SIDES AS WALKED AROUND BASED ON SPRITE DIRECTION
  bit 0,a
  jr z,markleftandrightboxess
  res 0,(ix+#00) ; TOP AND BOTTOM SIDES DONE ?
  res 2,(iy+#00)
  ret
  markleftandrightboxess:
  res 1,(ix+#00) ; LEFT AND RIGHT SIDES DONE ?
  res 3,(iy+#00)
  ret

; CHECK IF BOX HAS BEEN WALKED AROUND?

checkhasboxbeenwalkedroundplayer1:
  ld hl,(playerspritexy)          ; GET PLAYER COORDINATES
  ld (secondcoord-2),hl
  ld a,(playerspritedirection)
  jr checkhasboxbeenwalkedround
checkhasboxbeenwalkedroundplayer2:
  ld hl,(playerspritexy2)         ; GET PLAYER COORDINATES
  ld (secondcoord-2),hl
  ld a,(playerspritedirection2)
checkhasboxbeenwalkedround:
  ld (playerspritedir-1),a
  ; FUNCTION ONLY RUNS ONCE WE REACH A JUNCTION
  ld bc,(treasureboxxy)  ; GET CURRENT TREASURE BOX COORDINATES
  xor a                  ; RESET CARRY
  ld a,h                 ; STORE PLAYER Y POS IN A
  ld e,l                 ; BACKUP PLAYER X POS
  sbc hl,bc              ; SUBTRACT CURRENT TREASURE BOX POSITION FROM PLAYER COORDINATES
  ret z                  ; IF RESULT ZERO THEN CANCEL FUNCTION
  
  ; CHECK IF WE ARE IN A JUNCTION COORDINATE
  ; A = PLAYER Y POSITION
  ld hl,pathcoordinatesy ; JUNCTION COORDINATES TO CHECK FOR
  ld bc,#0005            ; LENGTH OF COORDINATE DATA BLOCK TO CHECK
  cpir
  ret nz                 ; NO MATCH FOUND, CANCEL FUNCTION
  
  ; CHECK IF WE ARE IN A JUNCTION COORDINATE
  ; A = PLAYER X POSITION
  ld d,c
  ld a,e                 ; RESTORE PLAYER X POS
  ld hl,pathcoordinatesx ; JUNCTION COORDINATES TO CHECK FOR
  ld bc,#0006            ; LENGTH OF COORDINATE DATA BLOCK TO CHECK
  cpir
  ret nz                 ; NO MATCH FOUND, CANCEL FUNCTION
  
  ld hl,0:secondcoord    ; STORE PLAYER POSITION AS CURRENT TREASURE BOX POSITION
  ld (treasureboxxy),hl  

  ; INPUTS
  ; C = COLUMN WE ARE CURRENTLY IN NUMBERED FROM LEFT 5,4,3,2,1,0
  ; D =    ROW WE ARE CURRENTLY IN NUMBERED FROM TOP  4,3,2,1,0

  ld a,4 
  sub d  
  ld d,a
  add a
  add a
  add a
  sub d
  ld d,a
  
  ld a,5
  sub c
  add d
  ld h,a
  ld l,a      

  ; RESULT
  ; H,L IS A UNIQUE NUMBER FOR EACH ROW / COL COMBINATION FROM 21 TO 8

  ; JUNCTIONS NUMBERED TOP LEFT TO RIGHT, HL = &0000, &0101, &0202, &0303, &0404  

  ; WORK OUT WHICH TREASURE BOX WE JUST PASSED BASED ON CURRENT PLAYER DIRECTION
  ; AND ADD OFFSET TO SPECIFY WHICH SIDE IS BEING UNCOVERED BASED ON PLAYER DIRECTION
  
  ld a,0:playerspritedir;(playerspritedirection)
  cp 2
  jr c,l7689
  jr z,l7684
  cp 3
  jr z,l767f
  
  ld bc,#0108
  jr l768c
  l767f:
  ld bc,#0001
  jr l768c
  l7684:
  ld bc,#0007
  jr l768c
  l7689:
  ld bc,#0708
  
  l768c:
  add hl,bc
  ld ix,data_treasureboxes ; BOXES TO LEFT OF PLAYER? - &2ACE
  ld iy,data_treasureboxes ; BOXED TO RIGHT OF PLAYER? - &2ACE
  ld d,0
  ld e,l
  ld b,0 
  ld c,h                                     

; PATH COORDINATE OFFSETS FOR BOX SIDES FROM TOP LEFT FROM SCREEN
; ADD 1 X AND 1 Y FOR EACH COLUMN
; TO MOVE DOWN A ROW, ADD 7 Y FOR EACH ROW

;        224,217           225,218              226,219              227,220             228,221
 
; 224,223        225,224             226,225               227,226              228,227            229,228

;        231,224           232,225              233,226              234,227             235,228					   

; 231,230        232,231             233,232               234,233              235,234            236,235             

;  
    
  
  add ix,bc
  add iy,de
  

  
  ; COORDINATES - TOP LEFT SIDES OF BOX = SAME VALUE AS BOTTOM RIGHT SIDES OF BOX BUT ON OPPOSITE REGISTER
  
  ; MARK SIDES AS WALKED AROUND BASED ON PLAYER DIRECTION?
  bit 0,a
  jr z,markleftandrightboxes
  set 0,(ix+#00) ; TOP AND BOTTOM SIDES DONE ?
  set 2,(iy+#00)
  jr checkrevealsarcophaguses
  markleftandrightboxes:
  set 1,(ix+#00) ; LEFT AND RIGHT SIDES DONE ?
  set 3,(iy+#00)
  
  ; REVEAL SARCOPHAGUS ON EITHER SIDE OF PLAYER?
  checkrevealsarcophaguses:
  ld a,(ix+#00)
  and %00001111  ; CHECK IF ALL BITS HAVE BEEN SET
  cp %00001111
  jr nz,revealonlyonesarcophagus

  ld a,(ix+#00)
  ld b,c
  push ix
  push iy
  push de
  call douncoversarcophagus
  pop de
  pop iy
  pop ix
  xor a          
  ld (ix+#00),a  ; DEACTIVATE BOX SO IT CAN'T BE REVEALED AGAIN
  
  revealonlyonesarcophagus:
  ld a,(iy+#00)
  and %00001111  ; CHECK IF ALL BITS HAVE BEEN SET
  cp %00001111
  ret nz
  ld a,(iy+#00)
  ld b,e
  push iy
  call douncoversarcophagus
  pop iy
  xor a
  ld (iy+#00),a  ; DEACTIVATE BOX SO IT CAN'T BE REVEALED AGAIN
ret

; INPUT
; B = BOX ID LOCATION ON SCREEN
; 1 = TOP LEFT CORNER
douncoversarcophagus:
  push af
  ld a,b
  dec a
  ld b,0
  l76f1:
    sub 7
    jr c,l76f8
    inc b
  jr l76f1

  l76f8:
  ; GET TREASURE BOX ID BASED ON COORD? 
  add 7
  add a
  ld c,a
  add a
  add a
  add a
  sub c
  add 8
  ld l,a
  ld a,b
  add a
  add a
  add a
  ld b,a
  add a
  add a
  add b
  ld h,a
  pop af
  
  ;push hl
  ;ld h,0
  ;ld l,a
  ;call debugprinthl
  ;pop hl
  
  ;cp 79                                     ; BOX NUMBER 79
  ;jr z,do_uncover_sarcophagus_random        ; FOUND TORCH OR ANKH
  ; WE FOUND TREASURE
  cp 31 ;#1f
  ret c
  jp z,do_uncover_sarcophagus_sarcophagus   ; EQUAL 31
  cp 63 ; #3f
  jp c,do_uncover_sarcophagus_key           ; EQUAL 47
  jp z,do_uncover_sarcophagus_guardianmummy ; EQUAL 63
  cp 95 ; #5f
  jr c,do_uncover_sarcophagus_random        ; EQUAL 79
  jp z,do_uncover_sarcophagus_treasure      ; EQUAL 95
  ; COLOURS BASED ON ROOM NUMBER
  ld a,(pyramidroomnumber)
  cp 2
  jr c,do_uncover_sarcophagus_blueblack
  jr z,do_uncover_sarcophagus_standard
  cp 4
  jr c,do_uncover_sarcophagus_yellowblack
  jr z,do_uncover_sarcophagus_tealgreen
jp fillpatternbox_orangebrown
  do_uncover_sarcophagus_tealgreen:
jp fillpatternbox_tealgreen
do_uncover_sarcophagus_yellowblack:
jp fillpatternbox_yellowblack
do_uncover_sarcophagus_standard:
jp fillpatternbox_standard
do_uncover_sarcophagus_blueblack:
jp fillpatternbox_blueblack
do_uncover_sarcophagus_scroll:
  ld (gotscroll),a
  push hl
  ld a,3                 ; INVERT SCORE COLOURS TO SHOW WE HAVE POWER
  call txt_set_paper
  xor a
  call txt_set_pen
  call printcurrentscore
  pop hl
jp uncover_sarcophagus_scroll

; UNCOVER EITHER TORCH, ANKH OR ELIXIR RANDOMLY
do_uncover_sarcophagus_random:
  ld a,4
  push hl
  call getrandomnumber
  pop hl
  or a
  jr z,do_uncover_sarcophagus_torch
  cp 1
  jr z,do_uncover_sarcophagus_elixir
  cp 2
  jr z,do_uncover_sarcophagus_scroll
do_uncover_sarcophagus_ankh:
  ld a,1
  ld (gotankh),a
  push hl
  ; SET ANKH/TORCH TIMER
  ld a,100
  ld (ankhtimer-1),a
  ld a,(soundeffects)
  cp "Y";#59
  call z,dolazerboltnoise
  pop hl
jp uncover_sarcophagus_ankh
do_uncover_sarcophagus_elixir:
  ld a,1
  ld (gotelixir),a
  
  ; ENABLE LOOP FOR SPEED WALKING
  ld a,2
  ld (loopforelixirspeed-1),a
  
  push hl
  ; SET ELIXIR TIMER
  ld a,100
  ld (elixirtimer-1),a
  ld a,(soundeffects)
  cp "Y";#59
  call z,dolazerboltnoise
  pop hl
jp uncover_sarcophagus_elixir

do_uncover_sarcophagus_torch:
  ld a,1
  ld (gottorch),a
  
  ; SET ANKH/TORCH TIMER
  ld a,100
  ld (torchtimer-1),a
  
  push hl
  push de
  call enablefirefootprints
  pop de
;  pop hl
;  push hl
  ld a,(soundeffects)
  cp "Y";#59
  call z,dolazerboltnoise
  pop hl
jp uncover_sarcophagus_torch

do_uncover_sarcophagus_key:
  ld (gotexitkey),a
  push hl
  ld a,(soundeffects)
  cp "Y";#59
  call z,dolazerboltnoise
  pop hl
jp uncover_sarcophagus_key

do_uncover_sarcophagus_sarcophagus:
  ld (gotroyalmummy),a ; GOT ROYAL MUMMY
  push hl
  ld hl,(playerscore)
  ld bc,#0032
  add hl,bc
  ld (playerscore),hl
  call printcurrentscore
  ld a,(soundeffects)
  cp "Y";#59
  call z,dolazerboltnoise
  pop hl
jp uncover_sarcophagus_sarcophagus

do_uncover_sarcophagus_guardianmummy:
  ; DON'T SPAWN NEW MUMMY IF WE HAVE NO ROOM FOR ANOTHER HARDWARE SPRITE
  ld a,(totalnumberofmummies)
  cp totalnumberofmummiesallowed
  jr z,do_uncover_sarcophagus_sarcophagus
  
  ld a,31; #1f
  ld (gotguardianmummy),a
  ld de,(playerspritexy)
  ld a,d
  sub h
  add e
  sub l
  cp 236 ; #ec           ; SET START LOCATION OF GUARDIAN MUMMY BASED ON COORDINATE OF BOX
  jr z,setguardiantopleft
  cp 20 ; #14
  jr z,setguardianbottomleft
  cp 250 ; #fa
  jr z,setguardiantopleft
  ld de,#0806
jr setguardianlocation

setguardiantopleft:
  ld de,#0000
jr setguardianlocation
setguardiantopright:
  ld de,#0006
jr setguardianlocation
setguardianbottomleft:
  ld de,#0800
  setguardianlocation:
  add hl,de
  ld (guardianmummyxy),hl
ret

do_uncover_sarcophagus_treasure:
  push hl
  ld hl,(playerscore)
  ld bc,#0005
  add hl,bc
  ld (playerscore),hl
  call printcurrentscore
  ld a,(soundeffects)
  cp "Y"
  call z,docleansweepnoise
  pop hl
jp uncover_sarcophagus_treasure

;DEBUGOBJECTMAP equ 1

checkplayer1input:
  ld hl,0
  ld (setplayermovedirectionc),hl
  ld (setplayermovedirectionb),hl
  ld hl,setplayermovedirection
  
  call testkeyleft
  jr nz,notpressedleft
  ld a,4
  ld (setplayermovedirection),a  
  notpressedleft:
  call testkeydown
  jr nz,notpresseddown
  ld a,3
  ld (setplayermovedirection-1),a  
  notpresseddown:
  call testkeyright
  jr nz,notpressedright
  ld a,2
  ld (setplayermovedirection-2),a  
  notpressedright:
  call testkeyup
  jr nz,notpressedup
  ld a,1
  ld (setplayermovedirection-3),a  
  notpressedup:
  ld ix,setplayermovedirection-4

  ld a,(playerspritedirection)
  cp 2
  jr c,l782f ; 1?
  jr z,l7821 ; 2?
  cp 4
  jr c,l7813  ;3?
  ld l,(ix+#01)
  ld h,(ix+#03)
  ld e,(ix+#02)
  ld d,(ix+#04)
jr setmovedirection
l7813:
  ld l,(ix+#04)
  ld h,(ix+#02)
  ld e,(ix+#01)
  ld d,(ix+#03)
jr setmovedirection
l7821:
  ld l,(ix+#03)
  ld h,(ix+#01)
  ld e,(ix+#04)
  ld d,(ix+#02)
jr setmovedirection
l782f:
  ld l,(ix+#02)
  ld h,(ix+#04)
  ld e,(ix+#03)
  ld d,(ix+#01)
setmovedirection:
  ld (setplayermovedirectionc),hl
  ld (setplayermovedirectionb),de
  ld b,4
  l7844:
    push bc
    inc ix
    ld a,(ix+#00)
    or a
    jr z,skipmovedirection
    ld (playerspritedirection),a
		
    ld hl,(playerspritexy)
    call moveactualspriteposition
	
    call checkobjectmapcollision
    jr z,skipmovedirection            ; BLOCKAGE - RESTRICT MOVEMENT
    pop bc
	
	call enternewburnp1               ; IF WE HAVE TORCH, DRAW NEW BURN
	 
    call moveplayerspritedirection    ; MOVE PLAYER SPRITE
	
	ifdef DEBUGOBJECTMAP
     ;call printdebugtext2
    endif
	ret
	
    skipmovedirection:
    pop bc
  djnz l7844
ret
  
; ------------------------------------------------------------
; PLAYER 2
; ------------------------------------------------------------

checkplayer2input:
  ld hl,0
  ld (setplayermovedirection2c),hl
  ld (setplayermovedirection2b),hl
  ld hl,setplayermovedirection2
  
  call testkeyleft2
  jr nz,notpressedleft2
  ld a,4
  ld (setplayermovedirection2),a  
  notpressedleft2:
  call testkeydown2
  jr nz,notpresseddown2
  ld a,3
  ld (setplayermovedirection2-1),a  
  notpresseddown2:
  call testkeyright2
  jr nz,notpressedright2
  ld a,2
  ld (setplayermovedirection2-2),a  
  notpressedright2:
  call testkeyup2
  jr nz,notpressedup2
  ld a,1
  ld (setplayermovedirection2-3),a  
  notpressedup2:
  ld ix,setplayermovedirection2-4

  ld a,(playerspritedirection2)
  cp 2
  jr c,l782fa ; 1?
  jr z,l7821a ; 2?
  cp 4
  jr c,l7813a  ;3?
  ld l,(ix+#01)
  ld h,(ix+#03)
  ld e,(ix+#02)
  ld d,(ix+#04)
jr setmovedirection2
l7813a:
  ld l,(ix+#04)
  ld h,(ix+#02)
  ld e,(ix+#01)
  ld d,(ix+#03)
jr setmovedirection2
l7821a:
  ld l,(ix+#03)
  ld h,(ix+#01)
  ld e,(ix+#04)
  ld d,(ix+#02)
jr setmovedirection2
l782fa:
  ld l,(ix+#02)
  ld h,(ix+#04)
  ld e,(ix+#03)
  ld d,(ix+#01)
setmovedirection2:
  ld (setplayermovedirection2c),hl
  ld (setplayermovedirection2b),de
  ld b,4
  l7844a:
    push bc
    inc ix
    ld a,(ix+#00)
    or a
    jr z,skipmovedirection2
    ld (playerspritedirection2),a
		
    ld hl,(playerspritexy2)
    call moveactualspriteposition
    call checkobjectmapcollision
    jr z,skipmovedirection2                           ; BLOCKAGE - RESTRICT MOVEMENT
    pop bc
	
	call enternewburnp2               ; IF WE HAVE TORCH, DRAW NEW BURN
	
    call moveplayer2spritedirection;:movespritefunc    ; MOVE PLAYER SPRITE
	
	ifdef DEBUGOBJECTMAP
     ;call printdebugtext2
    endif
	ret
	
    skipmovedirection2:
    pop bc
  djnz l7844a
ret
  
  
;  DEBUGOBJECTMAP equ 1
ifdef DEBUGOBJECTMAP

debugprinthl:
  push af
  push bc
  push de

    ; PRINT COORDS
	push hl
    ld l,h
    ld h,0
    call convwordtostr
	ld hl,#0801
    call my_txt_set_cursor_main
    ld hl,wordtostr2
    call printstring_oldnontransp

	pop hl
	push hl

    ld h,0
    call convwordtostr
	ld hl,#0c01
    call my_txt_set_cursor_main
    ld hl,wordtostr2
    call printstring_oldnontransp
	pop hl
	
  pop de
  pop bc
  pop af
ret


;WORLDCOORDINATESXY: defb 0
;WORLDCOORDINATESY: defb 0
ifdef beuh
printcoords:
    ; PRINT COORDS
    ld a,(worldcoordinatesxy)
    ld l,a
    ld h,0
    call convwordtostr
	ld hl,#0801
    call my_txt_set_cursor_main
    ld hl,wordtostr2
    call printstring_oldnontransp

    ld a,(worldcoordinatesy)
    ld l,a
    ld h,0
    call convwordtostr
	ld hl,#0c01
    call my_txt_set_cursor_main
    ld hl,wordtostr2
    jp printstring_oldnontransp

printdebugtext2:
    ; PRINT COORDS
    ld a,(playerspritexy)
    ld l,a
    ld h,0
    call convwordtostr
	ld hl,#0502
    call my_txt_set_cursor_main
    ld hl,wordtostr
    call printstring_oldnontransp

    ld a,(playerspritey)
    ld l,a
    ld h,0
    call convwordtostr
	ld hl,#0c02
    call my_txt_set_cursor_main
    ld hl,wordtostr
    call printstring_oldnontransp

    ; PRINT EXIT REACHED
    ld de,(playerspritexy)
	call mygetobjectmaplocationfromde
	ld a,(hl)
	ld (txt_debug2),a
	ld hl,#0b02
    call my_txt_set_cursor_main
	ld hl,txt_debug2
	call printstring_oldnontransp
    ld a,(txt_debug2)
	cp 244;1       ; REACHED EXIT
	jr nz,skipprintexit
	
    ;ld a,1
	;ld (foundexit-1),a

	ld hl,#0b02
    call my_txt_set_cursor
	
	ld hl,txt_debug
	;call my_txt_output
	;ld hl,txt_debug
    call printstring_oldnontransp
	skipprintexit:
ret
printdebugtext:
    push af
    push hl
	push de
	ld hl,#0902
    call my_txt_set_cursor
	;pop af
	ld hl,txt_debug
	;call my_txt_output
	;ld hl,txt_debug
    call printstring_old
	pop de
	pop hl
	pop af
ret
endif
txt_debug2: defb 0,255

txt_debug: defb "EXIT",255
endif

; CONVERT A 16 BIT HEX TO STRING - EG FOR PLAYER MONEY
; INPUTS
; HL = NUMBER TO CONVERT
convwordtostr:
  ld bc,10000
  call convwordtostrloop
  ld (wordtostr+0),a  ; SAVE RESULT IN STRING
  ld bc,1000
  call convwordtostrloop
  ld (wordtostr+1),a  ; SAVE RESULT IN STRING
  ld bc,100
  call convwordtostrloop
  ld (wordtostr+2),a  ; SAVE RESULT IN STRING
  ld bc,10
  call convwordtostrloop
  ld (wordtostr+3),a  ; SAVE RESULT IN STRING
  ld a,l
  add 48
  ld (wordtostr+4),a  ; SAVE RESULT IN STRING
ret

; INPUTS
; BC = TENS HUNDREDS UNIT TO CHECK FOR
convwordtostrloop:
  xor a      ; RESET COUNTER
  convwordtostrloop2:
    sbc hl,bc
    inc a
  jr nc,convwordtostrloop2
  add hl,bc
  dec a
  add 48               ; CONVERT TO ASCII
ret

wordtostr:  defb 0,0
wordtostr2: defb 0,0,0,255

; ====================================================
; NORMAL NON GAME MOVEMENT
; ----------------------------------------------------

printpyramidroomnumber:
  ld h,0
  ld a,(pyramidroomscompleted)
  inc a
  ld l,a
  call convwordtostr 
  ld hl,#0b02
  call my_txt_set_cursor
  ld a,0
  call txt_set_paper
  ld a,3
  call txt_set_pen
  ld hl,wordtostr2
  call printstring_oldnontransp
  
  ld h,0
  ld a,(pyramidroomnumber)
  ld l,a
  call convwordtostr 
  ld hl,#0e02
  call my_txt_set_cursor
  ld a,":"
  ld (wordtostr2+1),a
  ld hl,wordtostr2+1
  jp printstring_oldnontransp

printcurrentscore:
  ld hl,#0901
  call my_txt_set_cursor
  ld hl,(playerscore)
  printscore:
  ld b,4                     ; NUMBER OF ZEROS TO PRINT AFTER SCORE?
  ld iy,data_highscoreslist
  printscoreloop:
    inc iy
    inc iy
    ld e,(iy+#00)
    ld d,(iy+#01)
  
    xor a
    ld a,48                  ; CONVERT DIGIT TO ASCII CHARACTER
    l787f:
      sbc hl,de
      jr c,l7886
      inc a
    jr l787f

    l7886:
    add hl,de
    call my_txt_output
  djnz printscoreloop
  ld a,48                    ; CONVERT DIGIT TO ASCII CHARACTER
  add l
  call my_txt_output
  ld a," "
  jp my_txt_output

; PAUSE GAME IF P PRESSED
checkpausegame:
   call testkeypause
   ret nz
   call km_wait_keyrelease
   doreadchar:
     call km_read_key
   jr nc,doreadchar
   jp km_wait_keyrelease

; INPUT 
; B = 1 OR 2 - PERFORM ODD OR EVEN MUMMY MOVEMENTS
domummymovements:
  ld a,(gotankh)                      ; PAUSE MUMMY MOVEMENTS IF WE HAVE THE ANKH
  or a
  jr nz,decrementankhtimer
  domummymovements2:
  push bc
  call movemummies
  pop bc
  ld a,2
  add b
  cp #15 ; 21                         ; HAVE WE MOVED ALL ODD / EVEN MUMMIES?               
  ld b,a
  jr c,domummymovements2              ; REPEAT MOVEMENT FUNCTION FOR EACH MUMMY UNTIL WE REACH MAX 20
ret

; DECREMENT ANKH TIMER
; IF THE TIMER IS ZERO, REMOVE ANKH POWER
decrementankhtimer:
  ld a,0:ankhtimer
  dec a
  ld (ankhtimer-1),a
  or a
  ret nz
  ; DISABLE ANKH
  ld (gotankh),a
ret
; DECREMENT TORCH TIMER
; IF THE TIMER IS ZERO, REMOVE TORCH POWER
decrementtorchtimer:
  ld a,(gottorch)
  or a
  ret z
  ld a,0:torchtimer
  dec a
  ld (torchtimer-1),a
  or a
  ret nz
  ld (gottorch),a
  jp disablefirefootprints ; MAKE SURE FIRE FOOTPRINTS ARE NOT STILL ENABLED
; DECREMENT ELIXIR TIMER
; IF THE TIMER IS ZERO, REMOVE ELIXIR POWER
decrementelixirtimer:
  ld a,(gotelixir)
  or a
  ret z
  ld a,0:elixirtimer
  dec a
  ld (elixirtimer-1),a
  or a
  ret nz
  ld (gotelixir),a
  ld a,1
  ld (loopforelixirspeed-1),a
ret

automoveplayersprite:
  ld a,(playerspritexy)
  cp #1a                               ; REACHED EXTREMITY OF BOX
  jr nz,automoveplayerspriteotherway
  ld a,2                               ; SET DIRECTION OF MOVEMENT RIGHT
  jr setplayerspritedirection
  
  automoveplayerspriteotherway:
  cp #34                               ; REACHED EXTREMITY OF BOX
  jr nz,moveplayerspritedirection
  ld a,4                               ; SET DIRECTION OF MOVEMENT LEFT
  setplayerspritedirection:
  ld (playerspritedirection),a

moveplayerspritedirection:
  ld a,84 ;#54 FOOTPRINTS
  ld de,(playerspritexy)

  call dodrawsprite
  ld a,(playerwalkinganimation)
  inc a;xor #01        ; CHANGE WALKING STANCE
  cp 2
  jr nz,skipresetanim2a
  xor a
  skipresetanim2a:
  ld (playerwalkinganimation),a

  ld a,(playerspritedirection)
  cp 2
  jr c,moveplayerlocationup
  jr z,moveplayerlocationright
  cp 3
  jr z,moveplayerlocationdown
  ; MOVE LEFT
  ld a,(playerspritexy)
  dec a
  dec a
jr finishplayerspritemovex

moveplayerlocationright:
  ld a,(playerspritexy)
  inc a
  inc a
jr finishplayerspritemovex

moveplayerlocationup:
  ld a,(playerspritey)
  ld b,8
  sub b
jr finishplayerspritemovey

moveplayerlocationdown:
  ld a,(playerspritey)
  ld b,8
  add b
finishplayerspritemovey:
  ld (playerspritey),a
  jr finishplayerspritemove
finishplayerspritemovex:
  ld (playerspritexy),a
  finishplayerspritemove:
  ld a,65;#41 PLAYER SPRITE
  ld de,(playerspritexy)
jp dodrawsprite


; -----------------------------------------------------
; PLAYER 2 SPRITE MOVEMENT
; -----------------------------------------------------

moveplayer2spritedirection:
  ld a,85 ;#54 FOOTPRINTS
  ld de,(playerspritexy2)
  call dodrawsprite

  ld a,(playerwalkinganimation2)
  inc a;xor #01        ; CHANGE WALKING STANCE
  cp 2
  jr nz,skipresetanim2aa
  xor a
  skipresetanim2aa:
  ld (playerwalkinganimation2),a

  ld a,(playerspritedirection2)
  cp 2
  jr c,moveplayer2locationup
  jr z,moveplayer2locationright
  cp 3
  jr z,moveplayer2locationdown
  ; MOVE LEFT
  ld a,(playerspritexy2)
  dec a
  dec a
jr finishplayer2spritemovex

moveplayer2locationright:
  ld a,(playerspritexy2)
  inc a
  inc a
jr finishplayer2spritemovex

moveplayer2locationup:
  ld a,(playerspritey2)
  ld b,8
  sub b
jr finishplayer2spritemovey

moveplayer2locationdown:
  ld a,(playerspritey2)
  ld b,8
  add b
finishplayer2spritemovey:
  ld (playerspritey2),a
  jr finishplayer2spritemove
finishplayer2spritemovex:
  ld (playerspritexy2),a
  finishplayer2spritemove:
  ld a,66;#42 PLAYER SPRITE
  ld de,(playerspritexy2)
jp dodrawsprite

; -----------------------------------------------------
; SPAWN MUMMIES
; -----------------------------------------------------

spawn_multiple_mummies:
  ld a,(totalnumberofmummies)
  ld b,a       
  spawn_multiple_mummies_loop:
    push bc
    call spawn_mummy
    pop bc
  djnz spawn_multiple_mummies_loop
ret

; SPAWN MUMMY
spawn_mummy_sweeper:
  ld c,1
  jr do_spawn_mummy
spawn_mummy:
  ld c,0
  do_spawn_mummy:
  ld a,(lastmummyidused)
  inc a
  ld (lastmummyidused),a

  ld b,a

  ld ix,gotguardianmummy
  ld de,mummydatablocksize
  l796a:
    add ix,de
  djnz l796a
  
  ld (ix+5),a ; RECORD MUMMY ID IN DATA BLOCK SO WE KNOW WHICH SPRITE IT BELONGS TO
  ld (ix+6),0 ; RESET COUNTER FOR SPRITE DESTRUCTION IF WE COLLIDE WITH PLAYER
  ld (ix+7),c ; NON-SWEEPER MUMMY?
  
  ld a,4
  call getrandomnumber
  inc a
  ld (ix+#00),a
  ld a,4
  call getrandomnumber
  inc a
  ld (ix+#01),a
  ld h,0
  ld a,(lastmummyidused)
  ld l,a
  add hl,hl
  ld de,(l8645)
  add hl,de
  ld e,(hl)
  inc hl
  ld d,(hl)
  ld (ix+#02),d
  ld (ix+#03),e
ret

; INPUT
; B = 1 OR 2 - SELECT MUMMY TO MOVE?
movemummies:
  ld ix,gotguardianmummy ; DATA AREA FOR MUMMIES
  ld de,mummydatablocksize
  l799d:
    add ix,de
  djnz l799d
  
  ; DOES MUMMY NEED FADED EVEN IF DEAD?
  ld a,(ix+6)
  or a
  call nz,domummyfadesprite
  
  ; SKIP IF MUMMY DEAD OR NOT ENABLED
  ld a,(ix+#00)
  or a
  jr nz,l79ac
  
  ld a,(ix+#01)
  or a
  ret z
  
  l79ac:
  ld (currentmummydatabblock),ix
  ; GET MUMMY POSITION
  ld d,(ix+#02)
  ld e,(ix+#03)
  ld (mummyspriteposition),de
  
  ; CHECK IF MUMMY IS IN CONTACT WITH BURN POSITION
  ld a,(gottorch)
  or a
  jr z,skipcheckmummyburn
  call checkmummyburnp1
  ret c                  ; STOP IF WE JUST KILLED MUMMY WITH BURN PLAYER 1
  call checkmummyburnp2 
  ret c                  ; STOP IF WE JUST KILLED MUMMY WITH BURN PLAYER 2
  skipcheckmummyburn:
  
  ; GET DIRECTON TO MOVE
  ld a,(gamedifficulty)
  call getrandomnumber
  or a
  call z,mummyseekplayerposition
  ld hl,(currentmummydatabblock)
  call movesinglemummy
  jp nz,clearmummytrail
  
  ld hl,(currentmummydatabblock)
  inc hl
  call movesinglemummy
  jp nz,clearmummytrail
  ld a,2
  call getrandomnumber
  or a
  jr nz,setmummydirectionbumpedwall
  ld d,(ix+#02)
  ld e,(ix+#03)
  jp drawmummyplussprite

setmummydirectionbumpedwall:
  ld b,(ix+#00)
  ld c,(ix+#01)
  dec a
  jr z,l79f7
  dec b
  dec c
  jr l79f9
  l79f7:
  inc b
  inc c
  l79f9:
  ld hl,l864b
  ld d,0
  ld e,b
  inc e
  add hl,de
  ld b,(hl)
  ld hl,l864b
  ld e,c
  inc e
  add hl,de
  ld c,(hl)
  ld (ix+#00),b
  ld (ix+#01),c
ret

movesinglemummy:
  ld a,(hl)
  ld (mummyspritedirection),a
  or a
  ret z
  ld hl,(mummyspriteposition)
  call moveactualspriteposition

  xor a
  ld (l8610),a
  ld iy,gotguardianmummy
  ld a,(lastmummyidused)
  ld b,a
  l7a25:
    push bc
    ld bc,mummydatablocksize
    add iy,bc
    ld a,(iy+#00)
    or (iy+#01)
    jr z,dontupdatemummyposition    ; IS MUMMY ALIVE?
    ld a,(iy+#02)
    sub d
    cp 248                          ; NOT REACHED EDGE OF SCREEN
    jr z,updatemummyposy
    cp 8                            ; NOT REACHED EDGE OF SCREEN
    jr z,updatemummyposy
    or a
    jr nz,dontupdatemummyposition
    updatemummyposy:
    ld a,(iy+#03)
    sub e
    cp 254                          ; NOT REACHED EDGE OF SCREEN
    jr z,updatemummyposx
    cp 2                            ; NOT REACHED EDGE OF SCREEN
    jr z,updatemummyposx
    or a
    jr nz,dontupdatemummyposition
    updatemummyposx:
    ld a,(l8610)
    inc a
    ld (l8610),a
    dontupdatemummyposition:
    pop bc
  djnz l7a25
  ld a,(l8610)
  cp 1
  jr z,checkobjectmapcollision
  xor a
ret

; CHECK OBJECT MAP FOR COLLISION
; INPUT
; E = HORIZ BYTE
; D = ROW
checkobjectmapcollision:
  ld (desiredplayerspriteposition),de
  ld iy,data_objectmap
  ld a,e
  srl a       ; BYTES - HALVE WIDTH - 80 TO 40
  ld b,0
  ld c,a
  add iy,bc   ; ROWS - MULTIPLY BY 6 TO ENSURE THERE IS AT LEAST 40 BYTES SPACE FOR EACH ROW (ACTUALLY 48)
  ld e,d
  ld d,0
  add iy,de
  add iy,de
  add iy,de
  add iy,de
  add iy,de
  ; CHECK EXTREMITIES OF SPRITE AGAINST OBJECT MAP FOR ANY OBJECT
  ; 0 = BLOCKAGE
  ld a,(iy+0)  ; CHECK LEFT BYTE
  or a
  ret z
  ld a,(iy+1)  ; CHECK RIGHT BYTE
  or a
  ret z
  ld a,(iy+40) ; CHECK NEXT ROW LEFT BYTE
  or a
  ret z
  ld a,(iy+41) ; CHECK NEXT ROW RIGHT BYTE
  or a
ret

; INPUT
; HL = SPRITE COORDINATES
; OUTPUT
; DE = NEW SPRITE POSITION
moveactualspriteposition:
  cp 2
  jr c,movespriteup8
  jr z,movespriteright8
  cp 3
  jr z,movespritedown8
  
  ; MOVE SPRITE LEFT
  dec l
  dec l
  ex de,hl
ret
movespritedown8:
  ld a,h
  add 8
  ld h,a
  ex de,hl
ret
movespriteright8:
  inc l
  inc l
  ex de,hl
ret
movespriteup8:
  ld a,h
  sub 8
  ld h,a
  ex de,hl
ret

; SEEK PLAYER 1 AND 2 ALTERNATELY
seekplayertoggle: defb 0

mummyseekplayerposition:
  ld a,(player2alive)
  or a
  jr z,mummyseekplayerposition_p1
  
  ld a,(seekplayertoggle)
  xor 1
  ld (seekplayertoggle),a
  or a
  jr z,mummyseekplayerposition_p1

  ; LOAD PLAYER 2 POSITION
  ld a,(playerspritexy2)
  ld (playerxycoord-1),a
  ld a,(playerspritey2)
  jr domummyseekplayerposition
mummyseekplayerposition_p1:
  ; LOAD PLAYER 1 POSITION
  ld a,(playerspritexy)
  ld (playerxycoord-1),a
  ld a,(playerspritey)

  domummyseekplayerposition:
  ld bc,(mummyspriteposition)
  ;ld a,(playerspritey)
  sub b
  jr c,l7ac6
  jr z,l7ac8
  ld a,3
  jr l7ac8
  l7ac6:
  ld a,1
  l7ac8:
  ld (l815f),a
  ld a,0:playerxycoord;(playerspritexy)
  sub c
  jr c,l7ad7
  jr z,l7ad9
  ld a,2
  jr l7ad9
  l7ad7:
  ld a,4
  l7ad9:
  ld (l8160),a
  ld a,2
  call getrandomnumber
  ld bc,(l815f)
  or a
  jr z,setnewmummydirection
  ld a,b
  ld b,c
  ld c,a
  setnewmummydirection:
  ld (ix+#00),b
  ld (ix+#01),c
ret

; NORMALLY REDRAWS WHATEVER TILE WAS UNDER MUMMY, PLAYER FOOTPRINTS OR EMPTY
; SWEEPER MUMMY MUST ERASE TILE

clearmummytrailsweeper:
  ld de,(mummyspriteposition)
  ld a,(mummyspritedirection)
  cp 2
  jr c,l7b19a
  jr z,l7b05a
  cp 3
  jr z,l7b1da
  inc e
  inc e
  
  ; NEED TO WIPE MAP OBJECTS, PLAYER FOOTPRINTS, HERE FOR SWEEPER MUMMY
  
  l7b05a:
  xor a
  call clearspritetrailsweeper               ; REDRAW FOOTPRINTS FROM MAP - NOT NEEDED FOR PLUS SPRITES
  ld a,8
  add d
  ld d,a
  xor a
  call clearspritetrailsweeper
  jr l7b2da
  
  l7b19a:
  ld a,8
  add d
  ld d,a
  l7b1da:
  xor a
  call clearspritetrailsweeper
  inc e
  inc e
  xor a
  call clearspritetrailsweeper
  
  l7b2da:
  ld de,(desiredplayerspriteposition)
  ld (ix+#02),d
  ld (ix+#03),e
  
  call drawmummyplussprite
  jp checkhasboxbeenwalkedround_mummy

clearmummytrail:
  ld a,(ix+7)
  cp 1 ; IS SWEEPER MUMMY?
  jr z,clearmummytrailsweeper
  
  ;jr l7b2d ; SKIP DIRECTLY TO DRAWING SPRITE

  ; ----------------------------------------------------------------------------
  ; REDRAW FOOTPRINTS FROM MAP AFTER MUMMY MOVES - NOT NEEDED FOR PLUS SPRITES

  ;ld de,(mummyspriteposition)
  ;ld a,(mummyspritedirection)
  ;cp 2
  ;jr c,l7b19
  ;jr z,l7b05
  ;cp 3
  ;jr z,l7b1d
  ;inc e
  ;inc e
 
  ;l7b05:
  ;call getobjectmaplocationfromde
  ;ld a,(hl)
  ;call clearspritetrail               
  ;ld a,8
  ;add d
  ;ld d,a
  ;call getobjectmaplocationfromde
  ;ld a,(hl)
  ;call clearspritetrail
  ;jr l7b2d
  
  ;l7b19:
  ;ld a,8
  ;add d
  ;ld d,a
  ;l7b1d:
  ;call getobjectmaplocationfromde
  ;ld a,(hl)
  ;call clearspritetrail
  ;inc e
  ;inc e
  ;call getobjectmaplocationfromde
  ;ld a,(hl)
  ;call clearspritetrail
  
  ; ----------------------------------------------------------------------------
  
  l7b2d:
  ld de,(desiredplayerspriteposition)
  ld (ix+#02),d
  ld (ix+#03),e
  ld a,79;#4f ; DRAW MUMMY
  
  dodrawsprite:
  push af
  ld a,16;#10
  ld (setspriteheightmod),a
  ld a,4
  ld (spritewidthmodifier),a
  pop af
  cp 32;#20
  jr z,drawimageblank
  cp 84;#54
  jr z,drawfootprintsplayer1
  cp 85
  jp z,drawfootprintsplayer2
  cp 65;#41
  jp z,drawplayersprite
  cp 66;#41
  jp z,drawplayer2sprite
  cp 79;#4f
  jp z,drawmummyplussprite

  ld iy,image_blank2
  jp drawsprite
  
drawimageblank:
  ld iy,image_blank
  jp drawsprite

enablefirefootprints:
  ld hl,fireimagetable
  jr setfirefootprints
disablefirefootprints:
  ld hl,footprintsimagetable
  setfirefootprints:
  ld de,defaultimagetable
  ld bc,16
  ldir
ret

; FOOTPRINTS IMAGES CURRENTLY USED
defaultimagetable:
  defw image_footprintsleft
  defw image_footprintsleft2
  defw image_footprintsdown
  defw image_footprintsdown2
  defw image_footprintsright
  defw image_footprintsright2
  defw image_footprintsup
  defw image_footprintsup2
; FIRE FOOTPRINT IMAGES
fireimagetable:
  defw image_fire1
  defw image_fire2
  defw image_fire1
  defw image_fire2
  defw image_fire1
  defw image_fire2
  defw image_fire1
  defw image_fire2
; NORMAL FOOTPRINT IMAGES
footprintsimagetable:
  defw image_footprintsleft
  defw image_footprintsleft2
  defw image_footprintsdown
  defw image_footprintsdown2
  defw image_footprintsright
  defw image_footprintsright2
  defw image_footprintsup
  defw image_footprintsup2

; INPUTS
; A = PLAYER DIRECTION
; DE = PLAYER LOCATION
; DRAWING FOOTPRINTS DOES NOT REVEAL TREASURE BOX
; IT JUST DRAWS THE FOOTPRINT SPRITE AND MARKS THE OBJECT MAP WITH THE CORRECT TILE ID FOR REDRAWING
drawfootprintsplayer1:
  ld a,(playerspritedirection)
  cp 2
  jp c,drawfootprintsup
  jr z,drawfootprintsright
  cp 3
  jr z,drawfootprintsdown
  ld iy,(defaultimagetable+0)
  ld a,2
  ld (spritewidthmodifier),a
  inc e
  inc e
  
  call getobjectmaplocationfromde
  ld a,8
  ld (hl),a
  add 24;#18
  ld bc,#0028
  add hl,bc
  ld (hl),a
  
  ld a,(playerwalkinganimation)
  or a
  jp z,drawsprite
  ld iy,(defaultimagetable+2)
  ld a,7
  ld (hl),a
  add #19
  sbc hl,bc
  ld (hl),a
jp drawsprite
drawfootprintsdown:
  ld iy,(defaultimagetable+4)
  ld a,8
  ld (setspriteheightmod),a
  call getobjectmaplocationfromde
  ld a,6
  ld (hl),a
  ld a,#20
  inc hl
  ld (hl),a
  ld a,(playerwalkinganimation)
  or a
  jp z,drawsprite
  ld iy,(defaultimagetable+6)
  ld a,5
  ld (hl),a
  ld a,#20
  dec hl
  ld (hl),a
jp drawsprite

drawfootprintsright:
  ld iy,(defaultimagetable+8)
  ld a,2
  ld (spritewidthmodifier),a
  call getobjectmaplocationfromde
  ld a,3
  ld (hl),a
  add #1d
  ld bc,#0028 
  add hl,bc
  ld (hl),a
  ld a,(playerwalkinganimation)
  or a
  jp z,drawsprite              ; DRAW FIRST PART OF FOOTPRINT BASED ON WHETHER PLAYER IS STEPPING
  ld iy,(defaultimagetable+10) ; DRAW SECOND PART OF FOOTPRINT
  ld a,4
  ld (hl),a
  add #1c
  sbc hl,bc
  ld (hl),a
jp drawsprite
drawfootprintsup:
  ld iy,(defaultimagetable+12)
  ld a,8
  ld (setspriteheightmod),a
  add d
  ld d,a
  call getobjectmaplocationfromde
  ld a,1
  ld (hl),a
  ld a,#20
  inc hl
  ld (hl),a
  ld a,(playerwalkinganimation)
  or a
  jp z,drawsprite
  ld iy,(defaultimagetable+14)
  ld a,2
  ld (hl),a
  ld a,#20
  dec hl
  ld (hl),a
jp drawsprite

drawplayersprite:
  ld a,(playerspritedirection)
  cp 2
  jr c,drawplayerdown
  jr z,drawplayerright
  cp 3
  jr z,drawplayerup
  ld a,(playerwalkinganimation)
  add 4
  jp updateplayersprite
drawplayerup:
  ld a,(playerwalkinganimation)
  jp updateplayersprite
drawplayerright: 
  ld a,(playerwalkinganimation)
  add 6
  jp updateplayersprite
drawplayerdown:
  ld a,(playerwalkinganimation)
  add 2
  jp updateplayersprite
 
; --- PLAYER 2 ----
 
drawfootprintsplayer2:
  ld a,(playerspritedirection2)
  cp 2
  jp c,drawfootprintsup2
  jr z,drawfootprintsright2
  cp 3
  jr z,drawfootprintsdown2
  ld iy,(defaultimagetable+0);image_footprintsleft
  ld a,2
  ld (spritewidthmodifier),a
  inc e
  inc e
  
  call getobjectmaplocationfromde
  ld a,8
  ld (hl),a
  add 24;#18
  ld bc,#0028
  add hl,bc
  ld (hl),a
  
  ld a,(playerwalkinganimation2)
  or a
  jp z,drawsprite
  ld iy,(defaultimagetable+2);image_footprintsleft2
  ld a,7
  ld (hl),a
  add #19
  sbc hl,bc
  ld (hl),a
jp drawsprite
drawfootprintsdown2:
  ld iy,(defaultimagetable+4);image_footprintsdown
  ld a,8
  ld (setspriteheightmod),a
  call getobjectmaplocationfromde
  ld a,6
  ld (hl),a
  ld a,#20
  inc hl
  ld (hl),a
  ld a,(playerwalkinganimation2)
  or a
  jp z,drawsprite
  ld iy,(defaultimagetable+6);image_footprintsdown2
  ld a,5
  ld (hl),a
  ld a,#20
  dec hl
  ld (hl),a
jp drawsprite
drawfootprintsright2:
  ld iy,(defaultimagetable+8);image_footprintsright
  ld a,2
  ld (spritewidthmodifier),a
  call getobjectmaplocationfromde
  ld a,3
  ld (hl),a
  add #1d
  ld bc,#0028 
  add hl,bc
  ld (hl),a
  ld a,(playerwalkinganimation2)
  or a
  jp z,drawsprite              ; DRAW FIRST PART OF FOOTPRINT BASED ON WHETHER PLAYER IS STEPPING
  ld iy,(defaultimagetable+10);image_footprintsright2 ; DRAW SECOND PART OF FOOTPRINT
  ld a,4
  ld (hl),a
  add #1c
  sbc hl,bc
  ld (hl),a
jp drawsprite
drawfootprintsup2:
  ld iy,(defaultimagetable+12);image_footprintsup
  ld a,8
  ld (setspriteheightmod),a
  add d
  ld d,a
  call getobjectmaplocationfromde
  ld a,1
  ld (hl),a
  ld a,#20
  inc hl
  ld (hl),a
  ld a,(playerwalkinganimation2)
  or a
  jp z,drawsprite
  ld iy,(defaultimagetable+14);image_footprintsup2
  ld a,2
  ld (hl),a
  ld a,#20
  dec hl
  ld (hl),a
jp drawsprite
 
drawplayer2sprite:
  ld a,(playerspritedirection2)
  cp 2
  jr c,drawplayer2down
  jr z,drawplayer2right
  cp 3
  jr z,drawplayer2up
  ld a,(playerwalkinganimation2)
  add 4
  jp updateplayer2sprite
drawplayer2up:
  ld a,(playerwalkinganimation2)
  jp updateplayer2sprite
drawplayer2right: 
  ld a,(playerwalkinganimation2)
  add 6
  jp updateplayer2sprite
drawplayer2down:
  ld a,(playerwalkinganimation2)
  add 2
  jp updateplayer2sprite

; DRAW MUMMY
; IX = DATA STRUCTURE OF MUMMY TO DRAW
drawmummyplussprite:
  ; ALTERNATE IMAGE FOR WALKING
  ld a,(ix+4)
  inc a
  cp 2
  jr nz,skipresetmummywalkinganimation
  xor a
  skipresetmummywalkinganimation:       
  ld (ix+4),a
  push af
  
  ld a,(mummyspritedirection)
  cp 2
  jr c,drawmummyplusup
  jr z,drawmummyplusright
  cp 3
  jr z,drawmummyplusdown
  pop af
  add 4
  jp updatemummysprite
drawmummyplusup:
  pop af
  add 2
  jp updatemummysprite
drawmummyplusright: 
  pop af
  add 6
  jp updatemummysprite
drawmummyplusdown:
  pop af
  jp updatemummysprite

; DISPLAY FADED MUMMY SPRITE AND DEPLETE COUNTER
domummyfadesprite:
  ; DEPLETE ASIC IMAGE FADE COUNTER
  ld a,(ix+6)
  dec a
  ld (ix+6),a 
  ; IF COUNTER 0, JUST HIDE SPRITE
  or a
  jp z,hideplussprite_getid
  
  add 8                             ; GET CORRECT POSITION FOR START OF FADED MUMMY IMAGES IN TABLE
  jp drawmummyspritenomovement      ; UPDATE SPRITE IN ASIC

hideplussprite_getid:
  ld b,(ix+5)
  jp hideplussprite 

drawsprite:
  push de
  ex de,hl
  call getscreenaddress
  setspriteheightmod equ $ + 1 ; SPRITE HEIGHT
  ld b,#10
  ld de,iy
  drawspriteloop:
    push bc
    push hl
    spritewidthmodifier equ $ + 1 ; SELF MODIFYING
    ld b,4 
    drawspriterow:
      ld a,(de)
      inc de
      ld (hl),a
      inc hl
    djnz drawspriterow
	pop hl
	call scr_next_line_hl
    pop bc
  djnz drawspriteloop
  pop de
ret

; REDRAWS FOOTPRINTS WHEN MUMMY WALKS OVER THEM
; NOT NEEDED FOR PLUS SPRITES
; INPUT 
; HL = PTR TO MAP TILE ID
clearspritetrail:
  cp 2
  jr c,dofootprintsupleft
  jr z,dofootprintsupright
  cp 4
  jr c,dofootprintsrighttop
  jr z,dofootprintsrightbottom
  cp 6
  jr c,dofootprintsdownright
  jr z,dofootprintsdownleft
  cp 8
  jr c,dofootprintslefttop
  jr z,dofootprintsleftbottom
clearspritetrailsweeper:
  ld iy,image_blank
jr dodrawsmallsprite
dofootprintsleftbottom:
  ld iy,image_footprintsleft
jr dodrawsmallsprite
dofootprintslefttop:
  ld iy,l8aa9
jr dodrawsmallsprite
dofootprintsdownleft:
  ld iy,l8a69
jr dodrawsmallsprite
dofootprintsdownright:
  ld iy,l8a79
jr dodrawsmallsprite
dofootprintsrightbottom:
  ld iy,l8a19
jr dodrawsmallsprite
dofootprintsrighttop:
  ld iy,image_footprintsright
jr dodrawsmallsprite
dofootprintsupright:
  ld iy,l89e9
jr dodrawsmallsprite
dofootprintsupleft:
  ld iy,l89d9
  dodrawsmallsprite:
  ld a,8
  ld (setspriteheightmod),a
  ld a,2
  ld (spritewidthmodifier),a
jp drawsprite


; INPUT
; D = VERTICAL POSITION IN LINES
; E = HORIZONTAL POSITION IN BYTES
mygetobjectmaplocationfromde:
  ld hl,my_data_objectmap
  jr getobjectmaplocationfromde2
; GET OBJECT FROM MAP USING DE AS LOCATION?
getobjectmaplocationfromde:
  ld hl,data_objectmap
  getobjectmaplocationfromde2:
  push de
  ; HORIZONTAL
  ld a,e
  srl a       ; DIVIDE HORIZ BYTES BY 2. REDUCE 80 COL TO 40
  ld b,0
  ld c,a
  add hl,bc   ; 0 + 5
  
  ; VERTICAL  ; MULTIPLY ROWS BY 6 - THIS ENSURES THERE IS AT LEAST 40 BYTES FOR EACH ROW (ACTUALLY 48)
  ld e,d      ; EG 16, 8 - START OF ROW TO FIND

  ld d,0
  add hl,de   ;    32, 16
  add hl,de   ;    48, 24
  add hl,de   ;    64, 32
  add hl,de   ;    80, 40 
  add hl,de   ;    96, 48 - START OF ROW IN MAP
  
  pop de
ret

; GET RANDOM RESULT FROM RANGE BASED ON TIMER
; a = TOP RANGE NUMBER
getrandomnumber:
  ld de,(currenttime)
  call l7d78
  push hl
  ld e,75;#4b
  ld a,(currenttime)
  call l7d78
  ld de,#004b
  add hl,de
  ld de,#0101
  xor a
  l7d6b:
  sbc hl,de
  jr c,l7d71
jr l7d6b

l7d71:
  add hl,de
  dec hl
  ld (currenttime),hl
  pop af
ret

l7d78:
  ld h,a
  ld l,0
  ld d,l
  ld b,8
  l7d7e:
    add hl,hl
    jr nc,l7d82
    add hl,de
    l7d82:
  djnz l7d7e
ret

uncover_sarcophagus_elixir:
  ld iy,(image_elixir)
  jr dodrawsarcophagusimageorange

uncover_sarcophagus_ankh:
  ld iy,(image_ankh)
  jr dodrawsarcophagusimageblue

uncover_sarcophagus_torch:
  ld iy,(image_torch)
  jr dodrawsarcophagusimageblue

uncover_sarcophagus_sarcophagus: 
  ld iy,(image_sarcophagus)
  jr dodrawsarcophagusimageblue

uncover_sarcophagus_key:
  ld iy,(image_key)
  jr dodrawsarcophagusimageblue

uncover_sarcophagus_scroll:
  ld iy,(image_scroll)
  dodrawsarcophagusimageblue:
  ld (l8645),hl
  call drawbluetreasurebox
  ld hl,(l8645)
  ld bc,#0602
  add hl,bc
  ld (l8645),hl
  jp displaysarcophagusimage

uncover_sarcophagus_treasure: 
  ld iy,(image_treasure)
  dodrawsarcophagusimageorange:
  ld (l8645),hl
  call draworangetreasurebox
  ld hl,(l8645)
  ld bc,#0602
  add hl,bc
  ld (l8645),hl
  jp displaysarcophagusimage

draworangetreasurebox:
  ld a,#0f
  ld (sarcophagusfillpatternmod-1),a
jp drawsarcophagusbgcol
drawbluetreasurebox:
  ld a,#ff
  ld (sarcophagusfillpatternmod-1),a
jp drawsarcophagusbgcol
drawoyellowtreasurebox: ; NOT USED BY GAME
  xor a
  ld (sarcophagusfillpatternmod-1),a
jp drawsarcophagusbgcol

fillpatternbox_orangebrown:
  ld a,#ff
  ld (currentboxfillpattern),a
  ld a,#a5
jr l7e30
fillpatternbox_mauveblue:
  ld a,#f0
  ld (currentboxfillpattern),a
  ld a,#af
jr l7e30
fillpatternbox_blueblack:
  ld a,#0f
  ld (currentboxfillpattern),a
  ld a,#fa
jr l7e30
fillpatternbox_yellowblack:
  ld a,#f0
  ld (currentboxfillpattern),a
  ld a,#50
jr l7e30
fillpatternbox_tealgreen:
  ld a,#ff
  ld (currentboxfillpattern),a
  ld a,#55
jr l7e30
fillpatternbox_standard:
  ld a,#0f
  ld (currentboxfillpattern),a
  ld a,5
l7e30:
  ld (sarcophagusfillpatternmod-1),a
  ld a,10
  ld (cursorentrylength),a
  ld (myscraddr),hl
  ld b,#18
  fillpatternloop:
    push bc
    ld b,1
    call l7e59
    ld a,(sarcophagusfillpatternmod-1)
    currentboxfillpattern equ $ + 1 ; SELF MODIFYING CODE
    xor #0f
    ld (sarcophagusfillpatternmod-1),a
    pop bc
  djnz fillpatternloop
ret

; HL = POSITION TO DRAW
drawpyramidblock:
  call fillpatternbox_standard
  
  ld a,#ff
  ld (currentboxfillpattern),a
  ld a,#a5
  ld (sarcophagusfillpatternmod-1),a
  ld a,10
  ld (cursorentrylength),a
  ld (myscraddr),hl
  
  ld b,12 ; DRAW HALF BLOCK
  jp fillpatternloop

drawsarcophagusbgcol:
  ld a,10
  ld (cursorentrylength),a
  ld b,#18
  ld (myscraddr),hl
  l7e59:
    push bc
    call getscreenaddress
    ld a,(cursorentrylength)
    ld b,a
    ld a,0:sarcophagusfillpatternmod;(sarcophagusfillpattern)
    l7e64:
      ld (hl),a
      inc hl
    djnz l7e64
    ld hl,(myscraddr)
    inc h
    ld (myscraddr),hl
    pop bc
  djnz l7e59
ret

; DISPLAY OPENED SARCOPHAGUS IMAGE
; IY = IMAGE TO DISPLAY
displaysarcophagusimage:
  ld b,12 ; 12 ROWS HIGH
  ld (myscraddr),hl
  l7e78:
    push bc
    call getscreenaddress
    ld b,6 ; 6 BYTES WIDE
    l7e7e:
      ld a,(iy+#00)
      inc iy
      ld (hl),a
      inc hl
    djnz l7e7e
    ld hl,(myscraddr)
    inc h
    ld (myscraddr),hl
    pop bc
  djnz l7e78
ret

; INPUT 
; HL = SCREEN ADDRESS
getscreenaddress:
  ld d,l
  ld c,h
  ld b,0
  ld hl,screenptrtable
  add hl,bc
  add hl,bc
  ld a,(hl)
  inc hl
  ld h,(hl)
  ld l,a
  ld c,d
  add hl,bc          ; ADD X COORD
ret

; ERASE OBJECT MAP FOR NEW LEVEL
wipeobjectmaps:
  xor a
  ld hl,mummyspritedatablock
  ld (hl),a
  ld de,mummyspritedatablock+1
  ld bc,1181+20+20;#049d
  ldir
  ; MY OWN OBJECT MAP
  ld hl,my_data_objectmap
  ld (hl),a
  ld de,my_data_objectmap+1
  ld bc,1037
  ldir
ret

; DRAW MUMMY CORRIDOR
; HL = TOP LEFT COORD
; DE = BOTTOM RIGHT COORD
drawbox:
  ld a,#20              ; NORMAL PATH
  drawboxcustom:
  ld (objectinsert-1),a ; CUSTOM OBJECT INSERTION

  push hl
  ld iy,data_objectmap_toprow
  ld b,0
  ld c,h
  add iy,bc
  ld b,l
  inc b
  push de
  
  ; GET HORIZONTAL ROW
  ld de,#0028
  l7ec9:
    add iy,de
  djnz l7ec9
  pop de
  ld a,e
  inc a
  sub l
  ld b,a
  
  ; CLEAR OBJECT PATH FOR MUMMIES TO WALK
  l7ed2:
    push bc
    ld a,d
    inc a
    sub h
    ld b,a
    ld a,#20:objectinsert ; OBJECT ID TO INSERT - ZERO = BLOCKAGE
    push iy
    l7edb:
      ld (iy+#00),a
      inc iy
    djnz l7edb
    ld bc,#0028
    pop iy
    add iy,bc
    pop bc
  djnz l7ed2 
  
  pop hl
  call my_txt_set_window
  jp my_txt_clear_window

; INPUT
; HL = STRING TO PRINT AT GFX POS
printstring_old:
  ;ld b,(hl) ; NUMBER OF CHARS
    ;inc hl
    ld a,(hl)
	cp 255
    ret z
    call my_txt_outputtransp
	inc hl
  jr printstring_old
; INPUT
; HL = STRING TO PRINT AT GFX POS
printstring_oldnontransp:
  ;ld b,(hl) ; NUMBER OF CHARS
    ;inc hl
    ld a,(hl)
	cp 255
    ret z
    call my_txt_output
	inc hl
  jr printstring_oldnontransp

; =============================================================
; MY INTERRUPT AND KEYBOARD FUNCTIONS
; -------------------------------------------------------------

interruptcountermummies:defb 0
interruptcounter2:      defb 0
interruptcounter3:      defb 0
interrupt_stack:        defs 256
interrupt_stack_start:

timepleasehl:           defw 0
timepleasede:           defw 0

matrix_buffer:          defb 255,255,255,255,255,255,255,255,255,255;10  ;map with 10*8 = 80 key status bits (bit=0 key is pressed)
charbuffer:             defb 0   ; RETAIN LAST CHAR PRESSED FROM KEYBOARD ROUTINE
keyrelease:             defb 0   ; HAS PLAYER RELEASED KEY?

interrupttableptr:      defw interrupttable
interrupttable:
  jp fiftiethofasecondinterrupt5 ; PLAY A CHANNEL
  jp fiftiethofasecondinterrupt4 ; READ KEYBOARD
  jp fiftiethofasecondinterrupt6 ; PLAY C CHANNEL
  jp fiftiethofasecondinterrupt2 ; GAME SPEED DELAY
  jp fiftiethofasecondinterrupt3 ; PLAY B CHANNEL
  jp fiftiethofasecondinterrupt  ; PLAY MUSIC

mc_wait_flyback:
  ; WAIT FLYBACK
  ld b,&f5
  v1b3:
  in a,(c)
  rra
  jr nc,v1b3
ret
  
installinterrupt:
  di
  ld a,&C3; JP
  ld hl,&0038
  ld (hl),a
  inc hl
  ld bc,myinterrupt
  ld (hl),c
  inc hl
  ld (hl),b
  call mc_wait_flyback ; WAIT FLYBACK SO WE START INTERRUPTS AT TOP OF SCREEN
  ei
ret
  
myinterrupt:
  ld (previous_stack+1),sp
  ld sp,interrupt_stack_start

  ; SWITCH TO SHADOW REGISTERS
  exx
  ex af,af'

  ; RECORD TIME EVERY 300th OF A SECOND
  ld bc,(timepleasehl)
  inc bc
  ld (timepleasehl),bc
  ld a,b
  or c   ; CHECK IF BC = 0, IF SO ZERO IS SET
  jr nz,skipsettimepleasede
  ; INC DE AS WE HAVE MADE A CYCLE OF HL
  ld bc,(timepleasede)
  inc bc
  ld (timepleasede),bc
  skipsettimepleasede:
  
  ld hl,(interrupttableptr)
  jp (hl)
  
  finishinterrupt:
  ld hl,(interrupttableptr)
  inc hl
  inc hl
  inc hl
  ld (interrupttableptr),hl
  finishinterrupt2:
  
  exx
  ex af,af'
  previous_stack:
  ld sp,0
  ei
ret
fiftiethofasecondinterrupt2:
  ld a,(interruptcountermummies)
  inc a
  ld (interruptcountermummies),a

  cp 4:mummyinterruptspeed
  jp nz,finishinterrupt

  xor a
  ld (interruptcountermummies),a
  ld (mummymovementok),a          ; TELL MUMMY MOVEMENT FUNCTION THAT WE ARE OKAY TO MOVE
jp finishinterrupt

mummymovementok: defb 0

fiftiethofasecondinterrupt4: 
  ; READ KEYBOARD EVERY 50th OF A SECOND
        ;di              ;1 ##%%## C P C   VERSION ##%%##
        ld hl,matrix_buffer    ;3
        ld bc,#f782     ;3
        out (c),c       ;4
        ld bc,#f40e     ;3
        ld e,b          ;1
        out (c),c       ;4
        ld bc,#f6c0     ;3
        ld d,b          ;1
        out (c),c       ;4
        ld c,0          ;2
        out (c),c       ;4
        ld bc,#f792     ;3
        out (c),c       ;4
        ld a,#40        ;2
        ld c,#4a        ;2 44
loopb:  ld b,d          ;1
        out (c),a       ;4 select line
        ld b,e          ;1
        ini             ;5 read bits and write into KEYMAP
        inc a           ;1
        cp c            ;1
        jr c,loopb      ;2/3 9*16+1*15=159
        ld bc,#f782     ;3
        out (c),c       ;4                
jp finishinterrupt


fiftiethofasecondinterrupt5:
  call playsound_a
jp finishinterrupt
fiftiethofasecondinterrupt3:
  call playsound_b
jp finishinterrupt
fiftiethofasecondinterrupt6:
  call playsound_c
jp finishinterrupt

fiftiethofasecondinterrupt: 
  ld hl,interrupttable
  ld (interrupttableptr),hl
  
  ld a,(interruptcounter2)
  inc a
  ld (interruptcounter2),a

  cp 8:thirdinterruptspeed
  jp nz,finishinterrupt2
mysecondinterrupt:
  xor a
  ld (interruptcounter2),a
  defb 0:thirdinterruptcommand    ; &CD = CALL
  defw 0:thirdinterruptfunction   ; playmusic
  
  defb 0:secondinterruptcommand   ; &CD = CALL
  defw 0:secondinterruptfunction  ; fadepalette
jp finishinterrupt2

; ENABLE MUSIC IN MENU
enablemusic:
  ld hl,thirdinterruptspeed-1    ; PASS LOCATION OF INTERRUPT SPEED TO FUNCTION
  call initmusicf                ; CLEAR BUFFERS AND CHANNELS AND RESET MUSIC TO START OF SCORE
  ld a,&CD                       ; CALL = &CD
  ld bc,playmusicf               ; secondinterruptcommand
  ld (thirdinterruptcommand-1),a
  ld (thirdinterruptfunction-2),bc
ret
; DISABLE MUSIC
disablemusic:
  call initsoundf; call silencechannels ; CLEAR SOUND CHANNELS AND BUFFERS
  xor a                ; CALL = &CD
  ld bc,0              ; secondinterruptcommand
  ld (thirdinterruptcommand-1),a
  ld (thirdinterruptfunction-2),bc
ret

my_kl_time_please:
  ld hl,(timepleasehl)
  ld de,(timepleasede)
ret

; =============================================================
; MY CUSTOM FUNCTIONS - DROP IN REPLACEMENTS FOR BIOS FUNCTIONS
; -------------------------------------------------------------

scr_addr equ &8000

currenttxtpos:     defw scr_addr
currentwindowxy:   defw 0
currentwindowxy2:  defb 24,39;160,20;39,24
currentpapernum:   defb 0 ; 0,1,2,3
currentpennum:     defb 1 ; 0,1,2,3

; INPUT
; HL = TOP LEFT CORNER
; DE = BOTTOM RIGHT CORNER
my_txt_set_window:
  ld (currentwindowxy),hl
  ld (currentwindowxy2),de
ret

; GET WINDOW DIMENSIONS AND CLEAR USING CURRENT PAPER
my_txt_clear_window:
  ; GET TOP LEFT SCREEN LOCATION
  ld hl,locatetable
  ; GET Y OFFSET FROM TOP WINDOW POSITION
  ld a,(currentwindowxy)
  call vectorlookuphl
  
  ; GET X OFFSET
  ld a,(currentwindowxy+1)
  rla   ; DOUBLE FOR MODE 1
  ld b,0
  ld c,a
  ; ADD TO LOOKUP
  add hl,bc 
  
  ; RESULT SHOULD BE TOP LEFT CORNER OF WINDOW AREA OF MEMORY TO CLEAR
  ; NOW WE NEED TO FILL DOWN NUMBER OF ROWS TIMES 8, BY NUMBER OF BYTES IN WIDTH
  
  ; GET WIDTH IN BYTES OF WINDOW
  ld a,(currentwindowxy+1)
  ld c,a
  ld a,(currentwindowxy2+1)
  inc a                     ; TREAT 0 AS COL 1
  sub c
  rla                       ; DOUBLE FOR MODE 1 GRID
  dec a                     ; LESS ONE BYTE AS START BYTE OF LINE ALREADY SET
  ld c,a
  ld (bytestoclear-2),bc
   
  ; GET ROWS TO CLEAR * 8
  ld a,(currentwindowxy)
  ld c,a
  ld a,(currentwindowxy2)
  inc a                     ; TREAT 0 AS ROW 1
  sub c
  rla                       ; MULTIPLY BY 8 PIXELS
  rla
  rla
  ld b,a
  
  clearloopvert:
    push bc
	push hl
	ld (hl),0:currentpaper
	ld d,h
	ld e,l
	inc e
	ld bc,0:bytestoclear
	ldir
	pop hl
	pop bc
    call scr_next_line_hl
  djnz clearloopvert 
ret

; INPUT
; HL = TABLE OF 16BIT NUMBERS
; A = INDEX
; OUTPUT
; HL = 16 BIT NUMBER FROM LIST
vectorlookuphl:
  push bc
  ;rlca ; DOES NOT WORK OVER TABLE LENGTH > 128
  ld b,0
  ld c,a
  add hl,bc
  add hl,bc
  ld a,(hl)
  inc hl
  ld h,(hl)
  ld l,a
  pop bc
ret

; SET PEN OF PAPER USING BINARY PATTERN
; INPUT 
; A = PEN NUMBER

txt_set_pen:
  ld (currentpennum),a
  jp setpaperpeninks

txt_set_paper:
  ld (currentpapernum),a
  call txt_set_paper2
  ld (currentpaper-1),a
  jp setpaperpeninks

txt_set_paper2:
  dec a;cp 1
  jr z,setpaper1
  dec a;cp 2
  jr z,setpaper2
  dec a;cp 3
  jr z,setpaper3
setpaper0:
  xor a;ld a,&00 ; YELLOW
  ret
setpaper1:
  ld a,&F0 ; BLACK
  ret
setpaper2:
  ld a,&0F ; ORANGE
  ret
setpaper3:
  ld a,&FF ; BLUE
  ret

dosetink:
  push bc
  inc hl
  ld a,(hl) ; GET INDEX
  ld b,a
  inc hl
  inc hl
  ld a,(hl) ; GET COLOUR
  ld c,a
  ld a,b
  ld b,c
  push hl
  
  call scr_set_ink

  pop hl
  pop bc
  dec b
  dec b
  dec b
  jp continueprintstring2
  
dosetborder:
  push bc
  inc hl
  inc hl
  ld a,(hl)
  ld c,a
  ld b,c
  push hl
  
  call scr_set_border

  pop hl
  pop bc
  dec b
  dec b
  jp continueprintstring2

dosetscreenmode:
  push bc
  inc hl
  ld a,(hl) ; GET MODE
  ld b,&7f
  add 128
  add 4
  add 8 
  ld c,a
  out (c),c
  
  push hl
  call my_txt_clear_window ; CHANGE IN MODE SEEMS TO DO CLS TOO
  pop hl

  pop bc
  dec b  
  jr continueprintstring2


; A = INDEX
; C = PEN COLOUR INDEX IN FIRMWARE TABLE
scr_set_border:
  ld a,#10
scr_set_ink:
  ; GET HARDWARE PEN COLOUR IN FIRMWARE ORDERED TABLE
  ld b,0
  ld hl,pensfirmware
  add hl,bc
  
  ld c,a
  ld b,&7f;10          ;{{0793-01107f}}  set border colour

;;====================================================================
;; set colour for a pen
;;
;; HL = address of colour for pen
;; C = pen index

set_colour_for_a_pen:             ;{{Addr=$07aa Code Calls/jump count- 2 Data use count- 0}}
        out     (c),c             ;{{07aa-ed49}}  select pen 
        ld      a,(hl)            ;{{07ac-7e}} 
        and     &1f               ;{{07ad-e61f}} 
        or      &40               ;{{07af-f640}} 
        out     (c),a             ;{{07b1-ed79}}  set colour for pen
        ret                       ;{{07b3-c9}} 

; HARDWARE COLOURS OF PEN ARRANGED BY FIRMWARE ORDER (BLACK TO WHITE)
pensfirmware:
  defb 20
  defb 4
  defb 21
  defb 28
  defb 24
  defb 29
  defb 12
  defb 5
  defb 13
  defb 22
  defb 6
  defb 23
  defb 30
  defb 0
  defb 31
  defb 14
  defb 7
  defb 15
  defb 18
  defb 2
  defb 19
  defb 26
  defb 25
  defb 27
  defb 10
  defb 3
  defb 11

writelineplainfde:
  ex de,hl
writelineplainf:
  ld a,(hl)
  cp 255
  ret z
  call writecharplainf
  inc hl
  jr writelineplainf  
  
; INPUT
; HL = STRING TO PRINT AT GFX POS
printstring:
  ; LOCATE TEXT BASED ON LAST SCREEN COORDINATE
  ld b,(hl) ; NUMBER OF CHARS TO PRINT AT START OF STRING
  my_printstringcharloop:
    inc hl
    ld a,(hl)
	
	cp #1f                ; TEXT LOCATE COMMAND
	jp z,my_locate
	; ASCII CONTROL CODES
	or a;cp #00                ; IGNORE ZERO
	jr z,continueprintstring2
	cp #04
	jr z,dosetscreenmode
	cp #08
	jr z,domovebackonechar
	cp #0a
	jr z,domovedownoneline
	cp #0c                ; CLEAR CURRENT TEXT WINDOW
	jr z,doclearwindow
	cp #0e                ; SET PAPER
	jr z,dosetpaperink    
	cp #0f                ; SET PEN
	jr z,dosetpenink    
	cp #1c                ; SET INK
	jp z,dosetink 
	cp #1d                ; SET BORDER
	jp z,dosetborder      

	; NORMAL CHARACTER
    call my_txt_output
	continueprintstring2:
  djnz my_printstringcharloop
ret

domovebackonechar:
  push hl
  ld hl,(currenttxtpos)
  dec hl
  dec hl
  ld (currenttxtpos),hl
  pop hl
  jr continueprintstring2
  
domovedownoneline:
  push hl
  ld hl,(currenttxtpos)
  push bc
  ld bc,&0050
  add hl,bc
  pop bc
  ld (currenttxtpos),hl
  pop hl
  jr continueprintstring2
  
doclearwindow:
  push bc
  push hl
  call my_txt_clear_window
  pop hl
  pop bc
  jr continueprintstring2

dosetpaperink:
  push bc
  inc hl
  ld a,(hl)
  call txt_set_paper
  pop bc
  dec b
  jp continueprintstring2

dosetpenink:
  push bc
  inc hl
  ld a,(hl)
  call txt_set_pen
  pop bc
  dec b
  jp continueprintstring2

; INPUT
; HL = STRING TO PRINT
; 1st byte = 1F LOCATE COMMAND
; 2nd byte = COLUMN
; 3rd byte = LINE
my_locate:
  push bc
  inc hl
  push hl
  ld a,(hl)
  inc hl
  ld l,(hl)
  ld h,a
  dec h  ; START FROM 0 AS COORD INSTEAD OF 1
  dec l
  call locatetextf
  ld (currenttxtpos),hl ; STORE POSITION
  pop hl
  inc hl
  pop bc
  dec b
  dec b
  jp continueprintstring2
;  inc hl
;  ld h,a
  ; INPUT
; H = X ROW
; L = Y COL
; OUTPUT
; HL = SCREEN POS

; HL, BC, A CORRUPT
locatetextf:
  ld a,h
  push af
  ld a,l
  rlca ; DOUBLE FOR LOOKUP
  ld hl,locatetable
  ld b,0
  ld c,a
  add hl,bc
  ld a,(hl)
  inc hl
  ld h,(hl)
  ld l,a
  pop af
  rlca ; DOUBLE FOR HORIZ BYTES  
  ld c,a
  add hl,bc
ret

locatetable:
  defw &8000 ;1
  defw &8050 ;2 
  defw &80a0 ;3
  defw &80f0 ;4
  defw &8140 ;5
  defw &8190 ;6
  defw &81e0 ;7
  defw &8230 ;8
  defw &8280 ;9
  defw &82d0 ;10
  defw &8320 ;11
  defw &8370 ;12
  defw &83c0 ;13
  defw &8410 ;14
  defw &8460 ;15
  defw &84b0 ;16
  defw &8500 ;17
  defw &8550 ;18
  defw &85a0 ;19
  defw &85f0 ;20
  defw &8640 ;21
  defw &8690 ;22
  defw &86e0 ;23
  defw &8730 ;24
  defw &8780 ;25

; MOVE CURSOR TO COLUMN AND LINE NUMBER BASED ON CURRENT WINDOW LOCATION
; INPUTS
; H = X POS
; L = Y POS
my_txt_set_cursor:
  ld bc,(currentwindowxy)
  add hl,bc
  dec h  ; START FROM 0 INSTEAD OF 1
  dec l  ; START FROM 0 INSTEAD OF 1
; SAME AS ABOVE, ONLY WITHOUT WINDOW OFFSET ADDED
  my_txt_set_cursor_main:
  call locatetextf
  ld (currenttxtpos),hl
ret

; INPUT
; A = CHAR TO PRINT AT CURRENT COORDINATES
my_txt_output:
  ld de,(currenttxtpos)
  call writecharplainf
  ld (currenttxtpos),de
ret
my_txt_outputtransp:
  ld de,(currenttxtpos)
  call writecharplainftransp
  ld (currenttxtpos),de
ret

amsfonttable equ &C100

; INPUTS
; A  = CHAR
; DE = SCREEN POS
writecharplainf:
  push hl
  sub 32             ; START WITH SPACE
  ;rlca               ; DOUBLE FOR LOOKUP
  ld h,0
  ld l,a
  add hl,hl          ; DOUBLE FOR LOOKUP
  push bc
  ld b,h
  ld c,l
  
  ld hl,amsfonttable
  
  add hl,bc
  pop bc
  
  ;ld l,a
  ; MOVE TO ACTUAL TABLE DATA IN HL
  ld a,(hl)
  inc hl
  ld h,(hl)
  ld l,a
  push de
  ; WRITE TO SCREEN
  call writecharpixelline
  call writecharpixelline
  call writecharpixelline
  call writecharpixelline
  call writecharpixelline;plain
  call writecharpixelline;plain
  call writecharpixelline;plain
  call writecharpixelline;plain
  pop de
  inc de ; MOVE TO NEXT CHAR SPACE
  inc de
  pop hl
ret
; INPUTS
; A  = CHAR
; DE = SCREEN POS
writecharplainftransp:
  push hl
  sub 32             ; START WITH SPACE
  ;rlca               ; DOUBLE FOR LOOKUP
  ld h,0
  ld l,a
  add hl,hl          ; DOUBLE FOR LOOKUP
  push bc
  ld b,h
  ld c,l
  
  ld hl,amsfonttable
  
  add hl,bc
  pop bc
  
  ;ld l,a
  ; MOVE TO ACTUAL TABLE DATA IN HL
  ld a,(hl)
  inc hl
  ld h,(hl)
  ld l,a
  push de
  ; WRITE TO SCREEN
  call writecharpixellinetransp
  call writecharpixellinetransp
  call writecharpixellinetransp
  call writecharpixellinetransp
  call writecharpixellinetransp;plain
  call writecharpixellinetransp;plain
  call writecharpixellinetransp;plain
  call writecharpixellinetransp;plain
  pop de
  inc de ; MOVE TO NEXT CHAR SPACE
  inc de
  pop hl
ret

; MACHINE CODE EQUIVALENTS FOR "AND, OR, XOR" FUNCTIONS IN COMMENTS BELOW
; THIS GETS COPIED TO THE CHARACTER DRAWING FUNCTION WHEN WE CHANGE PAPER OR PEN
; THIS TRANSFORMS BYTE DATA IN FONT SO PAPER AND PEN COLOURS ARE CORRECT
setpaperpeninkstable2:
  defw &0000,&0000, &F0E6,&F0EE, &0FE6,&0000, &F0EE,&0000 ; PEN 0, PAPER 0 1 2 3
  defw &F0E6,&0000, &0000,&0000, &0000,&0000, &F0F6,&0000 ; PEN 1, PAPER 0 1 2 3
  defw &0FE6,&0FEE, &FFEE,&0000, &0000,&0000, &0FF6,&0000 ; PEN 2, PAPER 0 1 2 3
  defw &0FEE,&0000, &F0F6,&0FEE, &0FF6,&0000, &0000,&0000 ; PEN 3, PAPER 0 1 2 3

; MODIFY CHARACTER DRAWING FUNCTION TO SET CORRECT PAPER AND PEN INKS
setpaperpeninks:
  push hl
  ld hl,setpaperpeninkstable2
  ; ADD 16 FOR EACH PEN
  ld a,(currentpennum)
  sla a
  sla a
  sla a
  sla a
  ld b,0
  ld c,a
  add hl,bc
  ld a,(currentpapernum)
  ; ADD 4 FOR EACH PAPER
  sla a
  sla a
  ld b,0
  ld c,a
  add hl,bc
  
  ; COPY COMMAND FOR FIRST BYTE IN CHARACTER INTO CHARACTER DRAWING FUNCTION
  push hl
  ld de,commbytes1
  ld bc,4
  ldir
  pop hl
  ; COPY COMMAND FOR SECOND BYTE IN CHARACTER
  ld de,commbytes2
  ld bc,4
  ldir
  pop hl
ret
  
  ; ADD 4 FOR EACH PEN
 
; 00000000 INK 0
; 00001111 INK 1
; 11110000 INK 2
; 11111111 INK 3

; DEFAULT BLACK ON ORANGE - INK 1 ON INK 2
;  -
;                   PEN INK, PAPER INK

;                   0,0

; YELLOW ON BLACK   0,1
;  AND %11110000
;  XOR %11110000

; YELLOW ON ORANGE  0,2
;  AND %00001111

; YELLOW ON BLUE    0,3
;  XOR %11110000

; BLACK ON YELLOW   1,0
;  AND %11110000

;                   1,1

; BLACK ON ORANGE   1,2
;  NO CHANGE
;

; BLACK ON BLUE     1,3
;  OR  %11110000

; ORANGE ON YELLOW  2,0
;  AND %00001111
;  XOR %00001111

; ORANGE ON BLACK   2,1
;  XOR %11111111

;                   2,2

; ORANGE ON BLUE    2,3
;  OR  %00001111

; BLUE ON YELLOW    3,0
;  XOR %00001111

; BLUE ON BLACK     3,1
;  OR  %11110000
;  XOR %00001111

; BLUE ON ORANGE    3,2
;  OR  %00001111

;                   3,3

writecharpixelline:
  push de
  ; LEFT BYTE
  ld a,(hl)
  commbytes1: defw &0FF6,&F0E6;0,0  PEN 1 PAPER 0 DEFAULT
  ld (de),a
  
  ; RIGHT BYTE
  inc de
  inc hl
  
  ld a,(hl)
  commbytes2: defw &0FF6,&F0E6;0,0  PEN 1 PAPER 0 DEFAULT
  ld (de),a
  inc hl

  pop de
  ex de,hl              ; MOVE TO NEXT PIXEL LINE DOWN
  call scr_next_line_hl
  ex de,hl
ret

writecharpixellinetransp:
  push de
  ; LEFT BYTE
  ld a,(hl)
  defw &0FF6,&F0E6;0,0  PEN 1 PAPER 0 DEFAULT
  ld c,a
  ld a,(de)
  or c
  ld (de),a
  
  ; RIGHT BYTE
  inc de
  inc hl
  
  ld a,(hl)
  defw &0FF6,&F0E6;0,0  PEN 1 PAPER 0 DEFAULT
  ld c,a
  ld a,(de)
  or c
  ld (de),a
  inc hl

  pop de
  ex de,hl              ; MOVE TO NEXT PIXEL LINE DOWN
  call scr_next_line_hl
  ex de,hl
ret

scr_next_line_hl:
  ld a,h              ; &BC26=&0C13 (&0970)  [98] SCR_NEXT_LINE (Step a screen address down one line)
  add a,&08
  ld h,a
  and &38
  ret nz
  ld a,h
  sub &40
  ld h,a
  ld a,l
  add a,&50
  ld l,a
  ret nc
  inc h
  ld a,h
  and #7
  ret nz
  ld a,h
  sub #8
  ld h,a
ret

backgroundmusic:          db "Y"             ; SOUND QUEUE NEEDS PLAYED?
soundeffects:             db "Y"
playerscoreentryposition: db #00,#00
playernameentryinmemory:  db #00,#00

txt_setuplevelcompleted: 
  db #24            ; NUM CHARS
  db #0e,#01        ; PAPER
  db #0f,#02        ; PEN
  db #0c            ; CLS
  db #1f,#07,#05    ; LOCATE
  db #21
db #21,#20,#20,#53,#20,#54,#20,#4f
db #20,#50,#20,#20,#20,#20,#50,#20
db #52,#20,#45,#20,#53,#20,#53,#20
db #20,#21,#21
txt_stoppress: 
db #23
db #0f,#00
db #1f,#07,#0a
db #42,#72,#69,#74,#69,#73,#68
db #20,#4d,#75,#73,#65,#75,#6d,#20
db #74,#6f,#64,#61,#79,#20,#61,#6e
db #6e,#6f,#75,#6e,#63,#65,#64
txt_britishmuseum: 
db #23
db #1f,#05,#0b
db #73,#75,#63,#63,#65
db #73,#73,#66,#75,#6c,#20,#65,#78
db #63,#61,#76,#61,#74,#69,#6f,#6e
db #20,#6f,#66,#20,#61,#6e,#63,#69
db #65,#6e,#74
txt_extraman: 
db #14
db #1f,#05,#0c
db #45,#67,#79,#70,#74,#69,#61,#6e,#20
db #70,#79,#72,#61,#6d,#69,#64,#2e
l809d:
db #1a
db #0f,#03
db #1f,#07,#11
db #4c,#65,#61,#64,#65,#72,#20,#6f,#66,#20
db #74,#65,#61,#6d,#20,#67,#69,#76
db #65,#6e,#20
l80b8: 
db #09
db #62,#6f,#6e,#75,#73,#20,#66,#6f,#72
l80c2: 
db #1d
db #1f,#05,#12
db #68,#69,#73,#20,#65,#66,#66
db #6f,#72,#74,#73,#20,#6f,#66,#20
db #32,#30,#30,#20,#70,#6f,#69,#6e
db #74,#73,#2e
l80e0: 
db #09
db #65,#78,#74,#72,#61,#20,#6d,#61,#6e
l80ea: 
db #10
db #1f,#05,#12
db #66,#6f,#72,#20,#6e,#65,#78,#74,#20,#64,#69,#67,#2e
txt_presscorfirebutton: 
  db 30;#29         ; NUM CHARS
  db #0f,#02     ; PEN 
  db #1f,#09,#17 ; LOCATE
  db "Press any key to continue"  
txt_gameoverboxcolours:
  db #07         ; NUM CHARS
  db #0e,#01     ; PAPER
  db #0f,#02     ; PEN
  db #1f,#0c,#0d ; LOCATE
txt_gameover: defb "GAME OVER"

; ---- PLAYER 2 DATA ----
playerspritexy2:         db #00
playerspritey2:          db #00
playerspritedirection2:  db #00
playerwalkinganimation2: db #00

setplayermovedirection2c: db #00,#00
setplayermovedirection2b: db #00
setplayermovedirection2:  db #00



guardianmummyxy:   db #00,#00
sweepermummyxy:    db 0,0
treasureboxxy:     db #00,#00
pathcoordinatesy:  db #18,#40,#68,#90,#b8
pathcoordinatesx:  db #04,#12,#20,#2e,#3c,#4a

; ---- PLAYER 1 DATA ----

setplayermovedirectionc: db #00,#00
setplayermovedirectionb: db #00
setplayermovedirection:  db #00

currenttime:    db #00,#00
gamespeed:      db #00,#04

playerspritexy:         db #00
playerspritey:          db #00
playerspritedirection:  db #00
playerwalkinganimation: db #00

mummyspritedirection:        db #00
playerscore:                 db #00,#00
pyramidroomnumber:           db #00,#00
l815e:                       db #00 ; UNUSED?
l815f:                       db #00
l8160:                       db #00
gamedifficulty:              db #1f
currentmummydatabblock:      db #00,#00
mummyspriteposition:         db #00,#00
desiredplayerspriteposition: db #00,#00
isscoreboardmenu:            db #00
totalnumberofmummies:        db #04
numberoflives:               db #00,#00
lastmummyidused:             db #00

gotguardianmummy: db #00
gotscroll:        db #00
gotexitkey:       db #00
gotroyalmummy:    db #00
gottorch:         db #00
gotankh:          db #00
gotelixir         db #00
l8171:            db #00 ; UNUSED?
                  db 0   ; DON'T REMOVE - OTHERWISE PLAYER SPRITE DISAPPEARS SOMETIMES WHEN COLLIDING WITH TOP LEFT WALL

; START 26EE

; OBJECT DATA FOR MUMMY SPRITES
; +0 = CURRENT DIRECTION?
; +1 = DESIRED DIRECTION?
; +2 = POSITION
; +3 = POSITION
; +4 = ANIMATION WALK BOOLEAN
; +5 = SPRITE ID
; +6 = SPRITE STATUS - FADE DEAD MUMMIES
; +7 = MUMMY TYPE - 0 = NORMAL, 1 = SWEEPER

mummydatablocksize equ &0008

mummyspritedatablock: 
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0
db #00,#00,#00,#00,#00,0,0,0


data_treasureboxes: 
  db #00,#00
data_objectmap_toprow: 
  db #00,#00,#00,#00,#00,#00
l81de: db #00
l81df: db #00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00
; START 277F
data_objectmap: db #00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00
l860f: db #00
l8610: db #00,#04,#b8,#4a,#b8
db #0a,#b8,#44,#b8,#10,#b8,#3e,#b8
db #16,#b8,#38,#b8,#1c,#b8,#32,#b8
db #22,#b8,#2c,#b8,#0a,#90,#44,#90
db #10,#90,#3e,#90,#16,#90,#38,#90
db #1c,#90
l8637:
db #32,#90,#16,#a8,#38,#a8
db #1c,#a8,#32,#a8,#22,#a8,#2c,#a8
l8645: db #00,#00
myscraddr: db #00,#00
cursorentrylength: db #00
;sarcophagusfillpattern: db #00

l864b: db #03,#04,#01,#02,#03,#04,#01,#02
txt_setupscreen: 
  db #19             ; 25 CHARS TO PRINT
  db #1d,#18,#18     ; SET BORDER
  db #1c,#00,#18,#18 ; SET INK 0  YELLOW
  db #1c,#01,#00,#00 ; SET INK 1  BLACK
  db #1c,#02,#0f,#0f ; SET INK 2  ORANGE
  db #1c,#03,#0b,#0b ; SET INK 3  BLUE
  db #0e,#00         ; SET PAPER  INK 0
  db #04,#01         ; SET SCREEN MODE + CLS
  db #0f,#01         ; SET PEN    INK 1
txt_setuphighscorescreen:
  db #08            ; CHARS TO PRINT
  db #1d,#0b,#0b    ; SET BORDER  BLUE
  db #0e,#03        ; SET PAPER   INK 3
  db #0c            ; CLS
  db #0e,#02        ; SET PAPER   INK 2
txt_setuphighscorescreennocls:
  db #07            ; CHARS TO PRINT
  db #1d,#0b,#0b    ; SET BORDER  BLUE
  db #0e,#03        ; SET PAPER   INK 3
  db #0e,#02        ; SET PAPER   INK 2
txt_highscoretable: 
  db #15            ; CHARS TO PRINT
  db #0e,#00        ; SET PAPER
  db #0f,#01        ; SET PEN
  db #1f,#0e,#07    ; LOCATE
  db "HI-SCORE TABLE"
scoreboard_score1: db #c4,#09
txt_score_stupendous: 
  db #0f
  db #1f,#12
txt_score_stupendous2: 
  db #0a,"Stupendous !"
scoreboard_score2: 
  db #d0,#07
txt_score_excellent: 
  db #0f
  db #1f,#12,#0b,"Excellent ! "
scoreboard_score3: 
  db #dc,#05
txt_score_verygood:  
  db #0f
  db #1f,#12,#0c,"Very Good ! "
scoreboard_score4: 
  db #e8,#03
txt_score_quitegood: 
  db #0f
  db #1f,#12,#0d,"Quite Good  "
scoreboard_score5: 
  db #f4,#01
txt_score_notbad:    
  db #11
  db #1f,#12,#0e,"Not Bad     "
  db #0e,#03         ; SET PAPER
txt_score_empty: 
  db 20
  db #0e,#04         ; PAPER
  db "                   "

txt_menu_userinput: 
  db 49              ; NUMBER OF CHARS
  db #0e,#00         ; PAPER
  db #1f,#0c,#10,"> Instructions"
  db #1f,#0e,#11,"Options     "
  db #1f,#0e,#12,"Play game   ";#49
txt_score_entername: 
  db #29             ; NUMBER OF CHARS
  db #0e,#03         ; PAPER BLUE
  db #1f,#03,#19
  db "Well done !!  Please enter your name";#57
txt_menu_clearentername: 
  db #29             ; NUMBER OF CHARS
  db #0e,#03         ; PAPER
  db #1f,#03,#19
  db "                                    ";#49
data_highscoreslist:  ; ???
  db #6d,#65
  db #10,#27
  db #e8,#03
  db #64,#00
  db #0a,#00
txt_title: db #2c    ; NUMBER OF CHARS
  db #1f,#02,#02     ; LOCATE 
  db #22,"OH MUMMY",#22," ",#a4," 1984 GEM SOFTWARE / CPSOFT"
  db #0e,#01         ; SET PAPER
txt_scorelives: 
  db 34              ; NUMBER OF CHARS
  db #1d,#18,#18     ; BORDER
  db #0e,#00         ; PAPER
  db #0f,#02         ; PEN
  db #0c             ; CLS
  db #1f,#03,#01     ; LOCATE
  db "SCORE"
  db #1f,#17,#01     ; LOCATE
  db "MEN"
  db #1f,#03,#02     ; LOCATE
  db "PYRAMID"
  db #0f,#03         ; PEN

;image_sarcophagus:
;        DB      #3F, #FF, #FF, #FF, #CE, #7F
;        DB      #0B, #FF, #FF, #8D, #04, #BF
;        DB      #09, #0F, #0F, #0F, #08, #01
;        DB      #08, #04, #04, #13, #0F, #0E
;        DB      #0C, #01, #01, #13, #55, #55
;        DB      #87, #0B, #0B, #1A, #5D, #56
;        DB      #D2, #1E, #1E, #1E, #5A, #5A
;        DB      #F8, #F0, #F0, #F0, #F0, #F0
;        DB      #8E, #0C, #09, #0C, #04, #1E
;        DB      #EE, #F7, #FF, #FF, #EE, #F7
;        DB      #CF, #05, #03, #01, #02, #35
;        DB      #EF, #F7, #FF, #FF, #EF, #F7
;image_key:
;        DB      #FF, #FF, #FF, #FF, #FF, #FF
;        DB      #FF, #FF, #FF, #FF, #CC, #77
;        DB      #FF, #FF, #FF, #FF, #89, #33
;        DB      #FF, #FF, #FF, #FF, #13, #19
;        DB      #00, #00, #00, #00, #37, #8D
;        DB      #0C, #01, #0F, #0F, #33, #89
;        DB      #CC, #11, #FF, #FF, #19, #13
;        DB      #88, #08, #FF, #FF, #8C, #37
;        DB      #8A, #8A, #FF, #FF, #CF, #7F
;        DB      #AB, #AE, #FF, #FF, #FF, #FF
;        DB      #BF, #EF, #FF, #FF, #FF, #FF
;        DB      #FF, #FF, #FF, #FF, #FF, #FF
;image_scroll:
;        DB      #FF, #F8, #FF, #FF, #F1, #FF
;        DB      #FF, #FA, #F7, #FE, #F5, #FF
;        DB      #FF, #FA, #F7, #FE, #F5, #FF
;        DB      #F9, #FA, #78, #E1, #F5, #F9
;        DB      #F6, #F2, #00, #00, #F4, #F6
;        DB      #F7, #FA, #00, #00, #F5, #FE
;        DB      #F7, #FA, #05, #05, #F5, #FE
;        DB      #F6, #F2, #0F, #0F, #F4, #F6
;        DB      #F9, #FA, #78, #E1, #F5, #F9
;        DB      #FF, #FA, #F7, #FE, #F5, #FF
;        DB      #FF, #FA, #F7, #FE, #F5, #FF
;        DB      #FF, #F8, #FF, #FF, #F1, #FF
;image_treasure:
;        DB      #1E, #F0, #F0, #F2, #F0, #87
;        DB      #3D, #8D, #05, #0D, #0F, #CB
;        DB      #6B, #0A, #00, #00, #00, #6D
;        DB      #F0, #BA, #79, #88, #ED, #F0
;        DB      #4B, #01, #06, #0D, #0A, #2D
;        DB      #F0, #BA, #E1, #F2, #E1, #F0
;        DB      #F7, #0B, #0F, #0B, #0F, #FE
;        DB      #6B, #0E, #0A, #04, #0B, #6D
;        DB      #7B, #0D, #00, #01, #07, #E9
;        DB      #3D, #8F, #08, #00, #1F, #CB
;        DB      #3C, #FF, #0F, #0F, #7E, #C3
;        DB      #1E, #F0, #F0, #F0, #F0, #87
;image_torch:
;        DB      #FF, #FF, #FF, #FF, #FF, #FF
;        DB      #FF, #FF, #FF, #FF, #6F, #FF
;        DB      #FF, #FF, #FF, #FE, #2F, #F7
;        DB      #FF, #FF, #FF, #ED, #0F, #7B
;        DB      #FF, #EF, #BF, #CB, #04, #3D
;        DB      #FF, #ED, #3D, #CA, #00, #16
;        DB      #FF, #CA, #16, #CA, #00, #16
;        DB      #9B, #CB, #12, #ED, #02, #1E
;        DB      #09, #CA, #16, #ED, #0E, #3D
;        DB      #96, #ED, #3D, #FE, #87, #7B
;        DB      #F9, #FE, #F3, #FF, #F8, #F7
;        DB      #FF, #FF, #FF, #FF, #FF, #FF
		
		
;image_torch:
;        DB      #FD, #FF, #FF, #FF, #FF, #F3;, #88;, #00
;        DB      #FC, #F8, #F0, #F0, #F0, #F0;, #88;, #00
;        DB      #FE, #F2, #F0, #F0, #F2, #FD;, #80;, #00
;        DB      #FF, #F0, #F0, #F0, #F0, #F1;, #80;, #00
;        DB      #FE, #96, #F0, #F0, #F0, #F0;, #88;, #00
;        DB      #FE, #03, #F1, #F9, #FF, #FF;, #88;, #00
;        DB      #EC, #05, #78, #F9, #FF, #FF;, #88;, #00
;        DB      #EC, #0B, #F3, #F9, #FF, #FF;, #88;, #00
;        DB      #C9, #16, #F0, #F3, #FF, #FF;, #88;, #00
;        DB      #C8, #1E, #FF, #FF, #FF, #FF;, #88;, #00
;        DB      #81, #3C, #FF, #FF, #FF, #FF;, #88;, #00
;        DB      #C0, #3D, #FF, #FF, #FF, #FF;, #88;, #00
;        DB      #F8, #F1, #FF, #FF, #FF, #FF;, #88;, #00


txt_ohmummylargeletters:
db #68                                 ; NUMBER OF CHARS
db #1f,#0c,#0b                         ; LOCATE
db #0e,#00                             ; PEN
db #0f,#02                             ; PAPER
db #88,#8c,#88,#88,#20,#20,#8c,#8c     ; ▗▄▗▗  ▄ ▄ ▖ ▖▄▄▖▄▄▖ ▖ ▖  
db #84,#84,#84,#8c,#8c,#84,#8c,#8c
db #84,#84,#84
db #08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#0a
db #8a,#8a,#8a,#8f,#20,#20,#87,#87,#85,#8d,#85,#87,#87,#85,#87,#87,#85,#8f,#85
db #08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#08,#0a
db #82,#83,#82,#82,#20,#20,#81,#20,#81,#83,#81,#81,#20,#81,#81,#20,#81,#20,#81
txt_pressctocontinue: 
  db #12           ; NUMBER OF CHARS
  db #1f,#0e,#11   ; LOCATE
  ;db #22,"C",#22," TO CONTINUE"
  db " PRESS ANY KEY "
  
; ABOUT &4000
  
;db #20,#54,#4f,#20,#43,#4f,#4e,#54
;.image_blank2 equ $ + 4
;db #49,#4e,#55,#45
image_blank2: ; YELLOW
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
db #00,#00,#00,#00,#00,#00,#00,#00
image_blank:  ; BLACK
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
image_footprintsup: 
db #f0,#87,#f0,#f0,#f0,#87,#f0,#f0
db #f0,#96,#f0,#f0,#f0,#96,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#96,#f0,#f0
db #f0,#96,#f0,#f0,#f0,#96,#f0,#f0
image_footprintsup2: 
db #f0,#f0,#1e,#f0,#f0,#f0,#1e,#f0
db #f0,#f0,#96,#f0,#f0,#f0,#96,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#96,#f0
db #f0,#f0,#96,#f0,#f0,#f0,#f0,#f0
l89d9: 
db #f0,#87,#f0,#87,#f0,#96,#f0,#96
db #f0,#f0,#f0,#96,#f0,#96,#f0,#f0
l89e9: 
db #1e,#f0,#1e,#f0,#96,#f0,#96,#f0
db #f0,#f0,#96,#f0,#96,#f0,#f0,#f0
image_footprintsright:
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#96,#0f,#96,#0f,#f0,#c3
image_footprintsright2: 
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
l8a19:
db #f0,#c3,#96,#0f,#96,#0f,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
image_footprintsdown: 
db #f0,#f0,#f0,#f0,#f0,#96,#f0,#f0
db #f0,#96,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#96,#f0,#f0,#f0,#96,#f0,#f0
db #f0,#87,#f0,#f0,#f0,#87,#f0,#f0
image_footprintsdown2: 
db #f0,#f0,#f0,#f0,#f0,#f0,#96,#f0
db #f0,#f0,#96,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#96,#f0,#f0,#f0,#96,#f0
db #f0,#f0,#1e,#f0,#f0,#f0,#1e,#f0
l8a69: 
db #f0,#f0,#f0,#96,#f0,#96,#f0,#f0
db #f0,#96,#f0,#96,#f0,#87,#f0,#87
l8a79: 
db #f0,#f0,#96,#f0,#96,#f0,#f0,#f0
db #96,#f0,#96,#f0,#1e,#f0,#1e,#f0
image_footprintsleft: 
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#0f,#96,#0f,#96,#3c,#f0
image_footprintsleft2: 
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
l8aa9: 
db #3c,#f0,#0f,#96,#0f,#96,#f0,#f0
db #f0,#f0,#f0,#f0,#f0,#f0,#f0,#f0
image_playerright: 
db #f0,#f0,#f0,#f0
db #f0,#f7,#fe,#f0,#f0,#ff,#ff,#fc
db #f0,#ee,#25,#f0,#f0,#80,#0f,#3c
db #f0,#e6,#2d,#f0,#f0,#11,#9e,#f0
db #f0,#00,#fe,#f0,#f0,#88,#00,#3c
db #f0,#cc,#00,#3c,#f1,#ff,#fb,#f0
db #f3,#ff,#f7,#f8,#d3,#fe,#ff,#f8
db #87,#fc,#f7,#fc,#c3,#78,#c3,#3c
db #e1,#3c,#c3,#1e
image_playerright2: 
db #f0,#f0,#f0,#f0
db #f0,#f7,#fe,#f0,#f0,#ff,#ff,#fc
db #f0,#ee,#25,#f0,#f0,#80,#0f,#3c
db #f0,#e6,#2d,#f0,#f0,#11,#9e,#f0
db #e0,#33,#fe,#f0,#e0,#00,#6f,#f0
db #f0,#89,#2f,#f0,#f0,#ff,#7e,#f0
db #f0,#f7,#fc,#f0,#f0,#f3,#fc,#f0
db #f0,#f3,#fc,#f0,#f0,#c3,#3c,#f0
db #f0,#c3,#1e,#f0

; ORDER OF THESE SPRITES MATTERS!!!
image_fire1:
        DB      #F0, #F0
        DB      #F0, #E1
        DB      #F0, #D2
        DB      #F0, #96
        DB      #F0, #3C
        DB      #E1, #3C
        DB      #E1, #1E
        DB      #C3, #0B
image_fire3:
        DB      #C3, #01
        DB      #C3, #00
        DB      #C3, #00
        DB      #E1, #08
        DB      #E1, #0D
        DB      #F0, #0F
        DB      #F0, #96
        DB      #F0, #F0
image_fire2:
        DB      #F0, #F0
        DB      #F0, #F0
        DB      #B4, #F0
        DB      #B4, #F0
        DB      #96, #F0
        DB      #96, #F0
        DB      #0F, #F0
        DB      #0B, #78

image_fire4:
        DB      #03, #3C
        DB      #02, #3C
        DB      #00, #3C
        DB      #01, #3C
        DB      #03, #78
        DB      #0F, #F0
        DB      #3C, #F0
        DB      #F0, #F0

;image_playerleft: 
;db #f0,#f0,#f0,#f0
;db #f0,#f7,#fe,#f0,#f3,#ff,#ff,#f0
;db #f0,#4a,#77,#f0,#c3,#0f,#10,#f0
;db #f0,#4b,#76,#f0,#f0,#97,#88,#f0
;db #f0,#f7,#00,#f0,#c3,#00,#11,#f0
;db #c3,#00,#33,#f0,#f0,#fd,#ff,#f8
;db #f1,#fe,#ff,#fc,#f1,#ff,#f7,#bc
;db #f3,#fe,#f3,#1e,#c3,#3c,#e1,#3c
;db #87,#3c,#c3,#78
image_mummyup: 
db #f0,#f0,#f0,#f0
db #e0,#20,#40,#70,#e0,#40,#20,#70
db #e0,#40,#20,#70,#e0,#20,#40,#70
db #e0,#00,#00,#f0,#f0,#00,#00,#f0
db #f0,#00,#10,#f0,#f0,#80,#30,#f0
db #f0,#80,#30,#f0,#f0,#00,#30,#f0
db #f0,#10,#10,#f0,#e0,#10,#10,#f0
db #e0,#30,#10,#f0,#f0,#f0,#00,#f0
db #f0,#f0,#00,#f0



txt_setupoptionscreen2: 
  db #15            ; CHARS TO PRINT
  db #0e,#00        ; SET PAPER
  db #0f,#01        ; SET PEN
  db #1f,#0e,#07    ; LOCATE
  db " GAME OPTIONS "
  
txt_options2:
  db 166;144            ; CHARS TO PRINT
  db #1f,#0c,#0a    ; LOCATE
  db "  Game speed: "
txt_optiongamespeed:
  db "4   "
  db #1f,#0c,#0b
  db "  Difficulty: "
txt_optiondifficulty:
  db "4   "
  db #1f,#0c,#0c
  db "  Music: "
txt_optionmusic:
  db "Yes       "
  db #1f,#0c,#0d
  db "  Effects: "
txt_optionsound:
  db "Yes   "
  db #1f,#0c,#0e
  db "  Input: "
txt_optioninputmethod:
  db "Joystick"
  db #1f,#0c,#0f
  db "  Redefine keys"
  
  db #1f,#0c,#10
  db "  Players: "
txt_optionnumplayers:
  db "1       "
  db #1f,#0c,#12
  db "  Exit             "
txt_optionsblank3:
  db 21;#0f
  db #1f,#0c,#11
  db "                  "

txt_resurrected:   defb "RESURRECTED",255
txt_pressakeyfor:  defb "Ply 1 key for ",255
txt_pressakeyfor2: defb "Ply 2 key for ",255
txt_up:            defb "up   ",255
txt_down:          defb "down ",255
txt_left:          defb "left ",255
txt_right:         defb "right",255
txt_fire:          defb "fire ",255
txt_pause:         defb "pause",255
inputmethod:       defb "Input: ",255
joysticktext:      defb "Joystick",255
keyboardtext:      defb "Keyboard",255
customtext:        defb "Custom  ",255
optionyes:         defb "Yes",255
optionno:          defb "No ",255
set1playertext:    defb "1",255
set2playertext:    defb "2",255

currentmenuoption:  defb 0
ismainmenu:         defb 0

setmainmenu:
  xor a
  ld (charbuffer),a
  ld (currentmenuoption),a
  ld a,1
  ld (ismainmenu),a
  ld a,3
  ld (maxmenuselect-1),a
ret
setoptionmenu:
  xor a
  ld (charbuffer),a
  ld (currentmenuoption),a
  xor a
  ld (ismainmenu),a
  ld a,8
  ld (maxmenuselect-1),a
ret

; OPTION MENU SELECTION
selectup:
  ld a,(currentmenuoption)
  dec a
  cp 255 
  jr z,awaitnextkeyfrommenu      ; DON'T GO PAST OPTION 1
  dodisplaypointer:
  ld (currentmenuoption),a
  call clearpointers
  ld a,(currentmenuoption)
  call displaypointer
  awaitnextkeyfrommenu:
  ld a,(ismainmenu)
  or a
  jp z,dowaitnextscoreboardkeypress2
  jp waitmainmenukeypress

selectdown:
  ld a,(currentmenuoption)
  inc a
  cp 8:maxmenuselect
  jr z,awaitnextkeyfrommenu      ; DON'T GO PAST OPTION 6
  jr dodisplaypointer
selectright:
  ld a,(currentmenuoption)
  or a
  jp z,incgamespeed
  dec a
  jp z,incgamedifficulty
  dec a
  jp z,incmusic
  dec a
  jp z,inceffects
  dec a
  jp z,setjoystickinput
  dec a
  dec a
  jp z,set2players
  jp dowaitnextscoreboardkeypress2
selectleft:
  ld a,(currentmenuoption)
  or a
  jp z,decgamespeed
  dec a
  jp z,decgamedifficulty
  dec a
  jp z,decmusic
  dec a
  jp z,deceffects
  dec a
  jp z,setkeyboardinput
  dec a
  dec a
  jp z,set1player
  jp dowaitnextscoreboardkeypress2
selectfire:
  ld a,(ismainmenu)
  or a
  jr z,selectfireoptionsmenu
  
  ; MAIN MENU SELECTION
  ld a,(currentmenuoption)
  or a
  jp z,showinstructions
  dec a
  jp z,showoptions
  dec a
  jp z,playthegame
  
  ; OPTIONS MENU SELECTION
  selectfireoptionsmenu:
  ld a,(currentmenuoption)
  cp 5
  jp z,redefinekeys
  cp 7
  jp z,returntomainmenu
  jp dowaitnextscoreboardkeypress2

returntomainmenu:
  call clearpointers
  ld hl,txt_setuphighscorescreennocls
  call printstring
  jp mainmenudrawhighscoretable;drawmainmenu

clearpointers:
  ld a,(ismainmenu)
  or a
  jr z,clearoptionpointers
  ld hl,pointerpositions2
  jr clearpointersloop
  clearoptionpointers:
  ld hl,pointerpositions
  clearpointersloop:
    ld a,(hl)
    or a
    ret z
	push hl
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	call clearpointer
	pop hl
	inc hl
	inc hl
  jr clearpointersloop
  
clearpointer:
  call locatetextf
  ld d,h
  ld e,l
  ld a," "
  jp writecharplainf

displaypointer:
  ld a,(ismainmenu)
  or a
  jr z,displaypointeroptions
  ld hl,pointerpositions2
  jr dodisplaypointer2
  displaypointeroptions:
  ld hl,pointerpositions
  dodisplaypointer2:
  ld a,(currentmenuoption)
  call vectorlookuphl
  call locatetextf
  ld d,h
  ld e,l
  ld a,">"
  jp writecharplainf

pointerpositions:
  defw &0b09
  defw &0b0a
  defw &0b0b
  defw &0b0c
  defw &0b0d
  defw &0b0e
  defw &0b0f
  defw &0b11
  defw 0
  
pointerpositions2:
  defw &0b0f
  defw &0b10
  defw &0b11
  defw 0

; INPUT
; A = 1 TO 5, GAME SPEED
incgamespeed:
  ; LIMIT 1 TO 5
  ld a,(txt_optiongamespeed)
  sub #30
  inc a
  cp 6
  jp z,awaitnextkeyfrommenu
  jr setgamespeed
decgamespeed:
  ; LIMIT 1 TO 5
  ld a,(txt_optiongamespeed)
  sub #30
  dec a
  or a
  jp z,awaitnextkeyfrommenu
setgamespeed:
  ld (mummyinterruptspeed-1),a
  ; UPDATE SCREEN WITH CHANGE
  add #30
  ld (txt_optiongamespeed),a
  
  ; RESET MUMMY MOVEMENT COUNTER VARIABLE WHEN WE CHANGE SPEED
  ; SO MUMMIES KEEP MOVING
  xor a
  ld (interruptcountermummies),a
  
  ld hl,&1909
  call locatetextf
  ld d,h
  ld e,l
  ld a,(txt_optiongamespeed)
  call writecharplainf
  jp awaitnextkeyfrommenu

; INPUT
; A = 1 TO 5, GAME DIFFICULTY
incgamedifficulty:
  ; LIMIT 1 TO 5
  ld a,(txt_optiondifficulty)
  sub #30
  inc a
  cp 6
  jp z,awaitnextkeyfrommenu
  jr setdifficulty
decgamedifficulty:
  ; LIMIT 1 TO 5
  ld a,(txt_optiondifficulty)
  sub #30
  dec a
  or a
  jp z,awaitnextkeyfrommenu
setdifficulty:
  ; UPDATE SCREEN WITH CHANGE
  add #30
  ld (txt_optiondifficulty),a 
  call dosetdifficulty
  
  ;sub #30

  ; SET DIFFICULTY
  ;ld b,a
  ;ld hl,#07f8
  ;l6477a:
  ;  add hl,hl
  ;djnz l6477a
  ;ld a,h
  ;ld (gamedifficulty),a
  
  ld hl,&190a
  call locatetextf
  ld d,h
  ld e,l
  ld a,(txt_optiondifficulty)
  call writecharplainf
  jp awaitnextkeyfrommenu

dosetdifficulty:
  ; SET DIFFICULTY
  ld a,(txt_optiondifficulty)
  sub #30
  ld b,a
  ld hl,#07f8
  l6477aa:
    add hl,hl
  djnz l6477aa
  ld a,h
  ld (gamedifficulty),a
ret

; INPUT
; A = "n" or "y"
incmusic:
  ld a,"Y"
  ld (backgroundmusic),a
  ld hl,&140b
  call locatetextf
  ld d,h
  ld e,l
  ld hl,optionyes
  call writelineplainf

  ld hl,optionyes
  ld de,txt_optionmusic
  ld bc,3
  ldir
  
  call enablemusic
  
  jp awaitnextkeyfrommenu
decmusic:
  ld a,"N"
  ld (backgroundmusic),a
  ld hl,&140b
  call locatetextf
  ld d,h
  ld e,l
  ld hl,optionno
  call writelineplainf

  ld hl,optionno
  ld de,txt_optionmusic
  ld bc,3
  ldir
  
  call disablemusic
  
  jp awaitnextkeyfrommenu

; INPUT
; A = "n" or "y"
inceffects:
  ld a,"Y"
  ld (soundeffects),a
  
  ld hl,&160c
  call locatetextf
  ld d,h
  ld e,l
  ld hl,optionyes
  call writelineplainf

  ld hl,optionyes
  ld de,txt_optionsound
  ld bc,3
  ldir
  jp awaitnextkeyfrommenu
  
deceffects:
  ld a,"N"
  ld (soundeffects),a
  
  ld hl,&160c
  call locatetextf
  ld d,h
  ld e,l
  ld hl,optionno
  call writelineplainf

  ld hl,optionno
  ld de,txt_optionsound
  ld bc,3
  ldir
  jp awaitnextkeyfrommenu

; ========================================================
; JOYSTICK SCOREBOARD NAME ENTRY
; --------------------------------------------------------

km_wait_key:
  call mc_wait_flyback
  call km_read_key
  jr nc,km_wait_key
ret

km_check_keyrelease:
  ld hl,matrix_buffer
  ld b,10
  ld a,255
  km_wait_keyreleaseloop2:
    cp (hl)
	jr nz,returnkeyheld
	inc hl
  djnz km_wait_keyreleaseloop2
  ; WE HAVE KEY RELEASE
  ; RECORD IT
  scf;xor a ; CLEAR CARRY FLAG
ret
returnkeyheld:
  xor a ; CLEAR CARRY FLAG
ret

km_wait_keyrelease:
  push af
  push bc
  km_wait_keyrelease2:
  call mc_wait_flyback
  ld hl,matrix_buffer
  ld b,10
  ld a,255
  km_wait_keyreleaseloop:
    cp (hl)
	jr nz,km_wait_keyrelease2
	inc hl
  djnz km_wait_keyreleaseloop
  pop bc
  pop af
ret

delcharnameentry:
  pop hl
  pop bc         ; CHECK NUMBER OF CHARACTERS PLAYER HAS ENTERED
  ld a,b         ; MAKE SURE WE DON'T DELETE TOO FAR!
  sub 12         ; IF IT IS ZERO, GO BACK TO START
  or a
  jr z,printscores2
  
  push bc
  push hl
  dec hl
  ld (hl)," ";&80
  dec de              
  dec de
  ld a," "
  call writecharplainf  ; CLEAR CURRENT CHAR AND CURSOR
  ld a," "
  call writecharplainf  ; CLEAR CURSOR
  dec de
  dec de
  dec de
  dec de
  call writecursor      ; REDRAW CURSOR
 
  pop hl
  dec hl
  pop bc
  inc b                 ; MAKE SURE WE CAN STILL TYPE UP TO 6 CHARS
  jr printnamestrloop

currentjoykey: defb 0

decrementcurrentkey:
  ld a,(currentjoykey)
  or a
  jr z,setcurrentjoykeya
  dec a
  
  ; DON'T GO BEYOND BOUNDS OF ALPHABET
  sub " "
  jr c,getanotherkey
  add " "
  
  ld (currentjoykey),a
  jr displaycurrentjoykey
incrementcurrentkey:
  ld a,(currentjoykey)
  or a
  jr z,setcurrentjoykeya
  inc a
  
  ; DON'T GO BEYOND BOUNDS OF ALPHABET
  sub "Z"+1
  jr nc,getanotherkey
  add "Z"+1
  
  ld (currentjoykey),a
  jr displaycurrentjoykey
setcurrentjoykeya:
  ld a,"A"
  ld (currentjoykey),a
  displaycurrentjoykey:
  push af
  call writecharplainf
  pop af
  dec de
  dec de
  jr getanotherkey
  
joymovenextchar:
  ld a,(currentjoykey)
  or a ; NO KEY SELECTED, JUST ENTER
  jp z,finishnameentryloop
  
  push af
  call writecharcursor
  xor a
  ld (currentjoykey),a
  pop af
jr storekeymovenext


; INPUT
; HL = SCOREBOARD ENTRY
; DE = SCREEN POS
; PRINT SCORE BOARD
printscores:
    ; RESET CURRENT KEY FOR JOYSTICK ENTRY
    xor a
    ld (currentjoykey),a
    
    printscores2:

    ; NAME
    ld b,12;6 ; STOP IF WE REACH 12 CHARS
    printnamestrloop:
	  push bc
	  push hl
      
	  ; PRINT CURSOR SO PLAYER KNOWS TO ENTER NAME
	  call writecursor
	  call enableblinkcursor
	  
      getanotherkey:	
	    call km_wait_key   ; GET KEYPRESS
	    call km_wait_keyrelease
		  
	    cp 10 ; ENTER
	    jp z,finishnameentryloop
	    cp 13 ; ENTER
	    jp z,finishnameentryloop
	    cp &7f  ; DEL
	    jp z,delcharnameentry
	    cp "l" ; JOY LEFT
	    jp z,delcharnameentry
		cp "f" ; JOY RIGHT
		jr z,joymovenextchar
	    cp "u" ; JOY UP
		jr z,incrementcurrentkey
		cp "d" ; JOY DOWN
		jp z,decrementcurrentkey
		
		; ONLY ACCEPT ALPHANUMERIC KEYS
	    sub "Z"+1
        jr nc,getanotherkey
        add "Z"+1
	    sub " "
        jr c,getanotherkey
        add " "
		
	    push af               ; BACK UP CHAR
	    pop bc                ; CHECK IF THIS IS LAST CHAR 
	    ld a,b
	    push bc
	    or a                  ; IF SO, DON'T PRINT CURSOR
	    jr z,printnocursor2
	    pop af
	    push af
        call writecharcursor
	    pop af
		jr storekeymovenext
	    printnocursor2:       ; PRINT NO CURSOR ON THE LAST LETTER SO IT DOESN'T TRASH SCREEN
	    push af
	    call writecharplainf
		pop af
		
	  storekeymovenext:
	  pop hl	  
	  ld (hl),a
	  
      pop bc
      inc hl
    djnz printnamestrloop
	call blinkcursor            ; MAKE SURE CURSOR IS ERASED IF WE USE ALL 12 LETTERS
    nameentrycomplete:
	call disablesecondinterrupt ; STOP BLINKING CURSOR
	jp finishedscoreboardnameentry2

; DISABLE PALETTE FADE / CURSOR BLINK
disablesecondinterrupt:
  xor a;ld a,0  ; CALL = &CD
  ld bc,0 ; secondinterruptcommand
  jr setsecondinterrupt
; ENABLE THE CURSOR TO BLINK ON THE SCOREBOARD
enableblinkcursor:
  ld a,&CD  ; CALL = &CD
  ld bc,blinkcursor ; secondinterruptcommand
  setsecondinterrupt:
  ld (secondinterruptcommand-1),a
  ld (secondinterruptfunction-2),bc
ret

flashplayer1: defb 0
flashplayer2: defb 0

; FLASH PLAYER SPRITE IF HE COLLIDES WITH A MUMMY
enableflashplayer1sprite:
  ld a,7                    ; SET FLASH COUNTER
  ld (flashplayer1),a
  ld a,&CD  ; CALL = &CD
  ld bc,flashplayersprite ; secondinterruptcommand
  jr setsecondinterrupt
  
; FLASH PLAYER SPRITE IF HE COLLIDES WITH A MUMMY
enableflashplayer2sprite:
  ld a,7                    ; SET FLASH COUNTER
  ld (flashplayer2),a
  ld a,&CD  ; CALL = &CD
  ld bc,flashplayersprite ; secondinterruptcommand
  jr setsecondinterrupt

flashplayersprite:
  ; CHECK IF WE HAVE FLASHED ALL FLASHES FOR PLAYER 1 AND 2
  ; IF SO, DISABLE INTERRUPT
  ld bc,(flashplayer1)
  ld a,b
  or c
  jr z,disablesecondinterruptspritecolours

  ; CHECK IF PLAYER 1 NEEDS FLASHED
  ld a,(flashplayer1)
  or a
  jr z,tryflashplayer2
  dec a
  ld (flashplayer1),a
  
  ; TOGGLE FLASH SPRITE
  and &01 ; EVEN OR ODD?
  cp 1    ; IS EVEN
  jr z,setplayer1spritecoloursnormal
  
  ; FLASH SPRITE COLOURS
  ld hl,sprite_colours_white
  jr setplayer1spritecolours
 
  setplayer1spritecoloursnormal:
    ;; copy colours into ASIC sprite palette registers
  ld hl,sprite_colours_normal_1
  setplayer1spritecolours:
  ld de,&6422
  ld bc,3*2
  ldir

  
  tryflashplayer2:
  ; CHECK IF PLAYER 2 NEEDS FLASHED
  ld a,(flashplayer2)
  or a
  ret z ; NOTHING TO FLASH
  dec a
  ld (flashplayer2),a

  ; TOGGLE FLASH SPRITE
  and &01 ; EVEN OR ODD?
  cp 1    ; IS EVEN
  jr z,setplayer2spritecoloursnormal
  
  ; FLASH SPRITE COLOURS
  ld hl,sprite_colours_white
  jr setplayer2spritecolours
 
  setplayer2spritecoloursnormal:
    ;; copy colours into ASIC sprite palette registers
  ld hl,sprite_colours_normal_2
  setplayer2spritecolours:
  ld de,&6422+&000c
  ld bc,3*2
  ldir
ret

disablesecondinterruptspritecolours:
  call setplayer1spritecoloursnormal
  call setplayer2spritecoloursnormal
  jp disablesecondinterrupt

; -GRB
sprite_colours_normal_1:
  defw &060f			;; colour for sprite pen 1 = BLUE
  defw &0ff0			;; colour for sprite pen 2 = YELLOW
  defw &09f0			;; colour for sprite pen 3 = ORANGE
  
  ; PLAYER 2 COLOURS
sprite_colours_normal_2:
  defw &00f6			;; 11 BLUE        - OVERALLS
  defw &0ff0			;; 12 YELLOW      - SHIRT
  defw &09f0			;; 13 ORANGE      - FACE

sprite_colours_white:
  defw &0fff			;; colour for sprite pen 1 = BLUE
  defw &0fff			;; colour for sprite pen 2 = YELLOW
  defw &0fff			;; colour for sprite pen 3 = ORANGE

; PLAYER PRESSED ENTER BEFORE 6 CHARS OF NAME ARE PRINTED
; FILLED REST OF NAME WITH SPACES
; INPUT
; HL = CURRENT POSITION IN SCOREBOARD NAME ENTRY
; DE = SCREEN POS
finishnameentryloop:
  pop hl
  pop bc

  call writecursor 
  finishnameentryloop2:
    ld a," "
    cp (hl)
    jp nz,nameentrycomplete
    inc hl    
    call writecharplainf ; MOVE ON A SPACE CHARACTER - MAKE SURE TO ERASE CURSOR
  jr finishnameentryloop2

; INPUT
; A = CHAR
; DE = SCREEN POS
writecharcursor:
  call writecharplainf
  jp writecursor

; RECORD LAST POSITION SO WE CAN BLINK IT
cursorpos: defw 0

blinkcursor:
  ld de,(cursorpos)
  ld a,d
  or a                  ; DON'T BLINK IF WE DON'T HAVE A POSITION
  ret z
  ld b,8
  writecursorloop2:
    ; WRITE TO SCREEN
	push de
    ld a,(de)
    xor &0f
    ld (de),a
    inc de
    ld a,(de)
    xor &0f
    ld (de),a
	pop de
  
    ex de,hl              ; MOVE TO NEXT PIXEL LINE DOWN
    call scr_next_line_hl
    ex de,hl
  djnz writecursorloop2
ret

; INPUTS
; DE = SCREEN POS
; XOR SAME POSITION TO ERASE AGAIN
writecursor:
  push de
  push hl
  
  ld b,8
  writecursorloop:
    ; WRITE TO SCREEN
	push de
    ld a,(de)
    xor &0f
    ld (de),a
    inc de
    ld a,(de)
    xor &0f
    ld (de),a
	pop de
  
    ex de,hl              ; MOVE TO NEXT PIXEL LINE DOWN
    call scr_next_line_hl
    ex de,hl
  djnz writecursorloop 
  
  pop hl
  pop de
  ld (cursorpos),de
ret

; Z80 BIT *,a COMMANDS AS MACHINE CODE - LITTLE ENDIAN
bit0a equ &47CB
bit1a equ &4FCB
bit2a equ &57CB
bit3a equ &5FCB
bit4a equ &67CB
bit5a equ &6FCB
bit6a equ &77CB
bit7a equ &7FCB
 
istwoplayer: defb 1
player1alive: defb 0
player2alive: defb 0
 
; REDEFINE KEYS
redefinekeys:
  ld hl,redefinekeytable
  ld (redefinekeyptr),hl
  
  ld hl,&0d0f
  call locatetextf  
  ld de,txt_pressakeyfor
  call writelineplainfde

  call doredefinekeys
  
  ; ONLY ASK PLAYER 2 KEYS IF TWO PLAYER MODE SELECTED
  ld a,(istwoplayer)
  cp 2
  jp nz,setcustominput
  
  ; PLAYER 2
  ld hl,&0d0f
  call locatetextf
  ld de,txt_pressakeyfor2
  call writelineplainfde
  
  call doredefinekeysplayer2

  jp setcustominput

setcustominput:
  ; CLEAR PLAYER INPUT TEXTS
  ;ld hl,txt_optionsblank2
  ;call printstring
  ld hl,txt_options2;txt_optionsblank3
  call printstring
  ld hl,txt_optionsblank3
  call printstring
  call displaypointer
  
  ; PRINT INPUT METHOD
  ld hl,customtext
  jr drawinputmethod
setkeyboardinput:
  call setkeyboardbits
  ld hl,keyboardtext
  jr drawinputmethod
setjoystickinput:
  call setjoystickbits
  ld hl,joysticktext
  drawinputmethod:
  push hl
  ld de,txt_optioninputmethod
  ld bc,8
  ldir
  pop hl
  ex de,hl
  ld hl,&140d
  call locatetextf
  call writelineplainfde
jp dowaitnextscoreboardkeypress2

set2players:
  ld a,2
  ld hl,set2playertext
  jr drawnumplayers
set1player:
  ld a,1
  ld hl,set1playertext
  drawnumplayers:
  ld (istwoplayer),a
  push hl
  ld de,txt_optionnumplayers
  ld bc,1
  ldir
  pop hl
  ex de,hl
  ld hl,&160f
  call locatetextf
  call writelineplainfde
  jp dowaitnextscoreboardkeypress2

doredefinekeys:
  ld hl,&1110
  ld de,txt_up
  call redefinekey

  ld hl,&1110
  ld de,txt_down
  call redefinekey
  
  ld hl,&1110
  ld de,txt_left
  call redefinekey
 
  ld hl,&1110
  ld de,txt_right
  call redefinekey
  
  ld hl,&1110
  ld de,txt_fire
  call redefinekey
  
  ld hl,&1110
  ld de,txt_pause
  jp redefinekey
  ; REWRITE REDEFINE KEYS TITLE
  ;ld hl,&030F
  ;call locatetextf
  ;ld de,redefinekeystext
  ;jp writelineplainf

doredefinekeysplayer2:
  ld hl,&1110
  ld de,txt_up
  call redefinekey

  ld hl,&1110
  ld de,txt_down
  call redefinekey
  
  ld hl,&1110
  ld de,txt_left
  call redefinekey
 
  ld hl,&1110
  ld de,txt_right
  call redefinekey
  
  ld hl,&1110
  ld de,txt_fire
  jp redefinekey

; INPUT 
; HL = POSITION ON SCREEN
; DE = TEXT TO PRINT
redefinekey:
  call locatetextf           ; WRITE PROMPT FOR KEY
  call writelineplainfde 
  waitforupkey:
  
    ; SET SPEED OF GAME FOR WALKING
    ld a,(mummymovementok)        ; WAIT UNTIL INTERRUPT TELLS US TO MOVE MUMMIES
    or a
    jr nz,skipmovemummiesmenub    ; WE HAVE MOVED MUMMIES ALREADY
    ld a,1                        ; MARK THAT WE HAVE COMPLETED DELAY
    ld (mummymovementok),a	
	
	; RECORD WHETHER WE ARE TO MOVE ODD OR EVEN MUMMIES IN THIS LOOP
	; WE NEED TO DO THIS TO KEEP GAME SPEED REGULAR
	
	ld a,(moveoddevenmummies)
	xor 1
	ld (moveoddevenmummies),a
	or a
	jr z,moveevenmummies4
	
    ld b,1                   ; MOVE ODD MUMMIES
	jr domovemummies4
	moveevenmummies4:
	ld b,2                   ; MOVE EVEN MUMMIES
	domovemummies4:
	call domummymovements
	
	skipmovemummiesmenub:
	
    call km_read_key_id      ; GET KEY FROM USER
  jr nc,waitforupkey         ; NO KEY PRESSED
  call km_wait_keyrelease    ; STOP KEY REPEAT
  ;jr nc,waitforupkey
  dec b  ; START LINE FROM 0 NOT 1 FOR LOOKUP
  ld d,b
  ld e,c
; INPUT
; D = LINE, E = BITS
savelinebitsinkeytable:
  ; GET LINE FROM TABLE
  ld a,d
  ld hl,tableoflines
  call vectorlookuphl
  ld b,h ; GET IN DE
  ld c,l

  ld hl,(redefinekeyptr)
  ld (hl),c
  inc hl
  ld (hl),b
  inc hl
  ld (redefinekeyptr),hl
  
  ; GET BITS FROM TABLE
  ld a,e
  ld hl,tableofbits
  call vectorlookuphl
  ld b,h ; GET IN BC
  ld c,l
  
  ld hl,(redefinekeyptr)
  ld (hl),c
  inc hl
  ld (hl),b
  inc hl  
  ld (redefinekeyptr),hl
ret

; REDEFINABLE JOYSTICK AND KEYS TABLE
; THIS IS USED IN THE ACTUAL GAME REGARDLESS OF INPUT METHOD 
; THE KEYS FOR KEYBOARD OR JOYSTICK ARE COPIED INTO IT
redefinekeyptr: defw 0

redefinekeytable:
  ; PLAYER 1
  defw 0,0
  defw 0,0
  defw 0,0
  defw 0,0
  defw 0,0
  defw 0,0
  ; PLAYER 2
  defw 0,0
  defw 0,0
  defw 0,0
  defw 0,0
  defw 0,0
  defw 0,0
  ;defw 0,0
  ;defw 0,0

; STANDARD JOYSTICK AND KEYS CONFIGURATION
definekeysjoystick:
  ; PLAYER 1
  defw matrix_buffer+9,bit0a
  defw matrix_buffer+9,bit1a
  defw matrix_buffer+9,bit2a
  defw matrix_buffer+9,bit3a
  defw matrix_buffer+9,bit5a ; FIRE 1
  defw matrix_buffer+3,bit3a ; P - PAUSE
  ;defw matrix_buffer+8,bit2a
  ; PLAYER 2
  defw matrix_buffer+6,bit0a
  defw matrix_buffer+6,bit1a
  defw matrix_buffer+6,bit2a
  defw matrix_buffer+6,bit3a
  defw matrix_buffer+6,bit5a ; FIRE 1
  defw matrix_buffer+3,bit3a ; FIRE 2
  ;defw matrix_buffer+8,bit2a
definekeyskeyboard:
  ; PLAYER 1
  defw matrix_buffer+0,bit7a 
  defw matrix_buffer+0,bit6a
  defw matrix_buffer+8,bit7a
  defw matrix_buffer+7,bit7a
  defw matrix_buffer+1,bit7a ; FIRE 1
  defw matrix_buffer+3,bit3a ; P - PAUSE
  ;defw matrix_buffer+8,bit2a
  ; PLAYER 2
  defw matrix_buffer+6,bit5a
  defw matrix_buffer+6,bit7a
  defw matrix_buffer+8,bit7a
  defw matrix_buffer+7,bit7a
  defw matrix_buffer+1,bit7a
  defw matrix_buffer+3,bit3a
  ;defw matrix_buffer+8,bit2a
  
; TABLES MAKE IT EASIER TO LOOK UP ADRESSES FROM AN INTEGER LINE OR BIT
tableoflines:
  defw matrix_buffer+0
  defw matrix_buffer+1
  defw matrix_buffer+2
  defw matrix_buffer+3
  defw matrix_buffer+4
  defw matrix_buffer+5
  defw matrix_buffer+6
  defw matrix_buffer+7
  defw matrix_buffer+8
  defw matrix_buffer+9
tableofbits:
  defw bit0a
  defw bit1a
  defw bit2a
  defw bit3a
  defw bit4a
  defw bit5a
  defw bit6a
  defw bit7a

; JOYSTICK KEYS
setkeyboardbits:
  ld hl,definekeyskeyboard
  jr copykeyboardlinesbits 
setjoystickbits:
  ld hl,definekeysjoystick
  copykeyboardlinesbits:
  ld de,redefinekeytable
  ld bc,24*2
  ldir
ret

defb "CHRISA"

; COPY KEYS LINES AND BITS INTO FUNCTIONS TO CHECK FOR THEM
setlinesandbits:
  ; PLAYER 1
  ; UP
  ld bc,(redefinekeytable+0)
  ld (testkeybuffercommandup-2),bc
  ld bc,(redefinekeytable+2)
  ld (testkeybitcommandup-2),bc
  ; DOWN
  ld bc,(redefinekeytable+4)
  ld (testkeybuffercommanddown-2),bc
  ld bc,(redefinekeytable+6)
  ld (testkeybitcommanddown-2),bc
  ; LEFT
  ld bc,(redefinekeytable+8)
  ld (testkeybuffercommandleft-2),bc
  ld bc,(redefinekeytable+10)
  ld (testkeybitcommandleft-2),bc
  ; RIGHT
  ld bc,(redefinekeytable+12)
  ld (testkeybuffercommandright-2),bc
  ld bc,(redefinekeytable+14)
  ld (testkeybitcommandright-2),bc
  ; FIRE
  ;ld bc,(redefinekeytable+16)
  ;ld (testkeybuffercommandfire-2),bc
  ;ld bc,(redefinekeytable+18)
  ;ld (testkeybitcommandfire-2),bc
  ; PAUSE GAME
  ld bc,(redefinekeytable+20)
  ld (testkeybuffercommandpause-2),bc
  ld bc,(redefinekeytable+22)
  ld (testkeybitcommandpause-2),bc
  ; PLAYER 2
  ; UP
  ld bc,(redefinekeytable+24)
  ld (testkeybuffercommandup2-2),bc
  ld bc,(redefinekeytable+26)
  ld (testkeybitcommandup2-2),bc
  ; DOWN
  ld bc,(redefinekeytable+28)
  ld (testkeybuffercommanddown2-2),bc
  ld bc,(redefinekeytable+30)
  ld (testkeybitcommanddown2-2),bc
  ; LEFT
  ld bc,(redefinekeytable+32)
  ld (testkeybuffercommandleft2-2),bc
  ld bc,(redefinekeytable+34)
  ld (testkeybitcommandleft2-2),bc
  ; RIGHT
  ld bc,(redefinekeytable+36)
  ld (testkeybuffercommandright2-2),bc
  ld bc,(redefinekeytable+38)
  ld (testkeybitcommandright2-2),bc
  ; FIRE
  ;ld bc,(redefinekeytable+40)
  ;ld (testkeybuffercommandfire2-2),bc
  ;ld bc,(redefinekeytable+42)
  ;ld (testkeybitcommandfire2-2),bc
  ; PAUSE GAME
  ;ld bc,(redefinekeytable+44)
  ;ld (testkeybuffercommandpause2-2),bc
  ;ld bc,(redefinekeytable+46)
  ;ld (testkeybitcommandpause2-2),bc
ret



; INPUT - GENERAL
; WHEN PLAYER CHANGES FROM KEYBOARD TO JOYSTICK,
; OR REDEFINES KEYS, THESE MEMORY LOCATIONS AND BIT TESTING COMMANDS ARE OVERWRITTEN WITH CORRECT VALUES
; PLAYER 1
testkeyup:
  ld hl,matrix_buffer+9:testkeybuffercommandup
  ld a,(hl)
  bit 0,a:testkeybitcommandup
ret
testkeydown:
  ld hl,matrix_buffer+9:testkeybuffercommanddown
  ld a,(hl)
  bit 1,a:testkeybitcommanddown
ret
testkeyleft:
  ld hl,matrix_buffer+9:testkeybuffercommandleft
  ld a,(hl)
  bit 2,a:testkeybitcommandleft
ret
testkeyright:
  ld hl,matrix_buffer+9:testkeybuffercommandright
  ld a,(hl)
  bit 3,a:testkeybitcommandright
ret
;testkeyfire:
;  ld hl,matrix_buffer+9:testkeybuffercommandfire
;  ld a,(hl)
;  bit 4,a:testkeybitcommandfire
;ret
testkeypause:
  ld hl,matrix_buffer+3:testkeybuffercommandpause
  ld a,(hl)
  bit 3,a:testkeybitcommandpause
ret
; PLAYER 2
testkeyup2:
  ld hl,matrix_buffer+6:testkeybuffercommandup2
  ld a,(hl)
  bit 0,a:testkeybitcommandup2
ret
testkeydown2:
  ld hl,matrix_buffer+6:testkeybuffercommanddown2
  ld a,(hl)
  bit 1,a:testkeybitcommanddown2
ret
testkeyleft2:
  ld hl,matrix_buffer+6:testkeybuffercommandleft2
  ld a,(hl)
  bit 2,a:testkeybitcommandleft2
ret
testkeyright2:
  ld hl,matrix_buffer+6:testkeybuffercommandright2
  ld a,(hl)
  bit 3,a:testkeybitcommandright2
ret
;testkeyfire2:
;  ld hl,matrix_buffer+6:testkeybuffercommandfire2
;  ld a,(hl)
;  bit 4,a:testkeybitcommandfire2
;ret
;testkeypause2:
;  ld hl,matrix_buffer+3:testkeybuffercommandpause2
;  ld a,(hl)
;  bit 3,a:testkeybitcommandpause2
;ret

; INPUT
; DE = NEW BURN LOCATION
enternewburnp1:
  ld a,(gottorch)
  or a
  ret z
  ld de,(playerspritexy)
  ld (newburnlocationp1),de
ret

; INPUT
; DE = NEW BURN LOCATION
enternewburnp2:
  ld a,(gottorch)
  or a
  ret z
  ld de,(playerspritexy2)
  ld (newburnlocationp2),de
ret

eraselastburnp1:
  ld de,(burntablep1)
  call eraseburn
  
  ; MOVE BURNS UPWARD IN TABLE
  ld de,burntablep1
  ld hl,burntablep1+2
  ld bc,16
  ldir
ret

eraselastburnp2:
  ld de,(burntablep2)
  call eraseburn
  
  ; MOVE BURNS UPWARD IN TABLE
  ld de,burntablep2
  ld hl,burntablep2+2
  ld bc,16
  ldir
ret

; INPUT
; DE = BURN LOCATION TO ERASE
eraseburn:
  ld a,d
  or e
  ret z ; QUIT IF BURN LOCATION ZERO

  ; REDRAW FOOTPRINTS IF NECESSARY
  call getobjectmaplocationfromde
  ld a,(hl)
  call clearspritetrail
  inc e
  inc e
  call getobjectmaplocationfromde
  ld a,(hl)
  call clearspritetrail
  ld a,8
  add d
  ld d,a
  call getobjectmaplocationfromde
  ld a,(hl)
  call clearspritetrail
  dec e  
  dec e
  call getobjectmaplocationfromde
  ld a,(hl)
  jp clearspritetrail

burntablep1:
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
newburnlocationp1:
  defb 0,0 ; COPIED UPWARDS
  defb 0,0 ; BLANK, SO WE EVENTUALLY CLEAR BURNS
  
burntablep2:
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
  defb 0,0 ; X Y BURN LOCATION
newburnlocationp2:
  defb 0,0 ; COPIED UPWARDS
  defb 0,0 ; BLANK, SO WE EVENTUALLY CLEAR BURNS

defb "CHRIS2"  ; AROUND 3F90

; INPUT
; DE = MUMMY LOCATION TO CHECK
checkmummyburnp2:
  ld hl,burntablep2
  jr docheckmummyburn
checkmummyburnp1:
  ld hl,burntablep1
  docheckmummyburn:
  ld b,8
  checkyloop:
    ld a,(hl)
    cp e
	jr nz,skipycheck
	
	inc hl
	ld a,(hl)
	cp d
	jr nz,movenextburnlocation

	; BURN IS SAME LOCATION AS MUMMY
	; KILL MUMMY
	
    ld a,16 ; SET NUMBER OF SPRITE CHANGES TO MAKE AS MUMMY SINKS INTO GROUND
    ld (ix+6),a
  
    ; KILL MUMMY
    xor a
    ld (ix+#00),a       
    ld (ix+#01),a
  
    ; MUMMY DIES
    ld hl,totalnumberofmummies
    dec (hl)
	scf ; RETURN TRUE - SET CARRY FLAG
	ret
	
	skipycheck:
	inc hl
	movenextburnlocation:
	inc hl
  djnz checkyloop
  xor a ; CLEAR CARRY FLAG
ret
  

defb "CHRISP"  ; AROUND 3F90
  
ifndef ISCART
ifndef ISCASSETTE
;defb "CHRIS4"
; RASM INSERT INTO DSK
;SAVE "OHMUMMY3.BIN",&4000,&3B00,DSK,"../compile/build/OhMummyResurrected.dsk" ; LEAVE SPACE FOR FIRMWARE SO IT IS NOT OVERWRITTEN- WE NEED FOR CASETTE LOADING
SAVE "OHMUMMY1.BIN",&0100,&3FDF,DSK,"../compile/build/OhMummyResurrected.dsk"
SAVE "OHMUMMY2.BIN",&C100,&3EFF,DSK,"../compile/build/OhMummyResurrected.dsk" ; LEAVE 100 FOR THE STACK FOR LOADER!

endif
ifdef ISCASSETTE
;save "OHMUMMY3.BIN",&4000,&3B00 ; LEAVE SPACE FOR FIRMWARE SO IT IS NOT OVERWRITTEN - WE NEED FOR CASETTE LOADING
save "OHMUMMY2.BIN",&C100,&3EFF ; LEAVE 100 FOR THE STACK FOR LOADER!
SAVE "OHMUMMY1.BIN",&0100,&3EFF
endif
endif