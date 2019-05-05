Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:36127 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726636AbfEEJ0u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 5 May 2019 05:26:50 -0400
From: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Subject: =?UTF-8?Q?=5bbug_report=5d_chattr_+i_succeed_in_docker_which_don?=
 =?UTF-8?Q?=e2=80=98t_have_the_capability_CAP=5fLINUX=5fIMMUTABLE?=
Message-ID: <3393f96c-e9a7-2882-f210-81a9c332a138@linux.alibaba.com>
Date: Sun, 5 May 2019 17:26:44 +0800
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: miklos@szeredi.hu, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi,

We are using kernel v4.19.24 and have found that it can be successful
when we set IMMUTABLE_FL flag to a file in docker while the docker
didn't have the capability CAP_LINUX_IMMUTABLE.

# touch tmp
# chattr +i tmp
# lsattr tmp
----i--------e-- tmp

We have tested this case in older version such as 4.9 and it returned
-EPERM as expected.

We found that the commit d1d04ef8572b ("ovl: stack file ops") and
dab5ca8fd9dd ("ovl: add lsattr/chattr support") implemented chattr
operations on a regular overlay file. ovl_real_ioctl() overridden the
current process's subjective credentials with ofs->creator_cred which
have the capability CAP_LINUX_IMMUTABLE so that it will return success
in vfs_ioctl()->cap_capable().

I wondered is this kind of mechanism of overlayfs or a bug?

Thanks,
Jiufei
