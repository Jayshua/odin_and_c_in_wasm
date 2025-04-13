package main



/*
Since we'll be calling this code from other languages, it needs to be
@export to mark it as linkable when constructing the wasm executable from the wasm
object files. It also needs to use the "c" abi so other languages know how to talk
to it. Note that the "c" abi in this context corresponds to the "BasicC" abi
defined by llvm.

https://github.com/WebAssembly/tool-conventions/blob/main/BasicCABI.md
*/
@export
odin_receive :: proc "c" (input: i32) -> i32 {
	return input * 3
}



/*
This function will be called from the wasm environment, so it also
needs to be marked as @export and abi "c".
*/
@export
odin_call_all :: proc "c" () -> i32 {
	return js_receive(35) * c_receive(35)
}



/*
The path of this import (the bit inside the quotes) doesn't matter as long as it
ends in ".o". "my_object.o" or "../path/velociraptor.o" would work just as well.
".o" seems to get Odin to generate the necessary "hey linker! link this up!" instructions.

The name of the import doesn't matter either. (The bit called other_code here.)
It just needs to match the name used in the foreign block.
*/
foreign import other_code ".o"

foreign other_code {
	c_receive :: proc "c" (i32) -> i32 ---
}



/*
Geting functions from the wasm runtime environment is similar.

Again, the import path inside the quotes doesn't matter. It can be anything
so long as it doesn't end in ".o".

It does need to match the field on the env object used when initalizing the wasm
module in the runtime environment. Other than that, the sky's the limit. I've tried
colons, spaces, brackets, anything goes. Might depend on what your wasm runtime
supports though?
*/

foreign import js "my_js_code"

foreign js {
	js_receive :: proc "c" (i32) -> i32 ---
}
