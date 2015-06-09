From: james harvey <jamespharvey20@gmail.com>
Subject: Overlay filesystem bug with parallel reads & writes
Date: Mon, 8 Jun 2015 20:24:44 -0400
Message-ID: <CA+X5Wn5Rh4XFdWgzwTwx=PaS-0kowFe-F7PX4Hup3_qmH7i8KQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33929 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048AbbFIAYp (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 8 Jun 2015 20:24:45 -0400
Received: by lbcmx3 with SMTP id mx3so1704329lbc.1
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Jun 2015 17:24:44 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

I'm experiencing a bug that I'm pretty sure comes from the overlay
filesystem.  A lot is written about GCC below, but this is NOT a bug
about actually compiling GCC.  GCC is my bug-reproducing-testcase to
cause this bug.  I unfortunately haven't (yet) come up with a faster
manual (mkdir, touch, rm, etc) testcase.  You will see below that GCC
compiles just fine on ext4 rather than overlay.  And GCC compiles just
fine on overlay using a serial (make) build rather than a parallel
(make -j8) build.  The best I can determine is the bug has something
to do with intensive parallel interaction with the same filename --
i.e. Writing into it, executing it, erasing it (not sure if it's by
removing it, moving it, or moving its directory.)  The file only
exists in upperdir.  I'm resetting to a VM snapshot between attempts,
so the user directory is empty, and configure/make don't make any
changes to the git-given source directory.


On a fresh Fedora 22 (kernel 4.0.4-303.fc22) (netinstaller, so most up
to date packages, "Minimal Install") or a fresh Arch Linux (kernel
4.0.5-1-ARCH), running through VMWare Workstation 11.1, I experience
the following bug.

It's quite reproducible, but it varies whether it errors regarding
cc1plus or f951.

LIST 1 (gcc prerequisites and gcc source code)
===================================
Fedora: sudo dnf install wget zip tar texinfo-tex flex bison
libmpc-devel isl isl-devel ncurses-devel git gcc gcc-c++
Arch: sudo pacman -S wget zip flex bison libmpc git gcc
git clone git://gcc.gnu.org/git/gcc.git gcc.git

LIST 2 (set up overlay/chroot)
======================
sudo mkdir -p /sandbox/gcc
sudo mkdir -p /sandbox/hidden/gcc/{merged,workdir,dev.upperdir,dev.workdir,proc.upperdir,proc.workdir,sys.upperdir,sys.workdir}
sudo modprobe overlay
sudo mount -t overlay -o
lowerdir=/,upperdir=/sandbox/gcc,workdir=/sandbox/hidden/gcc/workdir
overlay /sandbox/hidden/gcc/merged
sudo mount -t overlay -o
lowerdir=/dev,upperdir=/sandbox/hidden/gcc/dev.upperdir,workdir=/sandbox/hidden/gcc/dev.workdir
overlay /sandbox/hidden/gcc/merged/dev
sudo mount -t overlay -o
lowerdir=/proc,upperdir=/sandbox/hidden/gcc/proc.upperdir,workdir=/sandbox/hidden/gcc/proc.workdir
overlay /sandbox/hidden/gcc/merged/proc
sudo mount -t overlay -o
lowerdir=/sys,upperdir=/sandbox/hidden/gcc/sys.upperdir,workdir=/sandbox/hidden/gcc/sys.workdir
overlay /sandbox/hidden/gcc/merged/sys
sudo chroot /sandbox/hidden/gcc/merged /bin/su - username

LIST 3 (configure gcc)
================
mkdir gcc.git.build
cd gcc.git.build
../gcc.git/configure --disable-multilib

Performing LIST 1-3, then "make -j8" fails, with: "xgcc: error trying
to exec 'cc1plus': execvp: No such file or directory", or the same
error on 'f951'
Performing LIST 1-3, then "make" succeeds {same as what failed, just
doing a serial build inside overlay/chroot}
Performing LIST 1, then 3, and "make -j8" succeeds {same as what
failed, just skipping overlay/chroot}

This is why I believe I'm running into an overlay filesystem bug.  I
can build gcc in parallel outside of overlay/chroot.  I can build gcc
in serial inside an overlay/chroot.  But, I cannot do both -- that is,
I cannot build gcc in parallel inside an overlay/chroot.

Building GCC this way uses a 3 stage bootstrap process: (1) build gcc
with existing c compiler; (2) re-build gcc with the version of gcc
just built; (3) repeat step 2 for verification purposes.  From what
I've gathered monitoring the complained about files during the build
process, it appears the file is built in the same location each time,
and is moved out (unsure if as an individual file or the whole
directory) for each stage.

The error occurs because although the complained about executable
(cc1plus or f951) exists, it is trying to execute before it properly
exists.  Sometimes the file complained about is zero bytes.  Sometimes
it is smaller than it would be from a successful build, lacks
executable bits, and is only recognized by the command "file" as
"data" rather than an "ELF 64-bit LSB executable".

... Guessing here, but maybe it's a parallel resource contention
issue?  Something like the final write to the executable is cached and
not yet written when something tries to execute it?
