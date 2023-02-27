#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <unistd.h>

/* duplicated from caml/sys.h and io.c */
CAMLextern value caml_channel_descriptor(value vchannel);
#define NO_ARG Val_int(0)
CAMLextern void caml_sys_error (value);
/* End of code duplication */

static int capture_output_saved_stdout;
static int capture_output_saved_stderr;

CAMLprim value capture_output_setup (value voutput, value vstdout, value vstderr) {
  int output_fd, stdout_fd, stderr_fd, fd, ret;
  stdout_fd = Int_val(caml_channel_descriptor(vstdout));
  stderr_fd = Int_val(caml_channel_descriptor(vstderr));
  output_fd = Int_val(caml_channel_descriptor(voutput));
  fd = dup(stdout_fd);
  if(fd == -1) caml_sys_error(NO_ARG);
  capture_output_saved_stdout = fd;
  fd = dup(stderr_fd);
  if(fd == -1) caml_sys_error(NO_ARG);
  capture_output_saved_stderr = fd;
  ret = dup2(output_fd, stdout_fd);
  if(ret == -1) caml_sys_error(NO_ARG);
  ret = dup2(output_fd, stderr_fd);
  if(ret == -1) caml_sys_error(NO_ARG);
  return Val_unit;
}

CAMLprim value capture_output_restore (value vstdout, value vstderr) {
  int stdout_fd, stderr_fd, ret;
  stdout_fd = Int_val(caml_channel_descriptor(vstdout));
  stderr_fd = Int_val(caml_channel_descriptor(vstderr));
  ret = dup2(capture_output_saved_stdout, stdout_fd);
  if(ret == -1) caml_sys_error(NO_ARG);
  ret = dup2(capture_output_saved_stderr, stderr_fd);
  if(ret == -1) caml_sys_error(NO_ARG);
  ret = close(capture_output_saved_stdout);
  if(ret == -1) caml_sys_error(NO_ARG);
  ret = close(capture_output_saved_stderr);
  if(ret == -1) caml_sys_error(NO_ARG);
  return Val_unit;
}
