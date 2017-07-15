TARGETS = calc

CFLAGS += -O6

all: $(TARGETS)

clean:
	rm -f *.o lexer.[ch] parser.[ch] $(TARGETS)

PREFIX ?= /usr/local

install: $(TARGETS)
	install -D -d $(DESTDIR)/$(PREFIX)/bin
	install -s -m 0755 $^ $(DESTDIR)/$(PREFIX)/bin

%.c %.h: %.l
	flex -o $(patsubst %.l,%.c, $<) \
		--header-file=$(patsubst %.l,%.h, $<) $<

%.c %.h: %.y
	bison -o $(patsubst %.y,%.c, $<) \
		--defines=$(patsubst %.y,%.h, $<) $<

lexer.o: parser.h
parser.o: lexer.h
calc: se.o lexer.o parser.o
