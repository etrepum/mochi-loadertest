MXMLC := mxmlc
FDB := fdb

ZIP_SRC := Makefile LoaderTest.as LoaderTest.swf LoaderTest.html swfobject.js
TARGETS := LoaderTest.swf LoaderTest.zip

.PHONY: all test clean

all: $(TARGETS)

clean:
	rm -f $(TARGETS)

test: all
	$(FDB) LoaderTest.html

LoaderTest.swf: LoaderTest.as
	$(MXMLC) -default-background-color 0xCFD4E6 \
		 -default-size 800 600 \
		 -default-frame-rate 30 \
		 -target-player 10 \
		 -debug LoaderTest.as

LoaderTest.zip: $(ZIP_SRC)
	zip $@ $(ZIP_SRC)
