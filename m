Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B012C47082
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Jun 2021 18:20:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39A026136D
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Jun 2021 18:20:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhFHSWX (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 14:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233348AbhFHSWX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Jun 2021 14:22:23 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2E4C061574
        for <linux-unionfs@vger.kernel.org>; Tue,  8 Jun 2021 11:20:29 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id y207so3044394vsy.12
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Jun 2021 11:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1AXWHGUf/bQBHPim1zsT4mm7vxF6oH7pHgZ4xmNbjrE=;
        b=hI+Z+Ch4rwMFf3Tl6D0VqqyynmS1JiIILebG0n5YHm2Uvh8VROSmuee9qkewK0r4Jj
         yd4bQ11Ve5jpcYV7dvy6lBHLytzzdLVZkdIW53CQjBvTM3263RxZrK2fwDxv4Qf4PVma
         fPIh5mK/AJUv9tLJ5h7ISbeoX1btbLQxFDWS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1AXWHGUf/bQBHPim1zsT4mm7vxF6oH7pHgZ4xmNbjrE=;
        b=ZtTwWPDd6q8ZY6NgQlDz0s3GfD+BMC3wyoaWxFxw34hCZ9/gWr/+t8TmzdAY/w2+TG
         nuVpHMkm4Cm+j/Mo9Pa/jgZkH3/aeh6Edrbf0xutp4/IHQH6vIY3GxlbGS+Jocf3d/7m
         /AKHwp91jT/ozpIQVzatIPNXPkvyxeeI56hj6lD4lKXvS/reIG2uomCTKX8SuG/mID5o
         iya7GDEmrPikYG1S8GZK6gpPHuZdq55IyZkChoYC84dOrF1oQEu1bRptopwGRrDJ/5wd
         11Oaw51srqSbzEDKDJrHRxheFjMmxni+sqkBYQnuxEyAX9ScMZHGIbQTuQsCd7s/sFTH
         48Qw==
X-Gm-Message-State: AOAM5313rnVSk2B2+E2/aHZjntZIrXqJnwsps0p2d7Cwv2mwCWZo5iNP
        xk1UxYWVMO6LM83Ke5zvIXOyB5jE2/Ag/pwRG3xx4UwxlWY=
X-Google-Smtp-Source: ABdhPJx9tiAMQJX/PoDXtz2kZkg+jiBSCnB6j7HZHDFfrWLiy88iUIMQVAKrtnmLBQb1t4hsubXg2oK3dY57I5sSSW0=
X-Received: by 2002:a67:bb14:: with SMTP id m20mr1682772vsn.0.1623176429078;
 Tue, 08 Jun 2021 11:20:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
 <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
 <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com> <CAOQ4uxiqxJBHkiDDuPvL=pMvfqkPadDWReLOwzGpiEn3BBwcjQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiqxJBHkiDDuPvL=pMvfqkPadDWReLOwzGpiEn3BBwcjQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 8 Jun 2021 20:20:18 +0200
Message-ID: <CAJfpegtC+bg3_onOuzQv116axuX36y13P-_ojA5ZOUjfdTPR-g@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 8 Jun 2021 at 17:33, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Jun 8, 2021 at 5:49 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Tue, 8 Jun 2021 at 16:37, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Tue, Jun 8, 2021 at 4:52 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Sun, 6 Jun 2021 at 16:46, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > >
> > > > > When a lower file has immutable/append-only attributes, the behavior of
> > > > > overlayfs post copy up is inconsistent.
> > > > >
> > > > > Immediattely after copy up, ovl inode still has the S_IMMUTABLE/S_APPEND
> > > > > inode flags copied from lower inode, so vfs code still treats the ovl
> > > > > inode as immutable/append-only.  After ovl inode evict or mount cycle,
> > > > > the ovl inode does not have these inode flags anymore.
> > > > >
> > > > > We cannot copy up the immutable and append-only fileattr flags, because
> > > > > immutable/append-only inodes cannot be linked and because overlayfs will
> > > > > not be able to set overlay.* xattr on the upper inodes.
> > > >
> > > > Ugh.
> > > >
> > > > > Instead, if any of the fileattr flags of interest exist on the lower
> > > > > inode, we set an xattr overlay.xflags on the upper inode as an indication
> > > > > to merge the origin inode fileattr flags on lookup.
> > > > >
> > > > > This gives consistent behavior post copy up regardless of inode eviction
> > > > > from cache.
> > > > >
> > > > > When user sets new fileattr flags, we break the connection with the
> > > > > origin fileattr by removing the overlay.xflags xattr.
> > > > >
> > > > > Note that having the S_IMMUTABLE/S_APPEND on the ovl inode does not
> > > > > provide the same level of protection as setting those flags on the real
> > > > > upper inode, because some filesystem check those flags internally in
> > > > > addition or instead of the vfs checks (e.g. btrfs_may_delete()), but
> > > > > that is the way it has always been for overlayfs.
> > > >
> > > > That's fine, underlying filesystem is just a backing store.
> > > >
> > >
> > > Immutability of underlying files was not my concern.
> > > My concern was that vfs does not provide full protection and that some
> > > protection is provided in fs level, because I saw IS_APPEND/IS_IMMUTABLE
> > > sprinkled all over the place in fs (e.g. ext4_setattr()), but I guess those are
> > > just leftovers and I was over concerned.
> >
> > Would be a nice cleanup to get rid of these.   It would also prove
> > that the vfs protection is sufficient.
> >
> > >
> > > > > As can be seen in the comment above ovl_check_origin_xflags(), the
> > > > > "xflags merge" feature is designed to solve other non-standard behavior
> > > > > issues related to immutable directories and hardlinks in the future, but
> > > > > this commit does not bother to fix those cases because those are corner
> > > > > cases that are probably not so important to fix.
> > > > >
> > > > > A word about the design decision to merge the origin and upper xflags -
> > > > > Because we do not copy up fileattr and because fileattr_set breaks the
> > > > > link to origin xflags, the only cases where origin and upper inodes both
> > > > > have xflags is if upper inode was modified not via overlayfs or if the
> > > > > system crashed during ovl_fileattr_set() before removing the
> > > > > overlay.xflags xattr.  In both cases, modifiying the upper inode is not
> > > > > going to be permitted, so it is better to reflect this in the overlay
> > > > > inode flags.
> > > >
> > > > So why not implement the non-merge (#3) behavior unconditionally?
> > > > That would solve all issues related to fileattr, right?
> > > >
> > >
> > > I suppose so. Note that #3 fileattr_get is still a merge between upper fileattr
> > > and the 4 overlay stored flags, but for inode flags it will not be a merge.
> > >
> > > I can give this a shot.
> > >
> > > While you are here, do you think that will be sufficient for the on-disk format
> > > of overlay.xflags?
> > >
> > > struct ovl_xflags {
> > >         __le32 xflags;
> > >         __le32 xflags_mask;
> > > }
> >
> > I think I'd prefer a slightly more complex, but user friendlier
> > "+i,-a,..." format.
> >
>
> OK, but since this is not a merge, we'd only need:
> overlay.xflags = "ia..."
>
> Which is compatible with the format of:
> chattr =<xflags> <file>

Fine.   Not sure what xflags_mask would be useful for in your proposal, though.

Thanks,
Miklos
