MKPATH = constructor
AHK2EXE = Ahk2Exe.exe

ifeq ($(PROCESSOR_ARCHITECTURE), x86)
	AHKRES = resources32.bin
else
	AHKRES = resources64.bin
endif

RM = /bin/rm

object = mintty-dropdown

all: mintty-dropdown

mintty-dropdown: $(object).ahk
	$(MKPATH)/$(AHK2EXE) /in $^ /base $(MKPATH)/$(AHKRES) /compress 2 /silent verbose

clean: $(object)
	$(RM) -f $^.exe

.PHONY: clean
