From: =?iso-8859-2?b?VmFyZ2926O1r?= Pavol <xvargo01@stud.fit.vutbr.cz>
Subject: Operation not permitted when removing file in stacked overlayfs
Date: Tue, 11 Oct 2016 15:34:37 +0200
Message-ID: <20161011153437.460515c6wphl8p65@email.fit.vutbr.cz>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-2;
 DelSp="Yes";
 format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from eva.fit.vutbr.cz ([147.229.176.14]:45605 "EHLO eva.fit.vutbr.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751537AbcJKNsJ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Oct 2016 09:48:09 -0400
Received: from fit.vutbr.cz (hermina.fit.vutbr.cz [147.229.9.15])
        by eva.fit.vutbr.cz (8.15.2/8.15.2) with ESMTP id u9BDYbes017873
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Oct 2016 15:34:38 +0200 (CEST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

I cannot remove any file in stacked overlayfs. As far as I know,  
two-layer stacking should work in newer kernel versions.

root ~# uname -a
Linux pallly_hp 4.7.1-1-ARCH #1 SMP PREEMPT Wed Aug 17 08:13:35 CEST  
2016 x86_64 GNU/Linux

This is the reproduction script:

#! /bin/bash

mkdir ovl-test
pushd ovl-test

mkdir -p merged overlay/{upper/{merged,overlay/{upper,work}},work} lower/lower
touch lower/lower/foo

tree

mount -t overlay -o  
lowerdir=lower,upperdir=overlay/upper,workdir=overlay/work overlay  
merged

tree

cd merged
mount -t overlay -o  
lowerdir=lower,upperdir=overlay/upper,workdir=overlay/work overlay  
merged

tree

strace rm merged/foo > /tmp/out

popd
umount ovl-test/merged{/merged,}

rm -r ovl-test

Output:

execve("/usr/bin/rm", ["rm", "merged/foo"], [/* 25 vars */]) = 0
brk(NULL)                               = 0x1d6c000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or  
directory)
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=188775, ...}) = 0
mmap(NULL, 188775, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f2dca0b6000
close(3)                                = 0
open("/usr/lib/libc.so.6", O_RDONLY|O_CLOEXEC) = 3
read(3,  
"\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0\260\3\2\0\0\0\0\0"...,  
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1951744, ...}) = 0
mmap(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,  
0) = 0x7f2dca0b4000
mmap(NULL, 3791152, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,  
0) = 0x7f2dc9b25000
mprotect(0x7f2dc9cba000, 2093056, PROT_NONE) = 0
mmap(0x7f2dc9eb9000, 24576, PROT_READ|PROT_WRITE,  
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x194000) = 0x7f2dc9eb9000
mmap(0x7f2dc9ebf000, 14640, PROT_READ|PROT_WRITE,  
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x7f2dc9ebf000
close(3)                                = 0
arch_prctl(ARCH_SET_FS, 0x7f2dca0b5480) = 0
mprotect(0x7f2dc9eb9000, 16384, PROT_READ) = 0
mprotect(0x60d000, 4096, PROT_READ)     = 0
mprotect(0x7f2dca0e5000, 4096, PROT_READ) = 0
munmap(0x7f2dca0b6000, 188775)          = 0
brk(NULL)                               = 0x1d6c000
brk(0x1d8d000)                          = 0x1d8d000
open("/usr/lib/locale/locale-archive", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=1669168, ...}) = 0
mmap(NULL, 1669168, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f2dc9f1c000
close(3)                                = 0
ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) = 0
newfstatat(AT_FDCWD, "merged/foo", {st_mode=S_IFREG|0644, st_size=0,  
...}, AT_SYMLINK_NOFOLLOW) = 0
geteuid()                               = 0
unlinkat(AT_FDCWD, "merged/foo", 0)     = -1 EPERM (Operation not permitted)
open("/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=2997, ...}) = 0
read(3, "# Locale name alias data base.\n#"..., 4096) = 2997
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
write(2, "rm: ", 4rm: )                     = 4
write(2, "cannot remove 'merged/foo'", 26cannot remove 'merged/foo') = 26
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
write(2, ": Operation not permitted", 25: Operation not permitted) = 25
write(2, "\n", 1
)                       = 1
lseek(0, 0, SEEK_CUR)                   = -1 ESPIPE (Illegal seek)
close(0)                                = 0
close(1)                                = 0
close(2)                                = 0
exit_group(1)                           = ?
+++ exited with 1 +++
