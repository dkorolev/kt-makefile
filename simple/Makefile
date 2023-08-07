.PHONY: build run clean cleanall

# NOTE(dkorolev): This requires `.kt` files to be named in a `CamelCase.kt` fashion.
SRC=$(wildcard *.kt)
BIN=$(SRC:%.kt=%Kt)
CLASS=$(BIN:%=%.class)

run: build
	java $(BIN)

build: $(CLASS)

%Kt.class: %.kt
	kotlinc "$<"

clean:
	rm -f *.class

cleanall: clean
	rm -rf META-INF
