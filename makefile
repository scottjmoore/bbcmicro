MMBTOOLSPATH = ../../hoglet67/MMFS/tools/mmb_utils/

BEEB.MMB:	helloworld.ssd
	-@rm -f BEEB.MMB
	@$(MMBTOOLSPATH)dblank_mmb.pl
	@$(MMBTOOLSPATH)dput_ssd.pl 0 disc.ssd

helloworld.ssd:	HELLOWO
	-@rm -f disc.ssd
	-@rm -f disc.ssd.dsk
	bbcim -ab disc.ssd -side 0 !BOOT
	bbcim -a disc.ssd -side 0 HELLOWO

HELLOWO:	helloworld.asm
	vasm6502_oldstyle helloworld.asm -chklabels -nocase -L helloworld.lst -Fbin -o HELLOWO

clean:
	-@rm -f HELLOWO
	-@rm -f BEEB.MMB
	-@rm -f *.ssd
	-@rm -f *.dsk
	-@rm -f *.bin
	-@rm -f *.lst

deploy:
	rsync --progress BEEB.MMB root@mister:/media/fat/games/BBCMICRO/boot.vhd
	
run:
	make
	-@killall b-em
	b-em -disc disc.ssd -mx=5 -s -i -autoboot &

clean-run:
	make clean
	make run
