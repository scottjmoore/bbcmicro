MMBTOOLSPATH = @../../hoglet67/MMFS/tools/mmb_utils/
DISKNAME = helloworld.ssd
OBJS = HELLOWO !BOOT

BEEB.MMB:	${DISKNAME}
	-@rm -f BEEB.MMB
	@$(MMBTOOLSPATH)dblank_mmb.pl
	@$(MMBTOOLSPATH)dput_ssd.pl 0 ${DISKNAME}
	${MMBTOOLSPATH}dcat.pl BEEB.MMB 

helloworld.ssd:	${OBJS}
	-@rm -f ${DISKNAME}
	$(MMBTOOLSPATH)blank_ssd.pl ${DISKNAME}
	$(MMBTOOLSPATH)title.pl ${DISKNAME} HELLOWORLD
	$(MMBTOOLSPATH)opt4.pl ${DISKNAME} 3
	${MMBTOOLSPATH}putfile.pl ${DISKNAME} !BOOT
	${MMBTOOLSPATH}putfile.pl ${DISKNAME} HELLOWO
	${MMBTOOLSPATH}info.pl ${DISKNAME}

HELLOWO:	helloworld.asm
	vasm6502_oldstyle helloworld.asm -chklabels -nocase -L helloworld.lst -Fbin -o HELLOWO

clean:
	-@rm -f HELLOWO
	-@rm -f BEEB.MMB
	-@rm -f *.ssd
	-@rm -f *.bin
	-@rm -f *.lst

deploy:
	rsync --progress BEEB.MMB root@mister:/media/fat/games/BBCMICRO/boot.vhd

run:
	make
	-@killall b-em
	b-em -disc ${DISKNAME} -mx=5 -s -i -autoboot &

clean-deploy:
	make clean
	make deploy

clean-run:
	make clean
	make run
