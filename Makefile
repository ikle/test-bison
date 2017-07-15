TARGETS = calc

CFLAGS += -O6

all: $(TARGETS)

clean:
	rm -f *.o *-lexer.[ch] *-parser.[ch] $(TARGETS)

PREFIX ?= /usr/local

install: $(TARGETS)
	install -D -d $(DESTDIR)/$(PREFIX)/bin
	install -s -m 0755 $^ $(DESTDIR)/$(PREFIX)/bin

%-lexer.c %-lexer.h: %-lexer.l
	flex -o $(patsubst %.l,%.c, $<) \
		--header-file=$(patsubst %.l,%.h, $<) $<

%-parser.c %-parser.h: %-parser.y
	bison -o $(patsubst %.y,%.c, $<) \
		--defines=$(patsubst %.y,%.h, $<) $<

calc-lexer.o:  calc-parser.h
calc-parser.o: calc-lexer.h
calc: se.o calc-lexer.o calc-parser.o
