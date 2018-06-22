Return-Path: <eddiehorng.tw@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CALLuPvqGdzMWry8m1ewjtecV47uMSCNTPykn954zL42yFDcgRQ@mail.gmail.com>
References: <CALLuPvowiBB7-2aaEgMEyykaZd+Web4zmPPUkx492Wq2CUNhkQ@mail.gmail.com>
 <CAOQ4uxi37A0Nrfhjwc0bxEkrAvjjA47s+aGg6RdOt7J-s0z5BQ@mail.gmail.com>
 <CALLuPvpEzczsFCD_u6+XOxUHY8EWaczYhH-sd=amJGgXsrnd4w@mail.gmail.com>
 <CALLuPvqk3SDWA-GDTworPdgfV=jqeWMUviR5AhYxk+Tc-bUjnw@mail.gmail.com>
 <CAOQ4uxgt41iTTfEgDtYSG=iGLSK9LPR1znBKg_LQYVDwzAG21g@mail.gmail.com> <CALLuPvqGdzMWry8m1ewjtecV47uMSCNTPykn954zL42yFDcgRQ@mail.gmail.com>
From: Eddie Horng <eddiehorng.tw@gmail.com>
Date: Fri, 22 Jun 2018 13:38:25 +0800
Message-ID: <CALLuPvrxjwRwqvfxTTTqZSihTt+DHSBTOMXA9SdHPxnGbJ_yew@mail.gmail.com>
Subject: Re: Invalid argument reading file caps for file
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Serge Hallyn <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-ID: <linux-unionfs@vger.kernel.org>

>> If you can, please create a small reproducer that opens an executable,
>> unlink the executable and execute it with execveat().
>> I estimate this should fail with file capabilities enabled over any file
>> system, not just overlayfs.

I'm able to reproduce very similar failure with the small reproducer,
dmesg is like:
Invalid argument reading file caps for /dev/fd/3

But the result is different in test executable in overlay and ext4,
later one can pass the test.

Also I tested yocto codebase in ext4 can not reproduce the error.
The error accessed executable in yocto is compiled in build process
and run by shell exec.
It seems the shell script could rm the file in certain conditions.

Below is the reproducer usage and source code, for your reference.
$ cd /mnt/merged
$ cp /bin/echo .
$ ~/test_execveat/a.out
execveat exec: Invalid argument

$ cd /tmp
$ cp /bin/echo .
$ ~/test_execveat/a.out
hello

----
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <linux/fcntl.h>
#include <sys/syscall.h>
#include <errno.h>

static void die_if_negative(int ret, const char* msg) {
if(ret<0) {
   fprintf(stderr, "%s: %s\n", msg, strerror(errno));
   exit(1);
}
}

const char* exec="echo";
char *newargv[] = { "echo", "hello", NULL};
char *newenviron[] = { NULL };

void main() {
int exefd, ret;

exefd = open(exec, O_PATH);
die_if_negative(exefd, "open exec");

ret = unlink(exec);
die_if_negative(ret, "unlink exec");

ret = syscall(322/*SYS_execveat*/, exefd, "", newargv, newenviron,
AT_EMPTY_PATH);
die_if_negative(ret, "execveat exec");
}

thanks,
Eddie
