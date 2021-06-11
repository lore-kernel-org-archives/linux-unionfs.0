Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A92C48BE0
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Jun 2021 08:38:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D14D4613B3
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Jun 2021 08:38:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbhFKIkC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 04:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhFKIkC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Jun 2021 04:40:02 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E15D0C061574
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Jun 2021 01:37:51 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id k16so30040702ios.10
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Jun 2021 01:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zwPyf2XVqmfTTQM8NvLKSXzx8ynGfbqnq2/k6pUTWvQ=;
        b=t3/le4R/iHArLWCkmaEjBi0hIAl108QrbEJPtz5H4eS6HqEY36WGgullQZoC9Fvayc
         GtZgHOM2KNsAHNe10s4AKsx4Ya/Iz1E95V8iFDt6TFhmUBn3llrMfURD9e1SXVpaONXE
         zI4kJzwxBSHMs3RNXxti20g3ZbaS2q9r9h/2qzcTJB9sseiEM0LmYtx+lj3Y7/wK0xTG
         r81YoJyyj2PocfMc92+fbXFhow7AUPLOCii5vFWwmIIEZT7IsOzbGcK/SKDkXUNBKZWd
         nzk2VrmZUDc64vpyOsdYd/4dsyGZRZu/6ScyRyd8Ldb/o7xOJY3bHmcIJQG55qvvFpPz
         RwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zwPyf2XVqmfTTQM8NvLKSXzx8ynGfbqnq2/k6pUTWvQ=;
        b=nKMdDnto1g9LL7WVR77rpCuJDsb0eHNlXnf1wZVi7HQQOT3t5+HhNMYMOACJ10nriT
         PX2Jzj18L3dE9zaDpQGmciltPFt7m5lmLP+VRz3RWmAMXSPxMlhYhZAecNRv355PTiUY
         EqfrJgZ/DYtyjllNXgFepnLQ5hQWWAyabvu5sPMK20yjyCYMsr7et6SXtfQ7od18WsXY
         p/SfeDJRwtBcDekJm/mfgIZ87WtBdaemlr1KvQ7zGL4FK+cQga3GASJ8Lb8lCM3PvVdm
         Bz+3Mecmay+PCj6am1id87EI5jX3bFQWuN9LUNoX86rY0rLJCTC7P5AkjEkopO7F+06Z
         grOA==
X-Gm-Message-State: AOAM531xeaBhhEP68zW96XvEoZ3iD3rBVTXd08trGl+BlOXGRNP+R40Q
        hrZsxAd7JekbOEenBOYvz67qQO67SDBlpOXUK3I=
X-Google-Smtp-Source: ABdhPJwQngcapOgm/iTbMDXLp94PxH4SAFU9lR9BnxyBF8AEJBUTW/7BnfpLWYm8y9E0NnmrzJ7q8/2C3+xQLo/jg9w=
X-Received: by 2002:a6b:7b41:: with SMTP id m1mr2306273iop.186.1623400671309;
 Fri, 11 Jun 2021 01:37:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
 <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
 <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com>
 <CAOQ4uxiqxJBHkiDDuPvL=pMvfqkPadDWReLOwzGpiEn3BBwcjQ@mail.gmail.com>
 <CAJfpegtC+bg3_onOuzQv116axuX36y13P-_ojA5ZOUjfdTPR-g@mail.gmail.com>
 <CAOQ4uxheGdKSqEBYAOTf7=UwqeW=JAaZBwaCs-ng28G7rtqZ7Q@mail.gmail.com>
 <CAJfpegtupBqa6c4qgMVayWZO+5noGEnSAd9tOWySedx+VA=5JQ@mail.gmail.com>
 <CAOQ4uxjXWWmqFRs3GoyruQ1PUYOE7DiTVqqMFP_RkU7mo7GuaQ@mail.gmail.com>
 <CAOQ4uxiHyd4iRxgtDGorNK8fzBJgViUXxgAtS7nfAdHMQeiAew@mail.gmail.com> <CAJfpeguateThdqWPdF1P-OFuxYdrdgtz7dj-=ewBft-k2gDSdQ@mail.gmail.com>
In-Reply-To: <CAJfpeguateThdqWPdF1P-OFuxYdrdgtz7dj-=ewBft-k2gDSdQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 11 Jun 2021 11:37:40 +0300
Message-ID: <CAOQ4uxgicOnJvV-juNoi9pV+PCzyGqWU-=vrU=1Uq9-tUE+FrA@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jun 11, 2021 at 10:55 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Fri, 11 Jun 2021 at 09:31, Amir Goldstein <amir73il@gmail.com> wrote:
>
> >
> > Taking a step back.
> >
> > The main problem this is trying to solve is losing persistent inode flags
> > on copy-up.
> >
> > If this was just NOATIME and SYNC the solution would have been
> > simple - copy up the flags along with other metadata we copy up.
> >
> > We wouldn't even need to limit ourselves to the 4 vfs inode flags
> > in ovl_copyflags(). We could add the the copied up flags more
> > fs specific flags that we know to be safe and rational to copy
> > such as NOCOW, NODUMP and DIRSYNC.
> >
> > The secondary problem is that copying IMMUTABLE/APPEND
> > to upper inode on copy up is not an option, so the solution is to
> > store those properties in an xattr.
> >
> > I think we should split the solution to the primary and secondary
> > problems and avoid an over-designed generic future extendable
> > xflags xattr feature.
> >
> > So I am leaning towards a more focused solution for
> > IMMUTABLE/APPEND in the form of either two boolean
> > xattr overlay.{immutable,appendonly} or one single bytes
> > xattr overlay.protected.
>
> Makes sense.
>
> Not sure how you'd make it single byte and user friendly at the same
> time. I.e. how'd you represent +ia?.   Otherwise I'm fine with either.
>

I had not considered user friendliness.
I was thinking about the lower byte of i_flags.
I can go with text format as planned for xflags
but with no need for the fixed positions of letters.
This format will be compatible with chattr so easy
for script that "offline merge" overlay upper to lower.

Thanks,
Amir.
