#!/bin/bash

mkdir -p target

odin build src -target=freestanding_wasm32 -build-mode:object -out:target/odin.o \
	&& clang src/c_src.c --target=wasm32 --no-standard-libraries -c -o target/c.wasm.o \
	&& wasm-ld target/*.o -o target/app.wasm --no-entry


# Odin:
#
#  Build the src directory. I also store the .c file in the src directory, but Odin seems to ignore it so it's fine.
#    odin build src
#
#  First arg: use a wasm target to generate wasm code
#  We won't depend on the Odin js runtime (js_wasm32 target) or the wasi stuff (wasi_wasm32 target),
#  so we'll use the freestanding version of the wasm32 target.
#    -target=freestanding_wasm32
#
#  By default odin will generate a wasm file ready to be loaded by a WASM runtime.
#  Instead, we need it to generate a wasm relocatable file that can be linked with wasm-ld.
#    -emit-mode:object
#
#  Finally, send the output wasm file to the target directory.
#  Note that odin automatically inserts ".wasm" before the final ".o" extension,
#  making the final filename "odin.wasm.o" I haven't found a way to control that behavior.
#    -out:target/odin.o


# Clang:
#
# Build src/c_src.c
#   clang src/c_src.c
#
# Choose the wasm32 target
#   --target=wasm32
#
# Disable the C standard library since the normal one usually cannot be compiled to wasm
#   --no-standard-libraries
#
# Generate a linkable wasm object file rather than an executable wasm file.
# An executable wasm file would be ready to be loaded into a WASM runtime, while a linkable
# wasm file cannot be loaded by a runtime. Instead it must first be linked by a linker.
#   -c
#
# Output to the target directory. I choose c.wasm.o as the name to match Odin's output file name.
# The name doesn't matter though.
#   -o target/c.wasm.o


# wasm-ld:
#
# Now that we have two linkable wasm object files, we need to link them into a single executable wasm file.
# We need to use a linker that understands wasm to do that. The normal one is wasm-ld, which you probably already
# have if you managed to successfully run the last two commands.
#   wasm-ld target/*.o
#
# Disable entry point. I'm not exactly sure why wasm-ld has the concept of an entry point. As far as I can tell
# from the wasm spec, there isn't really a such thing as an "entry point" to wasm files.
#   --no-entry
#
# Output to the target directory. The final binary is called "app.wasm" and is ready to be loaded
# into a wasm runtime like a web browser.
#   -o target/app.wasm
