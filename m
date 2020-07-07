Return-Path: <SRS0=JIvn=AS=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79ED7C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Jul 2020 17:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 513FE20675
	for <linux-unionfs@archiver.kernel.org>; Tue,  7 Jul 2020 17:41:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ag22QigY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgGGRlc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 7 Jul 2020 13:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728191AbgGGRlc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Jul 2020 13:41:32 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFE45C061755
        for <linux-unionfs@vger.kernel.org>; Tue,  7 Jul 2020 10:41:31 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id y2so44085706ioy.3
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Jul 2020 10:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HXkygzV5KnlcB6DshoB25GDxMELnKGL0YhbCvdsRRTo=;
        b=Ag22QigYE0br4BiPvg+YsbrIIqCWUC5hxJ0IJ8MMat4yS60ELeBHZK8v+fvnl1/nAA
         JPvl70dVdaeqUv/MqwJyzGoijdDU6OOK9ckgGzSoW6R1qaWm+aeCskncumOS31jupKx0
         YsdPkmDhqN2/Xi1JXd2F7IuxIXTUQZ0VA6bZyoOV7Dl/so6HB6SddwKCbytljkFxVF/6
         o0+z/Rjzn2TEXJbn+Z8khwNDN6v/YnfoLTWiGG1gSTrjYTMjPcKNXLlwWpsNQJSdmps+
         qC1J0AAwAaSWOaUdQ4Z77/UfgPfqD6OAILU7wXlJYx4TfFNhgmD+JWoGYLn8RRH6+TkC
         vQmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HXkygzV5KnlcB6DshoB25GDxMELnKGL0YhbCvdsRRTo=;
        b=nEyD31PT8cTFU1zF5ys+Yxf89FQHQYty8AOItgCDwGPDF90PSp7Kb6XOvndTbhIN3j
         w42KNwKT6cyYQhLGbGmEGnA5hdFdZlnvwg6e53oqOfHEpripuD8jTDz8nEYbIbgX08Kd
         wun3UD5DK5Q2r0q2nQG/OdPZrW6aVZDzkm7TXVWbh1NmnqAxYjYIDEy5AhgMIG16vPIZ
         sw0GYc4M6EBvN+0WHNEp0ZNWgQgPvOhjvA0gCPEmopXsmxRZhbZJQdkf4OlR6vicDr0+
         UF5PnSRBj/kJV30GEPhPuFnIrer9gU5gsZ+pKpEHCZuNW1nRra/wzmescmorIPWSkLR+
         XP0A==
X-Gm-Message-State: AOAM531MgvuOuw9zmo/Lb0paB369GicN9Moa66luMdW/4IkkWcFiMcPj
        iskwHNKOyLIlX9S9yVcCRwCkrZ2cOhMpjwfmBBI=
X-Google-Smtp-Source: ABdhPJzOovWha6GVUrwN+h2pOPVfRF5FmsBikFqvT0QGLFXnP6K6Oh5kI+Nwq7Nv1JDJdT95c7uToIYsBKtGqrUQFXY=
X-Received: by 2002:a05:6602:58a:: with SMTP id v10mr32313201iox.203.1594143691109;
 Tue, 07 Jul 2020 10:41:31 -0700 (PDT)
MIME-Version: 1.0
References: <32532923.JtPX5UtSzP@fgdesktop> <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
 <106271350.sqX05tTuFB@fgdesktop> <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
 <20200707155159.GA48341@redhat.com>
In-Reply-To: <20200707155159.GA48341@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 7 Jul 2020 20:41:20 +0300
Message-ID: <CAOQ4uxhMq_8xwCU2t+WveTGgc9MAWE2RD66q5UjQ1r09EoLzHA@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> > Miklos,
> >
> > At first glance I did not understand how changing lower file handles causes
> > failure to ovl_verify_inode().
> > To complete the picture, here is the explanation.
> >
> > Upper file A was copied up from lower file with inode 10 in old squashfs
> > and the "origin" file handle composed of the inode number 10 is recorded
> > in upper file A.
> >
> > With newly formatted lower, lower A has inode 11 and lower B has inode 10.
> > Upper file B is copied from lower file B with inode 10 in new squashfs and
> > the "origin" file handle composed of the inode number 10 is recorded
> > in upper file B.
> > Now we have two upper files with the same "origin" that are not hardlinks.
> >
> > On lookup of both overlay files A and B, ovl_check_origin() decodes lower
> > file B (inode 10) as the lower inode.
> > This lower inode is used to get the overlay inode number (10) and as
> > the key to hash overlay inode in inode cache.
> >
> > Suppose A is looked up first and it's inode is hashed.
> > Then B is looked up and in ovl_get_inode() it finds the inode hashed
> > by the same lower inode in inode cache, but fails ovl_verify_inode()
> > because:
> > d_inode(upperdentry) /* B */ != ovl_inode_upper(inode) /* A */
> >
> > This can also happen when copying overlay layers to a new
> > fs tree and carrying over the old "origin" xattr.
> > In practice, the UUID part of the stored "origin" xattr is meant to
> > protect against decoding lower fh when migrating to another
> > filesystem, but layers could be migrated inside the same filesystem.
> > Since squashfs does not have a UUID, re-creating sqhashfs is similar
> > to migrating layers inside the same filesystem.
>
> Hi Amir,
>
> So we can't use "origin" if lower layers have been copied. If they
> have been copied to a different filesystem with uuid we seem to
> have a mechanism to detect it but otherwise not and we can run
> into these kind of issues.
>

