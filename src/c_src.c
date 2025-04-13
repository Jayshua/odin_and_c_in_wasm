#include <stdint.h>


// Declare for C the functions we expect to have supplied by the linker.
extern int32_t odin_receive(int32_t input);


// This attribute instructs the compiler that this function will be supplied at runtime
// by the wasm runtime. In this example, by the JS code.
// The __import_module__("...") bit specifies which field on the env object to look in,
// and the __import_name__("...") bit specifies what property on that field to find the function.
__attribute__((__import_module__("my_js_code"), __import_name__("js_receive")))
extern int32_t js_receive(int32_t input);


// This attribute instructions clang to mark the function as linkable in the wasm object file.
// That permits the linker to use this function when other wasm object files need a function
// with the same name.
__attribute__((export_name("c_receive")))
int32_t c_receive(int32_t input) {
	return input * 5;
}


// This same attribute also marks the function as exported from the resulting wasm
// binary and available to call from the wasm environment.
__attribute__((export_name("c_call_all")))
int32_t c_call_all() {
	return odin_receive(23) * js_receive(23);
}