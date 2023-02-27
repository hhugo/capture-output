#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <unistd.h>

CAMLprim value capture_output_print_stdout(value unit){
  fprintf(stdout, "stdout from external");
  fflush(stdout);
  return Val_unit;
}

CAMLprim value capture_output_print_stderr(value unit){
  fprintf(stderr, "stderr from external");
  fflush(stderr);
  return Val_unit;
}


