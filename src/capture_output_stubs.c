#include <caml/alloc.h>
#include <caml/memory.h>
#include <caml/mlvalues.h>
#include <unistd.h>

/* duplicated from caml/sys.h and io.c */
CAMLextern value caml_channel_descriptor(value vchannel);
#define NO_ARG Val_int(0)
CAMLextern void caml_sys_error (value);
/* End of code duplication */

CAMLprim value capture_output_setup (value voutput, value vtocapture) {
  int output_fd, tocapture_fd, fd, ret;
  tocapture_fd = Int_val(caml_channel_descriptor(vtocapture));
  output_fd = Int_val(caml_channel_descriptor(voutput));
  fd = dup(tocapture_fd);
  if(fd == -1) caml_sys_error(NO_ARG);
  ret = dup2(output_fd, tocapture_fd);
  if(ret == -1) caml_sys_error(NO_ARG);
  return Val_int(fd);
}

CAMLprim value capture_output_restore (value vcaptured, value vold) {
  int captured_fd, ret;
  int old = Int_val(vold);
  captured_fd = Int_val(caml_channel_descriptor(vcaptured));
  ret = dup2(old, captured_fd);
  if(ret == -1) caml_sys_error(NO_ARG);
  ret = close(old);
  if(ret == -1) caml_sys_error(NO_ARG);
  return Val_unit;
}
