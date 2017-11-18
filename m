From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V3] overlay: Test consistent st_ino numbers for non-samefs scenario
Date: Sat, 18 Nov 2017 22:33:34 +0200
Message-ID: <CAOQ4uxgDO+32gU_WvOKgg=ex1j-+gVX3EUfMiMG-o+CrUog72w@mail.gmail.com>
References: <20171118055700.17442-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:33730 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423431AbdKRUdf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 18 Nov 2017 15:33:35 -0500
In-Reply-To: <20171118055700.17442-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Sat, Nov 18, 2017 at 7:57 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit adds a test to verify consistent st_ino feature when
> the overlayfs instance is composed of two different underlying
> filesystem instances.
>
> For example,
> $ mount -t xfs /dev/loop0 /mnt/test
> $ mount -t xfs /dev/loop1 /mnt/scratch
> $ mkdir /mnt/scratch/upper
> $ mkdir /mnt/scratch/work
> $ mount -t overlay overlay -o lowerdir=/mnt/test \
>         -o upperdir=/mnt/scratch/upper \
>         -o workdir=/mnt/scratch/work /mnt/merge
>
> The goal of this test is to verify that overlayfs returns consistent
> st_ino for the following scenarios,
> - Copy-up of lowerdir files
> - Rename files and drop dentry/inode cache
> - Remount the overlayfs instance
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Looks good.

I reviewed and verified that all test you modified and added work as expected
with index=on/off (does not change result) and with/without 32bit inode/xino
(new tests fail on 64 ino and pass with 32bit ino or -o xino)

For Eryu, it would have been more clear if you posted this test in
the same series as 017,018,044 and re-post the "t_dir_type strtoul" change
on the same series, just to highlight that they are all related and dependencies
between them. Nevermind now, but in case you need to re-post.

Thanks,
Amir.
