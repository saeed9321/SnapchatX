#include <objc/runtime.h>

#include <dlfcn.h>

#include <mach/task_info.h>
#include <mach-o/dyld.h>
#include <mach-o/dyld_images.h>

#include <sys/sysctl.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/syscall.h>



void bypass_jailbreak_detection();
