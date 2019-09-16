Return-Path: <lange@informatik.uni-koeln.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23935.36189.612024.342204@informatik.uni-koeln.de>
Date: Mon, 16 Sep 2019 15:25:49 +0200
From: lange@debian.org
Subject: can overlayfs work wit NFS v4 as lower fs?
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

I'm using overlayfs with NFS v3 as a lower (mounted read-only) and a
tmpfs as an upper filesystem. This works nicely since several years.
So I get a writeable directory tree on an nfs client even the nfs was
mounted ro.

But then I mount the lower filesystem as NFS v4 (4.2) it does not
work. Is this combination supposed to work?
I tested this with kernels up to 5.2 yet but still no success.


Here's my current test setup:

NFS server kernel 5.2.0-0.bpo.2-amd64 (Debian 10 with newer kernel)
NFS client kernel 5.2.0-0.bpo.2-amd64 (Debian 10 with newer kernel)

On the NFS server I did once
# mkdir /files/scratch/t/etc; echo test-buster > /files/scratch/t/etc/test1

/etc/exports: /files/scratch  11.22.33.128/25(async,ro,no_subtree_check,no_root_squash)

I can do more tests if you tell me what I can change.
Here are the two tests result, one using nfs v3 the other using NFS v4.

P.S.: After more research I think this may be a problem of a
      filesystem missing xattr support. Do you have any experiences
      using overlayfs using NFS v4 as lower fs?

Any hints would be appreciated.

regards Thomas






NFS v3 mount
============
Result: read and write works


+ mkdir -p /b/lower /a/upper /a/work /b/merged
+ mount -t nfs -overs=3,ro,noatime buster:/files/scratch/t /b/lower
mount -t overlay -olowerdir=$lower,upperdir=$upper,workdir=$work,default_permissions overlay $merged || exit 88
+ cat /b/merged/etc/test1
test-buster
+ sleep 3
echo "write to merged" > $merged/etc/test1
+ echo 'write to merged'
+ sleep 3
echo "write new file" > $merged/etc/test3
+ echo 'write new file'

both files test1 and test3 exists with corect content.

Here's the journalctl output of the overlayfs debug messages:
Sep 16 13:45:04 suenner kernel: overlay: mkdir(work/work, 040000) = 0
Sep 16 13:45:04 suenner kernel: overlay: tmpfile(work/work, 0100000) = 0
Sep 16 13:45:04 suenner kernel: overlay: setxattr(work/work, "trusted.overlay.opaque", "0", 1, 0x0) = 0
Sep 16 13:45:04 suenner kernel: overlay: open(00000000b7f8278e[etc/test1/l], 0100000) -> (00000000df256fc7, 0401100000)
Sep 16 13:45:07 suenner kernel: overlay: setxattr(a/upper, "trusted.overlay.impure", "y", 1, 0x0) = 0
Sep 16 13:45:07 suenner kernel: overlay: mkdir(work/#7, 040000) = 0
Sep 16 13:45:07 suenner kernel: [168B blob data]
Sep 16 13:45:07 suenner kernel: overlay: rename(work/#7, upper/etc, 0x0)
Sep 16 13:45:07 suenner kernel: overlay: setxattr(upper/etc, "trusted.overlay.impure", "y", 1, 0x0) = 0
Sep 16 13:45:07 suenner kernel: overlay: tmpfile(work/work, 0100644) = 0
Sep 16 13:45:07 suenner kernel: [174B blob data]
Sep 16 13:45:07 suenner kernel: overlay: link(work/#150994, etc/test1) = 0
Sep 16 13:45:07 suenner kernel: overlay: open(000000001998a069[etc/test1/u], 0100001) -> (0000000009d1ebd4, 0401100001)
Sep 16 13:45:10 suenner kernel: overlay: create(etc/test3, 0100666) = 0
Sep 16 13:45:10 suenner kernel: overlay: open(0000000009d1ebd4[etc/test3/u], 0100001) -> (000000001998a069, 0401100001)


The mount info
buster:/files/scratch/t on /b/lower type nfs (ro,noatime,vers=3,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=11.22.33.211,mountvers=3,mountport=45356,mountproto=udp,local_lock=none,addr=11.22.33.211)
overlay on /b/merged type overlay (rw,relatime,lowerdir=/b/lower,upperdir=/a/upper,workdir=/a/work,default_permissions)


-----------------------------------------------------------------------------------------------
NFS v4 mount
============
Result: read works, write does not work

+ mkdir -p /b/lower /a/upper /a/work /b/merged
+ mount -t nfs -oro,noatime buster:/files/scratch/t /b/lower
+ mount -t overlay -olowerdir=/b/lower,upperdir=/a/upper,workdir=/a/work,default_permissions overlay /b/merged

+ cat /b/merged/etc/test1
test-buster
+ sleep 3
echo "write to merged" > $merged/etc/test1
+ echo 'write to merged'
/home/lange/fairesearch/xfai/overlay-test: line 32: /b/merged/etc/test1: Operation not supported
+ sleep 3
echo "write new file" > $merged/etc/test3
+ echo 'write new file'
/home/lange/fairesearch/xfai/overlay-test: line 34: /b/merged/etc/test3: Operation not supported


Here's the journalctl output of the overlayfs debug messages:
Sep 16 13:40:57 suenner kernel: overlay: mkdir(work/work, 040000) = 0
Sep 16 13:40:57 suenner kernel: overlay: tmpfile(work/work, 0100000) = 0
Sep 16 13:40:57 suenner kernel: overlay: setxattr(work/work, "trusted.overlay.opaque", "0", 1, 0x0) = 0
Sep 16 13:40:57 suenner kernel: overlay: open(00000000ca5c0310[etc/test1/l], 0100000) -> (0000000023701f29, 0401100000)
Sep 16 13:41:00 suenner kernel: overlay: setxattr(a/upper, "trusted.overlay.impure", "y", 1, 0x0) = 0
Sep 16 13:41:00 suenner kernel: overlay: mkdir(work/#3, 040000) = 0
Sep 16 13:41:00 suenner kernel: overlay: rmdir(work/#3) = 0
Sep 16 13:41:03 suenner kernel: overlay: mkdir(work/#4, 040000) = 0
Sep 16 13:41:03 suenner kernel: overlay: rmdir(work/#4) = 0

The mount info:
buster:/files/scratch/t on /b/lower type nfs4 (ro,noatime,vers=4.2,rsize=1048576,wsize=1048576,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,clientaddr=11.22.33.136,local_lock=none,addr=11.22.33.211)
overlay on /b/merged type overlay (rw,relatime,lowerdir=/b/lower,upperdir=/a/upper,workdir=/a/work,default_permissions)

A manual test writing to the files using strace shows:
openat(AT_FDCWD, "/b/merged/etc/test1", O_WRONLY|O_CREAT|O_TRUNC, 0666) = -1 EOPNOTSUPP (Operation not supported)
openat(AT_FDCWD, "/b/merged/etc/test3", O_WRONLY|O_CREAT|O_TRUNC, 0666) = -1 EOPNOTSUPP (Operation not supported)
