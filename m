Return-Path: <SRS0=do5T=BW=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88EF7C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 643FF207F7
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Aug 2020 15:21:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sFR7TArq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgHLPVi (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Aug 2020 11:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbgHLPVh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Aug 2020 11:21:37 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6637FC061383
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Aug 2020 08:21:36 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id j9so1983843ilc.11
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Aug 2020 08:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=BVCggW2moxQCnsGD1Ytm96c9dB41MpG1x4QRW15CEtc=;
        b=sFR7TArqXZS/KrtieE9sLKA6BUc9/viqrBlHXQ3oMTRd1GNoxymYKcoInIsp5D5L8H
         kfs7tGJFi5mZcU0hiPpMiYy8D9Jv8ZWsQoOKxehHodbBbTwMz0VI7bK4YSu5p2RwigAW
         7gAoovQdoU2yx1s2TN1u81SAZ51XFIWA8F4grw0Rijqc7V7NqEAfX3jfpJazeaHpXEQJ
         FXGSBpYfH1HxU2Lh6GuZNbeQjJn1EJnsxNiIVMP5TdCZlaH8gmcqNx2wfUsW0Ee1yJVP
         UFte3/ZuZMz1m+XH7WZH5iufgdbrzaTjG0+fMDxRgPnjIU5DLO4L2OnAKeMsEpSUr0P6
         2xcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=BVCggW2moxQCnsGD1Ytm96c9dB41MpG1x4QRW15CEtc=;
        b=H/eRUhX7ufs0Nk/ZeN0CiHhSXj4R/HqQCtqaqYGdmXHqpiQPW/GymzTwNXvLQFWkpl
         aQotlRRLaoHkEWYFOpCpnRnOSAMMS8jvqQAqWcN4o9S/4DVIX2EcSKooc2NKX2YL8X/H
         v9mY0ehcuL6+GZYNXZi/t1BI/z7AyoZl9qpq5m6bZUrAD8zv9R7RO3XJeQY8NDUc+kg5
         5/cqwwmUHuU4nDOgyYzdNx1uEhKR7Y+tbmfpC2MUztTa2rsUZYb9B/1xOzG5ZkClOfkS
         aa3/+sCJB5zizgsyIaD3gXuNHgHFQI6eynnwIQSOw5SUA7XWRdyCSmylwVhlnMEX3Gz6
         vMDA==
X-Gm-Message-State: AOAM533DxTniczCeEVM/sjSjD0KjdAf6zWKvTDIxSRfHBQxzioSVPj3p
        /0gYGJYMWyQpWpUoFrIVSzPmJmzxgQ76NF2UsxU6ql2E
X-Google-Smtp-Source: ABdhPJxhbww2ijFQyhTpEwhr3XJU3glcU7O+PBMWI179Dhi/ESpTQTQCvn+ny9VI4cFZQy2hECZ0gsIZl2wyTmQYGH0=
X-Received: by 2002:a05:6e02:dc3:: with SMTP id l3mr153803ilj.137.1597245695607;
 Wed, 12 Aug 2020 08:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200812135529.GA122370@kevinolos>
In-Reply-To: <20200812135529.GA122370@kevinolos>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 12 Aug 2020 18:21:24 +0300
Message-ID: <CAOQ4uxih2aDb7_LPSUb5Q4xBL5_gDaqtmC0M0M4EtCDgKLvi3w@mail.gmail.com>
Subject: Re: EIO for removed redirected files?
To:     Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 12, 2020 at 5:06 PM Kevin Locke <kevin@kevinlocke.name> wrote:
>
> Hi All,
>
> I recently encountered files on an overlayfs which returned EIO
> (Input/output error) for open, stat, and unlink (and presumably other)
> syscalls.  I eventually determined that the files had been redirected

It's *empty* redirected files that cause the alleged problem.
If files were not empty, the EIO would have been expected, because...

> and the target removed from the lower level.  The behavior can be
> reproduced as follows:
>
> # Create overlay with foo.txt on lower level
> mkdir -p lower upper work merged
> touch lower/foo.txt

Suppose this was:
echo 123 >  lower/foo.txt

> mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work,metacopy=on none merged
>
> # Redirect bar.txt on upper to foo.txt on lower
> mv merged/foo.txt merged/bar.txt
>

...this mv does not copy up "123" to foo.txt before renaming it to bar.txt...

> # Remove foo.txt on lower while unmounted
> umount merged
> rm lower/foo.txt
>
> # open, stat, and unlink on bar.txt now fail with EIO:
> mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work,metacopy=on none merged
> cat merged/bar.txt
> stat merged/bar.txt
> rm merged/bar.txt
>
> At this point, the only way to recover appears to be unmounting the
> overlay and removing the file from upper (or updating the
> overlay.redirect xattr to a valid location).  Is that correct?
>
> Is this the intended behavior?

Yes.
What would you expect to happen when data of metacopy file has been removed?

> I didn't see any tests covering it in

We have some tests in xfstests to prove that modifying underlying
layers does not
result in a crash, but otherwise the behavior is undefined, so it is
hard to write tests.
There is some code and tests in place for better behavior on
underlying file changes
like not exposing whiteouts in upper dir when lower dir was removed.

> unionmount-testsuite.  If so, perhaps the behavior could be noted in
> "Changes to underlying filesystems" in
> Documentation/filesystems/overlayfs.rst?  I'd be willing to write a
> first draft.  (I doubt I understand it well enough to get everything
> right on the first try.)
>

I guess the only thing we could document is that changes to underlying
layers with metacopy and redirects have undefined results.
Vivek was a proponent of making the statements about outcome of
changes to underlying layers sound more harsh.

> Also, if there is any way this could be made easier to debug, it might
> be helpful for users, particularly newbies like myself.  Perhaps logging
> bad redirects at KERN_ERR?  If that would be too noisy, perhaps only
> behind a debug module option?  Again, if this is acceptable I'd be
> willing to draft a patch.  (Same caveat as above.)
>

There are a handful of places in overlayfs where returning EIO is
combined with informative pr_warn_ratelimited().
You can see some examples in ovl_lookup(), which is where the reported
EIO is coming from:
        if (d.metacopy || (uppermetacopy && !ctr)) {
                err = -EIO;


Having said all that, metacopy and redirects on lower empty files seems
like an unintentional outcome.

If you care about this use case particularly, you may try this untested patch:

Thanks,
Amir.

---
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d07fb92b7253..178067cb6583 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -764,7 +764,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
        return err;
 }

-static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
+static bool ovl_need_meta_copy_up(struct dentry *dentry, struct kstat *stat,
                                  int flags)
 {
        struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
@@ -772,7 +772,7 @@ static bool ovl_need_meta_copy_up(struct dentry
*dentry, umode_t mode,
        if (!ofs->config.metacopy)
                return false;

-       if (!S_ISREG(mode))
+       if (!S_ISREG(stat->mode) || !stat->size)
                return false;

        if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
@@ -852,8 +852,6 @@ static int ovl_copy_up_one(struct dentry *parent,
struct dentry *dentry,
        if (err)
                return err;

-       ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
-
        if (parent) {
                ovl_path_upper(parent, &parentpath);
                ctx.destdir = parentpath.dentry;
@@ -870,6 +868,8 @@ static int ovl_copy_up_one(struct dentry *parent,
struct dentry *dentry,
        if (flags & O_TRUNC)
                ctx.stat.size = 0;

+       ctx.metacopy = ovl_need_meta_copy_up(dentry, &ctx.stat, flags);
+
        if (S_ISLNK(ctx.stat.mode)) {
                ctx.link = vfs_get_link(ctx.lowerpath.dentry, &done);
                if (IS_ERR(ctx.link))
