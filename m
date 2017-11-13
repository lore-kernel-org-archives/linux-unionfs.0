From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/2] overlay: Test consistent st_ino numbers for
 non-samefs scenario
Date: Mon, 13 Nov 2017 17:08:12 +0200
Message-ID: <CAOQ4uxiYSgzCVkDYL288y3LZfm4VdrqG24_M0tpUBoYYpnmEgw@mail.gmail.com>
References: <20171113144527.1034-1-chandan@linux.vnet.ibm.com> <20171113144527.1034-2-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:45730 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752269AbdKMPIN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Nov 2017 10:08:13 -0500
In-Reply-To: <20171113144527.1034-2-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Mon, Nov 13, 2017 at 4:45 PM, Chandan Rajendra
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
> ---
> Eryu,
> To pass, This test requires Amir's "Overlayfs: constant st_ino/d_ino for
> non-samefs" patchset. But this patch can be merged as it indicates an
> incorrect behaviour by overlayfs code as presently available on
> upstream kernel.

Eryu,

To add a bit more context
This test, like test 041 checks for bad behavior of overlayfs with upper/lower
not on the samefs.

I posted work to address these issues, but the work was not accepted to
v4.15, so 041 as well as the new proposed test are still going to fail on v4.15.
I had already posted some new patches (i.e. the 'xino' mount option which
these patches refer to), available on my ovl-xino development branch.
The new work addresses those issues and got positive feedback from Miklos,
so it may land in the next merge cycle.

Thanks Chandan,
I will review this test later.

Cheers,
Amir.
