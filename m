Return-Path: <SRS0=DgkE=AT=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABC3C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 08:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3543C21532
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 08:31:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AxxqbbI+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgGHIbo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 04:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgGHIbn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Jul 2020 04:31:43 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79111C08C5DC
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2020 01:31:43 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id e64so41188227iof.12
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2020 01:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WiN6WlFoTugTmXtHtSp/ELh34lX1wNAqUgBTT41QA28=;
        b=AxxqbbI+I0uFexVWG4VhC/9mKvXkhZ5DiIslTzzJeX8DRH4PWJA0ROQBYnfv2eOYQy
         pRAy61rHFozf8ltC7PP3o1vtkwkUkv023SEETPId/AVMXq8Ts/TBzO+OsiCCOY8zZA+l
         9GUG4aBLgXoRb1u3cSj6aJA+LQWvxskVq9+HTWuN3oEwTujQc7oL8FFNsQEWd+rXQAO3
         Gi6X+Sy0AvBWoKYsYpE51y2d+HFdGlX+I4djTxrd87FeFeoexovTOWAiTLBdEnS7HKKs
         ZcFvSzmWHhRpjLFunynyosA4Y6goFo9pecKUknDYJjRgXBJYn1ZGH+I33fV36Pa6410r
         SSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WiN6WlFoTugTmXtHtSp/ELh34lX1wNAqUgBTT41QA28=;
        b=p1i4AiUHjSkfGtKdOiGEr5s3e6VJKH/DpKO7WUmBo70N8rWF7+JRKSQoZzZVTNdYgo
         ONUm+RJZBu+w/R8aR0CWenCv1wJROP5XxtSc0yBdRcy/HGoEiqRsyY8dF3lYsxpkD4bN
         qSrugGRNW2p6fBo1nyTf2yBaYriirzjaW2AbhJwGKi0oR4MpotFrm0RJbDuOodZ1L4Px
         Zuq2Qnf+NIRjv4YdNb9Q8IEvfGhWzmHBNcZCL78P6TnchIfVzqr04/Lsh5/VmQ168D7F
         Qhu63l6jPYDDsKa6+Yvgr7R0t16dhec2X9AXr3TMDtLF2LGV9VuOOYF0wEQpI7aQBwPx
         wwKg==
X-Gm-Message-State: AOAM530RghC4PqqbcIlKpCGcNUwqUZDyUmuT+uWMpBDRG76kfPoNtHPL
        p0GgvTJCXRy6O4/8P2xMnGDkcV+mzfgIhnBlo3eE/4fr
X-Google-Smtp-Source: ABdhPJwJX+htkQnmPrQU4IPr/YMsXJvrxh2LM/WczngAolFfG7ezrz6/GUvPDPtmPAGs9vQZEeUZGdaFKGY5BOpsyiE=
X-Received: by 2002:a05:6602:1225:: with SMTP id z5mr35654971iot.64.1594197102805;
 Wed, 08 Jul 2020 01:31:42 -0700 (PDT)
MIME-Version: 1.0
References: <32532923.JtPX5UtSzP@fgdesktop> <CAOQ4uxjm7i+uO4o4470ACctsft1m18EiUpxBfCeT-Wyqf1FAYg@mail.gmail.com>
 <106271350.sqX05tTuFB@fgdesktop> <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
 <20200707155159.GA48341@redhat.com> <CAOQ4uxhMq_8xwCU2t+WveTGgc9MAWE2RD66q5UjQ1r09EoLzHA@mail.gmail.com>
 <20200707215309.GB48341@redhat.com> <CAOQ4uxhd+kYzaDmndCV5rgiswfHnyLjZokmUa+BVk9t31C=HWg@mail.gmail.com>
 <CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com>
