Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6378FC47095
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Jun 2021 06:09:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ADF660C40
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Jun 2021 06:09:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236407AbhFIGLI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 9 Jun 2021 02:11:08 -0400
Received: from mail-il1-f177.google.com ([209.85.166.177]:35628 "EHLO
        mail-il1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbhFIGLH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 Jun 2021 02:11:07 -0400
Received: by mail-il1-f177.google.com with SMTP id b9so23667408ilr.2
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Jun 2021 23:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lj/BCYnttTBnraC9miK4b2eThv+IuVdZmVSWqtlFLQ0=;
        b=CLarFyVDu2ALsBKKff8HX9I3paADw2Zi70mNvyebozXc2CHhsTJmNszsqCHi+xe06I
         RHOSJ95r+KCwVQXj+BP3MseIn7k9Ljhmn2KO8UwlaKVU8uqo3GvsilOT0YDF9ulcNXJ3
         tI158kQPVEgLdoKm0rmDGOBO3UDLnZJVf9Zd5kXys9zmGXS1dd1ySeGNboN/yG7EH46p
         LQ0v3jKH43oHRZs/KsKG9Fvc4HvZh7nKta+WeudFCtjwPPxX7TJUbKMnshOF4Mjftg2x
         sS6cCAjll3usxeLAMf1cPeEip+SCEDilfneC5qG2PG1DFzs2T/7HcF4iyha8PbvaPmgf
         GPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lj/BCYnttTBnraC9miK4b2eThv+IuVdZmVSWqtlFLQ0=;
        b=jj6fahc9ItDuVsRiSewzRbZZGp5CPoJuD3GoT9MgpzFXo0RTeg0aj4DzFqDeHLgaGb
         8eA4ht/bZOwBLdGpKnggkqcgUjLldt+Vej4/78osn/q9loDo3CyZuGplHrgjRKBoYUuv
         nd7LPuC6IVbI1vOshAd2n8PCWOl7hsusZOt/KxPPJQ+9qQKn+y+JlHbkYKzlMhDoqzO2
         j8IpyDrGGVMj+0agZlkRCLFnBXaqqHK0D+0fpWpCFom3xcLKO6PLCjgl9SrqjRf0Q8de
         8XnLApQ7VGPu5V9icoQ0d83gN4ZNrFImTZP75t6WPWMS+l752Zx6kq8pHiWxndyIeeCJ
         unhw==
X-Gm-Message-State: AOAM532MK6Fs9JWjVP0PuT/Db3l8G69psIDK1vD+7FF/yQmLI1ZQNy9x
        SUjFpso5ynDWOIZRFv2kpZg5I20DyUgY59Ujsolj6oyK2xI=
X-Google-Smtp-Source: ABdhPJw8DVOGfhzZd6NWCXeAN+D81hvAntKsrFUhXaG4epkSkH3UNMtrd6Lx6G1ojzOZXLcpyQpyKM6xhGggFaI0wnQ=
X-Received: by 2002:a05:6e02:14a:: with SMTP id j10mr23723431ilr.250.1623218893398;
 Tue, 08 Jun 2021 23:08:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
 <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
 <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com>
 <CAOQ4uxiqxJBHkiDDuPvL=pMvfqkPadDWReLOwzGpiEn3BBwcjQ@mail.gmail.com> <CAJfpegtC+bg3_onOuzQv116axuX36y13P-_ojA5ZOUjfdTPR-g@mail.gmail.com>
In-Reply-To: <CAJfpegtC+bg3_onOuzQv116axuX36y13P-_ojA5ZOUjfdTPR-g@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 9 Jun 2021 09:08:02 +0300
Message-ID: <CAOQ4uxheGdKSqEBYAOTf7=UwqeW=JAaZBwaCs-ng28G7rtqZ7Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 8, 2021 at 9:20 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Tue, 8 Jun 2021 at 17:33, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Jun 8, 2021 at 5:49 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Tue, 8 Jun 2021 at 16:37, Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > On Tue, Jun 8, 2021 at 4:52 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > >
> > > > > On Sun, 6 Jun 2021 at 16:46, Amir Goldstein <amir73il@gmail.com> wrote:
> > > > > >
> > > > > > When a lower file has immutable/append-only attributes, the behavior of
> > > > > > overlayfs post copy up is inconsistent.
> > > > > >
> > > > > > Immediattely after copy up, ovl inode still has the S_IMMUTABLE/S_APPEND
> > > > > > inode flags copied from lower inode, so vfs code still treats the ovl
> > > > > > inode as immutable/append-only.  After ovl inode evict or mount cycle,
> > > > > > the ovl inode does not have these inode flags anymore.
> > > > > >
> > > > > > We cannot copy up the immutable and append-only fileattr flags, because
> > > > > > immutable/append-only inodes cannot be linked and because overlayfs will
> > > > > > not be able to set overlay.* xattr on the upper inodes.
> > > > >
> > > > > Ugh.
> > > > >
> > > > > > Instead, if any of the fileattr flags of interest exist on the lower
> > > > > > inode, we set an xattr overlay.xflags on the upper inode as an indication
> > > > > > to merge the origin inode fileattr flags on lookup.
> > > > > >
> > > > > > This gives consistent behavior post copy up regardless of inode eviction
> > > > > > from cache.
> > > > > >
> > > > > > When user sets new fileattr flags, we break the connection with the
> > > > > > origin fileattr by removing the overlay.xflags xattr.
> > > > > >
> > > > > > Note that having the S_IMMUTABLE/S_APPEND on the ovl inode does not
> > > > > > provide the same level of protection as setting those flags on the real
> > > > > > upper inode, because some filesystem check those flags internally in
> > > > > > addition or instead of the vfs checks (e.g. btrfs_may_delete()), but
> > > > > > that is the way it has always been for overlayfs.
> > > > >
> > > > > That's fine, underlying filesystem is just a backing store.
> > > > >
> > > >
> > > > Immutability of underlying files was not my concern.
> > > > My concern was that vfs does not provide full protection and that some
> > > > protection is provided in fs level, because I saw IS_APPEND/IS_IMMUTABLE
> > > > sprinkled all over the place in fs (e.g. ext4_setattr()), but I guess those are
> > > > just leftovers and I was over concerned.
> > >
> > > Would be a nice cleanup to get rid of these.   It would also prove
> > > that the vfs protection is sufficient.
> > >
> > > >
> > > > > > As can be seen in the comment above ovl_check_origin_xflags(), the
> > > > > > "xflags merge" feature is designed to solve other non-standard behavior
> > > > > > issues related to immutable directories and hardlinks in the future, but
> > > > > > this commit does not bother to fix those cases because those are corner
> > > > > > cases that are probably not so important to fix.
> > > > > >
> > > > > > A word about the design decision to merge the origin and upper xflags -
> > > > > > Because we do not copy up fileattr and because fileattr_set breaks the
> > > > > > link to origin xflags, the only cases where origin and upper inodes both
> > > > > > have xflags is if upper inode was modified not via overlayfs or if the
> > > > > > system crashed during ovl_fileattr_set() before removing the
> > > > > > overlay.xflags xattr.  In both cases, modifiying the upper inode is not
> > > > > > going to be permitted, so it is better to reflect this in the overlay
> > > > > > inode flags.
> > > > >
> > > > > So why not implement the non-merge (#3) behavior unconditionally?
> > > > > That would solve all issues related to fileattr, right?
> > > > >
> > > >
> > > > I suppose so. Note that #3 fileattr_get is still a merge between upper fileattr
> > > > and the 4 overlay stored flags, but for inode flags it will not be a merge.
> > > >
> > > > I can give this a shot.
> > > >
> > > > While you are here, do you think that will be sufficient for the on-disk format
> > > > of overlay.xflags?
> > > >
> > > > struct ovl_xflags {
> > > >         __le32 xflags;
> > > >         __le32 xflags_mask;
> > > > }
> > >
> > > I think I'd prefer a slightly more complex, but user friendlier
> > > "+i,-a,..." format.
> > >
> >
> > OK, but since this is not a merge, we'd only need:
> > overlay.xflags = "ia..."
> >
> > Which is compatible with the format of:
> > chattr =<xflags> <file>
>
> Fine.   Not sure what xflags_mask would be useful for in your proposal, though.
>

The idea was that in the context of fileattr_get(), any specific xflag
value can be one of: SET, CLEAR, REAL.

For most inodes all flags are REAL (no xflags xattr)
All flags but the 4 in OVL_FS_XFLAGS_MASK are always REAL
(i.e. taken from fileattr_get() on real inode).

If we ever decide to extend OVL_FS_XFLAGS_MASK, say to include
DIRSYNC, then an upper inode with DIRSYNC that was in state
REAL before upgrade would become CLEAR after upgrade unless
we kept the old xflags_mask in xattr.

With the string format, this is not a concern.
Therefore, I like the string format better.

Thanks,
Amir.
