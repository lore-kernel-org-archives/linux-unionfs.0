Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB75C77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 11:12:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242993AbjD0LMS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 07:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243473AbjD0LMR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 07:12:17 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD881BD9
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 04:12:15 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id ada2fe7eead31-42e5d6709fdso2739237137.0
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 04:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682593935; x=1685185935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGIFLFjh7pOQ3BKtqEWbCmCacU0zoBQGsYRF/iBTWMg=;
        b=fmN+scXA5JjfIzA5noNL6wVGxqd44HvHATl5rP2IUeKOxRQ3Fgq+56miAXjm6R6RSP
         ZKkGCwxkw3lw3b5Ayz4h0F+3l0xOrJp4NtBna7rMseiyOVRrARsYnm1C/61Ggqo0qJXA
         xAou02fQ3BMEEVCc1tv+oTaknKQ5f638dZRCgCM47vx9mO3LTtmPm/Xm3xVeIFTTBd0g
         LBZ2a9lxSO/0lKJTrwlKtRXuA5bC6NgrV2BkInVUsK3OPCxFZNqg1lcrV7xx5aX2oJnQ
         AeOep6S37rOkewemeJd4n2O+RuxC9j7xAaGlpKLB3Q51LlkO7o4ktFhLS7Asl8OK9EZg
         FNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682593935; x=1685185935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fGIFLFjh7pOQ3BKtqEWbCmCacU0zoBQGsYRF/iBTWMg=;
        b=KAPgMjchG0THzSHLrjLHV09HLaRiIJ92sj7ZT1zyXHyFp39633r3DiWxHs584ymLic
         IsRgvuq3ohZUyLN+bLR1eI4O7NqgGcFvVHrNiuV9RAHVk2jSoQqj2XmA1tjIRYMfZXtQ
         Fnhck2RKX23ASSRu9y8Ur9mTdkZSIYFAn7F9gONXzWDa+BXVBKoyLDSUA5YIPYPz6lS+
         lwAOTeMWi5IcYwE/OyFRw53VzB0PSlbpUwXVCh5TbEK5q7x7/+2RhT6RolZcH0B4vLMn
         axn/BSP3nqJIIs32TWyv9w4v/YDpp8/WUUcCI/kHuwIleu+uG5f25Wis9MrcC++zbMMD
         0Zqw==
X-Gm-Message-State: AC+VfDyeU6Wh+HjlrvzbgO34HXJtWEKqJ8plRp6zPPIuzjn626dFCnp9
        ZHo/aPk2EDpSrnUgS8/vGnsQbM1pMwHa3s72ZRC7PLLFaGzjwg==
X-Google-Smtp-Source: ACHHUZ6V8ENI8aq0GQ8XIUKJTpcbZGMzU9LNYGcMCl6lU9lq0C5jSafLZODrzPbRaFSCHouDZnDT3slq370ZnL9e37c=
X-Received: by 2002:a67:ea4e:0:b0:42f:eb45:47de with SMTP id
 r14-20020a67ea4e000000b0042feb4547demr444042vso.21.1682593934806; Thu, 27 Apr
 2023 04:12:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230412135412.1684197-1-amir73il@gmail.com> <20230412135412.1684197-5-amir73il@gmail.com>
 <CAJfpegtx2DixU+TNRa5LA8Dv=mvi_w=Oh5k3USLmip3LmGtX2g@mail.gmail.com>
In-Reply-To: <CAJfpegtx2DixU+TNRa5LA8Dv=mvi_w=Oh5k3USLmip3LmGtX2g@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Apr 2023 14:12:03 +0300
Message-ID: <CAOQ4uxgBDf2-mFmRQN=Q_bgYsZ4GmAPWT0x8uH29SGVpyAoeJw@mail.gmail.com>
Subject: Re: [PATCH 4/5] ovl: prepare for lazy lookup of lowerdata inode
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 26, 2023 at 5:57=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Wed, 12 Apr 2023 at 15:54, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Make the code handle the case of numlower > 1 and missing lowerdata
> > dentry gracefully.
> >
> > Missing lowerdata dentry is an indication for lazy lookup of lowerdata
> > and in that case the lowerdata_redirect path is stored in ovl_inode.
> >
> > Following commits will defer lookup and perform the lazy lookup on
> > acccess.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/export.c |  2 +-
> >  fs/overlayfs/file.c   |  7 +++++++
> >  fs/overlayfs/inode.c  | 18 ++++++++++++++----
> >  fs/overlayfs/super.c  |  3 +++
> >  fs/overlayfs/util.c   |  2 +-
> >  5 files changed, 26 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > index 9951c504fb8d..2498fa8311e3 100644
> > --- a/fs/overlayfs/export.c
> > +++ b/fs/overlayfs/export.c
> > @@ -343,7 +343,7 @@ static struct dentry *ovl_dentry_real_at(struct den=
try *dentry, int idx)
> >         if (!idx)
> >                 return ovl_dentry_upper(dentry);
> >
> > -       for (i =3D 0; i < ovl_numlower(oe); i++) {
> > +       for (i =3D 0; i < ovl_numlower(oe) && lowerstack[i].layer; i++)=
 {
>
> Metacopy and NFS export are mutually exclusive, so this doesn't make sens=
e.
>

OK.

>
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 3484f39a8f27..ef78abc21998 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
>
> ovl_d_real() calls ovl_dentry_lowerdata().  If triggered from
> file_dentry() it should be okay, since that is done on an open file
> (lazy lookup already perfromed).   But it can also be called from
> d_real_inode(), the only caller of which is trace_uprobe.  Is this
> going to be okay?
>

Not sure.
It's hard to imagine that trace_uprobe_create() is being called to place
a probe on a file at offset X without reading the content of symbols first.

I wonder if lazy lookup from within ovl_d_real(d, NULL) is acceptable?
It does look like the context of trace_uprobe() callers should be fine for =
lazy
lowerdata lookup.

> In any case a comment is needed at least.
>

I will leave it as is and add a comment.

Thanks,
Amir.