Correct.

> My question is, why do we allow copying or updating lower layers
> with same upper when we know this will break stored origin in
> upper.

I don't know if we "allow" this. We never considered the case expect
for nfs export and index, see overlayfs.rst:
"When the overlay NFS export feature is enabled, overlay filesystems
behavior on offline changes of the underlying lower layer is different
than the behavior when NFS export is disabled. ..."

> Can't I do same thing with ext4/xfs, where I recreate
> lower layers when inode numbers get exchanged  and same problem
> will happen (despite uuid being same).
>

Same problem.

> IOW, how can we support copying layers (with same upper) while origin
> is in use. Rest of the features are built on top of the assumption
> that origin is valid. And in case of copying layers, we don't
> seem to have a sure way to find if origin is valid or not.
>

With index/nfs_export enabled we at least do:
/* Verify lower root is upper root origin */
and if verification fails we disable the feature.

> Should we put a restrictions that if lower layers are updated or
> moved then upper should be rotated as lower layer and a new
> fresh upper should be used instead?
>

Don't know and it doesn't matter.
Fabian's bug report is for an old setup that used to work.
He did not opt-in to any new feature.
In kernel v4.12 we added "origin" for persistent inode numbers on same-fs
and we didn't make it an opt-in feature.
This is when the regression of re-creating lower happened, but back then
squashfs (null uuid) did not suffer from the problem.

> I might be missing something very fundamental, but before I try
> to understand fine details of all the features built on top of
> "origin", I fail to understand that how can we allow changing
> lower layers and still expect "origin" to be valid and use it.
>

See the text below.
We *thought* that using "origin" for persistent st_ino was safe
even if lower layers were copied on the same fs, because we thought
If the file handle can be decoded then it guarantees a unique inode
number even if it is in the old lower tree and not the new copied tree.
For me the reported bug was an oversight, but maybe Miklos has
another way of looking at this.

Thanks,
Amir.

> >
> > We were aware of the "layer migration" case when designing the
> > index/nfs_export feature, which is one of the reasons they are
> > opt-in features.
> >
> > But we enabled the functionality of following non-dir origin
> > unconditionally because we *thought* it is harmless, as the comment
> > in ovl_lookup() says:
> >
> >          /*
> >          * Lookup copy up origin by decoding origin file handle.
> >          * We may get a disconnected dentry, which is fine,
> >          * because we only need to hold the origin inode in
> >          * cache and use its inode number.  We may even get a
> >          * connected dentry, that is not under any of the lower
> >          * layers root.  That is also fine for using it's inode
> >          * number - it's the same as if we held a reference
> >          * to a dentry in lower layer that was moved under us.
> >          */
> >
> > The patch I posted disabled decoding of non-dir origin for the special
> > case of lower null uuid.
> >
> > I think we can also warn and auto-disable decoding non-dir origin in
> > case index is disabled and we detect this upper inode conflict in
> > ovl_verify_inode().
> >
> > The problem is if A is not metacopy and looked up first, and B is
> > metacopy and looked up second, then conflict will be deleted after
> > the wrong inode has been hashed.
> >
> > Perhaps we should disable decoding non-dir origin with in case
> > metacopy=on,index=off?
> > Maybe also provide a user option to disable decoding non-dir origin
> > at the price of losing persistent inode number for copied up non-dir?
> > Something like 'index=nofollow'.
> >
> > Thoughts?
> > Am I overthinking this?
> >
> > Thanks,
> > Amir.
> >
>
