org &C100
;align 256
amsfonttable:
  defw t1 ; 32 SPACE - 32
  defw t2 ; 33 !
  defw t3 ; 34
  defw t4 ; 35
  defw t5 ; 36
  defw t6 ; 37
  defw t7 ; 38
  defw t8 ; 39
  defw t9 ; 40
  defw t10
  defw t11
  defw t12
  defw t13
  defw t14
  defw t15
  defw t16
  defw t17 ; 1
  defw t18 ; 2
  defw t19 ; 50
  defw t20
  defw t21
  defw t22
  defw t23
  defw t24
  defw t25
  defw t26
  defw t27
  defw t28
  defw t29 ; 60
  defw t30 ; >
  defw t31
  defw t32
  defw t33
  defw t34
  defw t35
  defw t36
  defw t37
  defw t38
  defw t39 ;70
  defw t40 ; 
  defw t41 ; 
  defw t43 ; 
  defw t44 ; 
  defw t45 ; 
  defw t46 ; 
  defw t47 ; M
  defw t48
  defw t49
  defw t50 ;80
  defw t51
  defw t52
  defw t53
  defw t54
  defw t55
  defw t56
  defw t57
  defw t58 ; 
  defw t59 ; Z
  defw t60 ; 90 [
  defw t61 ; 
  defw t62 ;
  defw t63 ; 
  defw t64 ; 
  defw t65 ; 
  defw t66 ; a
  defw t67
  defw t68
  defw t69
  defw t70 ; 100
  defw t71
  defw t72
  defw t73
  defw t74
  defw t75
  defw t76
  defw t77
  defw t78
  defw t79
  defw t80 ; 110
  defw t81
  defw t82
  defw t84
  defw t85
  defw t86
  defw t87
  defw t88
  defw t89
  defw t90
  defw t91 ; 120
  defw t92 ; 
  defw t93 ; z
  defw t94 ; {
  defw t95 ; |
  defw t96 ; }
  defw t97 ; ~
  defw t98 ; DEL
  defw t99 ; " "
  defw t100 ; BLOCK
  defw t101 ; 130
  defw t102 
  defw t103
  defw t104
  defw t105
  defw t106
  defw t107mummy1 ; 136
  defw t108
  defw t109
  defw t110 
  defw t111 ; 140
  defw t112
  defw t113
  defw t114 ; 
  defw t115
  defw t116
  defw t117 
  defw t118 
  defw t119
  defw t120 
  defw t121 ; 150
  defw t122
  defw t123
  defw t125
  defw t126
  defw t127
  defw t128
  defw t129
  defw t130
  defw t131 
  defw t132 ; 160
  defw t133
  defw t134
  defw t135 ; 164 COPYRIGHT?
  defw t136
  defw t137
  defw t138
  defw t139
  defw t140 
  defw t141 
  defw t142 ; 170 
  defw t143 
  defw t144 
  defw t145 
  defw t146 
  defw t147
  defw t148
  defw t149
  defw t150
  defw t151
  defw t152 ; 180
  defw t153
  defw t154
  defw t155
  defw t156
  defw t157
  defw t158
  defw t159
  defw t160
  defw t161
  defw t162
  defw t163
  defw t164
  defw t166
  defw t167
  defw t168
  defw t169
  defw t170
  defw t171
  defw t172
  defw t173
  defw t174
  defw t175
  defw t176
  defw t177
  defw t178
  defw t179
  defw t180
  defw t181
  defw t182
  defw t183
  defw t184
  defw t185
  defw t186
  defw t187
  defw t188
  defw t189
  defw t190
  defw t191
  defw t192
  defw t193
  defw t194
  defw t195
  defw t196
  defw t197
  defw t198
  defw t199
  defw t200
  defw t201 
  defw t202 
  defw t203
  defw t204
  defw t205
  defw t207
  defw t208
  defw t209
  defw t210
  defw t211
  defw t212
  defw t213
  defw t214
  defw t215
  defw t216
  defw t217 
  defw t218 
  defw t219
  defw t220
  defw t221
  defw t222
  defw t223
  defw t224

align 256 ; STARTS C300
jumptable:
  jp playsound_all_channelsf  ;39
  jp initmusicf
  jp playmusicf
  jp playsound_a
  jp playsound_b
  jp playsound_c
  jp initsoundf
  jp docleansweepnoise
  jp dolazerboltnoise
  jp dodiednoise
  jp setupplussprites
  jp hideallplussprites
  jp moveplussprite2
  jp updateplayersprite
  jp updateplayer2sprite
  jp updatemummysprite
  jp drawmummyspritenomovement
  jp hideplussprite
  jp playgameovermusic

boximagestable:
  defw image_torch
  defw image_key
  defw image_sarcophagus
  defw image_scroll
  defw image_treasure
  defw image_ankh
  defw image_elixir
  
updateplayer2spritetable:
updateplayerspritetable:
  defw plussprite_weemandown1
  defw plussprite_weemandown2
  defw plussprite_weemanup1
  defw plussprite_weemanup2
  defw plussprite_weemanleft1
  defw plussprite_weemanleft2
  defw plussprite_weemanright1
  defw plussprite_weemanright2
  
updatemummyspritetable:
  defw plussprite_mummydown1
  defw plussprite_mummydown2
  defw plussprite_mummyup1
  defw plussprite_mummyup2
  defw plussprite_mummyleft1
  defw plussprite_mummyleft2
  defw plussprite_mummyright1
  defw plussprite_mummyright2
  ; FADED SPRITES - MUMMY TURNS TO DUST
  defw plussprite_mummyfaded16
  defw plussprite_mummyfaded15
  defw plussprite_mummyfaded14
  defw plussprite_mummyfaded13
  defw plussprite_mummyfaded12
  defw plussprite_mummyfaded11
  defw plussprite_mummyfaded10
  defw plussprite_mummyfaded9
  defw plussprite_mummyfaded8
  defw plussprite_mummyfaded7
  defw plussprite_mummyfaded6
  defw plussprite_mummyfaded5
  defw plussprite_mummyfaded4
  defw plussprite_mummyfaded3
  defw plussprite_mummyfaded2
  defw plussprite_mummyfaded1
  
updatemummyspritetable2:
  ; SWEEPER MUMMY
  defw plussprite_mummybrushdown1
  defw plussprite_mummybrushdown2
  defw plussprite_mummybrushup1
  defw plussprite_mummybrushup2
  defw plussprite_mummybrushleft1
  defw plussprite_mummybrushleft2
  defw plussprite_mummybrushright1
  defw plussprite_mummybrushright2
  
ifdef ISCART
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
endif

; INPUT
; A = IMAGE NUMBER IN TABLE TO UPDATE PLAYER PLUS SPRITE WITH
updateplayersprite:
  ld (vect-1),a
  ex de,hl
  
  ; MOVE SPRITE TO NEW POSITION
  xor a ; SPRITE ID TO MOVE
  call moveplussprite2
  
  ; GET NEW SPRITE IMAGE
  ld hl,updateplayerspritetable
  ld a,0:vect
  call vectorlookuphl
  
  ; UPDATE ASIC IMAGE
  ld de,&4000
  ld bc,256;&100
  ldir
ret
  
; INPUT
; A = IMAGE NUMBER IN TABLE TO UPDATE PLAYER PLUS SPRITE WITH
updateplayer2sprite:
  ld (vecta-1),a
  ex de,hl
  
  ; MOVE SPRITE TO NEW POSITION
  ld a,15 ; SPRITE ID TO MOVE
  call moveplussprite2
  
  ; GET NEW SPRITE IMAGE
  ld hl,updateplayer2spritetable
  ld a,0:vecta
  call vectorlookuphl
  
  ; UPDATE ASIC IMAGE
  ; JUST ALTER COLOURS FOR SECOND PLAYER - SAVES MEMORY
  ld de,&4f00
  ld b,255;&100
  updateplayer2spriteloop:
    ld a,(hl)
	or a
	jr z,skipupdateplayer2spriteloop
	add 6
	skipupdateplayer2spriteloop:
	ld (de),a
	inc hl
	inc e
  djnz updateplayer2spriteloop
ret
  
; INPUT
; IX = MUMMY DATA LOCATION
; A = IMAGE NUMBER IN TABLE TO UPDATE PLAYER PLUS SPRITE WITH
updatemummysprite:
  ld (vect2-1),a
  ex de,hl
  
  ; MOVE SPRITE TO NEW POSITION
  ld a,(ix+5)
  call moveplussprite2
  
  ; GET NEW SPRITE IMAGER
  ld a,(ix+7) ; CHECK MUMMY TYPE
  or a
  jr z,skipsweepermummytable
  ; NORMAL MUMMY SPRITE
  ld hl,updatemummyspritetable2
  jr domummyspritelookup
  skipsweepermummytable:
  ; SWEEPER MUMMY SPRITE
  ld hl,updatemummyspritetable
  
  domummyspritelookup:
  ld a,0:vect2
  call vectorlookuphl
  
  ; UPDATE ASIC IMAGE
  ld a,(ix+5) ; NUMBER OF MUMMY SPRITE TO UPDATE
  add &40
  ld d,a
  ld e,&00
  ld bc,256
  ldir
ret

; SAME AS ABOVE, BUT ONLY REDRAW SPRITE - DO NOT MOVE IT
; THIS IS USED FOR FADING MUMMIES AFTER THEY COLLIDE WITH PLAYER
; INPUT
; IX = MUMMY DATA LOCATION
; A = IMAGE NUMBER IN TABLE TO UPDATE PLAYER PLUS SPRITE WITH
drawmummyspritenomovement:
  ; GET NEW SPRITE IMAGE
  ld hl,updatemummyspritetable
  call vectorlookuphl
  
  ; UPDATE ASIC IMAGE
  ld a,(ix+5) ; NUMBER OF MUMMY SPRITE TO UPDATE
  add &40
  ld d,a
  ld e,&00
  ld bc,256
  ldir
ret

numplussprites equ 16   ; MAX MUMMIES + PLAYER

hideallplussprites:
  ld b,numplussprites
  hideallplusspritesloop:
    call hideplussprite
  djnz hideallplusspritesloop
  jp hideplussprite

; INPUT
; B = SPRITE NUMBER
hideplussprite:
  push hl
  push af
  ld a,b

  ; GET CORRECT POSITION OF SPRITE NUMBER IN ASIC RAM
  rlca
  rlca
  rlca

  ;; set x coordinate for sprite 0
  ld h,&60
  ld l,a
  ;ld (hl),e

  inc l
  inc l
  ;; set y coordinate for sprite 0
  ;ld (hl),d

  inc l
  inc l
  ;; set sprite x and y magnification
  ;; x magnification = 1
  ;; y magnification = 1
  ;ld a,%1001
  ld (hl),0 ; HIDE SPRITE
  pop af
  pop hl
ret

; INPUT
; A = SPRITE NUMBER
; HL = Y X POSITION
moveplussprite2:  
  push hl
  ; GET CORRECT POSITION OF SPRITE NUMBER IN ASIC RAM
  rlca
  rlca
  rlca

  ld b,h     ; STORE HEIGHT IN B

  ld h,0     ; FIND X POS
  add hl,hl  ; DOUBLE
  add hl,hl
  add hl,hl  ; DOUBLE AGAIN TO GET X PIXEL COORDINATE
  ;add hl,hl
  
  ex de,hl
  ;; set x coordinate for sprite 0
  ld h,&60
  ld l,a
  ld (hl),e
  inc l
  ld (hl),d

  inc l
  ;; set y coordinate for sprite 0
  ;ld a,b 
  ;rlca      ; TRIPLE H TO GET Y POS LINE
  ;rlca
  ;rlca
  ld (hl),b

  inc l
  inc l
  ;; set sprite x and y magnification
  ;; x magnification = 1
  ;; y magnification = 1
  ld a,%1001
  ld (hl),a
  pop hl
ret

  
setupplussprites:
  ;;--------------------------------------------------
  ;; STEP 2 - Setup sprite pixel data
  ;;
  ;; The ASIC has internal "RAM" used to store the sprite pixel
  ;; data. If you want to change the pixel data for a sprite
  ;; then you need to copy new data into the internal "RAM".
 
  ;; copy colours into ASIC sprite palette registers
  ld hl,sprite_colours
  ld de,&6422
  ld bc,15*2
  ldir
ret

; -GRB
sprite_colours:
  ; PLAYER 1 COLOURS
  defw &060f			;;  1 BLUE        - OVERALLS
  defw &0ff0			;;  2 YELLOW      - SHIRT
  defw &09f0			;;  3 ORANGE      - FACE
  defw &0000			;;  4 BLACK       - EYES
  defw &030f            ;;  5 DARK BLUE   - OVERALLS SHADING
  defw &0990            ;;  6 DARK YELLOW - SHIRT SHADING
  
  ; PLAYER 2 COLOURS
  defw &00f6			;; 11 BLUE        - OVERALLS
  defw &0ff0			;; 12 YELLOW      - SHIRT
  defw &09f0			;; 13 ORANGE      - FACE
  defw &0000			;; 14 BLACK       - EYES
  defw &00f3            ;; 15 DARK BLUE   - OVERALLS SHADING
  defw &0990            ;; 16 DARK YELLOW - SHIRT SHADING
  
  ; MUMMY COLOURS
  defw &03c3            ;;  7 LIGHT BROWN BROOM
  defw &0660            ;;  8 DARKER YELLOW - MUMMY SKIRT
  defw &0ff0			;;  9 MUMMY YELLOW - SEPARATE FROM PLAYER YELLOW


image_sarcophagus:
        DB      #3F, #FF, #FF, #FF, #CE, #7F
        DB      #0B, #FF, #FF, #8D, #04, #BF
        DB      #09, #0F, #0F, #0F, #08, #01
        DB      #08, #04, #04, #13, #0F, #0E
        DB      #0C, #01, #01, #13, #55, #55
        DB      #87, #0B, #0B, #1A, #5D, #56
        DB      #D2, #1E, #1E, #1E, #5A, #5A
        DB      #F8, #F0, #F0, #F0, #F0, #F0
        DB      #8E, #0C, #09, #0C, #04, #1E
        DB      #EE, #F7, #FF, #FF, #EE, #F7
        DB      #CF, #05, #03, #01, #02, #35
        DB      #EF, #F7, #FF, #FF, #EF, #F7
image_key:
        DB      #FF, #FF, #FF, #FF, #FF, #FF
        DB      #FF, #FF, #FF, #FF, #CC, #77
        DB      #FF, #FF, #FF, #FF, #89, #33
        DB      #FF, #FF, #FF, #FF, #13, #19
        DB      #00, #00, #00, #00, #37, #8D
        DB      #0C, #01, #0F, #0F, #33, #89
        DB      #CC, #11, #FF, #FF, #19, #13
        DB      #88, #08, #FF, #FF, #8C, #37
        DB      #8A, #8A, #FF, #FF, #CF, #7F
        DB      #AB, #AE, #FF, #FF, #FF, #FF
        DB      #BF, #EF, #FF, #FF, #FF, #FF
        DB      #FF, #FF, #FF, #FF, #FF, #FF
image_scroll:
        DB      #FF, #F8, #FF, #FF, #F1, #FF
        DB      #FF, #FA, #F7, #FE, #F5, #FF
        DB      #FF, #FA, #F7, #FE, #F5, #FF
        DB      #F9, #FA, #78, #E1, #F5, #F9
        DB      #F6, #F2, #00, #00, #F4, #F6
        DB      #F7, #FA, #00, #00, #F5, #FE
        DB      #F7, #FA, #05, #05, #F5, #FE
        DB      #F6, #F2, #0F, #0F, #F4, #F6
        DB      #F9, #FA, #78, #E1, #F5, #F9
        DB      #FF, #FA, #F7, #FE, #F5, #FF
        DB      #FF, #FA, #F7, #FE, #F5, #FF
        DB      #FF, #F8, #FF, #FF, #F1, #FF
image_treasure:
        DB      #1E, #F0, #F0, #F2, #F0, #87
        DB      #3D, #8D, #05, #0D, #0F, #CB
        DB      #6B, #0A, #00, #00, #00, #6D
        DB      #F0, #BA, #79, #88, #ED, #F0
        DB      #4B, #01, #06, #0D, #0A, #2D
        DB      #F0, #BA, #E1, #F2, #E1, #F0
        DB      #F7, #0B, #0F, #0B, #0F, #FE
        DB      #6B, #0E, #0A, #04, #0B, #6D
        DB      #7B, #0D, #00, #01, #07, #E9
        DB      #3D, #8F, #08, #00, #1F, #CB
        DB      #3C, #FF, #0F, #0F, #7E, #C3
        DB      #1E, #F0, #F0, #F0, #F0, #87
image_torch:
        DB      #FF, #FF, #FF, #FF, #FF, #FF
        DB      #FF, #FF, #FF, #FF, #6F, #FF
        DB      #FF, #FF, #FF, #EF, #2F, #F7
        DB      #FF, #FF, #FF, #ED, #0F, #7B
        DB      #FF, #FF, #FF, #C3, #04, #3D
        DB      #FF, #FF, #F8, #C2, #00, #16
        DB      #FF, #FC, #C1, #42, #00, #16
        DB      #FE, #E0, #1B, #2D, #02, #1E
        DB      #F8, #05, #BE, #ED, #0E, #3D
        DB      #C1, #5F, #F4, #F8, #87, #7B
        DB      #F8, #F0, #F0, #F0, #F0, #F7
        DB      #FF, #FF, #FF, #FF, #FF, #FF
image_ankh:
        DB      #FF, #FF, #ED, #77, #FF, #FF
        DB      #ED, #1F, #CE, #FB, #FF, #FF
        DB      #CA, #01, #C8, #FB, #FF, #FF
        DB      #95, #E2, #59, #F7, #FF, #FF
        DB      #94, #FD, #15, #F7, #FF, #FF
        DB      #C5, #F6, #89, #F7, #FF, #FF
        DB      #EA, #00, #00, #16, #FF, #FF
        DB      #FD, #FE, #33, #00, #3D, #FF
        DB      #FE, #E1, #74, #EE, #01, #7B
        DB      #FF, #EF, #75, #F1, #CC, #B9
        DB      #FF, #EC, #FB, #FE, #F3, #B5
        DB      #FF, #ED, #F3, #FF, #FC, #F3
image_elixir:
        DB      #0F, #0F, #F3, #F0, #0F, #0F
        DB      #0F, #0F, #85, #7E, #0F, #0F
        DB      #0F, #0F, #84, #3E, #0F, #0F
        DB      #0F, #0F, #85, #7E, #0F, #0F
        DB      #0F, #1E, #08, #1F, #87, #0F
        DB      #0F, #2D, #01, #0F, #CB, #0F
        DB      #0F, #78, #FE, #F4, #E9, #0F
        DB      #0F, #E2, #3F, #FF, #FC, #0F
        DB      #0F, #E6, #7F, #DD, #FE, #0F
        DB      #0F, #F7, #6E, #FF, #FE, #0F
        DB      #0F, #F3, #FF, #FF, #74, #0F
        DB      #0F, #78, #F0, #F0, #E1, #0F

plussprite_mummydown2:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
defb 0,0,0,0,0,0,0,6, 6,0,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,6, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,6,6,0,0,0,0
defb 0,0,0,0,6,15,15,15, 15,15,15,15,6,0,0,0
defb 0,0,0,0,6,15,6,15, 15,15,6,15,6,0,0,0
defb 0,0,0,6,15,6,0,6, 15,6,0,6,15,6,0,0
defb 0,0,0,6,6,0,6,15, 15,15,6,0,6,6,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 6,15,15,6,0,0,0,0
defb 0,0,0,0,0,6,15,6, 0,6,15,6,0,0,0,0
defb 0,0,0,0,0,6,15,6, 0,6,15,15,6,0,0,0
defb 0,0,0,0,0,6,15,6, 0,0,6,6,6,0,0,0
defb 0,0,0,0,6,15,15,6, 0,0,0,0,0,0,0,0
defb 0,0,0,0,6,6,6,6, 0,0,0,0,0,0,0,0

plussprite_mummybrushdown2:
defb 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
defb 00,00,00,00,00,00,00,06,06,00,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,06,06,00,00,00,00,00,00
defb 00,00,00,00,00,06,06,15,15,15,06,00,00,00,00,00
defb 00,00,00,00,06,15,15,15,15,15,15,06,00,00,00,00
defb 00,00,00,00,06,15,15,06,15,06,15,06,00,00,00,00
defb 00,00,00,00,00,06,15,15,06,00,06,06,00,00,00,00
defb 00,00,00,00,00,06,06,15,15,06,06,06,00,00,00,00
defb 00,00,00,00,00,14,14,06,06,14,03,00,00,00,00,00
defb 00,00,00,00,14,14,14,14,06,14,00,03,00,00,00,00
defb 00,00,00,00,06,15,14,14,14,06,14,00,03,00,00,00
defb 00,00,00,06,15,15,06,00,14,14,14,00,00,03,13,00
defb 00,00,00,06,06,06,00,00,06,15,06,00,00,13,03,07
defb 00,00,00,00,00,00,00,00,06,15,15,06,00,03,03,00
defb 00,00,00,00,00,00,00,00,06,06,06,06,00,00,00,00

plussprite_mummybrushdown1:
defb 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
defb 00,00,00,00,00,00,00,06,06,00,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,06,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,15,15,06,06,00,00,00,00,00
defb 00,00,00,00,06,15,15,15,15,15,15,06,00,00,00,00
defb 00,00,00,00,06,15,06,15,06,15,15,06,00,00,00,00
defb 00,00,00,00,06,06,00,06,15,15,06,00,00,00,00,00
defb 00,00,00,00,06,06,06,15,15,06,06,00,00,00,00,00
defb 00,00,00,00,00,03,14,06,06,14,14,00,00,00,00,00
defb 00,00,00,00,03,00,14,06,14,14,14,14,00,00,00,00
defb 00,00,00,03,00,14,06,14,14,14,15,06,00,00,00,00
defb 00,13,03,00,00,14,14,14,00,06,15,15,06,00,00,00
defb 13,03,13,00,00,06,15,06,00,00,06,06,06,00,00,00
defb 00,03,03,00,06,15,15,06,00,00,00,00,00,00,00,00
defb 00,00,00,00,06,06,06,06,00,00,00,00,00,00,00,00

plussprite_mummydown1:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
defb 0,0,0,0,0,0,0,6, 6,0,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,6,6,15,15, 15,15,6,0,0,0,0,0
defb 0,0,0,6,15,15,15,15, 15,15,15,6,0,0,0,0
defb 0,0,0,6,15,6,15,15, 15,6,15,6,0,0,0,0
defb 0,0,6,15,6,0,6,15, 6,0,6,15,6,0,0,0
defb 0,0,6,6,0,6,15,15, 15,6,0,6,6,0,0,0
defb 0,0,0,0,6,15,15,6, 15,6,0,0,0,0,0,0
defb 0,0,0,0,6,15,6,0, 6,15,6,0,0,0,0,0
defb 0,0,0,6,15,15,6,0, 6,15,6,0,0,0,0,0
defb 0,0,0,6,6,6,0,0, 6,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,0,0, 6,15,15,6,0,0,0,0
defb 0,0,0,0,0,0,0,0, 6,6,6,6,0,0,0,0

plussprite_mummyup2:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
defb 0,0,0,6,6,15,0,6, 6,0,15,6,6,0,0,0
defb 0,0,0,6,15,0,6,15, 15,6,0,15,6,0,0,0
defb 0,0,0,6,15,0,6,15, 15,6,0,15,6,0,0,0
defb 0,0,0,6,15,6,0,6, 6,0,6,15,6,0,0,0
defb 0,0,0,0,6,15,6,15, 15,6,15,15,6,0,0,0
defb 0,0,0,0,6,15,15,15, 15,15,15,6,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,15,15,6,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 6,15,15,6,0,0,0,0
defb 0,0,0,0,0,6,15,6, 0,6,15,6,0,0,0,0
defb 0,0,0,0,0,6,15,6, 0,6,15,15,6,0,0,0
defb 0,0,0,0,0,6,15,6, 0,0,6,6,6,0,0,0
defb 0,0,0,0,6,15,15,6, 0,0,0,0,0,0,0,0
defb 0,0,0,0,6,6,6,6, 0,0,0,0,0,0,0,0

plussprite_mummybrushup2:
defb 00,00,00,00,00,00,00,00,00,00,00,00,00,00,13,00
defb 00,00,00,00,00,00,06,06,06,06,00,00,00,13,03,10
defb 00,00,00,00,00,00,06,15,15,06,00,00,00,03,13,00
defb 00,00,00,00,00,00,06,15,15,06,00,06,03,00,00,00
defb 00,00,00,00,00,00,00,06,06,00,06,15,06,00,00,00
defb 00,00,00,00,00,06,06,15,15,06,15,15,06,00,00,00
defb 00,00,00,00,06,15,15,15,15,15,15,06,00,00,00,00
defb 00,00,00,00,00,06,15,15,15,15,15,06,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,14,14,14,14,14,00,00,00,00,00
defb 00,00,00,00,00,00,14,06,14,14,14,14,00,00,00,00
defb 00,00,00,00,00,14,06,14,14,14,14,14,00,00,00,00
defb 00,00,00,00,00,14,14,14,00,06,15,15,06,00,00,00
defb 00,00,00,00,00,06,15,06,00,00,06,06,06,00,00,00
defb 00,00,00,00,06,15,15,06,00,00,00,00,00,00,00,00
defb 00,00,00,00,06,06,06,06,00,00,00,00,00,00,00,00

plussprite_mummyfaded16:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded15:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded14:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded13:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded12:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded11:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded10:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded9:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded8:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded7:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded6:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded5:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded4:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded3:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded2:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyfaded1:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
plussprite_mummyup1:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
defb 0,0,0,6,6,15,0,6, 6,0,15,6,6,0,0,0
defb 0,0,0,6,15,0,6,15, 15,6,0,15,6,0,0,0
defb 0,0,0,6,15,0,6,15, 15,6,0,15,6,0,0,0
defb 0,0,0,6,15,6,0,6, 6,0,6,15,6,0,0,0
defb 0,0,0,6,15,15,6,15, 15,6,15,6,0,0,0,0
defb 0,0,0,0,6,15,15,15, 15,15,15,6,0,0,0,0
defb 0,0,0,0,6,15,15,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,6,15,15,6, 15,6,0,0,0,0,0,0
defb 0,0,0,0,6,15,6,0, 6,15,6,0,0,0,0,0
defb 0,0,0,6,15,15,6,0, 6,15,6,0,0,0,0,0
defb 0,0,0,6,6,6,0,0, 6,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,0,0, 6,15,15,6,0,0,0,0
defb 0,0,0,0,0,0,0,0, 6,6,6,6,0,0,0,0

plussprite_mummybrushup1:
defb 00,13,00,00,00,00,00,00,00,00,00,00,00,00,00,00
defb 03,03,13,00,00,00,06,06,06,06,00,00,00,00,00,00
defb 13,03,03,00,00,00,06,15,15,06,00,00,00,00,00,00
defb 00,00,00,03,06,00,06,15,15,06,00,00,00,00,00,00
defb 00,00,00,06,15,06,00,06,06,00,00,00,00,00,00,00
defb 00,00,00,06,15,15,06,15,15,06,06,00,00,00,00,00
defb 00,00,00,00,06,15,15,15,15,15,15,06,00,00,00,00
defb 00,00,00,00,06,15,15,15,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,06,15,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,14,14,14,14,14,00,00,00,00,00,00
defb 00,00,00,00,14,14,14,14,06,14,00,00,00,00,00,00
defb 00,00,00,00,14,14,14,14,14,06,14,00,00,00,00,00
defb 00,00,00,06,15,15,06,00,14,14,14,00,00,00,00,00
defb 00,00,00,06,06,06,00,00,06,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,00,00,06,15,15,06,00,00,00,00
defb 00,00,00,00,00,00,00,00,06,06,06,06,00,00,00,00

plussprite_mummyleft2:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
defb 0,0,0,0,0,0,0,6, 6,6,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,0,0,6, 15,15,6,0,0,0,0,0
defb 0,0,0,15,15,15,15,15, 15,15,6,0,0,0,0,0
defb 0,0,15,15,6,6,6,6, 15,8,6,0,0,0,0,0
defb 0,0,15,6,0,0,6,8, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,6,6,6, 6,6,6,0,0,0,0,0

plussprite_mummyright2:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,6, 6,0,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 6,0,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,15,15,15,15,0,0,0
defb 0,0,0,0,0,6,8,15, 15,6,6,6,15,15,0,0
defb 0,0,0,0,0,6,15,15, 8,6,0,0,6,15,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,6,6, 6,6,6,0,0,0,0,0

plussprite_mummybrushright2:
defb 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,06,06,00,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,15,06,00,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,15,15,00,00,00,00,00,00,00
defb 00,00,00,00,00,06,14,15,15,15,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,06,06,15,15,00,00,00,00,00
defb 00,00,00,00,00,14,14,14,14,06,06,13,00,00,00,00
defb 00,00,00,00,00,14,14,06,14,00,00,00,13,00,00,00
defb 00,00,00,00,00,14,14,14,06,14,00,00,00,03,13,00
defb 00,00,00,00,00,14,14,14,06,14,00,00,00,03,03,07
defb 00,00,00,00,00,06,15,15,15,06,00,00,00,00,13,00
defb 00,00,00,00,00,06,15,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,06,06,06,06,06,06,00,00,00,00,00

plussprite_mummyleft1:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
defb 0,0,0,0,0,0,0,6, 6,6,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,0,0,6, 15,15,6,0,0,0,0,0
defb 0,0,0,15,15,15,15,15, 15,15,6,0,0,0,0,0
defb 0,0,15,15,6,6,6,6, 15,8,6,0,0,0,0,0
defb 0,0,15,6,0,0,6,8, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,15,6,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 6,15,15,6,0,0,0,0
defb 0,0,0,0,0,6,15,6, 0,6,15,6,0,0,0,0
defb 0,0,0,0,0,6,15,6, 0,0,6,15,6,0,0,0
defb 0,0,0,0,6,15,6,0, 0,0,6,15,6,0,0,0
defb 0,0,0,6,6,6,6,0, 0,6,6,6,6,0,0,0

plussprite_mummyright1:
defb 0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,6, 6,0,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,0,6,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 6,0,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,15,15,15,15,0,0,0
defb 0,0,0,0,0,6,8,15, 15,6,6,6,15,15,0,0
defb 0,0,0,0,0,6,15,15, 8,6,0,0,6,15,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,0,6,15,15, 15,6,0,0,0,0,0,0
defb 0,0,0,0,6,15,15,6, 15,6,0,0,0,0,0,0
defb 0,0,0,0,6,15,6,0, 6,15,6,0,0,0,0,0
defb 0,0,0,6,15,6,0,0, 6,15,6,0,0,0,0,0
defb 0,0,0,6,15,6,0,0, 0,6,15,6,0,0,0,0
defb 0,0,0,6,6,6,6,0, 0,6,6,6,6,0,0,0

plussprite_mummybrushright1:
defb 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,06,06,00,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,15,06,00,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,15,00,00,00,00,00,00,00,00
defb 00,00,00,00,00,06,14,15,15,00,00,00,00,00,00,00
defb 00,00,00,00,00,06,15,06,15,15,00,00,00,00,00,00
defb 00,00,00,00,00,14,14,14,06,15,15,00,00,00,00,00
defb 00,00,00,00,00,14,14,06,14,06,15,15,00,00,00,00
defb 00,00,00,00,14,14,14,14,06,14,00,13,00,00,00,00
defb 00,00,00,00,14,14,14,14,14,06,14,00,13,13,00,00
defb 00,00,00,06,15,06,00,00,06,15,06,00,00,03,13,10
defb 00,00,00,06,15,06,00,00,00,06,15,06,00,03,03,07
defb 00,00,00,06,06,06,06,00,00,06,06,06,06,03,13,00

plussprite_mummybrushleft1:
defb 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
defb 00,00,00,00,00,00,00,06,06,06,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,00,00,06,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,00,00,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,00,15,15,14,06,00,00,00,00,00
defb 00,00,00,00,00,00,15,15,06,15,06,00,00,00,00,00
defb 00,00,00,00,00,15,15,06,14,14,14,00,00,00,00,00
defb 00,00,00,00,15,15,06,14,06,14,14,00,00,00,00,00
defb 00,00,00,00,13,00,14,06,14,14,14,14,00,00,00,00
defb 00,00,13,13,00,14,06,14,14,14,14,14,00,00,00,00
defb 03,13,03,00,00,06,15,06,00,00,06,15,06,00,00,00
defb 13,03,03,00,06,15,06,00,00,00,06,15,06,00,00,00
defb 00,13,03,06,06,06,06,00,00,06,06,06,06,00,00,00

plussprite_mummybrushleft2:
defb 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
defb 00,00,00,00,00,00,00,06,06,06,00,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,06,00,00,00,00,00,00
defb 00,00,00,00,00,00,00,06,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,00,15,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,15,15,15,14,06,00,00,00,00,00
defb 00,00,00,00,00,15,15,06,06,15,06,00,00,00,00,00
defb 00,00,00,00,13,06,06,14,14,14,14,00,00,00,00,00
defb 00,00,00,13,00,00,00,14,06,14,14,00,00,00,00,00
defb 00,13,03,00,00,00,14,06,14,14,14,00,00,00,00,00
defb 13,03,03,00,00,00,14,06,14,14,14,00,00,00,00,00
defb 00,13,00,00,00,00,06,15,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,00,06,15,15,15,06,00,00,00,00,00
defb 00,00,00,00,00,06,06,06,06,06,06,00,00,00,00,00


plussprite_weemanright1:
defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
defb 0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0
defb 0,0,0,0,5,1,1,1,1,1,1,5,5,5,0,0
defb 0,0,0,0,5,1,1,2,2,3,4,3,0,0,0,0
defb 0,0,0,0,0,2,2,2,3,3,3,3,3,3,0,0
defb 0,0,0,0,0,1,1,2,3,3,4,3,0,0,0,0
defb 0,0,0,0,6,2,2,1,1,3,3,0,0,0,0,0
defb 0,0,0,6,2,2,1,1,1,1,1,0,0,0,0,0
defb 0,0,0,6,6,2,2,2,3,1,1,3,0,0,0,0
defb 0,0,0,0,1,6,6,3,3,3,1,3,0,0,0,0
defb 0,0,0,0,1,1,1,1,3,1,1,0,0,0,0,0
defb 0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0
defb 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
defb 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
defb 0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0
defb 0,0,0,0,0,0,3,3,3,3,3,0,0,0,0,0

plussprite_weemanright2:
defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
defb 0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0
defb 0,0,0,0,5,1,1,1,1,1,1,5,5,5,0,0
defb 0,0,0,0,5,1,1,2,2,3,4,3,0,0,0,0
defb 0,0,0,0,0,2,2,2,3,3,3,3,3,3,0,0
defb 0,0,0,0,0,1,1,2,3,3,4,3,0,0,0,0
defb 0,0,0,0,6,2,2,1,1,3,3,0,0,0,0,0
defb 0,0,0,0,6,2,2,2,1,1,1,0,0,0,0,0
defb 0,0,0,0,1,6,2,2,2,2,2,2,3,3,0,0
defb 0,0,0,0,1,1,6,6,6,6,6,6,3,3,0,0
defb 0,0,0,1,1,1,1,1,1,4,5,5,0,0,0,0
defb 0,0,1,1,1,1,1,1,4,5,5,5,5,0,0,0
defb 0,0,3,1,1,1,1,4,5,5,5,5,5,0,0,0
defb 0,3,3,3,1,1,0,0,0,5,5,5,5,5,0,0
defb 0,0,3,3,3,0,0,0,0,0,3,3,3,3,0,0
defb 0,0,0,3,3,3,0,0,0,0,3,3,3,3,3,0

plussprite_weemandown1:
defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
defb 0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0
defb 0,0,0,0,5,1,1,1,1,1,1,5,0,0,0,0
defb 0,0,0,0,3,1,1,1,1,1,1,3,0,0,0,0
defb 0,0,0,0,3,1,1,1,1,1,1,3,0,0,0,0
defb 0,0,0,0,0,3,3,1,1,3,3,0,0,0,0,0
defb 0,0,0,0,6,2,3,3,3,3,1,6,2,0,0,0
defb 0,0,0,6,2,1,1,3,3,1,1,6,2,2,0,0
defb 0,0,0,6,2,1,1,1,1,1,1,6,2,2,0,0
defb 0,0,0,3,1,1,1,1,1,1,1,3,2,2,0,0
defb 0,0,0,0,1,1,1,1,0,1,1,3,3,0,0,0
defb 0,0,0,0,1,1,1,1,0,1,1,1,1,0,0,0
defb 0,0,0,0,1,1,1,1,0,3,3,3,3,0,0,0
defb 0,0,0,0,1,1,1,3,0,0,3,3,3,0,0,0
defb 0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0
defb 0,0,0,0,3,3,3,0,0,0,0,0,0,0,0,0

plussprite_weemandown2:
defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
defb 0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0
defb 0,0,0,0,5,1,1,1,1,1,1,5,0,0,0,0
defb 0,0,0,0,3,1,1,1,1,1,1,3,0,0,0,0
defb 0,0,0,0,3,1,1,1,1,1,1,3,0,0,0,0
defb 0,0,0,0,0,3,3,1,1,3,3,0,0,0,0,0
defb 0,0,0,6,2,1,3,3,3,3,6,2,0,0,0,0
defb 0,0,6,2,2,1,1,3,3,1,1,6,2,0,0,0
defb 0,0,6,2,2,1,1,1,1,1,1,6,2,0,0,0
defb 0,0,6,2,3,1,1,1,1,1,1,1,3,0,0,0
defb 0,0,0,3,3,1,1,0,1,1,1,1,0,0,0,0
defb 0,0,0,1,1,1,1,0,1,1,1,1,0,0,0,0
defb 0,0,0,3,3,3,3,0,1,1,1,1,0,0,0,0
defb 0,0,0,3,3,3,0,0,3,1,1,1,0,0,0,0
defb 0,0,0,0,0,0,0,0,3,3,3,3,0,0,0,0
defb 0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0

plussprite_weemanup1:
defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
defb 0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0
defb 0,0,0,0,5,1,1,1,1,1,1,5,0,0,0,0
defb 0,0,0,0,3,1,1,1,1,1,1,3,0,0,0,0
defb 0,0,0,0,3,3,2,2,2,2,3,3,0,0,0,0
defb 0,0,0,3,0,3,3,2,2,3,3,0,0,0,0,0
defb 0,0,0,6,2,2,1,1,1,1,1,6,2,0,0,0
defb 0,0,0,6,2,2,1,1,1,1,1,6,2,2,0,0
defb 0,0,0,6,2,1,1,1,1,1,1,6,2,2,0,0
defb 0,0,0,0,1,1,1,1,1,1,1,6,2,2,0,0
defb 0,0,0,0,1,1,1,1,0,1,1,1,3,3,0,0
defb 0,0,0,0,1,1,1,1,0,1,1,1,1,0,0,0
defb 0,0,0,0,1,1,1,1,0,3,3,3,3,0,0,0
defb 0,0,0,0,3,1,1,1,0,3,3,3,0,0,0,0
defb 0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0
defb 0,0,0,0,0,3,3,3,0,0,0,0,0,0,0,0

plussprite_weemanup2:
defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
defb 0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0
defb 0,0,0,0,5,1,1,1,1,1,1,5,0,0,0,0
defb 0,0,0,0,3,1,1,1,1,1,1,3,0,0,0,0
defb 0,0,0,0,3,3,2,2,2,2,3,3,0,0,0,0
defb 0,0,0,0,0,3,3,2,2,3,3,0,3,0,0,0
defb 0,0,0,6,2,1,1,1,1,1,6,2,2,0,0,0
defb 0,0,6,2,2,1,1,1,1,1,6,2,2,0,0,0
defb 0,0,6,2,2,1,1,1,1,1,1,2,2,0,0,0
defb 0,0,6,2,2,1,1,1,1,1,1,1,0,0,0,0
defb 0,0,3,3,1,1,1,0,1,1,1,1,0,0,0,0
defb 0,0,0,1,1,1,1,0,1,1,1,1,0,0,0,0
defb 0,0,0,3,3,3,3,0,1,1,1,1,0,0,0,0
defb 0,0,0,0,3,3,3,0,1,1,1,3,0,0,0,0
defb 0,0,0,0,0,0,0,0,3,3,3,3,0,0,0,0
defb 0,0,0,0,0,0,0,0,3,3,3,0,0,0,0,0

plussprite_weemanleft1:
defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
defb 0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0
defb 0,0,5,5,5,1,1,1,1,1,1,5,0,0,0,0
defb 0,0,0,0,3,4,3,2,2,1,1,5,0,0,0,0
defb 0,0,3,3,3,3,3,3,2,2,2,0,0,0,0,0
defb 0,0,0,0,3,4,3,3,2,1,1,0,0,0,0,0
defb 0,0,0,0,0,3,3,1,1,2,2,6,0,0,0,0
defb 0,0,0,0,0,1,1,1,1,1,2,2,6,0,0,0
defb 0,0,0,0,3,1,1,3,2,2,2,6,6,0,0,0
defb 0,0,0,0,3,1,3,3,3,6,6,1,0,0,0,0
defb 0,0,0,0,0,1,1,3,1,1,1,1,0,0,0,0
defb 0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0
defb 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
defb 0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0
defb 0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0
defb 0,0,0,0,0,3,3,3,3,3,0,0,0,0,0,0

plussprite_weemanleft2:
defb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
defb 0,0,0,0,0,5,5,5,5,5,5,0,0,0,0,0
defb 0,0,5,5,5,1,1,1,1,1,1,5,0,0,0,0
defb 0,0,0,0,3,4,3,2,2,1,1,5,0,0,0,0
defb 0,0,3,3,3,3,3,3,2,2,2,0,0,0,0,0
defb 0,0,0,0,3,4,3,3,2,1,1,0,0,0,0,0
defb 0,0,0,0,0,3,3,1,1,2,2,6,0,0,0,0
defb 0,0,0,0,0,1,1,1,2,2,2,6,0,0,0,0
defb 0,0,3,3,2,2,2,2,2,2,6,1,0,0,0,0
defb 0,0,3,3,6,6,6,6,6,6,1,1,0,0,0,0
defb 0,0,0,0,5,5,4,1,1,1,1,1,1,0,0,0
defb 0,0,0,5,5,5,5,4,1,1,1,1,1,1,0,0
defb 0,0,0,5,5,5,5,5,4,1,1,1,1,3,0,0
defb 0,0,5,5,5,5,5,0,0,0,1,1,3,3,3,0
defb 0,0,3,3,3,3,0,0,0,0,0,3,3,3,0,0
defb 0,3,3,3,3,3,0,0,0,0,3,3,3,0,0,0

amsfont:
t1:
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t2:
db #1e,#0f,#1e,#0f,#1e,#0f,#1e,#0f
db #1e,#0f,#0f,#0f,#1e,#0f,#0f,#0f
t3:
db #2d,#4b,#2d,#4b,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t4:
db #2d,#4b,#2d,#4b,#78,#e1,#2d,#4b
db #2d,#4b,#78,#e1,#2d,#4b,#2d,#4b
t5:
db #3c,#c3,#4b,#a5,#4b,#87,#3c,#c3
db #0f,#a5,#4b,#a5,#3c,#c3,#0f,#0f
t6:
db #0f,#0f,#69,#2d,#69,#4b,#0f,#87
db #1e,#0f,#2d,#69,#4b,#69,#0f,#0f
t7:
db #3c,#87,#4b,#4b,#2d,#87,#1e,#0f
db #2d,#a5,#4b,#4b,#3c,#a5,#0f,#0f
t8:
db #0f,#4b,#0f,#87,#1e,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t9
db #0f,#4b,#0f,#87,#1e,#0f,#1e,#0f
db #1e,#0f,#0f,#87,#0f,#4b,#0f,#0f
t10:
db #1e,#0f,#0f,#87,#0f,#4b,#0f,#4b
db #0f,#4b,#0f,#87,#1e,#0f,#0f,#0f
t11:
db #0f,#0f,#4b,#2d,#2d,#4b,#1e,#87
db #2d,#4b,#4b,#2d,#0f,#0f,#0f,#0f
t12:
db #0f,#0f,#0f,#87,#0f,#87,#3c,#e1
db #0f,#87,#0f,#87,#0f,#0f,#0f,#0f
t13:
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#4b,#0f,#87,#1e,#0f
t14:
db #0f,#0f,#0f,#0f,#0f,#0f,#78,#e1
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t15:
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#87,#0f,#0f
t16:
db #0f,#2d,#0f,#4b,#0f,#87,#1e,#0f
db #2d,#0f,#4b,#0f,#87,#0f,#0f,#0f
t17:
db #78,#c3,#87,#69,#87,#a5,#96,#2d
db #a5,#2d,#c3,#2d,#78,#c3,#0f,#0f
t18:
db #0f,#87,#1e,#87,#2d,#87,#0f,#87
db #0f,#87,#0f,#87,#0f,#87,#0f,#0f
t19:
db #3c,#c3,#4b,#2d,#0f,#2d,#3c,#c3
db #4b,#0f,#4b,#0f,#78,#e1,#0f,#0f
t20:
db #3c,#c3,#4b,#2d,#0f,#2d,#1e,#c3
db #0f,#2d,#4b,#2d,#3c,#c3,#0f,#0f
t21:
db #1e,#87,#2d,#87,#4b,#87,#87,#87
db #f0,#e1,#0f,#87,#0f,#87,#0f,#0f
t22:
db #78,#e1,#4b,#0f,#4b,#0f,#3c,#c3
db #0f,#2d,#4b,#2d,#3c,#c3,#0f,#0f
t23:
db #3c,#c3,#4b,#0f,#4b,#0f,#78,#c3
db #4b,#2d,#4b,#2d,#3c,#c3,#0f,#0f
t24:
db #78,#e1,#0f,#2d,#0f,#4b,#0f,#87
db #1e,#0f,#2d,#0f,#4b,#0f,#0f,#0f
t25:
db #3c,#c3,#4b,#2d,#4b,#2d,#3c,#c3
db #4b,#2d,#4b,#2d,#3c,#c3,#0f,#0f
t26:
db #3c,#c3,#4b,#2d,#4b,#2d,#3c,#e1
db #0f,#2d,#0f,#2d,#3c,#c3,#0f,#0f
t27:
db #0f,#0f,#0f,#0f,#0f,#87,#0f,#87
db #0f,#0f,#0f,#87,#0f,#87,#0f,#0f
t28:
db #0f,#0f,#0f,#0f,#0f,#87,#0f,#87
db #0f,#0f,#0f,#87,#1e,#0f,#0f,#0f
t29:
db #0f,#4b,#0f,#87,#1e,#0f,#2d,#0f
db #1e,#0f,#0f,#87,#0f,#4b,#0f,#0f
t30:
db #0f,#0f,#0f,#0f,#78,#e1,#0f,#0f
db #0f,#0f,#78,#e1,#0f,#0f,#0f,#0f
t31:
db #2d,#0f,#1e,#0f,#0f,#87,#0f,#4b
db #0f,#87,#1e,#0f,#2d,#0f,#0f,#0f
t32:
db #3c,#c3,#4b,#2d,#0f,#2d,#0f,#4b
db #0f,#87,#0f,#0f,#0f,#87,#0f,#0f
t33:
db #3c,#c3,#4b,#2d,#5a,#e1,#5a,#2d
db #5a,#e1,#4b,#0f,#3c,#c3,#0f,#0f
t34:
db #1e,#87,#2d,#4b,#4b,#2d,#4b,#2d
db #78,#e1,#4b,#2d,#4b,#2d,#0f,#0f
t35:
db #78,#c3,#4b,#2d,#4b,#2d,#78,#c3
db #4b,#2d,#4b,#2d,#78,#c3,#0f,#0f
t36:
db #3c,#c3,#4b,#2d,#87,#0f,#87,#0f
db #87,#0f,#4b,#2d,#3c,#c3,#0f,#0f
t37:
db #78,#87,#4b,#4b,#4b,#2d,#4b,#2d
db #4b,#2d,#4b,#4b,#78,#87,#0f,#0f
t38:
db #78,#e1,#4b,#0f,#4b,#0f,#78,#87
db #4b,#0f,#4b,#0f,#78,#e1,#0f,#0f
t39:
db #78,#e1,#4b,#0f,#4b,#0f,#78,#87
db #4b,#0f,#4b,#0f,#4b,#0f,#0f,#0f
t40:
db #1e,#c3,#2d,#2d,#4b,#0f,#4b,#0f
db #4b,#69,#2d,#2d,#1e,#c3,#0f,#0f
t41:
db #4b,#2d,#4b,#2d,#4b,#2d,#78,#e1
db #4b,#2d,#4b,#2d,#4b,#2d,#0f,#0f
t43:
db #78,#c3,#1e,#0f,#1e,#0f,#1e,#0f
db #1e,#0f,#1e,#0f,#78,#c3,#0f,#0f
t44:
db #1e,#e1,#0f,#4b,#0f,#4b,#0f,#4b
db #0f,#4b,#87,#4b,#78,#87,#0f,#0f
t45:
db #4b,#2d,#4b,#4b,#4b,#87,#78,#0f
db #4b,#87,#4b,#4b,#4b,#2d,#0f,#0f
t46:
db #4b,#0f,#4b,#0f,#4b,#0f,#4b,#0f
db #4b,#0f,#4b,#0f,#78,#e1,#0f,#0f
t47:
db #c3,#69,#a5,#a5,#96,#2d,#87,#2d
db #87,#2d,#87,#2d,#87,#2d,#0f,#0f
t48:
db #87,#2d,#c3,#2d,#a5,#2d,#96,#2d
db #87,#a5,#87,#69,#87,#2d,#0f,#0f
t49:
db #3c,#87,#4b,#4b,#87,#2d,#87,#2d
db #87,#2d,#4b,#4b,#3c,#87,#0f,#0f
t50:
db #78,#c3,#4b,#2d,#4b,#2d,#78,#c3
db #4b,#0f,#4b,#0f,#4b,#0f,#0f,#0f
t51:
db #3c,#87,#4b,#4b,#87,#2d,#87,#2d
db #87,#a5,#4b,#4b,#3c,#a5,#0f,#0f
t52:
db #78,#c3,#4b,#2d,#4b,#2d,#78,#c3
db #4b,#4b,#4b,#2d,#4b,#2d,#0f,#0f
t53:
db #3c,#c3,#4b,#2d,#4b,#0f,#3c,#c3
db #0f,#2d,#4b,#2d,#3c,#c3,#0f,#0f
t54:
db #78,#c3,#1e,#0f,#1e,#0f,#1e,#0f
db #1e,#0f,#1e,#0f,#1e,#0f,#0f,#0f
t55:
db #4b,#2d,#4b,#2d,#4b,#2d,#4b,#2d
db #4b,#2d,#4b,#2d,#3c,#c3,#0f,#0f
t56:
db #4b,#2d,#4b,#2d,#4b,#2d,#4b,#2d
db #4b,#2d,#2d,#4b,#1e,#87,#0f,#0f
t57:
db #87,#2d,#87,#2d,#87,#2d,#87,#2d
db #96,#2d,#a5,#a5,#c3,#69,#0f,#0f
t58:
db #87,#2d,#4b,#4b,#2d,#87,#1e,#0f
db #2d,#87,#4b,#4b,#87,#2d,#0f,#0f
t59:
db #4b,#4b,#4b,#4b,#4b,#4b,#2d,#87
db #1e,#0f,#1e,#0f,#1e,#0f,#0f,#0f
t60:
db #f0,#e1,#0f,#4b,#0f,#87,#1e,#0f
db #2d,#0f,#4b,#0f,#f0,#e1,#0f,#0f
t61:
db #3c,#c3,#2d,#0f,#2d,#0f,#2d,#0f
db #2d,#0f,#2d,#0f,#3c,#c3,#0f,#0f
t62:
db #87,#0f,#4b,#0f,#2d,#0f,#1e,#0f
db #0f,#87,#0f,#4b,#0f,#2d,#0f,#0f
t63:
db #3c,#c3,#0f,#4b,#0f,#4b,#0f,#4b
db #0f,#4b,#0f,#4b,#3c,#c3,#0f,#0f
t64:
db #1e,#87,#3c,#c3,#78,#e1,#78,#e1
db #1e,#87,#1e,#87,#1e,#87,#0f,#0f
t65:
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#f0,#f0
t66:
db #3c,#0f,#1e,#87,#0f,#c3,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t67:
db #0f,#0f,#0f,#0f,#3c,#c3,#4b,#2d
db #4b,#2d,#4b,#69,#3c,#a5,#0f,#0f
t68:
db #4b,#0f,#4b,#0f,#78,#c3,#4b,#2d
db #4b,#2d,#4b,#2d,#3c,#c3,#0f,#0f
t69:
db #0f,#0f,#0f,#0f,#3c,#c3,#4b,#2d
db #4b,#0f,#4b,#2d,#3c,#c3,#0f,#0f
t70:
db #0f,#2d,#0f,#2d,#3c,#e1,#4b,#2d
db #4b,#2d,#4b,#2d,#3c,#c3,#0f,#0f
t71:
db #0f,#0f,#0f,#0f,#3c,#c3,#4b,#2d
db #78,#e1,#4b,#0f,#3c,#c3,#0f,#0f
t72:
db #1e,#c3,#2d,#2d,#2d,#0f,#78,#0f
db #2d,#0f,#2d,#0f,#2d,#0f,#0f,#0f
t73:
db #0f,#0f,#0f,#0f,#3c,#e1,#4b,#2d
db #4b,#2d,#3c,#e1,#0f,#2d,#78,#c3
t74:
db #4b,#0f,#4b,#0f,#5a,#c3,#69,#2d
db #4b,#2d,#4b,#2d,#4b,#2d,#0f,#0f
t75:
db #0f,#87,#0f,#0f,#0f,#87,#0f,#87
db #0f,#87,#0f,#87,#0f,#87,#0f,#0f
t76:
db #0f,#2d,#0f,#0f,#0f,#2d,#0f,#2d
db #0f,#2d,#0f,#2d,#4b,#2d,#3c,#c3
t77:
db #2d,#0f,#2d,#0f,#2d,#2d,#2d,#4b
db #3c,#87,#2d,#4b,#2d,#2d,#0f,#0f
t78:
db #1e,#0f,#1e,#0f,#1e,#0f,#1e,#0f
db #1e,#0f,#1e,#0f,#0f,#87,#0f,#0f
t79:
db #0f,#0f,#0f,#0f,#69,#c3,#96,#2d
db #96,#2d,#96,#2d,#87,#2d,#0f,#0f
t80:
db #0f,#0f,#0f,#0f,#5a,#c3,#69,#2d
db #4b,#2d,#4b,#2d,#4b,#2d,#0f,#0f
t81:
db #0f,#0f,#0f,#0f,#3c,#c3,#4b,#2d
db #4b,#2d,#4b,#2d,#3c,#c3,#0f,#0f
t82:
db #0f,#0f,#0f,#0f,#78,#c3,#4b,#2d
db #4b,#2d,#78,#c3,#4b,#0f,#4b,#0f
t84:
db #0f,#0f,#0f,#0f,#3c,#e1,#4b,#2d
db #4b,#2d,#3c,#e1,#0f,#2d,#0f,#2d
t85:
db #0f,#0f,#0f,#0f,#5a,#c3,#69,#2d
db #4b,#0f,#4b,#0f,#4b,#0f,#0f,#0f
t86:
db #0f,#0f,#0f,#0f,#3c,#c3,#4b,#0f
db #3c,#c3,#0f,#2d,#3c,#c3,#0f,#0f
t87:
db #2d,#0f,#2d,#0f,#78,#87,#2d,#0f
db #2d,#0f,#2d,#2d,#1e,#c3,#0f,#0f
t88:
db #0f,#0f,#0f,#0f,#4b,#2d,#4b,#2d
db #4b,#2d,#4b,#2d,#3c,#c3,#0f,#0f
t89:
db #0f,#0f,#0f,#0f,#4b,#2d,#4b,#2d
db #4b,#2d,#2d,#4b,#1e,#87,#0f,#0f
t90:
db #0f,#0f,#0f,#0f,#87,#2d,#96,#2d
db #96,#2d,#96,#2d,#69,#c3,#0f,#0f
t91:
db #0f,#0f,#0f,#0f,#4b,#2d,#2d,#4b
db #1e,#87,#2d,#4b,#4b,#2d,#0f,#0f
t92:
db #0f,#0f,#0f,#0f,#4b,#2d,#4b,#2d
db #4b,#2d,#3c,#e1,#0f,#2d,#78,#c3
t93:
db #0f,#0f,#0f,#0f,#78,#e1,#0f,#4b
db #0f,#87,#1e,#0f,#78,#e1,#0f,#0f
t94:
db #0f,#e1,#1e,#0f,#1e,#0f,#69,#0f
db #1e,#0f,#1e,#0f,#0f,#e1,#0f,#0f
t95:
db #2d,#0f,#2d,#0f,#2d,#0f,#2d,#0f
db #2d,#0f,#2d,#0f,#2d,#0f,#0f,#0f
t96:
db #78,#0f,#0f,#87,#0f,#87,#0f,#69
db #0f,#87,#0f,#87,#78,#0f,#0f,#0f
t97:
db #78,#69,#d2,#c3,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f

t98:
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000

t99:
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000

t100:
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111

t101:
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111

t102:
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111

t103:
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111

t104:
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111

t105:
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111

t106:
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111

t107mummy1:
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000

t108:
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000

t109:
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000

t110:
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000

t111:
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111
db %00001111,%00001111
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000

t112:
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00001111
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000

t113:
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00001111,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000

t114:
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000
db %00000000,%00000000

t115:
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#87,#0f
t116:
db #f0,#d2,#f0,#d2,#f0,#c3,#f0,#c3
db #f0,#c3,#f0,#c3,#f0,#87,#78,#0f
t117:
db #0f,#2d,#0f,#2d,#0f,#2d,#0f,#2d
db #0f,#2d,#0f,#2d,#0f,#69,#0f,#87
t118:
db #87,#0f,#c3,#0f,#e1,#0f,#f0,#0f
db #f0,#87,#f0,#c3,#f0,#e1,#f0,#f0
t119:
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#87,#0f
t120:
db #c3,#0f,#e1,#0f,#f0,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t121:
db #f0,#f0,#f0,#f0,#3c,#f0,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t122:
db #5a,#0f,#d2,#87,#d2,#c3,#d2,#e1
db #d2,#f0,#0f,#78,#0f,#0f,#0f,#0f
t123:
db #a5,#0f,#2d,#0f,#2d,#0f,#2d,#0f
db #2d,#0f,#69,#0f,#69,#0f,#0f,#0f
t125:
db #0f,#87,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#1e,#0f,#1e,#0f,#2d,#0f
t126:
db #0f,#0f,#0f,#0f,#0f,#1e,#0f,#3c
db #0f,#78,#0f,#78,#0f,#0f,#0f,#0f
t127:
db #b4,#2d,#5a,#5a,#b4,#2d,#78,#d2
db #b4,#a5,#78,#1e,#a5,#2d,#5a,#d2
t128:
db #0f,#0f,#0f,#0f,#0f,#0f,#f0,#0f
db #f0,#87,#1e,#87,#1e,#87,#1e,#87
t129:
db #1e,#87,#1e,#87,#1e,#87,#f0,#87
db #f0,#87,#1e,#87,#1e,#87,#1e,#87
t130:
db #0f,#0f,#0f,#0f,#0f,#0f,#f0,#f0
db #f0,#f0,#1e,#87,#1e,#87,#1e,#87
t131:
db #1e,#87,#1e,#87,#1e,#87,#f0,#f0
db #f0,#f0,#1e,#87,#1e,#87,#1e,#87
t132:
db #1e,#0f,#3c,#87,#69,#c3,#c3,#69
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t133:
db #0f,#c3,#1e,#87,#3c,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t134:
db #69,#69,#69,#69,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t135:
db #3c,#c3,#4b,#2d,#4b,#0f,#f0,#0f
db #4b,#0f,#4b,#0f,#f0,#e1,#0f,#0f
t136:
db #3c,#87,#4b,#4b,#b4,#a5,#a5,#2d
db #b4,#a5,#4b,#4b,#3c,#87,#0f,#0f
t137:
db #78,#e1,#f0,#4b,#f0,#4b,#78,#4b
db #3c,#4b,#3c,#4b,#3c,#4b,#0f,#0f
t138:
db #1e,#e1,#3c,#0f,#3c,#87,#69,#c3
db #3c,#87,#1e,#87,#f0,#0f,#0f,#0f
t139:
db #1e,#87,#1e,#87,#0f,#c3,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t140:
db #4b,#0f,#c3,#0f,#4b,#4b,#4b,#c3
db #5a,#4b,#1e,#e1,#0f,#4b,#0f,#0f
t141:
db #4b,#0f,#c3,#0f,#4b,#c3,#5a,#2d
db #4b,#4b,#0f,#87,#1e,#e1,#0f,#0f
t142:
db #e1,#0f,#1e,#0f,#69,#2d,#1e,#69
db #e1,#a5,#0f,#f0,#0f,#2d,#0f,#0f
t143:
db #0f,#0f,#1e,#87,#1e,#87,#78,#e1
db #1e,#87,#1e,#87,#78,#e1,#0f,#0f
t144:
db #1e,#87,#1e,#87,#0f,#0f,#78,#e1
db #0f,#0f,#1e,#87,#1e,#87,#0f,#0f
t145:
db #0f,#0f,#0f,#0f,#0f,#0f,#78,#e1
db #0f,#69,#0f,#69,#0f,#0f,#0f,#0f
t146:
db #1e,#87,#0f,#0f,#1e,#87,#3c,#0f
db #69,#69,#69,#69,#3c,#c3,#0f,#0f
t147:
db #1e,#87,#0f,#0f,#1e,#87,#1e,#87
db #1e,#87,#1e,#87,#1e,#87,#0f,#0f
t148:
db #0f,#0f,#0f,#0f,#78,#3c,#d2,#e1
db #c3,#c3,#d2,#e1,#78,#3c,#0f,#0f
t149:
db #78,#c3,#c3,#69,#c3,#69,#f0,#c3
db #c3,#69,#c3,#69,#f0,#87,#c3,#0f
t150:
db #0f,#0f,#69,#69,#69,#69,#3c,#c3
db #69,#69,#69,#69,#3c,#c3,#0f,#0f
t151:
db #3c,#c3,#69,#0f,#69,#0f,#3c,#c3
db #69,#69,#69,#69,#3c,#c3,#0f,#0f
t152:
db #0f,#0f,#0f,#0f,#1e,#e1,#3c,#0f
db #78,#c3,#3c,#0f,#1e,#e1,#0f,#0f
t153:
db #3c,#87,#69,#c3,#c3,#69,#f0,#e1
db #c3,#69,#69,#c3,#3c,#87,#0f,#0f
t154:
db #0f,#0f,#c3,#0f,#69,#0f,#3c,#0f
db #3c,#87,#69,#c3,#c3,#69,#0f,#0f
t155:
db #0f,#0f,#0f,#0f,#69,#69,#69,#69
db #69,#69,#78,#c3,#69,#0f,#69,#0f
t156:
db #0f,#0f,#0f,#0f,#0f,#0f,#f0,#e1
db #69,#c3,#69,#c3,#69,#c3,#0f,#0f
t157:
db #0f,#0f,#0f,#0f,#0f,#0f,#78,#e1
db #d2,#87,#d2,#87,#78,#0f,#0f,#0f
t158:
db #0f,#3c,#0f,#69,#0f,#c3,#3c,#c3
db #69,#69,#3c,#c3,#69,#0f,#c3,#0f
t159:
db #0f,#3c,#0f,#69,#0f,#c3,#69,#69
db #69,#69,#3c,#c3,#69,#0f,#c3,#0f
t160:
db #0f,#0f,#e1,#69,#3c,#c3,#1e,#87
db #3c,#87,#69,#c3,#c3,#78,#0f,#0f
t161:
db #0f,#0f,#0f,#0f,#69,#69,#c3,#3c
db #d2,#b4,#d2,#b4,#78,#e1,#0f,#0f
t162:
db #f0,#e1,#c3,#69,#69,#0f,#3c,#0f
db #69,#0f,#c3,#69,#f0,#e1,#0f,#0f
t163:
db #0f,#0f,#78,#c3,#c3,#69,#c3,#69
db #c3,#69,#69,#c3,#e1,#e1,#0f,#0f
t164:
db #1e,#87,#3c,#0f,#69,#0f,#c3,#0f
db #87,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t166:
db #1e,#87,#0f,#c3,#0f,#69,#0f,#3c
db #0f,#1e,#0f,#0f,#0f,#0f,#0f,#0f
t167:
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#1e
db #0f,#3c,#0f,#69,#0f,#c3,#1e,#87
t168:
db #0f,#0f,#0f,#0f,#0f,#0f,#87,#0f
db #c3,#0f,#69,#0f,#3c,#0f,#1e,#87
t169:
db #1e,#87,#3c,#c3,#69,#69,#c3,#3c
db #87,#1e,#0f,#0f,#0f,#0f,#0f,#0f
t170:
db #1e,#87,#0f,#c3,#0f,#69,#0f,#3c
db #0f,#3c,#0f,#69,#0f,#c3,#1e,#87
t171:
db #0f,#0f,#0f,#0f,#0f,#0f,#87,#1e
db #c3,#3c,#69,#69,#3c,#c3,#1e,#87
t172:
db #1e,#87,#3c,#0f,#69,#0f,#c3,#0f
db #c3,#0f,#69,#0f,#3c,#0f,#1e,#87
t173:
db #1e,#87,#3c,#0f,#69,#0f,#c3,#1e
db #87,#3c,#0f,#69,#0f,#c3,#1e,#87
t174:
db #1e,#87,#0f,#c3,#0f,#69,#87,#3c
db #c3,#1e,#69,#0f,#3c,#0f,#1e,#87
t175:
db #1e,#87,#3c,#c3,#69,#69,#c3,#3c
db #c3,#3c,#69,#69,#3c,#c3,#1e,#87
t176:
db #c3,#3c,#e1,#78,#78,#e1,#3c,#c3
db #3c,#c3,#78,#e1,#e1,#78,#c3,#3c
t177:
db #0f,#3c,#0f,#78,#0f,#e1,#1e,#c3
db #3c,#87,#78,#0f,#e1,#0f,#c3,#0f
t178:
db #c3,#0f,#e1,#0f,#78,#0f,#3c,#87
db #1e,#c3,#0f,#e1,#0f,#78,#0f,#3c
t179:
db #c3,#c3,#c3,#c3,#3c,#3c,#3c,#3c
db #c3,#c3,#c3,#c3,#3c,#3c,#3c,#3c
t180:
db #a5,#a5,#5a,#5a,#a5,#a5,#5a,#5a
db #a5,#a5,#5a,#5a,#a5,#a5,#5a,#5a
t181:
db #f0,#f0,#f0,#f0,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t182:
db #0f,#3c,#0f,#3c,#0f,#3c,#0f,#3c
db #0f,#3c,#0f,#3c,#0f,#3c,#0f,#3c
t183:
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #0f,#0f,#0f,#0f,#f0,#f0,#f0,#f0
t184:
db #c3,#0f,#c3,#0f,#c3,#0f,#c3,#0f
db #c3,#0f,#c3,#0f,#c3,#0f,#c3,#0f
t185:
db #f0,#f0,#f0,#e1,#f0,#c3,#f0,#87
db #f0,#0f,#e1,#0f,#c3,#0f,#87,#0f
t186:
db #f0,#f0,#78,#f0,#3c,#f0,#1e,#f0
db #0f,#f0,#0f,#78,#0f,#3c,#0f,#1e
t187:
db #0f,#1e,#0f,#3c,#0f,#78,#0f,#f0
db #1e,#f0,#3c,#f0,#78,#f0,#f0,#f0
t188:
db #87,#0f,#c3,#0f,#e1,#0f,#f0,#0f
db #f0,#87,#f0,#c3,#f0,#e1,#f0,#f0
t189:
db #a5,#a5,#5a,#5a,#a5,#a5,#5a,#5a
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
t190:
db #0f,#a5,#0f,#5a,#0f,#a5,#0f,#5a
db #0f,#a5,#0f,#5a,#0f,#a5,#0f,#5a
t191:
db #0f,#0f,#0f,#0f,#0f,#0f,#0f,#0f
db #a5,#a5,#5a,#5a,#a5,#a5,#5a,#5a
t192:
db #a5,#0f,#5a,#0f,#a5,#0f,#5a,#0f
db #a5,#0f,#5a,#0f,#a5,#0f,#5a,#0f
t193:
db #a5,#a5,#5a,#4b,#a5,#87,#5a,#0f
db #a5,#0f,#4b,#0f,#87,#0f,#0f,#0f
t194:
db #a5,#a5,#5a,#5a,#2d,#a5,#1e,#5a
db #0f,#a5,#0f,#5a,#0f,#2d,#0f,#1e
t195:
db #0f,#1e,#0f,#2d,#0f,#5a,#0f,#a5
db #1e,#5a,#2d,#a5,#5a,#5a,#a5,#a5
t196:
db #0f,#0f,#87,#0f,#4b,#0f,#a5,#0f
db #5a,#0f,#a5,#87,#5a,#4b,#a5,#a5
t197:
db #78,#e1,#f0,#f0,#96,#96,#f0,#f0
db #b4,#d2,#c3,#3c,#f0,#f0,#78,#e1
t198:
db #78,#e1,#f0,#f0,#96,#96,#f0,#f0
db #c3,#3c,#b4,#d2,#f0,#f0,#78,#e1
t199:
db #3c,#87,#3c,#87,#f0,#e1,#f0,#e1
db #f0,#e1,#1e,#0f,#3c,#87,#0f,#0f
t200:
db #1e,#0f,#3c,#87,#78,#c3,#f0,#e1
db #78,#c3,#3c,#87,#1e,#0f,#0f,#0f
t201:
db #69,#c3,#f0,#e1,#f0,#e1,#f0,#e1
db #78,#c3,#3c,#87,#1e,#0f,#0f,#0f
t202:
db #1e,#0f,#3c,#87,#78,#c3,#f0,#e1
db #f0,#e1,#1e,#0f,#3c,#87,#0f,#0f
t203:
db #0f,#0f,#3c,#c3,#69,#69,#c3,#3c
db #c3,#3c,#69,#69,#3c,#c3,#0f,#0f
t204:
db #0f,#0f,#3c,#c3,#78,#e1,#f0,#f0
db #f0,#f0,#78,#e1,#3c,#c3,#0f,#0f
t205:
db #0f,#0f,#78,#e1,#69,#69,#69,#69
db #69,#69,#69,#69,#78,#e1,#0f,#0f
t207:
db #0f,#0f,#78,#e1,#78,#e1,#78,#e1
db #78,#e1,#78,#e1,#78,#e1,#0f,#0f
t208:
db #0f,#f0,#0f,#78,#0f,#d2,#78,#87
db #c3,#c3,#c3,#c3,#c3,#c3,#78,#87
t209:
db #3c,#c3,#69,#69,#69,#69,#69,#69
db #3c,#c3,#1e,#87,#78,#e1,#1e,#87
t210:
db #0f,#c3,#0f,#c3,#0f,#c3,#0f,#c3
db #0f,#c3,#3c,#c3,#78,#c3,#3c,#87
t211:
db #1e,#87,#1e,#c3,#1e,#e1,#1e,#b4
db #1e,#87,#78,#87,#f0,#87,#78,#0f
t212:
db #96,#96,#5a,#a5,#2d,#4b,#c3,#3c
db #c3,#3c,#2d,#4b,#5a,#a5,#96,#96
t213:
db #1e,#0f,#3c,#87,#3c,#87,#3c,#87
db #3c,#87,#3c,#87,#78,#c3,#d2,#69
t214:
db #1e,#87,#3c,#c3,#78,#e1,#f0,#f0
db #1e,#87,#1e,#87,#1e,#87,#1e,#87
t215:
db #1e,#87,#1e,#87,#1e,#87,#1e,#87
db #f0,#f0,#78,#e1,#3c,#c3,#1e,#87
t216:
db #1e,#0f,#3c,#0f,#78,#0f,#f0,#f0
db #f0,#f0,#78,#0f,#3c,#0f,#1e,#0f
t217:
db #0f,#87,#0f,#c3,#0f,#e1,#f0,#f0
db #f0,#f0,#0f,#e1,#0f,#c3,#0f,#87
t218:
db #0f,#0f,#0f,#0f,#1e,#87,#3c,#c3
db #78,#e1,#f0,#f0,#f0,#f0,#0f,#0f
t219:
db #0f,#0f,#0f,#0f,#f0,#f0,#f0,#f0
db #78,#e1,#3c,#c3,#1e,#87,#0f,#0f
t220:
db #87,#0f,#e1,#0f,#f0,#87,#f0,#e1
db #f0,#87,#e1,#0f,#87,#0f,#0f,#0f
t221:
db #0f,#2d,#0f,#e1,#3c,#e1,#f0,#e1
db #3c,#e1,#0f,#e1,#0f,#2d,#0f,#0f
t222:
db #3c,#87,#3c,#87,#96,#2d,#78,#c3
db #1e,#0f,#2d,#87,#2d,#87,#2d,#87
t223:
db #3c,#87,#3c,#87,#1e,#0f,#f0,#e1
db #1e,#0f,#2d,#87,#4b,#4b,#87,#2d
t224:
db #3c,#87,#3c,#87,#1e,#2d,#78,#c3
db #96,#0f,#2d,#87,#2d,#4b,#2d,#2d

read "CPSoundEffectGenerator2.asm"

; ABOUT f300

ifdef ISCART
;screenptrtable equ &EF00


my_txt_set_window            equ &0103
my_txt_clear_window          equ my_txt_set_window+3
txt_set_paper                equ my_txt_clear_window+3
txt_set_pen                  equ txt_set_paper+3
scr_next_line_hl             equ txt_set_pen+3
getscreenaddress             equ scr_next_line_hl+3
mygetobjectmaplocationfromde equ getscreenaddress+3
locatetextf                  equ mygetobjectmaplocationfromde+3
writelineplainf              equ locatetextf+3
drawbox                      equ writelineplainf+3
scr_set_ink                  equ drawbox+3
dodrawsprite                 equ scr_set_ink+3
getobjectmaplocationfromde   equ dodrawsprite+3
endif

; EXTRA LAYER FOR MY OWN OBJECTS
; screenptrtable equ &F700
ifdef ISCART
my_data_objectmap equ &F900
endif
enddata:
