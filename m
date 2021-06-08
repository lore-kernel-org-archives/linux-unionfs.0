Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B359C47082
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Jun 2021 14:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FCE761182
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Jun 2021 14:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233363AbhFHOxA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 10:53:00 -0400
Received: from mail-vs1-f44.google.com ([209.85.217.44]:38714 "EHLO
        mail-vs1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233521AbhFHOxA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Jun 2021 10:53:00 -0400
Received: by mail-vs1-f44.google.com with SMTP id x8so11008147vso.5
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Jun 2021 07:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SUt8MHg/Vyqm8EunJee27ZFwK/MeopnIKKJY96fvUhs=;
        b=jvMfWmvlGbhaWWiK7aOypS5G0M/jCrGv8unSHf2Ag3BOqo/t93i27RBECYN63hPPd3
         3XSoKKc0j/oeX8hsHTsd0nVH9Eu6AHuTqY5ykxmgVGSyfyN1WtVz+K98Nni04K+odPXs
         jxljxy/ZMGbRqiqtCi8Q0BRaz4a+GtYX5o9Qg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SUt8MHg/Vyqm8EunJee27ZFwK/MeopnIKKJY96fvUhs=;
        b=Gf3ZisE69GMhT8ze7FeQvsGuu6k1WWkPHefB+RhNlxWSwaxsC+CJhEwYm4xJxmPJsW
         UpTiSd4bY7QutnMxoxPM/xud6OSeMuH173YIj4961TJGOnWAwND2WTD5dO8CGIx1sxNo
         ooX6auCgQIG01ADN44k9sSpekE4sI+7iQ/jQ0qLHJaZo+C0n8RXf7a9y5WTwzEfwWitC
         vQwxJYIA5G795G6kzIEuNY/9ilsX6DzbiL27lvPl96gV8iGsyxetbaZ2u2xE16ql9v1t
         quct23dPXYsgpaIy2gZZKI6Ti6RdrhrdLAFJYBxGk/zxKdH9wMc7YivqplzRcx6fCK6r
         HrcQ==
X-Gm-Message-State: AOAM533J8SjtxKhYzdD2HV8PQ2oCMvzF7sfzii5RKpsWlhlViDEN/grX
        617w0Shvfl5yQwbH8PKPsXEECJhAkxPEq9BPoZH06Na3L+I=
X-Google-Smtp-Source: ABdhPJze0dCRjZAa3DPahDSXjOiu9fhyhAixCK0xKPhsRdEMrAAzk7+XYmyPYVLGAkEGnvNIMAyCkmU+DBavGNZhPqU=
X-Received: by 2002:a67:5e82:: with SMTP id s124mr175388vsb.9.1623163793390;
 Tue, 08 Jun 2021 07:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
 <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
In-Reply-To: <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 8 Jun 2021 16:49:42 +0200
Message-ID: <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 8 Jun 2021 at 16:37, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jun 8, 2021 at 4:52 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Sun, 6 Jun 2021 at 16:46, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > When a lower file has immutable/append-only attributes, the behavior of
> > > overlayfs post copy up is inconsistent.
> > >
> > > Immediattely after copy up, ovl inode still has the S_IMMUTABLE/S_APPEND
> > > inode flags copied from lower inode, so vfs code still treats the ovl
> > > inode as immutable/append-only.  After ovl inode evict or mount cycle,
> > > the ovl inode does not have these inode flags anymore.
> > >
> > > We cannot copy up the immutable and append-only fileattr flags, because
> > > immutable/append-only inodes cannot be linked and because overlayfs will
> > > not be able to set overlay.* xattr on the upper inodes.
> >
> > Ugh.
> >
> > > Instead, if any of the fileattr flags of interest exist on the lower
> > > inode, we set an xattr overlay.xflags on the upper inode as an indication
> > > to merge the origin inode fileattr flags on lookup.
> > >
> > > This gives consistent behavior post copy up regardless of inode eviction
> > > from cache.
> > >
> > > When user sets new fileattr flags, we break the connection with the
> > > origin fileattr by removing the overlay.xflags xattr.
> > >
> > > Note that having the S_IMMUTABLE/S_APPEND on the ovl inode does not
> > > provide the same level of protection as setting those flags on the real
> > > upper inode, because some filesystem check those flags internally in
> > > addition or instead of the vfs checks (e.g. btrfs_may_delete()), but
> > > that is the way it has always been for overlayfs.
> >
> > That's fine, underlying filesystem is just a backing store.
> >
>
> Immutability of underlying files was not my concern.
> My concern was that vfs does not provide full protection and that some
> protection is provided in fs level, because I saw IS_APPEND/IS_IMMUTABLE
> sprinkled all over the place in fs (e.g. ext4_setattr()), but I guess those are
> just leftovers and I was over concerned.

Would be a nice cleanup to get rid of these.   It would also prove
that the vfs protection is sufficient.

>
> > > As can be seen in the comment above ovl_check_origin_xflags(), the
> > > "xflags merge" feature is designed to solve other non-standard behavior
> > > issues related to immutable directories and hardlinks in the future, but
> > > this commit does not bother to fix those cases because those are corner
> > > cases that are probably not so important to fix.
> > >
> > > A word about the design decision to merge the origin and upper xflags -
> > > Because we do not copy up fileattr and because fileattr_set breaks the
> > > link to origin xflags, the only cases where origin and upper inodes both
> > > have xflags is if upper inode was modified not via overlayfs or if the
> > > system crashed during ovl_fileattr_set() before removing the
> > > overlay.xflags xattr.  In both cases, modifiying the upper inode is not
> > > going to be permitted, so it is better to reflect this in the overlay
> > > inode flags.
> >
> > So why not implement the non-merge (#3) behavior unconditionally?
> > That would solve all issues related to fileattr, right?
> >
>
> I suppose so. Note that #3 fileattr_get is still a merge between upper fileattr
> and the 4 overlay stored flags, but for inode flags it will not be a merge.
>
> I can give this a shot.
>
> While you are here, do you think that will be sufficient for the on-disk format
> of overlay.xflags?
>
> struct ovl_xflags {
>         __le32 xflags;
>         __le32 xflags_mask;
> }

I think I'd prefer a slightly more complex, but user friendlier
"+i,-a,..." format.

Thanks,
Miklos
