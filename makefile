helloworld.ssd:	HELLOWO
	-@rm -f disc.ssd
	-@rm -f disc.ssd.dsk
	bbcim -ab disc.ssd -side 0 !BOOT
	bbcim -a disc.ssd -side 0 HELLOWO

HELLOWO:	helloworld.asm
	vasm6502_oldstyle helloworld.asm -chklabels -nocase -L helloworld.lst -Fbin -o HELLOWO

clean:
	-@rm -f HELLOWO
	-@rm -f *.ssd
	-@rm -f *.dsk
	-@rm -f *.bin
	-@rm -f *.lst

run:
	make
	-@killall b-em
	b-em -autoboot -disc disc.ssd &

clean-run:
	make clean
	make run
