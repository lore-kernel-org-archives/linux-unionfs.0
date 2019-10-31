Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:50388 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726793AbfJaOU5 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Oct 2019 10:20:57 -0400
Subject: Re: Compile error of fsck.overlay on Fedora30
References: <16e222490fd.db7c32a41966.5777637250125026331@mykernel.net>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <0827d20f-6494-58b9-db2b-6536af803774@huawei.com>
Date: Thu, 31 Oct 2019 22:20:45 +0800
MIME-Version: 1.0
In-Reply-To: <16e222490fd.db7c32a41966.5777637250125026331@mykernel.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
To: cgxu519@mykernel.net
Cc: linux-unionfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Chengguang,

Thanks for reporting, I will check and fix this soon.

Thanks,
Yi.

On 2019/10/31 22:07, Chengguang Xu Wrote:
> Hi Zhangyi,
> 
> I found a compile error of fsck.overlay on my laptop(fedora 30), it looks like lacking of header in the check.c.
> After manually added <sys/sysmacros.h> compile succeeded without error.
> 
> Detail info of compile error as below:
> 
>  [cgxu@localhost overlayfs-progs]$ make
> gcc -Wall -g -c fsck.c
> gcc -Wall -g -c common.c
> gcc -Wall -g -c lib.c
> gcc -Wall -g -c check.c
> check.c: In function ‘ovl_create_whiteout’:
> check.c:173:55: warning: implicit declaration of function ‘makedev’ [-Wimplicit-function-declaration]
>   173 |  if (mknodat(dirfd, pathname, S_IFCHR | WHITEOUT_MOD, makedev(0, 0))) {
>       |                                                       ^~~~~~~
> gcc -Wall -g -c mount.c
> gcc -Wall -g -c path.c
> gcc -Wall -g -c overlayfs.c
> gcc -lm fsck.o common.o lib.o check.o mount.o path.o overlayfs.o -o fsck.overlay
> /usr/bin/ld: check.o: in function `ovl_create_whiteout':
> /home/cgxu/git/overlayfs-progs/check.c:173: undefined reference to `makedev'
> collect2: error: ld returned 1 exit status
> make: *** [Makefile:10: overlay] Error 1
> 
> 
> Thanks,
> Chengguang
> 
> 
> 
> .
> 
