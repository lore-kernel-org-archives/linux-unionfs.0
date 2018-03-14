Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60339 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751289AbeCNIpC (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Mar 2018 04:45:02 -0400
MIME-Version: 1.0
Message-ID: <trinity-208a0783-1c9b-4d25-8080-109e2f7a20a2-1521017094371@3c-app-mailcom-bs05>
From: "Chengguang Xu" <cgxu519@gmx.com>
Subject: Re: Question about the condition of fsck.overlay
Content-Type: text/plain; charset=UTF-8
Date: Wed, 14 Mar 2018 09:44:54 +0100
In-Reply-To: <8f3b85fe-902a-820e-d2ab-9a525e299c32@huawei.com>
References: <trinity-9a7c9bff-31ae-42a1-b375-40fb8a4b83f5-1521012033735@3c-app-mailcom-bs05>
 <8f3b85fe-902a-820e-d2ab-9a525e299c32@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Zhangyi,

Thanks for your kind explanation!

> Sent: Wednesday, March 14, 2018 at 4:38 PM
> From: "zhangyi (F)" <yi.zhang@huawei.com>
> To: "Chengguang Xu" <cgxu519@gmx.com>
> Cc: overlayfs <linux-unionfs@vger.kernel.org>
> Subject: Re: Question about the condition of fsck.overlay
>
> Hi Chengguang,
> 
> On 2018/3/14 15:20, Chengguang Xu Wrote:
> > Hi Zhangyi,
> > 
> > Please let me ask a simple question about fsck.overlay,
> > is it possible to run any kernel version of overlayfs?
> > 
> 
> No, current fsck.overlay can recognize whiteout/redirect_dir/impure
> xattr feature only, it don't know index and nfs_export features. So,
> if run current version of fsck.overlay on overlayfs which was mounted
> with index=on or nfs_export=on, if cannot guarantee the relationship
> between dirs/files in indexdir and upper dir, so may lead to
> inconsistency in indexdir.
> 
> This drawback will be addressed through introduce overlay feature
> set as Amir suggested, I will post it soon and maybe write a NOTE
> or BUG in README is better before everything is done.
> 
> > I know some advanced features are only implemented in high
> > kernel version, I just want to make sure if the common check
> > and repair functions are available for 4.4 kernel? Any conditions?
> > 
> 
> Yes, I think current fsck.overlay can support <= 4.12 kernel well(not
> check origin xattr, but not harmful), it can support overlayfs without
> index dir.
> 
> Thanks,
> Yi.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
