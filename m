Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25329 "EHLO
        sender3-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726506AbfJaOHr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Oct 2019 10:07:47 -0400
Date: Thu, 31 Oct 2019 22:07:32 +0800
From: Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
Message-ID: <16e222490fd.db7c32a41966.5777637250125026331@mykernel.net>
In-Reply-To: 
Subject: Compile error of fsck.overlay on Fedora30
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
To: "yi.zhang" <yi.zhang@huawei.com>
Cc: linux-unionfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Zhangyi,

I found a compile error of fsck.overlay on my laptop(fedora 30), it looks l=
ike lacking of header in the check.c.
After manually added <sys/sysmacros.h> compile succeeded without error.

Detail info of compile error as below:

 [cgxu@localhost overlayfs-progs]$ make
gcc -Wall -g -c fsck.c
gcc -Wall -g -c common.c
gcc -Wall -g -c lib.c
gcc -Wall -g -c check.c
check.c: In function =E2=80=98ovl_create_whiteout=E2=80=99:
check.c:173:55: warning: implicit declaration of function =E2=80=98makedev=
=E2=80=99 [-Wimplicit-function-declaration]
  173 |  if (mknodat(dirfd, pathname, S_IFCHR | WHITEOUT_MOD, makedev(0, 0)=
)) {
      |                                                       ^~~~~~~
gcc -Wall -g -c mount.c
gcc -Wall -g -c path.c
gcc -Wall -g -c overlayfs.c
gcc -lm fsck.o common.o lib.o check.o mount.o path.o overlayfs.o -o fsck.ov=
erlay
/usr/bin/ld: check.o: in function `ovl_create_whiteout':
/home/cgxu/git/overlayfs-progs/check.c:173: undefined reference to `makedev=
'
collect2: error: ld returned 1 exit status
make: *** [Makefile:10: overlay] Error 1


Thanks,
Chengguang
