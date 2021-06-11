Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC68C48BE0
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Jun 2021 08:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4BE9610E6
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Jun 2021 08:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhFKIlv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 04:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhFKIlu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Jun 2021 04:41:50 -0400
Received: from mail-ua1-x935.google.com (mail-ua1-x935.google.com [IPv6:2607:f8b0:4864:20::935])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288E6C061574
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Jun 2021 01:39:41 -0700 (PDT)
Received: by mail-ua1-x935.google.com with SMTP id 68so2296956uao.11
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Jun 2021 01:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tvt9j1/4eQ7aospVZ89/Dfhs5ex92mDnVCjpDqPVbts=;
        b=awbHlVYogcVvD+dsN/qWl51HXcT9J3gSs/3Pq0/Lc1OutaG0BKOrGWZE8DIack5a7N
         Zvi8ESUcfhcCI80kGW6IF1WLK4AoCcT9oTNVJqnwVWg0/KVigNSeyS5AEHRkCJq85k4Y
         ceObPV8RE6AmZZujtI+ioTHlMw9Oo7kmMoHic=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tvt9j1/4eQ7aospVZ89/Dfhs5ex92mDnVCjpDqPVbts=;
        b=dcZB31x6bo2VqX2DZzs/Ge4hLwoWgILQKR/aroGURj1PkatUuWNGiZ+mPjB+G+bPcL
         leiTpAN683Bshm3bkGtFJ1fyzaJfzJAOvcE5l526VYf9EzA/Bctq6wWtx6JrdnKid3au
         E3otDqDRzuo076fR5ofcaAbwgN8glU/R3XOssqJ3u6pmczkDq074Hq9pYfZffociXfL8
         j/3i7Na+ZsC7bo2BX1FD7OLjPe1jm5GgMb9yVDP+orighgv3HIiLSWeDfwshng5/JCsY
         qob/Af9zq1pJIebL2DPGmykVrmGEu2tVLxs7ABUKm1sCSuYnYHcpITSbPNO96rzP7ctN
         YwQw==
X-Gm-Message-State: AOAM532KIMMCOq1XdZ6TpU72+T9A9WzAw/vHnMFYCcEKRI8ygSV4NED6
        A9fRK/dZ69VH21jJpyLYlVFFhg703jkn7Hu1QSVbWQ==
X-Google-Smtp-Source: ABdhPJwRigAijnMVkQhfl7lMUBzexYx+IDe5JOvm/J/oIOTJSovZrIMKuX0o9cMMCV5SFFZhexJ1+ngjFWPOemxQD5o=
X-Received: by 2002:ab0:3418:: with SMTP id z24mr1869610uap.11.1623400780267;
 Fri, 11 Jun 2021 01:39:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
 <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
 <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com>
 <CAOQ4uxiqxJBHkiDDuPvL=pMvfqkPadDWReLOwzGpiEn3BBwcjQ@mail.gmail.com>
 <CAJfpegtC+bg3_onOuzQv116axuX36y13P-_ojA5ZOUjfdTPR-g@mail.gmail.com>
 <CAOQ4uxheGdKSqEBYAOTf7=UwqeW=JAaZBwaCs-ng28G7rtqZ7Q@mail.gmail.com>
 <CAJfpegtupBqa6c4qgMVayWZO+5noGEnSAd9tOWySedx+VA=5JQ@mail.gmail.com>
 <CAOQ4uxjXWWmqFRs3GoyruQ1PUYOE7DiTVqqMFP_RkU7mo7GuaQ@mail.gmail.com>
 <CAOQ4uxiHyd4iRxgtDGorNK8fzBJgViUXxgAtS7nfAdHMQeiAew@mail.gmail.com>
 <CAJfpeguateThdqWPdF1P-OFuxYdrdgtz7dj-=ewBft-k2gDSdQ@mail.gmail.com> <CAOQ4uxgicOnJvV-juNoi9pV+PCzyGqWU-=vrU=1Uq9-tUE+FrA@mail.gmail.com>
In-Reply-To: <CAOQ4uxgicOnJvV-juNoi9pV+PCzyGqWU-=vrU=1Uq9-tUE+FrA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 11 Jun 2021 10:39:29 +0200
Message-ID: <CAJfpeguMQca-+vTdzoDdDWNJraWyqMa3vYRFDWPMk_R6-L7Obw@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 11 Jun 2021 at 10:37, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Fri, Jun 11, 2021 at 10:55 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Fri, 11 Jun 2021 at 09:31, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > >
> > > Taking a step back.
> > >
> > > The main problem this is trying to solve is losing persistent inode flags
> > > on copy-up.
> > >
> > > If this was just NOATIME and SYNC the solution would have been
> > > simple - copy up the flags along with other metadata we copy up.
> > >
> > > We wouldn't even need to limit ourselves to the 4 vfs inode flags
> > > in ovl_copyflags(). We could add the the copied up flags more
> > > fs specific flags that we know to be safe and rational to copy
> > > such as NOCOW, NODUMP and DIRSYNC.
> > >
> > > The secondary problem is that copying IMMUTABLE/APPEND
> > > to upper inode on copy up is not an option, so the solution is to
> > > store those properties in an xattr.
> > >
> > > I think we should split the solution to the primary and secondary
> > > problems and avoid an over-designed generic future extendable
> > > xflags xattr feature.
> > >
> > > So I am leaning towards a more focused solution for
> > > IMMUTABLE/APPEND in the form of either two boolean
> > > xattr overlay.{immutable,appendonly} or one single bytes
> > > xattr overlay.protected.
> >
> > Makes sense.
> >
> > Not sure how you'd make it single byte and user friendly at the same
> > time. I.e. how'd you represent +ia?.   Otherwise I'm fine with either.
> >
>
> I had not considered user friendliness.
> I was thinking about the lower byte of i_flags.
> I can go with text format as planned for xflags
> but with no need for the fixed positions of letters.
> This format will be compatible with chattr so easy
> for script that "offline merge" overlay upper to lower.

Okay, let's do that, then.

Thanks,
Miklos
