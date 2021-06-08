Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4F7C47082
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Jun 2021 14:38:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA6C261029
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Jun 2021 14:38:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhFHOks (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 10:40:48 -0400
Received: from mail-io1-f44.google.com ([209.85.166.44]:44801 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbhFHOkr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Jun 2021 10:40:47 -0400
Received: by mail-io1-f44.google.com with SMTP id v9so22407848ion.11
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Jun 2021 07:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ho4W7zN8HbRUFsP+5OO6Cj4/Lc//8nxQqSyahgJrVuE=;
        b=ec55AHg/twFN5lAF2vD7/jP509CeocQYSY7mKtpFG4JZ3vAlDzRIGfU9jFyG/hlLPM
         9/UGKCE78N++CLJPLzcOcTRJsOW5WRtHkzpz63f2pqCjuURz9yp7Z8+e1Fi14A7sSsxT
         rSh3KT0YTXtctHF4rZn6cLsqFC1VBrcQCCqJ4fpKtVVdgngJqxO0HJ8B4JDtkHYBOrFT
         xzf9k/7oYluUARsoxVw4lgkqlcI1TdXkBtaEQMpKX6zaMQFv26U2/9v7WKp+wBev74iB
         81ndRoQJqS7RiWhw4pkdserfseEzSJm6fBCjC+Te3wPRBc7zpHRtSEO+1f424AJwu9NG
         CC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ho4W7zN8HbRUFsP+5OO6Cj4/Lc//8nxQqSyahgJrVuE=;
        b=oFZbxHG0K9yYbJ147NkrZpDLe0QiDPwFDttw71wT5JqeYE5iHVcORjy3/c4Mj8IJC7
         AB36EmTI9ONUYb6TzgtjNWtxgixw5dJZaSS9J6jq0sBYI6qGRZYEH7cp/ZPLgzR/EgvT
         FbfC3hJeNMg1Jzf9M6Q85yRFMvZ/NeTugxmxzjpo3XSUItVloMVYNulG+HH/UxJvH9iA
         T0LVyBKjjmLtjeRykvMRnhLy/Tec8ID9Ivc4VGBMD0v74Rcyjgm3jK8mQCTemZUMTlRg
         5FyzdPjcTDZY0hklW4DYDH9hLuhDqUOWk5UfJY6LlJMAb8F3no0K7GyTXeakoVCnWeuU
         qDHQ==
X-Gm-Message-State: AOAM5310I50N4JHVlsf7eKvFegraZdAJb8S8RypD/RT2luBJHD4TDwJR
        vuWA3yG92birkCZOwmMUTAYYlXehd0WxpHHHMlw=
X-Google-Smtp-Source: ABdhPJwljS40iV7naq6WKBmhMMxQGRNhjazEChpfk+5rD+gB4gYBxM/ahNSSCRoTK0oac0gIQYqc/ya4c5kz9hRBw2Q=
X-Received: by 2002:a6b:7b41:: with SMTP id m1mr16935500iop.186.1623163074775;
 Tue, 08 Jun 2021 07:37:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
In-Reply-To: <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 8 Jun 2021 17:37:43 +0300
Message-ID: <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 8, 2021 at 4:52 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Sun, 6 Jun 2021 at 16:46, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > When a lower file has immutable/append-only attributes, the behavior of
> > overlayfs post copy up is inconsistent.
> >
> > Immediattely after copy up, ovl inode still has the S_IMMUTABLE/S_APPEND
> > inode flags copied from lower inode, so vfs code still treats the ovl
> > inode as immutable/append-only.  After ovl inode evict or mount cycle,
> > the ovl inode does not have these inode flags anymore.
> >
> > We cannot copy up the immutable and append-only fileattr flags, because
> > immutable/append-only inodes cannot be linked and because overlayfs will
> > not be able to set overlay.* xattr on the upper inodes.
>
> Ugh.
>
> > Instead, if any of the fileattr flags of interest exist on the lower
> > inode, we set an xattr overlay.xflags on the upper inode as an indication
> > to merge the origin inode fileattr flags on lookup.
> >
> > This gives consistent behavior post copy up regardless of inode eviction
> > from cache.
> >
> > When user sets new fileattr flags, we break the connection with the
> > origin fileattr by removing the overlay.xflags xattr.
> >
> > Note that having the S_IMMUTABLE/S_APPEND on the ovl inode does not
> > provide the same level of protection as setting those flags on the real
> > upper inode, because some filesystem check those flags internally in
> > addition or instead of the vfs checks (e.g. btrfs_may_delete()), but
> > that is the way it has always been for overlayfs.
>
> That's fine, underlying filesystem is just a backing store.
>

Immutability of underlying files was not my concern.
My concern was that vfs does not provide full protection and that some
protection is provided in fs level, because I saw IS_APPEND/IS_IMMUTABLE
sprinkled all over the place in fs (e.g. ext4_setattr()), but I guess those are
just leftovers and I was over concerned.

> > As can be seen in the comment above ovl_check_origin_xflags(), the
> > "xflags merge" feature is designed to solve other non-standard behavior
> > issues related to immutable directories and hardlinks in the future, but
> > this commit does not bother to fix those cases because those are corner
> > cases that are probably not so important to fix.
> >
> > A word about the design decision to merge the origin and upper xflags -
> > Because we do not copy up fileattr and because fileattr_set breaks the
> > link to origin xflags, the only cases where origin and upper inodes both
> > have xflags is if upper inode was modified not via overlayfs or if the
> > system crashed during ovl_fileattr_set() before removing the
> > overlay.xflags xattr.  In both cases, modifiying the upper inode is not
> > going to be permitted, so it is better to reflect this in the overlay
> > inode flags.
>
> So why not implement the non-merge (#3) behavior unconditionally?
> That would solve all issues related to fileattr, right?
>

I suppose so. Note that #3 fileattr_get is still a merge between upper fileattr
and the 4 overlay stored flags, but for inode flags it will not be a merge.

I can give this a shot.

While you are here, do you think that will be sufficient for the on-disk format
of overlay.xflags?

struct ovl_xflags {
        __le32 xflags;
        __le32 xflags_mask;
}

Thanks,
Amir.
