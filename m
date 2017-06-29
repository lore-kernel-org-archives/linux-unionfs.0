From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: Re: Overlayfs patches to consider for v4.13
Date: Thu, 29 Jun 2017 21:15:24 +0800
Message-ID: <0a1cd47b-0c71-44b2-343f-96d272a890e9@huawei.com>
References: <CAOQ4uxgy8PMhHqQwH9GtpamUOZAuqDibDZm2vu_F=A3h_2BnVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8403 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752536AbdF2NPw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Jun 2017 09:15:52 -0400
In-Reply-To: <CAOQ4uxgy8PMhHqQwH9GtpamUOZAuqDibDZm2vu_F=A3h_2BnVA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Chandan Rajendra <chandan@linux.vnet.ibm.com>

On 2017/6/28 21:17, Amir Goldstein Wrote:
> Miklos,
> 
> Not that I have not given you enough work with inode index patches,
> but just so you know, I have a tested branch [1] based on ovl-hardlinks
> with a merge of 3 topic branches:
> 1. Non-samefs constant inode (Chandan & Amir)
> 2. Verify & set merge dir origin on lookup (Amir)
> 3. Check whiteouts in origin dir (Zhangyi & Amir)
> 
> The 3 topic branches are completely independent and merge
> with no conflicts, so if you choose to, you may pick any one of
> them for v4.13.
> 
> The patches from Chandan and Zhangyi have gone through several
> review cycles and I complemented each with a patch on my own.
> Not sure if you had a chance to glimpse.
> 
> Tested with a new xfstests whiteout test by Zhangyi [2] and
> new unionmount-testsuite run flag [3] to check constant inode on
> non-samefs (./run --ov --verify).
> 
> Zhangyi,
> 
> One thing I have not tested, but that should work is hiding of
> whiteouts in a merge dir that was created prior to v4.12.
> The test should be:
> - Create merge dir and whiteouts with kernel <= v4.12-rc*
> - Upgrade to kernel built from overlayfs-devel
> - Mount overlay and list merge dir (should fix origin)
> - Continue with use case of removing lower dir
>   and trying to expose whiteouts
> 
> If you can spare the time, please test this use case.

Hi Amir,

I tested this use case, it works well. Thanks.

Thanks,
ZhangYi.
