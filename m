Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1283CC47082
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Jun 2021 15:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E589B61263
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Jun 2021 15:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhFHPfQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 11:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231165AbhFHPfP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Jun 2021 11:35:15 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052BEC061787
        for <linux-unionfs@vger.kernel.org>; Tue,  8 Jun 2021 08:33:22 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id f10so8159574iok.6
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Jun 2021 08:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zlsmTSuK6wpXiaTeUWXt8WbH6Dmu2gN0WI8EDhQ6jTw=;
        b=Ew1PJrXI/YDW7HiKaLJt+ekeXTwRw+DJxkMXuQBITQA9o4baEy4oif3i9ecWpXEdCB
         j9JWVG63uNO8MODxKh5GoG4jK+pFE7oblt4H/zwD2NkZcCjiHyQpUeL4ZNVJiyyFPaWC
         XnNV62nm+Cne2qXDbmcf8wkTZUUHVsx8Hh8+wvWoTAOHJGGyOUNPpMFLsNxl3JULIRno
         r+fN9RXzQGGig42fEIdBmp/oobwwdXYO5OC+twY9XhDHynxHXBACAK+DO5XTVv6JV/LH
         rUHzLEJ8GHX146t4vqlcxabDTCbieA4fAsdxepHn4Ed5ZeQ1l1pvq+kckbN26mEXokmQ
         gSaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zlsmTSuK6wpXiaTeUWXt8WbH6Dmu2gN0WI8EDhQ6jTw=;
        b=GP3LYX2g1LeyL87a4+0fmXUhrl9jljAvqEh5Eh6Kr7HYEU9LyYhL7XhJzURqhKBIaT
         arg7gwB5oRcg/L5AGT4yI3bfN+7Dm8PzsC0t6By66seOlAJ2x1egu26J3mTwYKQBZAXH
         PRGN+z+2xEOuDEHXY7LwU5egbZJfcY2px/+XgXSCuPPtfFl4ltqWPtUU52DdfGBZpqN/
         DOlHh+h7Fgzx/hG5O1gjBRDupPqZPcUztXiSV4C6Vvnv5zlgxJd5UT2GI9+I90tXKNQR
         lxasZCUcBCXIhW1Drjc+WMqVEUuuhkc7nLB2uGAWOsuZDAQhzcpiWHAw35gSfd2QqY8Z
         xn6w==
X-Gm-Message-State: AOAM532Yq36Ehx9trs51N/tV9FxVKXg6yDaC5f+5Qp+crfrLtDD5CO5g
        PmpuVKKkXXIKqFWa1F0cNiDjEtA9/p46Rx+GS66vF2N8
X-Google-Smtp-Source: ABdhPJyX4U3kwrC2aBx5SboytF9v9dXQbsxitNkh/WChlBcgiSGEcNxGUOepRhY6jw4QcUIsEoOCgIpYSnymPJPVGB0=
X-Received: by 2002:a6b:7b41:: with SMTP id m1mr17129315iop.186.1623166402174;
 Tue, 08 Jun 2021 08:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
 <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com> <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com>
In-Reply-To: <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 8 Jun 2021 18:33:11 +0300
Message-ID: <CAOQ4uxiqxJBHkiDDuPvL=pMvfqkPadDWReLOwzGpiEn3BBwcjQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 8, 2021 at 5:49 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, 8 Jun 2021 at 16:37, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Jun 8, 2021 at 4:52 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Sun, 6 Jun 2021 at 16:46, Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > When a lower file has immutable/append-only attributes, the behavior of
> > > > overlayfs post copy up is inconsistent.
> > > >
> > > > Immediattely after copy up, ovl inode still has the S_IMMUTABLE/S_APPEND
> > > > inode flags copied from lower inode, so vfs code still treats the ovl
> > > > inode as immutable/append-only.  After ovl inode evict or mount cycle,
> > > > the ovl inode does not have these inode flags anymore.
> > > >
> > > > We cannot copy up the immutable and append-only fileattr flags, because
> > > > immutable/append-only inodes cannot be linked and because overlayfs will
> > > > not be able to set overlay.* xattr on the upper inodes.
> > >
> > > Ugh.
> > >
> > > > Instead, if any of the fileattr flags of interest exist on the lower
> > > > inode, we set an xattr overlay.xflags on the upper inode as an indication
> > > > to merge the origin inode fileattr flags on lookup.
> > > >
> > > > This gives consistent behavior post copy up regardless of inode eviction
> > > > from cache.
> > > >
> > > > When user sets new fileattr flags, we break the connection with the
> > > > origin fileattr by removing the overlay.xflags xattr.
> > > >
> > > > Note that having the S_IMMUTABLE/S_APPEND on the ovl inode does not
> > > > provide the same level of protection as setting those flags on the real
> > > > upper inode, because some filesystem check those flags internally in
> > > > addition or instead of the vfs checks (e.g. btrfs_may_delete()), but
> > > > that is the way it has always been for overlayfs.
> > >
> > > That's fine, underlying filesystem is just a backing store.
> > >
> >
> > Immutability of underlying files was not my concern.
> > My concern was that vfs does not provide full protection and that some
> > protection is provided in fs level, because I saw IS_APPEND/IS_IMMUTABLE
> > sprinkled all over the place in fs (e.g. ext4_setattr()), but I guess those are
> > just leftovers and I was over concerned.
>
> Would be a nice cleanup to get rid of these.   It would also prove
> that the vfs protection is sufficient.
>
> >
> > > > As can be seen in the comment above ovl_check_origin_xflags(), the
> > > > "xflags merge" feature is designed to solve other non-standard behavior
> > > > issues related to immutable directories and hardlinks in the future, but
> > > > this commit does not bother to fix those cases because those are corner
> > > > cases that are probably not so important to fix.
> > > >
> > > > A word about the design decision to merge the origin and upper xflags -
> > > > Because we do not copy up fileattr and because fileattr_set breaks the
> > > > link to origin xflags, the only cases where origin and upper inodes both
> > > > have xflags is if upper inode was modified not via overlayfs or if the
> > > > system crashed during ovl_fileattr_set() before removing the
> > > > overlay.xflags xattr.  In both cases, modifiying the upper inode is not
> > > > going to be permitted, so it is better to reflect this in the overlay
> > > > inode flags.
> > >
> > > So why not implement the non-merge (#3) behavior unconditionally?
> > > That would solve all issues related to fileattr, right?
> > >
> >
> > I suppose so. Note that #3 fileattr_get is still a merge between upper fileattr
> > and the 4 overlay stored flags, but for inode flags it will not be a merge.
> >
> > I can give this a shot.
> >
> > While you are here, do you think that will be sufficient for the on-disk format
> > of overlay.xflags?
> >
> > struct ovl_xflags {
> >         __le32 xflags;
> >         __le32 xflags_mask;
> > }
>
> I think I'd prefer a slightly more complex, but user friendlier
> "+i,-a,..." format.
>

OK, but since this is not a merge, we'd only need:
overlay.xflags = "ia..."

Which is compatible with the format of:
chattr =<xflags> <file>

Thanks,
Amir.
