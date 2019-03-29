Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf1-f174.google.com ([209.85.210.174]:41641 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727654AbfC2CpG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Mar 2019 22:45:06 -0400
Received: by mail-pf1-f174.google.com with SMTP id 188so306471pfd.8
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Mar 2019 19:45:05 -0700 (PDT)
MIME-Version: 1.0
References: <CALsfCbd2UKVsC4k=da5x+joaBQk-phCizkyF0vXeMNOYDojWwQ@mail.gmail.com>
 <CAOQ4uxgEaMVF4kp4O8T=vY4zZSWfFYK2JmhwB4JSKhRVb-0KXw@mail.gmail.com> <CALsfCbeFZu7WW3_-jGGtFA5EtM3H-yJ2wKpxhVbuXwK6uyOysg@mail.gmail.com>
In-Reply-To: <CALsfCbeFZu7WW3_-jGGtFA5EtM3H-yJ2wKpxhVbuXwK6uyOysg@mail.gmail.com>
From: koishi komeiji <maykagura@gmail.com>
Date: Fri, 29 Mar 2019 10:44:52 +0800
Message-ID: <CALsfCbef=3P8z5G9FbYdwzj+Hy2JwL95vDCMitHDjEbtffdG7A@mail.gmail.com>
Subject: Re: [Help]Cannot read symbolic link(Invalid argument) in overlayfs
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

5.Please record strace from failures (e.g. of cat, stat, ls, readlink).

root:/var/lib/docker/overlay2# find . -name "libisis.so"
./654.../diff/usr/lib/libisis.so
./654.../merged/usr/lib/libisis.so


#strace cat 654.../diff/usr/lib/libisis.so
execve("/bin/cat", ["cat", "654e8c3827c816a6b69ee887b4518200"...], [/*
31 vars */]) = 0
brk(NULL)                               = 0x21e3000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=90859, ...}) = 0
mmap(NULL, 90859, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fbecce91000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\t\2\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1868984, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7fbecce90000
mmap(NULL, 3971488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7fbecc8b9000
mprotect(0x7fbecca79000, 2097152, PROT_NONE) = 0
mmap(0x7fbeccc79000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c0000) = 0x7fbeccc79000
mmap(0x7fbeccc7f000, 14752, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7fbeccc7f000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7fbecce8f000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7fbecce8e000
arch_prctl(ARCH_SET_FS, 0x7fbecce8f700) = 0
mprotect(0x7fbeccc79000, 16384, PROT_READ) = 0
mprotect(0x60b000, 4096, PROT_READ)     = 0
mprotect(0x7fbeccea8000, 4096, PROT_READ) = 0
munmap(0x7fbecce91000, 90859)           = 0
brk(NULL)                               = 0x21e3000
brk(0x2204000)                          = 0x2204000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=4759040, ...}) = 0
mmap(NULL, 4759040, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7fbecc42f000
close(3)                                = 0
fstat(1, {st_mode=S_IFCHR|0666, st_rdev=makedev(1, 3), ...}) = 0
open("654e8c3827c816a6b69ee887b45182003dce24b75b4325ba02ecab5d70d7a7c2/diff/usr/lib/libisis.so",
O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0755, st_size=435696, ...}) = 0
fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0
mmap(NULL, 139264, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS,
-1, 0) = 0x7fbecce6c000
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\310\0\0\0\0\0\0"...,
131072) = 131072
write(1, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\340\310\0\0\0\0\0\0"...,
131072) = 131072
read(3, "\266E\377\311\303\220f.\17\37\204\0\0\0\0\0f\17\37D\0\0UH\211\345H\203\3540H\211"...,
131072) = 131072
write(1, "\266E\377\311\303\220f.\17\37\204\0\0\0\0\0f\17\37D\0\0UH\211\345H\203\3540H\211"...,
131072) = 131072
read(3, "\1,\206\\\0\0\37\236\3M\0\0\0\30\2,R\215\0\0\37\237\3b\0\0\0\34\2,#\246"...,
131072) = 131072
write(1, "\1,\206\\\0\0\37\236\3M\0\0\0\30\2,R\215\0\0\37\237\3b\0\0\0\34\2,#\246"...,
131072) = 131072
read(3, "BadProtoId\0szAuthPlain\0uiBadLspE"..., 131072) = 42480
write(1, "BadProtoId\0szAuthPlain\0uiBadLspE"..., 42480) = 42480
read(3, "", 131072)                     = 0
munmap(0x7fbecce6c000, 139264)          = 0
close(3)                                = 0
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++



