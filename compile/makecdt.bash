# BUILD BINARIES
./rasm.exe -DOHMUMMY=1 -DISCASSETTE=1 -amper ../ohmummy18.asm OHMUMMY1
#./rasm.exe  -amper ../AMSTRADFONT3.asm HARRIER2
./rasm.exe -amper ../loader_scr.asm LOADSCR          # LOADING SCREEN
./rasm.exe -amper ../loadercasette.asm LOADERC        # CAS LOADER

# TURBO
# -----

rm build/OhMummy.cdt -f

# create new CDT and put binary loader

./2cdt -n -r ohmummy.bin ./LOADERC.bin build/OhMummyResurrected.cdt

# add screen to existing CDT data

./2cdt -r loadscr.bin ./LOADSCR.bin build/OhMummyResurrected.cdt

# add code to existing CDT data

./2cdt -r ohmummy1.bin ./OHMUMMY1.bin build/OhMummyResurrected.cdt
./2cdt -r ohmummy2.bin ./OHMUMMY2.bin build/OhMummyResurrected.cdt
#./2cdt -r ohmummy3.bin ./OHMUMMY3.bin build/OhMummyResurrected.cdt

# NORMAL BAUD - NEEDED FOR REAL HARDWARE
# --------------------------------------

# create new CDT and put binary loader

rm build/OhMummyResurrectedN.cdt -f

./2cdt -t 0 -s 0 -n -r ohmummy.bin ./LOADERC.bin build/OhMummyResurrectedN.cdt

# add screen to existing CDT data

./2cdt -t 0 -s 0 -r loadscr.bin ./LOADSCR.bin build/OhMummyResurrectedN.cdt

# add code to existing CDT data

./2cdt -t 0 -s 0 -r ohmummy1.bin ./OHMUMMY1.bin build/OhMummyResurrectedN.cdt
./2cdt -t 0 -s 0 -r ohmummy2.bin ./OHMUMMY2.bin build/OhMummyResurrectedN.cdt
#./2cdt -t 0 -s 0 -r ohmummy3.bin ./OHMUMMY3.bin build/OhMummyResurrectedN.cdt

# ZIP ARCHIVE

rm build/OhMummyResurrected.cdt.zip -f
rm build/OhMummyResurrectedN.cdt.zip -f
zip -j build/OhMummyResurrected.cdt.zip build/OhMummyResurrected.cdt
zip -j build/OhMummyResurrectedN.cdt.zip build/OhMummyResurrectedN.cdt
