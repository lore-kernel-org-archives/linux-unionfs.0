From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/3] overlay: Test hardlink breakage on non-samefs setup
Date: Sat, 18 Nov 2017 22:36:39 +0200
Message-ID: <CAOQ4uxjjS9zcCJc=9QxudEpw3BF_4DZWv3S-OE=f8--MH51VNA@mail.gmail.com>
References: <20171118055804.17611-1-chandan@linux.vnet.ibm.com> <20171118055804.17611-3-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:46715 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162168AbdKRUgk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 18 Nov 2017 15:36:40 -0500
In-Reply-To: <20171118055804.17611-3-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <eguan@redhat.com>

On Sat, Nov 18, 2017 at 7:58 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> This commit adds a test to check hardlink breakage when the overlayfs
> instance is composed of two different underlying filesystem instances.
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
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Looks good and tested.

Thanks,
Amir.
