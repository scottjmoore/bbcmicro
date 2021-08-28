helloworld.ssd:	HELLOWO
	-@rm -f disc.ssd
	-@rm -f disc.ssd.dsk
	-@bbcim -ab disc.ssd -side 0 !BOOT
	-@bbcim -a disc.ssd -side 0 HELLOWO

HELLOWO:	helloworld.asm
	-@vasm6502_oldstyle helloworld.asm -chklabels -nocase -L helloworld.lst -Fbin -o HELLOWO

clean:
	-@rm -f HELLOWO
	-@rm -f *.ssd
	-@rm -f *.dsk
	-@rm -f *.bin
	-@rm -f *.lst

run:
	-@make
	-@killall b-em 2>&1
	-@b-em -autoboot -disc disc.ssd & disown

clean-run:
	-@make clean
	-@make run
