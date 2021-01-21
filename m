Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF553C433E6
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Jan 2021 08:08:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75DA723976
	for <linux-unionfs@archiver.kernel.org>; Thu, 21 Jan 2021 08:08:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbhAUIIm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 21 Jan 2021 03:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727782AbhAUIIV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 21 Jan 2021 03:08:21 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C1DDC061575
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Jan 2021 00:07:38 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id 186so571034vsz.13
        for <linux-unionfs@vger.kernel.org>; Thu, 21 Jan 2021 00:07:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HJKAVHbB5ive9I6qDPNYB34EvzgegIV7pqrbZWLDm6A=;
        b=fARiv+9/l4+YDpEc+1svLF0/4kuY9Nlu92GJlRrzukZb8yv5BGcyBbwSlvPVB+KdcO
         wiFvAeUtE8D6PgZsORFxrtsijnvcYw9tfF5hJR/HnwrPT3miP8Sue94ecAOMuD9NNbBb
         ETFsiAOga8TFdekG5A4OrU6YMeJKlpu+MeRAU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HJKAVHbB5ive9I6qDPNYB34EvzgegIV7pqrbZWLDm6A=;
        b=qIbR+GDifO0A6rpdInpzXcAmIE1utlled8J/+Q5cNWSFFt0MCsjhiN9E0ToqIXZAYb
         SaJ9W7UDFBiclIGLqDxouikpHYVV/TXyZ+vzXhMtQg9whOXy+JkG3Px6QrFrxGTMNBMG
         6sOf8ChMFH1prWOtC/S16dBc1kq1OotQfeVaw/PoQvYdCQ3yJjIp0X6a0bj7oQ/yfxj9
         2KLz5IVhke2+4yHid6mxHXkMlWZDCJvoIbWDqAiQ5QM2I35FoPS79w70OUUbevHNab1U
         S+VpoCvVaY8gdE9nBq0Pff4wZqKSut7pQcQdyx3UiBPMSM1TQBvbCBAmSjACvix7c2FE
         Xpcg==
X-Gm-Message-State: AOAM53328vpF0eZEKIhWcg+AM94d9z/MLwt6pkx/C0qLyBkwkcVtBqbk
        1D/hNp7C6jfqJUidc59eutpqaoYYAfD8bseMQvpyeQ==
X-Google-Smtp-Source: ABdhPJzNjMkNDPoM96rwPmZSTgrlp2gW8S5mhVcsYGjbxKBDKXiCkuLan4UcdNHCEuGCbaPiBuAF0DcFYenQy/ibI2U=
X-Received: by 2002:a67:8844:: with SMTP id k65mr8969325vsd.9.1611216457611;
 Thu, 21 Jan 2021 00:07:37 -0800 (PST)
MIME-Version: 1.0
References: <20210105003611.194511-1-icenowy@aosc.io> <CAOQ4uxiFoQhrMbs91ZUNXqbJUXb5XRBgRrcq1rmChLKQGKg5xg@mail.gmail.com>
 <20210120102045.GD1236412@miu.piliscsaba.redhat.com> <83bb613212ee81648e5bf7c0f9cd3219e0046f80.camel@aosc.io>
In-Reply-To: <83bb613212ee81648e5bf7c0f9cd3219e0046f80.camel@aosc.io>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 21 Jan 2021 09:07:26 +0100
Message-ID: <CAJfpegsVnpV38j4ShOG0m9xh8Fy=P2kmZ_hwyfiaAzmM3tVaOg@mail.gmail.com>
Subject: Re: [PATCH v3] ovl: use a dedicated semaphore for dir upperfile caching
To:     Icenowy Zheng <icenowy@aosc.io>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jan 21, 2021 at 4:43 AM Icenowy Zheng <icenowy@aosc.io> wrote:
>
> =E5=9C=A8 2021-01-20=E6=98=9F=E6=9C=9F=E4=B8=89=E7=9A=84 11:20 +0100=EF=
=BC=8CMiklos Szeredi=E5=86=99=E9=81=93=EF=BC=9A
> > On Tue, Jan 05, 2021 at 08:47:41AM +0200, Amir Goldstein wrote:
> > > On Tue, Jan 5, 2021 at 2:36 AM Icenowy Zheng <icenowy@aosc.io>
> > > wrote:
> > > >
> > > > The function ovl_dir_real_file() currently uses the semaphore of
> > > > the
> > > > inode to synchronize write to the upperfile cache field.
> > >
> > > Although the inode lock is a rw_sem it is referred to as the "inode
> > > lock"
> > > and you also left semaphore in the commit subject.
> > > No need to re-post. This can be fixed on commit.
> > >
> > > >
> > > > However, this function will get called by ovl_ioctl_set_flags(),
> > > > which
> > > > utilizes the inode semaphore too. In this case
> > > > ovl_dir_real_file() will
> > > > try to claim a lock that is owned by a function in its call
> > > > stack, which
> > > > won't get released before ovl_dir_real_file() returns.
> > > >
> > > > Define a dedicated semaphore for the upperfile cache, so that the
> > > > deadlock won't happen.
> > > >
> > > > Fixes: 61536bed2149 ("ovl: support [S|G]ETFLAGS and
> > > > FS[S|G]ETXATTR ioctls for directories")
> > > > Cc: stable@vger.kernel.org # v5.10
> > > > Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
> > > > ---
> > > > Changes in v2:
> > > > - Fixed missing replacement in error handling path.
> > > > Changes in v3:
> > > > - Use mutex instead of semaphore.
> > > >
> > > >  fs/overlayfs/readdir.c | 10 +++++-----
> > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > > index 01620ebae1bd..3980f9982f34 100644
> > > > --- a/fs/overlayfs/readdir.c
> > > > +++ b/fs/overlayfs/readdir.c
> > > > @@ -56,6 +56,7 @@ struct ovl_dir_file {
> > > >         struct list_head *cursor;
> > > >         struct file *realfile;
> > > >         struct file *upperfile;
> > > > +       struct mutex upperfile_mutex;
> > >
> > > That's a very specific name.
> > > This mutex protects members of struct ovl_dir_file, which could
> > > evolve
> > > into struct ovl_file one day (because no reason to cache only dir
> > > upper file),
> > > so I would go with a more generic name, but let's leave it to
> > > Miklos to decide.
> > >
> > > He could have a different idea altogether for fixing this bug.
> >
> > How about this (untested) patch?
> >
> > It's a cleanup as well as a fix, but maybe we should separate the
> > cleanup from
> > the fix...
>
> If you are going to post this, feel free to add
>
> Tested-by: Icenowy Zheng <icenowy@aosc.io>

Okay, thanks.

> (And if you remove the IS_ERR(realfile) part, the tested-by tag still
> applies.)

Dropping the IS_ERR(realfile) here would mean having to add the same
check before relevant fput() calls, which would make it more complex
not less.

Or did you mean something else?

Thanks,
Miklos
