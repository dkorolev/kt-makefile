# NOTE(dkorolev): This `Makefile` is symlinked from the subdirectories of the root of this repo.
#                 It builds `.kt` files and runs them, in a given dir.
#                 Dependencies should be listed in a, possibly empty, `deps.txt`.
#                 Maven is used to install them, locally, under `.gitignore`-d directories.

.PHONY: run build install clean cleanall

# NOTE(dkorolev): This requires `.kt` files to be named in a `CamelCase.kt` fashion.
SRC=$(wildcard *.kt)
BIN=$(SRC:%.kt=%Kt)
CLASS=$(BIN:%=__kotlinc__/%.class)

run: build 
	@echo '#!/bin/bash\n(cd __kotlinc__; java -cp "$$(find "$$PWD/../__mvn__" -name "*.jar" | tr "\\n" ":")" $(BIN))' >__kotlinc__/run.sh
	@chmod +x __kotlinc__/run.sh
	@__kotlinc__/run.sh

install: __mvn__/installed_deps.txt

__mvn__/installed_deps.txt: __mvn__/install.sh
	@__mvn__/install.sh && cp deps.txt __mvn__/installed_deps.txt

__mvn__/install.sh: deps.txt
	@mkdir -p __mvn__
	@echo '#!/bin/bash\nfor i in $$(cat deps.txt | grep -v "^#") ; do mvn dependency:get -Dmaven.repo.local=./__mvn__ -Dartifact=$$i ; done' >__mvn__/install.sh
	@chmod +x __mvn__/install.sh

build: install $(CLASS)

__kotlinc__/%Kt.class: %.kt
	@mkdir -p __kotlinc__
	@echo 'kotlinc -d __kotlinc__ -cp "$$CLASSPATH"' "$<"
	@kotlinc -d __kotlinc__ -cp "$(shell find "$$PWD/__mvn__" -name "*.jar" | tr '\n' ':')" "$<"

clean:
	rm -f *.class

cleanall: clean
	rm -rf __kotlinc__ __mvn__
