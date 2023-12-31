# NOTE(dkorolev): This `Makefile` is symlinked from the subdirectories of the root of this repo.
#                 It builds `.kt` files and runs them, in a given dir.
#                 Dependencies should be listed in a, possibly empty, `deps.txt`.
#                 Maven is used to install them, locally, under `.gitignore`-d directories.

.PHONY: run build install clean cleanall

# NOTE(dkorolev): This requires `.kt` files to be named in a `CamelCase.kt` fashion.
SRC=$(wildcard *.kt)
BIN=$(SRC:%.kt=%Kt)
CLASS=$(BIN:%=.kt/%.class)

run: build 
	@echo '#!/bin/bash\n(cd .kt; java -cp "$$(cat kotlin-stdlib.jar.txt):$$(find "$$PWD/../.kt/mvn" -name "*.jar" | tr "\\n" ":")" $(BIN))' >.kt/run.sh
	@chmod +x .kt/run.sh
	@echo "(cd .kt; java -cp \"\$$CLASSPATH\" "$(BIN)")"
	@.kt/run.sh

install: .kt/mvn/installed_deps.txt

.kt/mvn/installed_deps.txt: .kt/mvn/install.sh
	@.kt/mvn/install.sh && cp deps.txt .kt/mvn/installed_deps.txt

.kt/mvn/install.sh: deps.txt
	@mkdir -p .kt/mvn
	@echo '#!/bin/bash\nfor i in $$(cat deps.txt | grep -v "^#") ; do mvn dependency:get -Dmaven.repo.local=./.kt/mvn -Dartifact=$$i -Dtransitive=true ; done' >.kt/mvn/install.sh
	@chmod +x .kt/mvn/install.sh

build: install .kt/kotlin-stdlib.jar.txt $(CLASS)

.kt/kotlin-stdlib.jar.txt: 
	@mkdir -p .kt
	@find /usr/share/kotlinc/lib /snap/kotlin/current/lib $(dirname $(which kotlinc))/.. -name kotlin-stdlib.jar -print -quit 2>/dev/null | head -n 1 >"$@.tmp"
	@([ -s "$@.tmp" ]) && mv "$@.tmp" "$@" || (echo 'Could not locate `kotlin-stdlib.jar`, maybe put the path to it into `$@` manually?'; exit 1)

.kt/%Kt.class: %.kt
	@mkdir -p .kt
	@echo 'kotlinc -include-runtime -d .kt -cp "$$CLASSPATH"' "$<"
	@kotlinc -d .kt -cp "$(shell find "$$PWD/.kt/mvn" -name "*.jar" | tr '\n' ':')" "$<"

clean:
	@mkdir -p .kt
	rm -f .kt/*.class

cleanall: clean
	rm -rf .kt
