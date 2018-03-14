Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:59947 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750751AbeCNIjV (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Mar 2018 04:39:21 -0400
Subject: Re: Question about the condition of fsck.overlay
References: <trinity-9a7c9bff-31ae-42a1-b375-40fb8a4b83f5-1521012033735@3c-app-mailcom-bs05>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <8f3b85fe-902a-820e-d2ab-9a525e299c32@huawei.com>
Date: Wed, 14 Mar 2018 16:38:45 +0800
MIME-Version: 1.0
In-Reply-To: <trinity-9a7c9bff-31ae-42a1-b375-40fb8a4b83f5-1521012033735@3c-app-mailcom-bs05>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Chengguang,

On 2018/3/14 15:20, Chengguang Xu Wrote:
> Hi Zhangyi,
> 
> Please let me ask a simple question about fsck.overlay,
> is it possible to run any kernel version of overlayfs?
> 

No, current fsck.overlay can recognize whiteout/redirect_dir/impure
xattr feature only, it don't know index and nfs_export features. So,
if run current version of fsck.overlay on overlayfs which was mounted
with index=on or nfs_export=on, if cannot guarantee the relationship
between dirs/files in indexdir and upper dir, so may lead to
inconsistency in indexdir.

This drawback will be addressed through introduce overlay feature
set as Amir suggested, I will post it soon and maybe write a NOTE
or BUG in README is better before everything is done.

> I know some advanced features are only implemented in high
> kernel version, I just want to make sure if the common check
> and repair functions are available for 4.4 kernel? Any conditions?
> 

Yes, I think current fsck.overlay can support <= 4.12 kernel well(not
check origin xattr, but not harmful), it can support overlayfs without
index dir.

Thanks,
Yi.