In-Reply-To: <CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Jul 2020 11:31:31 +0300
Message-ID: <CAOQ4uxgaVD_DjU5DM+rXzkqpgVLWN-R+kj5ef2SBvvvCDL3d6w@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 8, 2020 at 11:00 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Jul 8, 2020 at 8:55 AM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Wed, Jul 8, 2020 at 12:53 AM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > > On Tue, Jul 07, 2020 at 08:41:20PM +0300, Amir Goldstein wrote:
> > > > > > Miklos,
> > > > > >
> > > > > > At first glance I did not understand how changing lower file handles causes
> > > > > > failure to ovl_verify_inode().
> > > > > > To complete the picture, here is the explanation.
> > > > > >
> > > > > > Upper file A was copied up from lower file with inode 10 in old squashfs
> > > > > > and the "origin" file handle composed of the inode number 10 is recorded
> > > > > > in upper file A.
> > > > > >
> > > > > > With newly formatted lower, lower A has inode 11 and lower B has inode 10.
> > > > > > Upper file B is copied from lower file B with inode 10 in new squashfs and
> > > > > > the "origin" file handle composed of the inode number 10 is recorded
> > > > > > in upper file B.
> > > > > > Now we have two upper files with the same "origin" that are not hardlinks.
> > > > > >
> > > > > > On lookup of both overlay files A and B, ovl_check_origin() decodes lower
> > > > > > file B (inode 10) as the lower inode.
> > > > > > This lower inode is used to get the overlay inode number (10) and as
> > > > > > the key to hash overlay inode in inode cache.
> > > > > >
> > > > > > Suppose A is looked up first and it's inode is hashed.
> > > > > > Then B is looked up and in ovl_get_inode() it finds the inode hashed
> > > > > > by the same lower inode in inode cache, but fails ovl_verify_inode()
> > > > > > because:
> > > > > > d_inode(upperdentry) /* B */ != ovl_inode_upper(inode) /* A */
> > > > > >
> > > > > > This can also happen when copying overlay layers to a new
> > > > > > fs tree and carrying over the old "origin" xattr.
> > > > > > In practice, the UUID part of the stored "origin" xattr is meant to
> > > > > > protect against decoding lower fh when migrating to another
> > > > > > filesystem, but layers could be migrated inside the same filesystem.
> > > > > > Since squashfs does not have a UUID, re-creating sqhashfs is similar
> > > > > > to migrating layers inside the same filesystem.
>
> No, I think copying layers is a different issue: it's not possible to
> get the same file handle for A and B since they are
>
>  - either on different filesystems and uuid is different
>  - on the same filesystem, hence fh must be unique for the lifetime of the fs
>
> > Now, suggestions for work arounds:
> >
> > 1. Don't follow with lower null uuid (patch posted) - no caveats
>
> We could add some sort of "overlay version"  to origin to be able to
> trust null uuid, but only if created in *this* instance of overlayfs.
> That way we retain some of the advantages without any of the
> drawbacks.   This does not seem too complex theoretically, but not
> sure if it's worth it.

Don't think it is worth it.
It is a corner case of a special case.

>
> > 2. Opt-out of following origin with explicit option e.g. "index=nofollow"
> > 3. Don't follow origin unless one of the following opt-in features:
> >     metacopy,index,xino
>
> Maybe, if 1) is problematic for some reason.
>

1) is not problematic IMO and the simple patch I posted may be applied
for fixing the reported issue, but it only solved the special case of null uuid.
The problem still exists with re-creating lower on xfs/ext4, e.g. by
rm -rf and unpacking image tar.

So either we solve only the special case and wait for someone to complain
on the non-null uuid case or we try to make the code more robust.

Suggesting improvement for auto detecting re-created lower:
- On mount, even with index disabled, do ovl_verify_origin() of lower root
- On lookup of dir, do ovl_verify_origin() regardless of ovl_verify_lower()
- When ovl_verify_origin() on some dir fails and index/metacopy are disabled,
  warn and set ofs->bad_origin to disable ovl_check_origin() from here on
- Maybe also set null fh in ovl_set_origin() from here on?
- In ovl_dentry_*revalidate(), if non-dir has lower and ofs->bad_origin,
  invalidate the dentry
- Can also set ofs->bad_origin on ovl_verify_inode() for conflicting
  upper inode as reported in the bug

Thanks,
Amir.
