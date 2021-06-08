Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C21F4C4743E
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Jun 2021 13:52:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA6C260240
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Jun 2021 13:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhFHNyq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 8 Jun 2021 09:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhFHNyp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Jun 2021 09:54:45 -0400
Received: from mail-vs1-xe2f.google.com (mail-vs1-xe2f.google.com [IPv6:2607:f8b0:4864:20::e2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BB8C061787
        for <linux-unionfs@vger.kernel.org>; Tue,  8 Jun 2021 06:52:44 -0700 (PDT)
Received: by mail-vs1-xe2f.google.com with SMTP id j15so10896353vsf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 08 Jun 2021 06:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HOI/reEO38wVSgGlvdEwy91O3/F65dg6jltPcZvTy+8=;
        b=J3FYblOl2IxKk0mwZwaznsUrB6+5a7Q3Wptq4Ht/urEXWl/CTNSGPRQCmjagbqYfC0
         AW25yKoOHXOuFwNrg5nAANmBuldrxtZY7OCp8wdeR8IRt8KoiBfEuMzUjaYtpLofjqJR
         QxuBthcaMeiO1xHXaDd9LO2UMb8MpU76tnLyo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HOI/reEO38wVSgGlvdEwy91O3/F65dg6jltPcZvTy+8=;
        b=oPK+X0ZkHuRK1PBW7Zw/FMG4wYK9HSq5MRjufOHnjsvZPkR1NFoNGQ0oPL+C1gpCKC
         rhUMr3Knm538nYvxWW7PLfBomJtt6f1xCsVM+ZCRGl9CIm2lL39P6/d/x/Flb/QviBmM
         Fh7vF7ZEB/55/wGHducy0Z7bh4mYoFZH+sbwPpwWQG4sHj6W+mgRghmAIfNAUw8kDF3R
         cV2wQ8vEm3bZ1Qg34wcYXgcHcM59b8+o77NS7H6guWeKcMfCKvywL14oQZ73GButFghL
         UpQEe4aQZM9OEf3wvRKeaCanGpzS/b8Op4nIJXDMrJKx/zfrDhCCYY9wjM7C4IdFYQn/
         mjuA==
X-Gm-Message-State: AOAM531i4uMJp/kIqr7f5trcswIIP7S+aCPb7nNvONBnRxkM6BhhkukI
        OTi+wIrVAP9D7DQ260Z4ls32dwJN6hdPOCk7FNcylQ==
X-Google-Smtp-Source: ABdhPJwGyI6KzuhbLsXtxqkQarG/s7fx8WsBchNWh+F4nKo8hsUMZi6O8Qlq3sidGi7V8wbt7RdEi9QxRPs4OUojX3Y=
X-Received: by 2002:a05:6102:2144:: with SMTP id h4mr237036vsg.21.1623160363914;
 Tue, 08 Jun 2021 06:52:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com>
In-Reply-To: <20210606144641.419138-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 8 Jun 2021 15:52:32 +0200
Message-ID: <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, 6 Jun 2021 at 16:46, Amir Goldstein <amir73il@gmail.com> wrote:
>
> When a lower file has immutable/append-only attributes, the behavior of
> overlayfs post copy up is inconsistent.
>
> Immediattely after copy up, ovl inode still has the S_IMMUTABLE/S_APPEND
> inode flags copied from lower inode, so vfs code still treats the ovl
> inode as immutable/append-only.  After ovl inode evict or mount cycle,
> the ovl inode does not have these inode flags anymore.
>
> We cannot copy up the immutable and append-only fileattr flags, because
> immutable/append-only inodes cannot be linked and because overlayfs will
> not be able to set overlay.* xattr on the upper inodes.

Ugh.

> Instead, if any of the fileattr flags of interest exist on the lower
> inode, we set an xattr overlay.xflags on the upper inode as an indication
> to merge the origin inode fileattr flags on lookup.
>
> This gives consistent behavior post copy up regardless of inode eviction
> from cache.
>
> When user sets new fileattr flags, we break the connection with the
> origin fileattr by removing the overlay.xflags xattr.
>
> Note that having the S_IMMUTABLE/S_APPEND on the ovl inode does not
> provide the same level of protection as setting those flags on the real
> upper inode, because some filesystem check those flags internally in
> addition or instead of the vfs checks (e.g. btrfs_may_delete()), but
> that is the way it has always been for overlayfs.

That's fine, underlying filesystem is just a backing store.

> As can be seen in the comment above ovl_check_origin_xflags(), the
> "xflags merge" feature is designed to solve other non-standard behavior
> issues related to immutable directories and hardlinks in the future, but
> this commit does not bother to fix those cases because those are corner
> cases that are probably not so important to fix.
>
> A word about the design decision to merge the origin and upper xflags -
> Because we do not copy up fileattr and because fileattr_set breaks the
> link to origin xflags, the only cases where origin and upper inodes both
> have xflags is if upper inode was modified not via overlayfs or if the
> system crashed during ovl_fileattr_set() before removing the
> overlay.xflags xattr.  In both cases, modifiying the upper inode is not
> going to be permitted, so it is better to reflect this in the overlay
> inode flags.

So why not implement the non-merge (#3) behavior unconditionally?
That would solve all issues related to fileattr, right?

Thanks,
Miklos
