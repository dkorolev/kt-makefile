.PHONY: build run clean cleanall

run: build
	java CodeKt

build: CodeKt.class

CodeKt.class: code.kt
	kotlinc code.kt

clean:
	rm -f CodeKt.class

cleanall: clean
	rm -rf META-INF
