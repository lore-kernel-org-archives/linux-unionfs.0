Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pg1-f172.google.com ([209.85.215.172]:38265 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfCKGfo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Mar 2019 02:35:44 -0400
Received: by mail-pg1-f172.google.com with SMTP id m2so3277051pgl.5
        for <linux-unionfs@vger.kernel.org>; Sun, 10 Mar 2019 23:35:44 -0700 (PDT)
MIME-Version: 1.0
From: kagamine rinfans <maykagura@gmail.com>
Date: Mon, 11 Mar 2019 14:35:32 +0800
Message-ID: <CALsfCbcZ3EziEcRw5GAQ+5dp4vGct4QSezjEDVk+gzj8MYOb6A@mail.gmail.com>
Subject: [Help]Cannot read symbolic link, Invalid argument
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hello. I met a bug and want your help. When I run a container by
docker for a long time, some problems appeared.
In the container, a symbolic link has been broken.The filesystem is
overlay. The symlink libipfwinner.so point to libipfwinner.so.0.0.0.5.

Device Info:
sh-4.2$ uname -a
Linux xx 4.9.29 #1 SMP PREEMPT Fri Dec 21 16:00:00 CST 2018 x86_64
x86_64 x86_64 GNU/Linux

sh-4.2$ df
Filesystem     1K-blocks    Used Available Use% Mounted on
overlay          7891460 2300196   5591264  30% /

Normal:
sh-4.2$ ls  /lib/ -ll | grep libipfw
lrwxrwxrwx 1 root root       23 Feb 21 09:31 libipfwinner.so ->
libipfwinner.so.0.0.0.5
-rwxr-xr-x 1 root root    69808 Feb 21 09:31 libipfwinner.so.0.0.0.5

Bug=EF=BC=9A
sh-4.2$ ls /lib/ -ll | grep libipfwinner
ls: cannot read symbolic link /lib/libipfwinner.so: Invalid argument
lrwxrwxrwx 1 root root       23 Feb 22 09:42 libipfwinner.so
-rwxr-xr-x 1 root root    69808 Feb 22 09:42 libipfwinner.so.0.0.0.5

sh-4.2$ cat libipfwinner.so
cat: libipfwinner.so: Too many levels of symbolic links


I think it might be a bug of overlayfs.I cannot reproduce this
problem.It only happened once.

I hope you can give me some advice.Thanks!
