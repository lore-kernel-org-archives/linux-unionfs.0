Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C42C77B73
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 11:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243737AbjD0Ln0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 07:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243459AbjD0LnZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 07:43:25 -0400
Received: from mail-ua1-x92e.google.com (mail-ua1-x92e.google.com [IPv6:2607:f8b0:4864:20::92e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D3059EF
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 04:43:23 -0700 (PDT)
Received: by mail-ua1-x92e.google.com with SMTP id a1e0cc1a2514c-77aad9ef9adso3088763241.1
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 04:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682595802; x=1685187802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lHdFHvUgmfz/8TjKjuKgVtAuz/GdDSbRwpxPrqQbvB0=;
        b=hPFNrkXQlAm5Cub+KB9LYVg0qZHY11TtvcoK+kGM6Yivi3pJCnuju9aDNpkHDwX6kW
         Le7QpaIcXBBzHgF83z84D8sv3kFP80nmLAz8oU+8jN5rkmtcjVIP0IkwJDzgWGJlHCVY
         BQmuGBCDohTQaZI33syK8oz/89OF49C/ogNnLjEcD7Hs8WC+E44QtvDo6II3/rUcpXBX
         m+C/iUe+7Lq83sYj1Joo78ugGsxYnXEl72l0GievZgVAxzeImvZViw4PChW4YoW9o0lA
         nE6/R2mSjWXAqfgGODyPr97wGit/5/xOuI+gYp8bSKmUMJGuZrXuYS7QVuXih7/byrgI
         SKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682595802; x=1685187802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lHdFHvUgmfz/8TjKjuKgVtAuz/GdDSbRwpxPrqQbvB0=;
        b=L3aB0dEXlS1z7qiMLR/VXvgHKEKzyKha1tYWjtp/uUcGBd2+SeAanYgbf5ZGEOhkby
         Q78I5kH9KaLcQn2kpJ3/Bb4qchA1BigkcneyxXUNNGC6EBteypsOce/+7ifV3kEy/VrK
         QkmuBaeNFbLTjpdEQxtGr1wpgDB2Xv764E0dC5pd4i95SSkQEmaPlRfcorvSiTuWd+Cx
         Z9AyFvzYx3jx4aubcdI6AmOrOep8M5lL1FH8TOIDidED1nQFo3L1p7s/9TYoSdrfxEBe
         tPBKih9+uZQC9mC1rr3zAog203IIrDXcQm3bxQaVl2m+B9LbrT7OmAznobmiFXjQ/VyM
         KzJA==
X-Gm-Message-State: AC+VfDzj8Wykk7s9V9pKqiqCMg4GPpfbpAvQy8ooH0iWvkSg37rAzdQ6
        0rWMz6JYLmpFFutvlokH1mhsGJ8c1yw8s5dvAm8=
X-Google-Smtp-Source: ACHHUZ4lWTwjNglpVxLCI4LqNGnt+w8uamw6xSxhT/0N4l2T70KPDT9KxZuNvWe9L2ejqba24DWplgTpNtanOdj0OuM=
X-Received: by 2002:a05:6102:4191:b0:42e:50f6:b50a with SMTP id
 cd17-20020a056102419100b0042e50f6b50amr2610689vsb.8.1682595802522; Thu, 27
 Apr 2023 04:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20230412135412.1684197-1-amir73il@gmail.com> <20230412135412.1684197-5-amir73il@gmail.com>
 <CAJfpegtx2DixU+TNRa5LA8Dv=mvi_w=Oh5k3USLmip3LmGtX2g@mail.gmail.com> <CAOQ4uxgBDf2-mFmRQN=Q_bgYsZ4GmAPWT0x8uH29SGVpyAoeJw@mail.gmail.com>
In-Reply-To: <CAOQ4uxgBDf2-mFmRQN=Q_bgYsZ4GmAPWT0x8uH29SGVpyAoeJw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 Apr 2023 14:43:11 +0300
Message-ID: <CAOQ4uxgyqWR4eyNBo7ANRTNA7D0x-pv+7F2M1YeLmcXwxMyd6Q@mail.gmail.com>
Subject: Re: [PATCH 4/5] ovl: prepare for lazy lookup of lowerdata inode
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 27, 2023 at 2:12=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Wed, Apr 26, 2023 at 5:57=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Wed, 12 Apr 2023 at 15:54, Amir Goldstein <amir73il@gmail.com> wrote=
:
> > >
> > > Make the code handle the case of numlower > 1 and missing lowerdata
> > > dentry gracefully.
> > >
> > > Missing lowerdata dentry is an indication for lazy lookup of lowerdat=
a
> > > and in that case the lowerdata_redirect path is stored in ovl_inode.
> > >
> > > Following commits will defer lookup and perform the lazy lookup on
> > > acccess.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >  fs/overlayfs/export.c |  2 +-
> > >  fs/overlayfs/file.c   |  7 +++++++
> > >  fs/overlayfs/inode.c  | 18 ++++++++++++++----
> > >  fs/overlayfs/super.c  |  3 +++
> > >  fs/overlayfs/util.c   |  2 +-
> > >  5 files changed, 26 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > > index 9951c504fb8d..2498fa8311e3 100644
> > > --- a/fs/overlayfs/export.c
> > > +++ b/fs/overlayfs/export.c
> > > @@ -343,7 +343,7 @@ static struct dentry *ovl_dentry_real_at(struct d=
entry *dentry, int idx)
> > >         if (!idx)
> > >                 return ovl_dentry_upper(dentry);
> > >
> > > -       for (i =3D 0; i < ovl_numlower(oe); i++) {
> > > +       for (i =3D 0; i < ovl_numlower(oe) && lowerstack[i].layer; i+=
+) {
> >
> > Metacopy and NFS export are mutually exclusive, so this doesn't make se=
nse.
> >
>
> OK.
>
> >
> > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > > index 3484f39a8f27..ef78abc21998 100644
> > > --- a/fs/overlayfs/super.c
> > > +++ b/fs/overlayfs/super.c
> >
> > ovl_d_real() calls ovl_dentry_lowerdata().  If triggered from
> > file_dentry() it should be okay, since that is done on an open file
> > (lazy lookup already perfromed).   But it can also be called from
> > d_real_inode(), the only caller of which is trace_uprobe.  Is this
> > going to be okay?
> >
>
> Not sure.
> It's hard to imagine that trace_uprobe_create() is being called to place
> a probe on a file at offset X without reading the content of symbols firs=
t.
>
> I wonder if lazy lookup from within ovl_d_real(d, NULL) is acceptable?
> It does look like the context of trace_uprobe() callers should be fine fo=
r lazy
> lowerdata lookup.
>
> > In any case a comment is needed at least.
> >
>
> I will leave it as is and add a comment.

On second thought, I will add best effort lazy lowerdata lookup
in addition to the warning.
d_real_inode() does not expect errors or NULL and trace_uprobe
does not check for them either.

Thanks,
Amir.
