# CREATE BLANK DSK WITH LOADER AND SCREEN ALREADY ON
rm build/OhMummyResurrected.dsk -f
rm build/OhMummyResurrected.dsk.zip -f
cp build/OhMummy_Blank.dsk build/OhMummyResurrected.dsk 

# BUILD BINARIES

./rasm.exe -DOHMUMMY=1 -amper ../ohmummy18.asm
#./rasm.exe -DOHMUMMY=1 -amper ../AMSTRADFONT3.asm HARRIER2
#./rasm.exe -amper ../HARR_SCR2.asm HARRSCR            # LOADING SCREEN
#./rasm.exe -amper ../loader3.asm LOADER               # DSK LOADER

# MAKE ARCHIVE

zip -j build/OhMummyResurrected.dsk.zip build/OhMummyResurrected.dsk
