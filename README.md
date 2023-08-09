# kt-makefile

Simplified Kotlin builds for the "no-IDE" setup.

All the "logic" is in the top-level `Makefile`, which is symlinked from each subdirectory.

TL;DR: It installs modules from `deps.txt`, much like `pip`'s `requirements.txt`.

Highlights:

* The installation is performed via `maven`.
* The compilation — via `kotlinc`.
* There's an extra step to provide the `CLASSPATH`, which I do via `-cp` and via `grep ... | tr '\n' ':'`.
* Another bummer is to add `kotlin-stdlib.jar` into the `$CLASSPATH` via `-cp`, so I just `find` it in the `Makefile`, bwahaha.

Hope this helps!
