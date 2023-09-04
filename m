Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAB70C83F2C
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 13:27:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjIDN1l (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 09:27:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242377AbjIDN1i (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 09:27:38 -0400
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A44B0CD5
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 06:27:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0VrMGhM7_1693834039;
Received: from 192.168.3.4(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0VrMGhM7_1693834039)
          by smtp.aliyun-inc.com;
          Mon, 04 Sep 2023 21:27:21 +0800
Message-ID: <fe799167-249b-8fe2-a6c8-b222ac9acaf0@linux.alibaba.com>
Date:   Mon, 4 Sep 2023 21:27:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [potential issue, question] whiteout shows up in merged directory
To:     Jingbo Xu <jefflexu@linux.alibaba.com>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Xiang Gao <xiang@kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>
References: <a05e13c7-2fc2-77d8-05b5-759a73d7f5e2@linux.alibaba.com>
 <CAOQ4uxj_gM1BBCUE6p=TfVketOZohLPZs3fbw0BLacQFKEsuGg@mail.gmail.com>
 <9a89150e-cd84-c541-8088-41c2dfe863ac@linux.alibaba.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <9a89150e-cd84-c541-8088-41c2dfe863ac@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org



On 2023/9/4 20:49, Jingbo Xu wrote:

...

> 
> Thanks for the reply and it's really helpful to me.
> 
> I can understand in the normal use case, whiteout can not appear in
> non-merged directory without origin xattr, except it's hand crafted.
> 
> But indeed we suffer from this issue in the tarfs for erofs-utils we are
> developing. As described previously, in tarfs mode erofs-utils can
> convert each tar layer into one separate erofs image, and then merge
> these erofs images into one merged erofs image in a overlayfs-like model.
> 
> Suppose:
> 
> layer 0 + layer 1   +        layer 2         -->  merged
> 	  /foo/bar   /foo/bar (whiteout)
> 
> 
> To speed the merging process, we may merge the two top-most layers
> (layer 1 and layer 2) first, and then make layer0 merged into the final
> merged image as:
> 
> 
> 
>             layer 1   +        layer 2         -->  merged-intermediate
> 	  /foo/bar   /foo/bar (whiteout)
> 
> layer0 + merged-intermediate		      -->  merged


I could add some more background to this, assuming layer 0 is a
baseos layer (e.g. almost all images use this layer); and layer 1 +
layer 2 belongs to some specific workload images;

since layer 1 + layer 2 are always used together, so we could merge
layer 1 + layer 2 as a new merged layer to avoid extra overhead of
too many overlay layer dirs (but to simplify, here we just illustrate
layer 1 and layer 2, there could be layer 3, 4, ...), but layer 1 +
layer 2 has no relationship with layer 0 in principle (in principle,
merge tool doesn't need to know if layer 0 or any underlay layer
exists).

So if we merge layer 1 + layer 2 here first, and use layer0 together
with the merged layer, it could generate such whiteout cases
described before.

Anyway, we could work around this in the merge tool, but I'm not
sure if it's a design constaint of overlayfs.

Thanks,
Gao Xiang

> 
> Then there comes the problem: when merging layer1 and layer2, I need to
> keep the whiteout in the intermediate merged image though the target of
> the whiteout has showed up in underlying layer (/foo/bar in layer 1),
> because I have no idea if "/foo/bar" exits in the following further
> underlying layer (layer 0).  Reusing this logic, the whiteout is kept
> there in the final merged image after merging layer0 and
> merged-intermediate.
> 
> Then if "/foo" is not a merged directory, the "/foo/bar" whiteout will
> be exposed in the overlayfs unexpectedly.
> 
> Currently we work around this in erofs-utils side.  Apart from setting
> origin xattr on the parent directory of the whiteout, I'm not sure if
> the above use case is reasonable enough to fix this in the kernel side.
> 
