Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16023C433E6
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 02:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE3162192A
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 02:55:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qFlX8TXz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGNCzx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 22:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgGNCzx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 22:55:53 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7E6C061755
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 19:55:53 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id d18so15811284ion.0
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 19:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZH1q5Hduk5NiVSe4A7cISNYL2tUETxD62xW3LLfnEFU=;
        b=qFlX8TXzQtLaFlJPsXNe5dKW7pdFOsq3GYGB24BZg+XfpXRxBxSNdbOylJRUl277Kw
         ZEWBnhvym8XB+5jgMaI1pWtlnRpWfHPd0eRBU7pveGZ2jCImfZvpJrLf3Srrj07dt7YP
         CbNMJSh2cje1WFzvdL7Y7M0oRg2UGLxiamPazCHJ3AenuqNSxSJJrS0ajFITR7ePyHhJ
         w/U3mc0VZGX1vkyR15Im0X2xmygFnQ5wNE8U78T/EQyEaW8PDfMJU76p+Ow3c2y07P2U
         bwXVnpjdBWleNLntsWlfhHJOMR6uuerrypBWhjzSkbknEVXG7DTFuJ9OFnqZsm63RwfF
         a7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZH1q5Hduk5NiVSe4A7cISNYL2tUETxD62xW3LLfnEFU=;
        b=T7QZSCGsYJ8sr25UeHsEoIfksLRYw1/PKfOAltg3ButbPi8UMYW/0ncFPEEPvperbq
         GSPQggRvHOsuH4CL8bntOjWaZFOzn8xYK9KwPjCeFXOkl57y245CvdfdS0n+MBK/2ql7
         P+9RmqrZuu1gt9HsfnawkHwiqv2jnuwaogbettwIdKImdi5SH9PBhFYRJPwG6+RwFF2S
         mFb1cQAndy5/UDowQzHHDeebCdMA3M+94QTeui519aMjyFatO5qKTR8iahlIPEdrjeng
         vHHXooWZux0mEVNHqU7G/gZ6rqXkz9eXXTCu/TojwNJns9iWvU1db0sMvXaY1YH7sfpX
         oGOg==
X-Gm-Message-State: AOAM532PYNBYHgb7YctSp23yxWC4ZE2/DtI2BpykmUinRkUu4mAL4HLp
        JP5PhPqs0l7LIEoYyIPgcoPyV21z7b/NlJZXogYPjw==
X-Google-Smtp-Source: ABdhPJwbzN3KbJ0pUgyEqsw/LwNdLWwEpqkjc8jAvF5xko55E6l0nqIaeq52VIcbNvt7idiv1HJ9wmaVi/DKyHrZ3ZM=
X-Received: by 2002:a05:6602:1489:: with SMTP id a9mr659813iow.5.1594695352525;
 Mon, 13 Jul 2020 19:55:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200713105732.2886-1-amir73il@gmail.com> <20200713105732.2886-3-amir73il@gmail.com>
 <20200713200511.GB286591@redhat.com>
In-Reply-To: <20200713200511.GB286591@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 14 Jul 2020 05:55:41 +0300
Message-ID: <CAOQ4uxi4n1WjRHPR5ovu0C9GO3nfmAncMtXSY2+qUBtnrqDt=g@mail.gmail.com>
Subject: Re: [PATCH RFC 2/2] ovl: invalidate dentry if lower was renamed
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Josh England <jjengla@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 13, 2020 at 11:05 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Mon, Jul 13, 2020 at 01:57:32PM +0300, Amir Goldstein wrote:
> > Changes to lower layer while overlay in mounted result in undefined
> > behavior.  Therefore, we can change the behavior to invalidate the
> > overlay dentry on dcache lookup if one of the dentries in the lowerstack
> > was renamed since the lowerstack was composed.
> >
> > To be absolute certain that lower dentry was not renamed we would need to
> > know the redirect path that lead to it, but that is not necessary.
> > Instead, we just store the hash of the parent/name from when we composed
> > the stack, which gives a good enough probablity to detect a lower rename
> > and is much less complexity.
> >
> > We do not provide this protection for upper dentries, because that would
> > require updating the hash on overlay initiated renames and that is harder
> > to implement with lockless lookup.
> >
> > This doesn't make live changes to underlying layers valid, because
> > invalid dentry stacks may still be referenced by open files, but it
> > reduces the window for possible bugs caused by lower rename, because
> > lookup cannot return those invalid dentry stacks.
> >
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/export.c    |  1 +
> >  fs/overlayfs/namei.c     |  4 +++-
> >  fs/overlayfs/ovl_entry.h |  2 ++
> >  fs/overlayfs/super.c     | 17 ++++++++++-------
> >  4 files changed, 16 insertions(+), 8 deletions(-)
> >
> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > index 0e696f72cf65..7221b6226e26 100644
> > --- a/fs/overlayfs/export.c
> > +++ b/fs/overlayfs/export.c
> > @@ -319,6 +319,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
> >       if (lower) {
> >               oe->lowerstack->dentry = dget(lower);
> >               oe->lowerstack->layer = lowerpath->layer;
> > +             oe->lowerstack->hash = lower->d_name.hash_len;
> >       }
> >       dentry->d_fsdata = oe;
> >       if (upper_alias)
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index 3566282a9199..ae1c1216a038 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -375,7 +375,8 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
> >       }
> >       **stackp = (struct ovl_path){
> >               .dentry = origin,
> > -             .layer = &ofs->layers[i]
> > +             .layer = &ofs->layers[i],
> > +             .hash = origin->d_name.hash_len,
> >       };
> >
> >       return 0;
> > @@ -968,6 +969,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >               } else {
> >                       stack[ctr].dentry = this;
> >                       stack[ctr].layer = lower.layer;
> > +                     stack[ctr].hash = this->d_name.hash_len;
> >                       ctr++;
> >               }
> >
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index b429c80879ee..557f1782f53b 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -42,6 +42,8 @@ struct ovl_layer {
> >  struct ovl_path {
> >       const struct ovl_layer *layer;
> >       struct dentry *dentry;
> > +     /* Hash of the lower parent/name when we found it */
> > +     u64 hash;
> >  };
> >
> >  /* private information held for overlayfs's superblock */
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index f2c74387e05b..4b7cb2d98203 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -119,13 +119,13 @@ static bool ovl_dentry_is_dead(struct dentry *d)
> >  }
> >
> >  static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak,
> > -                            bool is_upper)
> > +                            bool is_upper, u64 hash)
> >  {
> >       bool strict = !weak;
> >       int ret = 1;
> >
> > -     /* Invalidate dentry if real was deleted since we found it */
> > -     if (ovl_dentry_is_dead(d)) {
> > +     /* Invalidate dentry if real was deleted/renamed since we found it */
> > +     if (ovl_dentry_is_dead(d) || (hash && hash != d->d_name.hash_len)) {
>
> So if lower hash_len changes, on local filesystem we will return -ESTALE?
> I am assuming we did that for remote filesystems and now we will do
> that for local filesystems as well?
>

That is correct.
Although I am personally in favor of the non 'strict' behavior.

Thanks,
Amir.
