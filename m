From: sa <sa-dev@rainbow.by>
Subject: Re: [PATCH 0/2] ovl: support NFS as lower layer
Date: Sun, 28 Jun 2015 17:38:35 +0300
Message-ID: <559006EB.605@rainbow.by>
References: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mgate.rtcs.ru ([188.127.242.169]:33735 "EHLO mail.rainbow.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752434AbbF1Onm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 28 Jun 2015 10:43:42 -0400
In-Reply-To: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

On 04.06.2015 16:29, Miklos Szeredi wrote:

> Two small patches implementing this follow.  Comments and testing wel=
come.
>    git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git ove=
rlayfs-next
> ---
>   fs/overlayfs/super.c | 81 +++++++++++++++++++++++++++++++++++++++++=
++++++-----
>   1 file changed, 74 insertions(+), 7 deletions(-)

Thank you, it works in our environment mostly as expected, except
of the following:
files already existing in readonly NFS lowerdir can't be opened
for writing (but can be deleted). Newly created files are writable
as expected. The same lowerdir works with aufs without problem.
Is it a bug or am I missing something?


(sid)root@usbsid:/var# ls -l test
-rw-r--r-- 1 root root 6 =D0=B8=D1=8E=D0=BD 28 17:01 test

(sid)root@usbsid:/var# cat test
00000

(sid)root@usbsid:/var# strace -e trace=3Dopen sh -c 'echo 11111 > test'
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
open("/lib/i386-linux-gnu/i686/cmov/libc.so.6", O_RDONLY|O_CLOEXEC) =3D=
 3
open("test", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) =3D -1 EACCES=20
(Permission denied)
sh: 1: cannot create test: Permission denied
+++ exited with 2 +++

(sid)root@usbsid:/var# strace -e trace=3Dopen sh -c 'echo 11111 >> test=
'
open("/etc/ld.so.cache", O_RDONLY|O_CLOEXEC) =3D 3
open("/lib/i386-linux-gnu/i686/cmov/libc.so.6", O_RDONLY|O_CLOEXEC) =3D=
 3
open("test", O_WRONLY|O_CREAT|O_APPEND|O_LARGEFILE, 0666) =3D -1 EACCES=
=20
(Permission denied)
sh: 1: cannot create test: Permission denied
+++ exited with 2 +++

(sid)root@usbsid:/var# mount | grep var
tmpfs on /var/lock type tmpfs (rw,nosuid,nodev,noexec,relatime,size=3D5=
120k)
192.168.211.140:/sid/var on /auvar.ro type nfs=20
(ro,relatime,vers=3D3,rsize=3D524288,wsize=3D524288,namlen=3D255,hard,n=
olock,proto=3Dtcp,port=3D2049,timeo=3D7,retrans=3D10,sec=3Dsys,local_lo=
ck=3Dall,addr=3D192.168.211.140)
tmpfs on /auvar.ro/lock type tmpfs=20
(rw,nosuid,nodev,noexec,relatime,size=3D5120k)
none on /auvar.rw type tmpfs (rw,relatime)
overlay on /var type overlay=20
(rw,relatime,lowerdir=3D/auvar.ro,upperdir=3D/auvar.rw/.upperdir,workdi=
r=3D/auvar.rw/.workdir)

(sid)root@usbsid:/var# uname -r
4.1.0+

user@buildhost:/build/kernel/4 (overlayfs-next)$ git rev-parse HEAD
cdb672795876d7bc1870aed9a2d7cb59f43d1d96


--=20
sa