#strace cat 654.../merged/usr/lib/libisis.so
execve("/bin/cat", ["cat", "654e8c3827c816a6b69ee887b4518200"...], [/*
31 vars */]) = 0
brk(NULL)                               = 0xcc2000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=90859, ...}) = 0
mmap(NULL, 90859, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f5d59281000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\t\2\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1868984, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f5d59280000
mmap(NULL, 3971488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f5d58ca9000
mprotect(0x7f5d58e69000, 2097152, PROT_NONE) = 0
mmap(0x7f5d59069000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c0000) = 0x7f5d59069000
mmap(0x7f5d5906f000, 14752, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f5d5906f000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f5d5927f000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f5d5927e000
arch_prctl(ARCH_SET_FS, 0x7f5d5927f700) = 0
mprotect(0x7f5d59069000, 16384, PROT_READ) = 0
mprotect(0x60b000, 4096, PROT_READ)     = 0
mprotect(0x7f5d59298000, 4096, PROT_READ) = 0
munmap(0x7f5d59281000, 90859)           = 0
brk(NULL)                               = 0xcc2000
brk(0xce3000)                           = 0xce3000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=4759040, ...}) = 0
mmap(NULL, 4759040, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f5d5881f000
close(3)                                = 0
fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 8), ...}) = 0
open("654e8c3827c816a6b69ee887b45182003dce24b75b4325ba02ecab5d70d7a7c2/merged/usr/lib/libisis.so",
O_RDONLY) = -1 ELOOP (Too many levels of symbolic links)
write(2, "cat: ", 5cat: )                    = 5
write(2, "654e8c3827c816a6b69ee887b4518200"...,
90654e8c3827c816a6b69ee887b45182003dce24b75b4325ba02ecab5d70d7a7c2/merged/usr/lib/libisis.so)
= 90
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2995, ...}) = 0
read(3, "# Locale name alias data base.\n#"..., 4096) = 2995
read(3, "", 4096)                       = 0
close(3)                                = 0
open("/usr/share/locale/en_US.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/libc.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT
(No such file or directory)
open("/usr/share/locale-langpack/en_US.UTF-8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US.utf8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US/LC_MESSAGES/libc.mo", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en.UTF-8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en.utf8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en/LC_MESSAGES/libc.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
write(2, ": Too many levels of symbolic li"..., 35: Too many levels of
symbolic links) = 35
write(2, "\n", 1
)                       = 1
close(1)                                = 0
close(2)                                = 0
exit_group(1)                           = ?
+++ exited with 1 +++



root:/var/lib/docker/overlay2# strace readlink  654.../merged/usr/lib/libisis.so
execve("/bin/readlink", ["readlink",
"654e8c3827c816a6b69ee887b4518200"...], [/* 31 vars */]) = 0
brk(NULL)                               = 0x1dab000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=90859, ...}) = 0
mmap(NULL, 90859, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7face2d1c000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\t\2\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1868984, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7face2d1b000
mmap(NULL, 3971488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7face2744000
mprotect(0x7face2904000, 2097152, PROT_NONE) = 0
mmap(0x7face2b04000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c0000) = 0x7face2b04000
mmap(0x7face2b0a000, 14752, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7face2b0a000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7face2d1a000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7face2d19000
arch_prctl(ARCH_SET_FS, 0x7face2d1a700) = 0
mprotect(0x7face2b04000, 16384, PROT_READ) = 0
mprotect(0x608000, 4096, PROT_READ)     = 0
mprotect(0x7face2d33000, 4096, PROT_READ) = 0
munmap(0x7face2d1c000, 90859)           = 0
brk(NULL)                               = 0x1dab000
brk(0x1dcc000)                          = 0x1dcc000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=4759040, ...}) = 0
mmap(NULL, 4759040, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7face22ba000
close(3)                                = 0
readlink("654e8c3827c816a6b69ee887b45182003dce24b75b4325ba02ecab5d70d7a7c2/merged/usr/lib/libisis.so",
0x1dacf80, 64) = -1 EINVAL (Invalid argument)
close(1)                                = 0
close(2)                                = 0
exit_group(1)                           = ?
+++ exited with 1 +++



root:/var/lib/docker/overlay2# strace ls  654.../merged/usr/lib/libisis.so
execve("/bin/ls", ["ls", "654e8c3827c816a6b69ee887b4518200"...], [/*
31 vars */]) = 0
brk(NULL)                               = 0x1291000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=90859, ...}) = 0
mmap(NULL, 90859, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f2a72fb2000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libselinux.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260Z\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=130224, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f2a72fb1000
mmap(NULL, 2234080, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f2a72b82000
mprotect(0x7f2a72ba1000, 2093056, PROT_NONE) = 0
mmap(0x7f2a72da0000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e000) = 0x7f2a72da0000
mmap(0x7f2a72da2000, 5856, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f2a72da2000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\t\2\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1868984, ...}) = 0
mmap(NULL, 3971488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f2a727b8000
mprotect(0x7f2a72978000, 2097152, PROT_NONE) = 0
mmap(0x7f2a72b78000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c0000) = 0x7f2a72b78000
mmap(0x7f2a72b7e000, 14752, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f2a72b7e000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libpcre.so.3", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\25\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=456632, ...}) = 0
mmap(NULL, 2552072, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f2a72548000
mprotect(0x7f2a725b6000, 2097152, PROT_NONE) = 0
mmap(0x7f2a727b6000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6e000) = 0x7f2a727b6000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\r\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=14608, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f2a72fb0000
mmap(NULL, 2109680, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f2a72344000
mprotect(0x7f2a72347000, 2093056, PROT_NONE) = 0
mmap(0x7f2a72546000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f2a72546000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260`\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=138696, ...}) = 0
mmap(NULL, 2212904, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f2a72127000
mprotect(0x7f2a7213f000, 2093056, PROT_NONE) = 0
mmap(0x7f2a7233e000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x7f2a7233e000
mmap(0x7f2a72340000, 13352, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f2a72340000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f2a72faf000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f2a72fad000
arch_prctl(ARCH_SET_FS, 0x7f2a72fad800) = 0
mprotect(0x7f2a72b78000, 16384, PROT_READ) = 0
mprotect(0x7f2a7233e000, 4096, PROT_READ) = 0
mprotect(0x7f2a72546000, 4096, PROT_READ) = 0
mprotect(0x7f2a727b6000, 4096, PROT_READ) = 0
mprotect(0x7f2a72da0000, 4096, PROT_READ) = 0
mprotect(0x61d000, 4096, PROT_READ)     = 0
mprotect(0x7f2a72fc9000, 4096, PROT_READ) = 0
munmap(0x7f2a72fb2000, 90859)           = 0
set_tid_address(0x7f2a72fadad0)         = 1148
set_robust_list(0x7f2a72fadae0, 24)     = 0
rt_sigaction(SIGRTMIN, {0x7f2a7212cb50, [], SA_RESTORER|SA_SIGINFO,
0x7f2a72138390}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x7f2a7212cbe0, [],
SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7f2a72138390}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
statfs("/sys/fs/selinux", 0x7ffcfd335e40) = -1 ENOENT (No such file or
directory)
statfs("/selinux", 0x7ffcfd335e40)      = -1 ENOENT (No such file or directory)
brk(NULL)                               = 0x1291000
brk(0x12b2000)                          = 0x12b2000
open("/proc/filesystems", O_RDONLY)     = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
read(3, "nodev\tsysfs\nnodev\trootfs\nnodev\tr"..., 1024) = 372
read(3, "", 1024)                       = 0
close(3)                                = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=4759040, ...}) = 0
mmap(NULL, 4759040, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f2a71c9d000
close(3)                                = 0
ioctl(1, TCGETS, {B38400 opost isig icanon echo ...}) = 0
ioctl(1, TIOCGWINSZ, {ws_row=43, ws_col=127, ws_xpixel=0, ws_ypixel=0}) = 0
stat("654e8c3827c816a6b69ee887b45182003dce24b75b4325ba02ecab5d70d7a7c2/merged/usr/lib/libisis.so",
{st_mode=S_IFLNK|0777, st_size=18, ...}) = 0
lstat("654e8c3827c816a6b69ee887b45182003dce24b75b4325ba02ecab5d70d7a7c2/merged/usr/lib/libisis.so",
{st_mode=S_IFLNK|0777, st_size=18, ...}) = 0
fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 8), ...}) = 0
write(1, "654e8c3827c816a6b69ee887b4518200"..., 91) = 91
close(1)                                = 0
close(2)                                = 0
exit_group(0)                           = ?
+++ exited with 0 +++



root:/var/lib/docker/overlay2# strace stat  654.../merged/usr/lib/libisis.so
execve("/usr/bin/stat", ["stat",
"654e8c3827c816a6b69ee887b4518200"...], [/* 31 vars */]) = 0
brk(NULL)                               = 0x12a3000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=90859, ...}) = 0
mmap(NULL, 90859, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f49839f8000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libselinux.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260Z\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=130224, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f49839f7000
mmap(NULL, 2234080, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f49835c8000
mprotect(0x7f49835e7000, 2093056, PROT_NONE) = 0
mmap(0x7f49837e6000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1e000) = 0x7f49837e6000
mmap(0x7f49837e8000, 5856, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f49837e8000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0P\t\2\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1868984, ...}) = 0
mmap(NULL, 3971488, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f49831fe000
mprotect(0x7f49833be000, 2097152, PROT_NONE) = 0
mmap(0x7f49835be000, 24576, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x1c0000) = 0x7f49835be000
mmap(0x7f49835c4000, 14752, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f49835c4000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libpcre.so.3", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0000\25\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=456632, ...}) = 0
mmap(NULL, 2552072, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f4982f8e000
mprotect(0x7f4982ffc000, 2097152, PROT_NONE) = 0
mmap(0x7f49831fc000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6e000) = 0x7f49831fc000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libdl.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\240\r\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=14608, ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f49839f6000
mmap(NULL, 2109680, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f4982d8a000
mprotect(0x7f4982d8d000, 2093056, PROT_NONE) = 0
mmap(0x7f4982f8c000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0x7f4982f8c000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libpthread.so.0", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260`\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=138696, ...}) = 0
mmap(NULL, 2212904, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f4982b6d000
mprotect(0x7f4982b85000, 2093056, PROT_NONE) = 0
mmap(0x7f4982d84000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x17000) = 0x7f4982d84000
mmap(0x7f4982d86000, 13352, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f4982d86000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f49839f5000
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f49839f3000
arch_prctl(ARCH_SET_FS, 0x7f49839f3800) = 0
mprotect(0x7f49835be000, 16384, PROT_READ) = 0
mprotect(0x7f4982d84000, 4096, PROT_READ) = 0
mprotect(0x7f4982f8c000, 4096, PROT_READ) = 0
mprotect(0x7f49831fc000, 4096, PROT_READ) = 0
mprotect(0x7f49837e6000, 4096, PROT_READ) = 0
mprotect(0x612000, 4096, PROT_READ)     = 0
mprotect(0x7f4983a0f000, 4096, PROT_READ) = 0
munmap(0x7f49839f8000, 90859)           = 0
set_tid_address(0x7f49839f3ad0)         = 1229
set_robust_list(0x7f49839f3ae0, 24)     = 0
rt_sigaction(SIGRTMIN, {0x7f4982b72b50, [], SA_RESTORER|SA_SIGINFO,
0x7f4982b7e390}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {0x7f4982b72be0, [],
SA_RESTORER|SA_RESTART|SA_SIGINFO, 0x7f4982b7e390}, NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
getrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM64_INFINITY}) = 0
statfs("/sys/fs/selinux", 0x7ffd25cdd420) = -1 ENOENT (No such file or
directory)
statfs("/selinux", 0x7ffd25cdd420)      = -1 ENOENT (No such file or directory)
brk(NULL)                               = 0x12a3000
brk(0x12c4000)                          = 0x12c4000
open("/proc/filesystems", O_RDONLY)     = 3
fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
read(3, "nodev\tsysfs\nnodev\trootfs\nnodev\tr"..., 1024) = 372
read(3, "", 1024)                       = 0
close(3)                                = 0
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=4759040, ...}) = 0
mmap(NULL, 4759040, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f49826e3000
close(3)                                = 0
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2995, ...}) = 0
read(3, "# Locale name alias data base.\n#"..., 4096) = 2995
read(3, "", 4096)                       = 0
close(3)                                = 0
open("/usr/share/locale/en_US.UTF-8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/coreutils.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en.UTF-8/LC_MESSAGES/coreutils.mo", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/coreutils.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/coreutils.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US.UTF-8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US.utf8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en.UTF-8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en.utf8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en/LC_MESSAGES/coreutils.mo", O_RDONLY) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=619, ...}) = 0
mmap(NULL, 619, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f4983a0e000
close(3)                                = 0
lstat("654e8c3827c816a6b69ee887b45182003dce24b75b4325ba02ecab5d70d7a7c2/merged/usr/lib/libisis.so",
{st_mode=S_IFLNK|0777, st_size=18, ...}) = 0
fstat(1, {st_mode=S_IFCHR|0600, st_rdev=makedev(136, 8), ...}) = 0
readlink("654e8c3827c816a6b69ee887b45182003dce24b75b4325ba02ecab5d70d7a7c2/merged/usr/lib/libisis.so",
0x12a4f80, 19) = -1 EINVAL (Invalid argument)
write(1, "  File: '654e8c3827c816a6b69ee88"..., 100) = 100
write(2, "stat: ", 6stat: )                   = 6
write(2, "cannot read symbolic link '654e8"..., 118cannot read
symbolic link '654e8c3827c816a6b69ee887b45182003dce24b75b4325ba02ecab5d70d7a7c2/merged/usr/lib/libisis.so')
= 118
open("/usr/share/locale/en_US.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US.utf8/LC_MESSAGES/libc.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
open("/usr/share/locale/en_US/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en.UTF-8/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
open("/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY) = -1 ENOENT
(No such file or directory)
open("/usr/share/locale-langpack/en_US.UTF-8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US.utf8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en_US/LC_MESSAGES/libc.mo", O_RDONLY)
= -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en.UTF-8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en.utf8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
open("/usr/share/locale-langpack/en/LC_MESSAGES/libc.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
write(2, ": Invalid argument", 18: Invalid argument)      = 18
write(2, "\n", 1
)                       = 1
write(1, "\n", 1)                       = 1
write(1, "  Size: 18        \tBlocks: 0    "..., 69) = 69
write(1, "Device: 801h/2049d\tInode: 278558"..., 47) = 47
socket(PF_LOCAL, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_LOCAL, sun_path="/var/run/nscd/socket"}, 110)
= -1 ENOENT (No such file or directory)
close(3)                                = 0
socket(PF_LOCAL, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_LOCAL, sun_path="/var/run/nscd/socket"}, 110)
= -1 ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/nsswitch.conf", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=529, ...}) = 0
read(3, "# /etc/nsswitch.conf\n#\n# Example"..., 4096) = 529
read(3, "", 4096)                       = 0
close(3)                                = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=90859, ...}) = 0
mmap(NULL, 90859, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f49839dc000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libnss_compat.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\320\22\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=35688, ...}) = 0
mmap(NULL, 2131040, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f49824da000
mprotect(0x7f49824e2000, 2093056, PROT_NONE) = 0
mmap(0x7f49826e1000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x7000) = 0x7f49826e1000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libnsl.so.1", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\360?\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=93128, ...}) = 0
mmap(NULL, 2198104, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f49822c1000
mprotect(0x7f49822d7000, 2093056, PROT_NONE) = 0
mmap(0x7f49824d6000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x15000) = 0x7f49824d6000
mmap(0x7f49824d8000, 6744, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f49824d8000
close(3)                                = 0
mprotect(0x7f49824d6000, 4096, PROT_READ) = 0
mprotect(0x7f49826e1000, 4096, PROT_READ) = 0
munmap(0x7f49839dc000, 90859)           = 0
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=90859, ...}) = 0
mmap(NULL, 90859, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f49839dc000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libnss_nis.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260
\0\0\0\0\0\0"..., 832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=47648, ...}) = 0
mmap(NULL, 2143624, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f49820b5000
mprotect(0x7f49820c0000, 2093056, PROT_NONE) = 0
mmap(0x7f49822bf000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xa000) = 0x7f49822bf000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/x86_64-linux-gnu/libnss_files.so.2", O_RDONLY|O_CLOEXEC) = 3
read(3, "\177ELF\2\1\1\0\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260!\0\0\0\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0644, st_size=47600, ...}) = 0
mmap(NULL, 2168600, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0x7f4981ea3000
mprotect(0x7f4981eae000, 2093056, PROT_NONE) = 0
mmap(0x7f49820ad000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0xa000) = 0x7f49820ad000
mmap(0x7f49820af000, 22296, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f49820af000
close(3)                                = 0
mprotect(0x7f49820ad000, 4096, PROT_READ) = 0
mprotect(0x7f49822bf000, 4096, PROT_READ) = 0
munmap(0x7f49839dc000, 90859)           = 0
open("/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
lseek(3, 0, SEEK_CUR)                   = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=2341, ...}) = 0
mmap(NULL, 2341, PROT_READ, MAP_SHARED, 3, 0) = 0x7f4983a0d000
lseek(3, 2341, SEEK_SET)                = 2341
munmap(0x7f4983a0d000, 2341)            = 0
close(3)                                = 0
socket(PF_LOCAL, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_LOCAL, sun_path="/var/run/nscd/socket"}, 110)
= -1 ENOENT (No such file or directory)
close(3)                                = 0
socket(PF_LOCAL, SOCK_STREAM|SOCK_CLOEXEC|SOCK_NONBLOCK, 0) = 3
connect(3, {sa_family=AF_LOCAL, sun_path="/var/run/nscd/socket"}, 110)
= -1 ENOENT (No such file or directory)
close(3)                                = 0
open("/etc/group", O_RDONLY|O_CLOEXEC)  = 3
lseek(3, 0, SEEK_CUR)                   = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=1016, ...}) = 0
mmap(NULL, 1016, PROT_READ, MAP_SHARED, 3, 0) = 0x7f4983a0d000
lseek(3, 1016, SEEK_SET)                = 1016
munmap(0x7f4983a0d000, 1016)            = 0
close(3)                                = 0
write(1, "Access: (0777/lrwxrwxrwx)  Uid: "..., 73) = 73
open("/etc/localtime", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=554, ...}) = 0
fstat(3, {st_mode=S_IFREG|0644, st_size=554, ...}) = 0
read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\3\0\0\0\3\0\0\0\0"...,
4096) = 554
lseek(3, -339, SEEK_CUR)                = 215
read(3, "TZif2\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\3\0\0\0\3\0\0\0\0"...,
4096) = 339
close(3)                                = 0
write(1, "Access: 2019-03-28 14:44:38.6214"..., 44) = 44
stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=554, ...}) = 0
write(1, "Modify: 2019-03-25 16:36:59.8200"..., 44) = 44
stat("/etc/localtime", {st_mode=S_IFREG|0644, st_size=554, ...}) = 0
write(1, "Change: 2019-03-25 16:36:59.8200"..., 44) = 44
write(1, " Birth: -\n", 10)             = 10
close(1)                                = 0
close(2)                                = 0
exit_group(1)                           = ?
+++ exited with 1 +++

On Fri, Mar 29, 2019 at 10:26 AM koishi komeiji <maykagura@gmail.com> wrote:
>
> 1.Which fs is this on?
> the fs on diff/ is ext2/ext3, the fs on merged/ is  overlayfs.
>
> root:/var/lib/docker/overlay2# stat -f  dd9.../diff/usr/lib/libscheduler.so
>   File: "dd9.../diff/usr/lib/libscheduler.so"
>     ID: c31f80297c8e8883 Namelen: 255     Type: ext2/ext3
> Block size: 4096       Fundamental block size: 4096
> Blocks: Total: 21641822   Free: 14040944   Available: 12935844
> Inodes: Total: 5505024    Free: 4977146
>
> root:/var/lib/docker/overlay2# stat -f dd9.../merged/usr/lib/libscheduler.so
>   File: "dd9.../merged/usr/lib/libscheduler.so"
>     ID: c31f80297c8e8883 Namelen: 255     Type: overlayfs
> Block size: 4096       Fundamental block size: 4096
> Blocks: Total: 21641822   Free: 14040942   Available: 12935842
> Inodes: Total: 5505024    Free: 4977146
>
>
> 2.Do you know if the symlink was just recently created or if it existed before
> container has been started?
> the symlink is existed before container has been started,but it is
> compressed in the image.After the container run, it is decompressed in
> /usr/lib.
> so the upperdir(diff/) has the symlink while the lowerdir doesnot have.
>
> bash-4.2# mount  | grep overlay
> overlay on / type overlay
> (rw,noatime,lowerdir=/var/lib/docker/overlay2/l/PVL6K62ZQQT3UNPFRH3GW4XAAU:/var/lib/docker/overlay2/l/D7RVPB765GILGJYUU4XSKOXWFF,upperdir=/var/lib/docker/overlay2/dd9.../diff,workdir=/var/lib/docker/overlay2/dd9.../work)
>
> root:/var/lib/docker/overlay2# find . -name "libscheduler.so"
> ./dd9.../diff/usr/lib/libscheduler.so
> ./dd9.../merged/usr/lib/libscheduler.so
>
> 3.I imagine that if you restart container or just drop caches problem
> goes away, but if problem still persists,
> I cannot restart the container,for it is not mine.It is using by other tester.
>
> 4.Can you try to 'cat' the file under 'diff' folder?
> If I cat the file under 'diff' folder.It shows ok without error.It
> would show the file that the symlink links to.
>
> 5.Please record strace from failures (e.g. of cat, stat, ls, readlink).
> the strace record is too long. the important error info is as following:
> open("dd9.../merged/usr/lib/libscheduler.so", O_RDONLY) = -1 ELOOP
> (Too many levels of symbolic links)
> readlink("dd9.../merged/usr/lib/libscheduler.so", 0x7ffff35d3690,
> 8191) = -1 EINVAL (Invalid argument)
>
>
>  I will paste strace record in the next mail.Thanks for your addvice!
>
> On Wed, Mar 27, 2019 at 8:09 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Mar 27, 2019 at 4:44 AM koishi komeiji <maykagura@gmail.com> wrote:
> > >
> > > Hello.I met a bug about overlayfs again. I run a container by docker .
> > > In the container, a symbolic link has been broken.I switch to host,
> > > and find the broken file in /var/lib/docker.   I find 2 file that one
> > > is in /var/lib/docker/overlay2/e3.../merged and another one is in
> > > /var/lib/docker/overlay2/e3.../diff.
> > > The directory of /var/lib/docker/overlay2/e3.../merged is mounted on
> > > overlay fs. The 2 file have same inode. I think this means they are
> > > the same file. The file in /var/lib/docker/overlay2/e3.../diff is ok.
> > > But the file in /var/lib/docker/overlay2/e3.../merged is broken.
> > > I doubt this is a bug of overlayfs.
> > >
> > > root:/var/lib/docker# df -h
> > > Filesystem      Size  Used Avail Use% Mounted on
> > > /dev/sda1        83G   29G   50G  38% /
> > > overlay          83G   29G   50G  38% /var/lib/docker/overlay2/e3ed8.../merged
> > > ...
> > >
> > >
> > > root:/var/lib/docker# find . -name "libdrv_ip6proen.so"
> > > ./overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so
> > > ./overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
> > >
> > >
> > > root:/var/lib/docker# cat overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
> > > cat: overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so: Too many
> > > levels of symbolic links
> > >
> > > root:/var/lib/docker# ls -li overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
> > > ls: cannot read symbolic link
> > > 'overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so': Invalid
> > > argument
> > > 3038490 lrwxrwxrwx 1 root root 26 3 25 16:24
> > > overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
> > >
> > > root:/var/lib/docker# ls -li overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so
> > > 3038490 lrwxrwxrwx 1 root root 26 3 25 16:24
> > > overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so ->
> > > libdrv_ip6proen.so.0.0.0.4
> > >
> > >
> > >
> > >
> > > root:/var/lib/docker# stat overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so
> > >   File: 'overlay2/e3ed8.../diff/usr/lib/libdrv_ip6proen.so' ->
> > > 'libdrv_ip6proen.so.0.0.0.4'
> > >   Size: 26              Blocks: 0          IO Block: 4096   symbolic link
> > > Device: 801h/2049d      Inode: 3038490     Links: 1
> > > Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
> > > Access: 2019-03-26 16:38:47.588388845 +0800
> > > Modify: 2019-03-25 16:24:05.536041935 +0800
> > > Change: 2019-03-25 16:24:05.536041935 +0800
> > >  Birth: -
> > >
> > >
> > > root:/var/lib/docker# stat overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so
> > >   File: 'overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so'stat:
> > > cannot read symbolic link
> > > 'overlay2/e3ed8.../merged/usr/lib/libdrv_ip6proen.so': Invalid
> > > argument
> > >
> > >   Size: 26              Blocks: 0          IO Block: 4096   symbolic link
> > > Device: 801h/2049d      Inode: 3038490     Links: 1
> > > Access: (0777/lrwxrwxrwx)  Uid: (    0/    root)   Gid: (    0/    root)
> > > Access: 2019-03-26 16:38:47.588388845 +0800
> > > Modify: 2019-03-25 16:24:05.536041935 +0800
> > > Change: 2019-03-25 16:24:05.536041935 +0800
> > >  Birth: -
> > >
> > >
> > >
> > > root:/var/lib/docker# uname -a
> > > Linux z15572-virtual-machine 4.9.29 #1 SMP Tue Oct 16 22:13:48 CST
> > > 2018 x86_64 x86_64 x86_64 GNU/Linux
> > >
> > > root:/var/lib/docker# cat /etc/os-release
> > > NAME="Ubuntu"
> > > VERSION="16.04.5 LTS (Xenial Xerus)"
> > > ID=ubuntu
> > > ID_LIKE=debian
> > > PRETTY_NAME="Ubuntu 16.04.5 LTS"
> > > VERSION_ID="16.04"
> > > HOME_URL="http://www.ubuntu.com/"
> > > SUPPORT_URL="http://help.ubuntu.com/"
> > > BUG_REPORT_URL="http://bugs.launchpad.net/ubuntu/"
> > > VERSION_CODENAME=xenial
> > > UBUNTU_CODENAME=xenial
> >
> > Which fs is this on?
> > Please cat /proc/mountinfo from host.
> >
> > Do you know if the symlink was just recently created or if it existed before
> > container has been started?
> >
> > I imagine that if you restart container or just drop caches problem
> > goes away, but if problem still persists, please keep container up
> > maybe Miklos will have more ideas for things to check.
> >
> > If seems that stat(2) works correctly, but readlink(2) return -EINVAL.
> > Why does readlink(2) work for upper inode and no for overlay inode?
> > The only reason I can think of is that somehow d_is_symlink(dentry)
> > in vfs_get_link() is false, but not sure how that can come to be.
> >
> > Another clue is that open(2) (i.e. from cat) returns -ELOOP, which
> > seem to also hint that maybe should_follow_link() sees false
> > d_is_symlink(dentry) and open tries to open the symlink inode
> > itself.
> > Can you try to 'cat' the file under 'diff' folder?
> > Please record strace from failures (e.g. of cat, stat, ls, readlink).
> >
> > Thanks,
> > Amir.
