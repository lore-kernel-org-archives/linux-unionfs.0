Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 773D0C433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 30 Nov 2021 05:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbhK3FwI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 30 Nov 2021 00:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbhK3FwH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 Nov 2021 00:52:07 -0500
Received: from mail-vk1-xa2f.google.com (mail-vk1-xa2f.google.com [IPv6:2607:f8b0:4864:20::a2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B785C061574
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Nov 2021 21:48:49 -0800 (PST)
Received: by mail-vk1-xa2f.google.com with SMTP id m16so11824813vkl.13
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Nov 2021 21:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nextdayvideo-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=lmyUUTtEPApvuiop98acycwPcEbk1FVZqdXPNp/OU20=;
        b=2bA+oH6TCCl6/20BwemckTrS4i20tVV0yhMdxmHWbbOpof0ZKOFYrCMcnATjEYAMA6
         rOgPtTkyQnVUAGjXY+IEwGxv1iDOiL4prHvFsMWwllt7WzdYGG0kVJ3eZbCvBChjR8uN
         CLeTA7zZA+omrE0dEAyeYK117UXfUball7+FVFgrjjq/m9gFn33eWO1SL6FSIRwtvJS7
         GP/RvM+lQZWnRT7S5fGB8Psy/3xKXW7MLaoeUf57dlvab57geE9ylJbMYOZ2W8E9q4ZY
         gPWyZ4loSapWhs3jeizwnYN5vmNI3K9LudZF7j/6vKNkjo4hwrbtwjD7d2LMkoBgayJ4
         E7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lmyUUTtEPApvuiop98acycwPcEbk1FVZqdXPNp/OU20=;
        b=BP9B6czFNl9oe54vJ08rR7Tnr1hMnVCzUeVlKBIVLpwcjAwdb8w33J3D1nEKLbBd2s
         x/yZ1pRHJxvFgfwaXR36zVJ4kNt/fEse0ghpGKJhRm7SLUtJqdQ1QNVVCsaf9ydksQp8
         Mc4UcYaqw7TeQUdmXztcNn5cSLscPK1cPlnkKbKgwQPc0RmASUEP5H1n2CGS7oLUgL4f
         yEi92/HFRrbI0MT+2qLE4h5Uu0+TYfRBulnpFQg5GgJMEpXb0sAY+WsdWX1s8Rj6foA5
         r1+AwQacVxbRBbKQuaJaHaYjrw70gyFkmstKPcX0DlW/L7uShARudBbf0rvZQl68hEyR
         28Rw==
X-Gm-Message-State: AOAM530mbBv0Ow/Ee/SC5RqrmKJq4VF2nasx8pGNo0QIuKApCIGS31sC
        oTOH1A7qja4jUm0vGmBoqxsLAwT/IGTMHeNJ5Lg6sBwf5x0=
X-Google-Smtp-Source: ABdhPJx+z1JP5l0UM7RG2hyy+BjqK+gIZCjHMf5cDsaZd317S4bxz0yOAUM7I9xR1PxtS5+k3JTbymm9RNRq3xBr0TM=
X-Received: by 2002:a05:6122:78c:: with SMTP id k12mr42954488vkr.22.1638251327636;
 Mon, 29 Nov 2021 21:48:47 -0800 (PST)
MIME-Version: 1.0
From:   Carl Karsten <carl@nextdayvideo.com>
Date:   Mon, 29 Nov 2021 21:48:21 -0800
Message-ID: <CADmzSSh7P+T78nuKxgK4mjOMMPO6AZmtYBFw+uu4UuE_K5FWCA@mail.gmail.com>
Subject: index=on,nfs_export=on Operation not permitted
To:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

I don't need any help, This seems odd enough to report.

I accidentally  built my nfs server on buster, which threw some errors
about index=on, so I added index=on.  Then I rebuilt the server on
bullseye, and almost everything was the same, except for 1 little
thing.  I removed the index=on, and all was well again.

server:
dist=bullseye
d=/srv/nfs/rpi/${dist}
p=${d}/boot
rm -rf ${p}/work/index
mount -t overlay overlay -o index=on,nfs_export=on,\
lowerdir=${p}/setup:${p}/base,\
upperdir=${p}/updates,\
workdir=${p}/work \
    ${p}/merged

/etc/exports
/srv/nfs/rpi/bullseye/boot/merged
*(rw,sync,no_subtree_check,no_root_squash,fsid=1)


client:
root@raspberrypi:~# mount
10.21.0.1:/srv/nfs/rpi/bullseye/root/merged on / type nfs
(rw,relatime,vers=3,rsize=4096,wsize=4096,namlen=255,hard,nolock,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=10.21.0.1,mountvers=3,mountproto=tcp,local_lock=all,addr=10.21.0.1)

root@raspberrypi:~# mv /boot/z /boot/config.txt
mv: cannot move '/boot/z' to '/boot/config.txt': Operation not permitted

root@raspberrypi:~# strace mv /boot/z /boot/config.txt
execve("/usr/bin/mv", ["mv", "/boot/z", "/boot/config.txt"],
0xffd9caa8 /* 18 vars */) = 0
brk(NULL)                               = 0x1541000
uname({sysname="Linux", nodename="raspberrypi", ...}) = 0
access("/etc/ld.so.preload", R_OK)      = 0
openat(AT_FDCWD, "/etc/ld.so.preload", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=54, ...}) = 0
mmap2(NULL, 54, PROT_READ|PROT_WRITE, MAP_PRIVATE, 3, 0) = 0xf7cb7000
close(3)                                = 0
readlink("/proc/self/exe", "/usr/bin/mv", 4096) = 11
openat(AT_FDCWD, "/usr/lib/arm-linux-gnueabihf/libarmmem-v8l.so",
O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\254\3\0\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=17708, ...}) = 0
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xf7cb5000
mmap2(NULL, 81964, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xf7c72000
mprotect(0xf7c76000, 61440, PROT_NONE)  = 0
mmap2(0xf7c85000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0xf7c85000
close(3)                                = 0
munmap(0xf7cb7000, 54)                  = 0
openat(AT_FDCWD, "/etc/ld.so.cache", O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=28423, ...}) = 0
mmap2(NULL, 28423, PROT_READ, MAP_PRIVATE, 3, 0) = 0xf7cae000
close(3)                                = 0
openat(AT_FDCWD, "/lib/arm-linux-gnueabihf/libselinux.so.1",
O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\20R\0\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=144896, ...}) = 0
mmap2(NULL, 216100, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xf7c3d000
mprotect(0xf7c60000, 61440, PROT_NONE)  = 0
mmap2(0xf7c6f000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x22000) = 0xf7c6f000
mmap2(0xf7c71000, 3108, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xf7c71000
close(3)                                = 0
openat(AT_FDCWD, "/lib/arm-linux-gnueabihf/libacl.so.1",
O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\0\23\0\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=30052, ...}) = 0
mmap2(NULL, 94276, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xf7c25000
mprotect(0xf7c2b000, 65536, PROT_NONE)  = 0
mmap2(0xf7c3b000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x6000) = 0xf7c3b000
close(3)                                = 0
openat(AT_FDCWD, "/lib/arm-linux-gnueabihf/libattr.so.1",
O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0
\16\0\0004\0\0\0"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=17724, ...}) = 0
mmap2(NULL, 81932, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xf7c10000
mprotect(0xf7c14000, 61440, PROT_NONE)  = 0
mmap2(0xf7c23000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x3000) = 0xf7c23000
close(3)                                = 0
openat(AT_FDCWD, "/lib/arm-linux-gnueabihf/libc.so.6",
O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\240\255\1\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1321488, ...}) = 0
mmap2(NULL, 1390760, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE,
3, 0) = 0xf7abc000
mprotect(0xf7bfb000, 61440, PROT_NONE)  = 0
mmap2(0xf7c0a000, 16384, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x13e000) = 0xf7c0a000
mmap2(0xf7c0e000, 6312, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xf7c0e000
close(3)                                = 0
openat(AT_FDCWD, "/lib/arm-linux-gnueabihf/libpcre2-8.so.0",
O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\220\31\0\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=563040, ...}) = 0
mmap2(NULL, 627292, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xf7a22000
mprotect(0xf7aab000, 61440, PROT_NONE)  = 0
mmap2(0xf7aba000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x88000) = 0xf7aba000
close(3)                                = 0
openat(AT_FDCWD, "/lib/arm-linux-gnueabihf/libdl.so.2",
O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0\330\v\0\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=13864, ...}) = 0
mmap2(NULL, 78020, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xf7a0e000
mprotect(0xf7a11000, 61440, PROT_NONE)  = 0
mmap2(0xf7a20000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x2000) = 0xf7a20000
close(3)                                = 0
openat(AT_FDCWD, "/lib/arm-linux-gnueabihf/libpthread.so.0",
O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0t]\0\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=137364, ...}) = 0
mmap2(NULL, 176728, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3,
0) = 0xf79e2000
mprotect(0xf79fa000, 65536, PROT_NONE)  = 0
mmap2(0xf7a0a000, 8192, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x18000) = 0xf7a0a000
mmap2(0xf7a0c000, 4696, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xf7a0c000
close(3)                                = 0
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xf7cac000
set_tls(0xf7cac700)                     = 0
mprotect(0xf7c0a000, 8192, PROT_READ)   = 0
mprotect(0xf7a0a000, 4096, PROT_READ)   = 0
mprotect(0xf7a20000, 4096, PROT_READ)   = 0
mprotect(0xf7aba000, 4096, PROT_READ)   = 0
mprotect(0xf7c23000, 4096, PROT_READ)   = 0
mprotect(0xf7c3b000, 4096, PROT_READ)   = 0
mprotect(0xf7c6f000, 4096, PROT_READ)   = 0
mprotect(0xf7c85000, 4096, PROT_READ)   = 0
mprotect(0x3a000, 4096, PROT_READ)      = 0
mprotect(0xf7cb9000, 4096, PROT_READ)   = 0
munmap(0xf7cae000, 28423)               = 0
set_tid_address(0xf7cac2a8)             = 4282
set_robust_list(0xf7cac2b0, 12)         = 0
rt_sigaction(SIGRTMIN, {sa_handler=0xf79e76a8, sa_mask=[],
sa_flags=SA_RESTORER|SA_SIGINFO, sa_restorer=0xf7aeedb0}, NULL, 8) = 0
rt_sigaction(SIGRT_1, {sa_handler=0xf79e7764, sa_mask=[],
sa_flags=SA_RESTORER|SA_RESTART|SA_SIGINFO, sa_restorer=0xf7aeedb0},
NULL, 8) = 0
rt_sigprocmask(SIG_UNBLOCK, [RTMIN RT_1], NULL, 8) = 0
ugetrlimit(RLIMIT_STACK, {rlim_cur=8192*1024, rlim_max=RLIM_INFINITY}) = 0
statfs("/sys/fs/selinux", 0xffd111ec)   = -1 ENOENT (No such file or directory)
statfs("/selinux", 0xffd111ec)          = -1 ENOENT (No such file or directory)
brk(NULL)                               = 0x1541000
brk(0x1562000)                          = 0x1562000
openat(AT_FDCWD, "/proc/filesystems", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
read(3, "nodev\tsysfs\nnodev\ttmpfs\nnodev\tbd"..., 1024) = 370
read(3, "", 1024)                       = 0
close(3)                                = 0
access("/etc/selinux/config", F_OK)     = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/lib/locale/locale-archive",
O_RDONLY|O_LARGEFILE|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=3041504, ...}) = 0
mmap2(NULL, 2097152, PROT_READ, MAP_PRIVATE, 3, 0) = 0xf77e2000
mmap2(NULL, 2596864, PROT_READ, MAP_PRIVATE, 3, 0x6d000) = 0xf7568000
close(3)                                = 0
geteuid32()                             = 0
ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) = 0
renameat2(AT_FDCWD, "/boot/z", AT_FDCWD, "/boot/config.txt",
RENAME_NOREPLACE) = -1 EEXIST (File exists)
stat64("/boot/config.txt", {st_mode=S_IFREG|0755, st_size=2425, ...}) = 0
fstatat64(AT_FDCWD, "/boot/z", {st_mode=S_IFREG|0755, st_size=2425,
...}, AT_SYMLINK_NOFOLLOW) = 0
fstatat64(AT_FDCWD, "/boot/config.txt", {st_mode=S_IFREG|0755,
st_size=2425, ...}, AT_SYMLINK_NOFOLLOW) = 0
geteuid32()                             = 0
rename("/boot/z", "/boot/config.txt")   = -1 EPERM (Operation not permitted)
openat(AT_FDCWD, "/usr/share/locale/locale.alias", O_RDONLY|O_CLOEXEC) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=2996, ...}) = 0
read(3, "# Locale name alias data base.\n#"..., 4096) = 2996
read(3, "", 4096)                       = 0
close(3)                                = 0
openat(AT_FDCWD,
"/usr/share/locale/en_GB.UTF-8/LC_MESSAGES/coreutils.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
openat(AT_FDCWD,
"/usr/share/locale/en_GB.utf8/LC_MESSAGES/coreutils.mo", O_RDONLY) =
-1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en_GB/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD,
"/usr/share/locale/en.UTF-8/LC_MESSAGES/coreutils.mo", O_RDONLY) = -1
ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en.utf8/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en/LC_MESSAGES/coreutils.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
write(2, "mv: ", 4mv: )                     = 4
write(2, "cannot move '/boot/z' to '/boot/"..., 43cannot move
'/boot/z' to '/boot/config.txt') = 43
openat(AT_FDCWD, "/usr/share/locale/en_GB.UTF-8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en_GB.utf8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en_GB/LC_MESSAGES/libc.mo", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=1433, ...}) = 0
mmap2(NULL, 1433, PROT_READ, MAP_PRIVATE, 3, 0) = 0xf7cb7000
close(3)                                = 0
openat(AT_FDCWD, "/usr/share/locale/en.UTF-8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en.utf8/LC_MESSAGES/libc.mo",
O_RDONLY) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/usr/share/locale/en/LC_MESSAGES/libc.mo", O_RDONLY)
= -1 ENOENT (No such file or directory)
write(2, ": Operation not permitted", 25: Operation not permitted) = 25
write(2, "\n", 1
)                       = 1
_llseek(0, 0, 0xffd11120, SEEK_CUR)     = -1 ESPIPE (Illegal seek)
close(0)                                = 0
close(1)                                = 0
close(2)                                = 0
exit_group(1)                           = ?
+++ exited with 1 +++



-- 
Carl K
