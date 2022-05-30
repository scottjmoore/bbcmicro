MMBTOOLSPATH = @../../hoglet67/MMFS/tools/mmb_utils/
MISTER = root@mister
MISTERPATH = ${MISTER}:/media/fat/games/BBCMICRO/boot.vhd
MISTERPASSWORD = 1
MMFSNAME = BEEB.MMB
DISKNAME = helloworld.ssd
DISKFILES = HELLOWO !BOOT README

${MMFSNAME}:	${DISKNAME} makefile
	-@rm -f ${MMFSNAME}
	@$(MMBTOOLSPATH)dblank_mmb.pl
	@$(MMBTOOLSPATH)dput_ssd.pl 0 ${DISKNAME}
	${MMBTOOLSPATH}dcat.pl ${MMFSNAME} 

helloworld.ssd:	${DISKFILES} makefile
	-@rm -f *.ssd
	$(MMBTOOLSPATH)blank_ssd.pl ${DISKNAME}
	$(MMBTOOLSPATH)title.pl ${DISKNAME} HELLOWORLD
	$(MMBTOOLSPATH)opt4.pl ${DISKNAME} 3
	${MMBTOOLSPATH}putfile.pl ${DISKNAME} ${DISKFILES}
	${MMBTOOLSPATH}info.pl ${DISKNAME}

HELLOWO:	helloworld.asm makefile
	vasm6502_oldstyle helloworld.asm -chklabels -nocase -L helloworld.lst -Fbin -o HELLOWO

clean:
	-@rm -f HELLOWO
	-@rm -f ${MMFSNAME}
	-@rm -f *.ssd
	-@rm -f *.bin
	-@rm -f *.lst

deploy: ${MMFSNAME} makefile
	@sshpass -p ${MISTERPASSWORD} rsync --progress ${MMFSNAME} ${MISTERPATH}

deploy-run: ${MMFSNAME} makefile
	@sshpass -p ${MISTERPASSWORD} rsync --progress ${MMFSNAME} ${MISTERPATH}
	@sshpass -p ${MISTERPASSWORD} ssh ${MISTER} "echo load_core /media/fat/_Computer/BBCMicro*.rbf >/dev/MiSTer_cmd"

run: ${DISKNAME} makefile
	make
	-@b-em -disc ${DISKNAME} -mx=5 -s -i -autoboot &

clean-deploy:
	make clean
	make deploy

clean-deploy-run:
	make clean
	make deploy-run

clean-run:
	make clean
	make run
