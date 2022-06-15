MKPATH = constructor
AHK2EXE = Ahk2Exe.exe
PACKER = upx.exe

ifeq ($(PROCESSOR_ARCHITECTURE), x86)
	AHKRES = resources32.bin
else
	AHKRES = resources64.bin
endif

RM = /bin/rm.exe

object = mintty-dropdown

all: mintty-dropdown

mintty-dropdown: $(object).ahk
	$(MKPATH)/$(AHK2EXE) /in $^ /bin $(MKPATH)/$(AHKRES)
	$(MKPATH)/$(PACKER) $(object).exe

clean: $(object)
	$(RM) -f $^.exe

.PHONY: clean
