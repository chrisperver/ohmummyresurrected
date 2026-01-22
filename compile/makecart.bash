# BUILD BINARIES

./rasm.exe -DISCART=1 -amper ../ohmummy18.asm OHMUMMY1
./rasm.exe -DISCART=1 -DOHMUMMY=1 -amper ../AMSTRADFONT6.asm OHMUMMY2
#./rasm.exe -DISCART=1 -DOHMUMMY=1 -amper ../buildworld2.asm OHMUMMY3
./rasm.exe -amper ../loader_scr.asm LOADSCR            # LOADING SCREEN

rm ./boot.bin -f
rm ./OhMummyResurrectedROM.bin -f

# CREATE ROM FILE

./rasm.exe -amper ../boot2.asm boot
./rominject -p 0 -o 0 boot.bin ./OhMummyResurrectedROM.bin
./rominject -p 1 -o 0 LOADSCR.bin ./OhMummyResurrectedROM.bin
./rominject -p 2 -o 0 OHMUMMY1.bin ./OhMummyResurrectedROM.bin #0100-3FFF CODE
./rominject -p 3 -o 0 OHMUMMY2.bin ./OhMummyResurrectedROM.bin #C100-FF00 CODE
#./rominject -p 4 -o 0 OHMUMMY3.bin ./OhMummyResurrectedROM.bin #4000-7FFF CODE (WHEN ASIC DISABLED)

rm ./build/OhMummyResurrected.cpr -f
rm ./build/OhMummyResurrected.cpr.zip -f
./buildcpr ./OhMummyResurrectedROM.bin ./build/OhMummyResurrected.cpr

# MAKE ARCHIVE

zip -j ./build/OhMummyResurrected.cpr.zip ./build/OhMummyResurrected.cpr
zip -j ./build/OhMummyResurrectedROM.zip ./OhMummyResurrectedROM.bin