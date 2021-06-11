Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0D7C4743D
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Jun 2021 07:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A643060FF4
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Jun 2021 07:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231216AbhFKH5b (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 03:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbhFKH53 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Jun 2021 03:57:29 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4828CC061574
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Jun 2021 00:55:32 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id z13so2256174uai.12
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Jun 2021 00:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=plyecH04Jqw3MVHbT0mp0NQZuPhWQFu6e+q5xLlvWUI=;
        b=Q/AdOI+CISRvvfX+HgLAb/Tp8q+opL7r1sMSINS8XRrZ9JXF9Yf/jb8jNTeDdgP9TA
         JKDNBmywMxJ/s+kCuAzRX2SLBNFnicJbke/3BNOF7HeMaHencz9Dei8hamDF94nmXqgl
         35fwVZzOBwJnnKtWYrfzNGBeDJ/m6mh0SvjCY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=plyecH04Jqw3MVHbT0mp0NQZuPhWQFu6e+q5xLlvWUI=;
        b=Aqip372Mnm/qkWJPo2u1CmY6LQAvb/xkxVH42zJT6DXt8VYFOUoKolIF4Wc2ZUHAwb
         s3VlI+aJzImH4VDBg4d753VbcTPHuEvo7ll64k1Dvk0Uzrr7Ra3Ql6jnNSVRNhICD4TU
         dn/PcyneteDauhaqD6v9zIx/B0Jo4fR2qZVuj2wSrpiZZtIMxiISVvTDJ8EmpWut9sgP
         N1YgLlnOXiTZlxkXlLHMqDdF9ELt9tKu7mMjHLDUU+ka8MI7PBuNCT6y0T+LbGAj+4GX
         FEabO80smdV1qQqqXYwhCs/ocMhVJ0lwSZP1OI96HcBvQ88w70OGy1rF+6dB3qInIyhn
         bYRg==
X-Gm-Message-State: AOAM530Y8vY829NB5jpG52QcffQe5aduzch7ucaNQutyEGLnLPdulCOW
        dB3TY7+ealbQ+/burcC1HwRfuMmwYh7S2UGp3/M6Voepu7o=
X-Google-Smtp-Source: ABdhPJy1TIxUTesPjpTukhNy6UheYsHXeBYZUT5kr5rQs703UVAehal/YslLVX9bCv+FpJQ8aOdzKIt1EauMo7rH+r4=
X-Received: by 2002:ab0:6998:: with SMTP id t24mr1856697uaq.72.1623398131500;
 Fri, 11 Jun 2021 00:55:31 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
 <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
 <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com>
 <CAOQ4uxiqxJBHkiDDuPvL=pMvfqkPadDWReLOwzGpiEn3BBwcjQ@mail.gmail.com>
 <CAJfpegtC+bg3_onOuzQv116axuX36y13P-_ojA5ZOUjfdTPR-g@mail.gmail.com>
 <CAOQ4uxheGdKSqEBYAOTf7=UwqeW=JAaZBwaCs-ng28G7rtqZ7Q@mail.gmail.com>
 <CAJfpegtupBqa6c4qgMVayWZO+5noGEnSAd9tOWySedx+VA=5JQ@mail.gmail.com>
 <CAOQ4uxjXWWmqFRs3GoyruQ1PUYOE7DiTVqqMFP_RkU7mo7GuaQ@mail.gmail.com> <CAOQ4uxiHyd4iRxgtDGorNK8fzBJgViUXxgAtS7nfAdHMQeiAew@mail.gmail.com>
In-Reply-To: <CAOQ4uxiHyd4iRxgtDGorNK8fzBJgViUXxgAtS7nfAdHMQeiAew@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 11 Jun 2021 09:55:20 +0200
Message-ID: <CAJfpeguateThdqWPdF1P-OFuxYdrdgtz7dj-=ewBft-k2gDSdQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 11 Jun 2021 at 09:31, Amir Goldstein <amir73il@gmail.com> wrote:

>
> Taking a step back.
>
> The main problem this is trying to solve is losing persistent inode flags
> on copy-up.
>
> If this was just NOATIME and SYNC the solution would have been
> simple - copy up the flags along with other metadata we copy up.
>
> We wouldn't even need to limit ourselves to the 4 vfs inode flags
> in ovl_copyflags(). We could add the the copied up flags more
> fs specific flags that we know to be safe and rational to copy
> such as NOCOW, NODUMP and DIRSYNC.
>
> The secondary problem is that copying IMMUTABLE/APPEND
> to upper inode on copy up is not an option, so the solution is to
> store those properties in an xattr.
>
> I think we should split the solution to the primary and secondary
> problems and avoid an over-designed generic future extendable
> xflags xattr feature.
>
> So I am leaning towards a more focused solution for
> IMMUTABLE/APPEND in the form of either two boolean
> xattr overlay.{immutable,appendonly} or one single bytes
> xattr overlay.protected.

Makes sense.

Not sure how you'd make it single byte and user friendly at the same
time. I.e. how'd you represent +ia?.   Otherwise I'm fine with either.

Thanks,
Miklos
