Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48186EC8747
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 Sep 2023 02:21:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236207AbjIHCVW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 22:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234854AbjIHCVW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 22:21:22 -0400
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1257D1BCD
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 19:21:17 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Vran2.W_1694139673;
Received: from 30.97.49.0(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0Vran2.W_1694139673)
          by smtp.aliyun-inc.com;
          Fri, 08 Sep 2023 10:21:14 +0800
Message-ID: <3e5c0260-53fe-4955-b77e-ab79282556d3@linux.alibaba.com>
Date:   Fri, 8 Sep 2023 10:21:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on
 overlayfs
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
References: <cover.1692270188.git.alexl@redhat.com>
 <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
 <CAL7ro1HyGrwdH7B8C4-uWsfK4XTA=LF6GSS+4+LwT_iosdO2wQ@mail.gmail.com>
 <CAOQ4uxjhVR656cME=G-wOu_zrpqPS1M=sx32ogiUtrSxLsaBsw@mail.gmail.com>
 <CAJfpegsLDi-V_0GYW=9qu3RE16Oh9Wc8-bmMX=3q3EfdSn-iQw@mail.gmail.com>
 <CAOQ4uxioDBiKH267ijR5VOXzStwkOvYGrjMGtP26x0LJR0oWAg@mail.gmail.com>
From:   Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <CAOQ4uxioDBiKH267ijR5VOXzStwkOvYGrjMGtP26x0LJR0oWAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi folks,

On 2023/8/23 01:29, Amir Goldstein wrote:
> On Tue, Aug 22, 2023 at 7:19 PM Miklos Szeredi <miklos@szeredi.hu> wrote:

...

>>
> 
> I proposed to look at the two features independently:
> 1. Nesting of overlayfs xattrs (patch 3/5)
> 2. Alternative format for whiteout (overlay.whiteout) that can be used
>     by container tools converting OCI/tar images to overlayfs images
> 
> Together, they provide a solution to Alexander's use case.
> 
> IIUC, the way this is intended to work is that mkfs.composefs
> is running inside a container, whose work directory is overlayfs
> and it composes some lower layers on that host mounted overlayfs.
> 
> mkfs.composefs composes layers with overlay.{metacopy,whiteout,redirect}
> xattrs (up to here it is standard mkfs.composefs) and because those layers
> are stored in overlayfs, the xattrs are stored in the host fs as
> overlay.overlay.*.
> 
> I hope I got the use case correctly?
Sorry for the dumb questions below.  I'm interested in the use cases:
after checking the previous github issue and emails (sorry if I'm
still missing something), I'm curious about this too.

I totally understand how it plans to work and how it works (by using
escape xattr prefixes) but I'm not sure if I'm quite understand the
original issue:

Do composefs use cases store overlayfs xattrs in the meta-only layer?
if so, such layer is actually hand-crafted by mkfs.  Why do we need
a way to keep escape xattrs on the underlay overlayfs?  Does the
other layer are data-only layers (do we keep some overlay xattrs in
these data-only layers)?

Thanks,
Gao Xiang
