Return-Path: <SRS0=nA/m=5J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE672C43331
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Mar 2020 10:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9656E2080C
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Mar 2020 10:20:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFwv1HpC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgCXKUU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 06:20:20 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:37130 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgCXKUU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Mar 2020 06:20:20 -0400
Received: by mail-il1-f193.google.com with SMTP id a6so3802619ilr.4
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2020 03:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2AVesd1OaHz26Y8Q5a+U3PWN2t5We6ygsL3cCUK91Sg=;
        b=KFwv1HpCSq6gBh2iSphmrQ8VdSkHWadDCeyghevhB+zf0KDVcjWNfQRqvq1r4JUWxi
         My58+Jan5Xz/DP+z6Ey2dIu1jSJhHzgJo36h0fRVqS9xIdehScuA274sE0BtkKsOuq47
         Cnb5Xx4bHrOWuNVCdWpZn7qFQYQIWo5NgvjnPzqH95HsWoQD0tpz0KAjVAjP/S8oQ4xs
         ksTENCHEFt1fq4yUb2gLiQvfA1wpYG+FD2/jxVXFgJKRNselVjaW1vi4FWGbIhNpb5Cf
         xioMY9sNMyL7q0KlyvB5Hhwr+7WvgvqNzyAOLlZlz4//tSwOmrLsL3HBibeyFtQObSoh
         OoQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2AVesd1OaHz26Y8Q5a+U3PWN2t5We6ygsL3cCUK91Sg=;
        b=g47B4lQJBh8uvH6l50Go0jYb9aY4De5bRtpvx3vLp9IaKtuVkVFs48muY0EKxpCGra
         +uKR8qet9fOTp/g9wlJSMTE5LJ0PuDGreehMiqMGWnz0jvx2WjHHEWUGPvJ6nmZUei4a
         QP9jQmv6le1GAR3f/tezKIYjHn1CMpE3fv0O3q6242XTSJ8y0fuUyDMnMCng41uGU/LD
         /DsItv5O9u+7hpyBpl1D9PC2wHTy+X9E6etDMmxoey22+/ij0Gtf4GH6si4ZSg51RYeb
         m8LCjIJnKtpUbsvhjYiIGfGkYhJ+ZImbPbgdbXN71CjxP3gAADY4ZcO3Qhn2PRXml+FQ
         dW8g==
X-Gm-Message-State: ANhLgQ0X7oG+fFXiCS7ovOBIxFh+BrWsvEG0sLt0Nx8llkfsUmlwCEc4
        ruqvMUYJM4i34QaMqjLjPjhXYnLEZ8OIOnTir3J+z40/
X-Google-Smtp-Source: ADFU+vtXs38mDLl4a5pMGFXega7jifXXLzb/cQnGb4xoFu8lu9+Jv8Jjtz11pIahYtqwbV0q7RF1AQdc+1jGNECRNS8=
X-Received: by 2002:a92:bb9d:: with SMTP id x29mr26407746ilk.137.1585045219156;
 Tue, 24 Mar 2020 03:20:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200323190850.3091-1-amir73il@gmail.com> <CAJfpeguyREKNnkGWmdUpDNP6U2J53_wzRipKyxvYj30cpkOpiA@mail.gmail.com>
In-Reply-To: <CAJfpeguyREKNnkGWmdUpDNP6U2J53_wzRipKyxvYj30cpkOpiA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 24 Mar 2020 12:20:07 +0200
Message-ID: <CAOQ4uxjA9wzKA5BFc61+Nr_WSVWps9rsTWD8qX5xVhJ1hxhbYw@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix WARN_ON nlink drop to zero
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Mar 24, 2020 at 11:48 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Mon, Mar 23, 2020 at 8:08 PM Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > Changes to underlying layers should not cause WARN_ON(), but this repro
> > does:
> >
> >  mkdir w l u mnt
> >  sudo mount -t overlay -o workdir=w,lowerdir=l,upperdir=u overlay mnt
> >  touch mnt/h
> >  ln u/h u/k
> >  rm -rf mnt/k
> >  rm -rf mnt/h
> >  dmesg
> >
> >  ------------[ cut here ]------------
> >  WARNING: CPU: 1 PID: 116244 at fs/inode.c:302 drop_nlink+0x28/0x40
> >
> > After upper hardlinks were added while overlay is mounted, unlinking all
> > overlay hardlinks drops overlay nlink to zero before all upper inodes
> > are unlinked.
> >
> > Detect too low i_nlink before unlink/rename and set the overlay nlink
> > to the upper inode nlink (minus one for an index entry).
> >
> > Reported-by: Phasip <phasip@gmail.com>
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/util.c | 23 ++++++++++++++++++++++-
> >  1 file changed, 22 insertions(+), 1 deletion(-)
> >
> > Miklos,
> >
> > This fix passed the reported reproducers (with index=off),
> > overlay/034 with (index=on) and overlay/034 with s/LOWER/UPPER:
> >
> >  -lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> >  +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
> >   workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
> >
> > As well as the rest of overlay/quick group.
> >
> > I will post the overlay/034 fork as a separate test later.
> >
> > Thanks,
> > Amir.
> >
> > diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> > index 36b60788ee47..e894a14857c7 100644
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -734,7 +734,9 @@ static void ovl_cleanup_index(struct dentry *dentry)
> >  int ovl_nlink_start(struct dentry *dentry)
> >  {
> >         struct inode *inode = d_inode(dentry);
> > +       struct inode *iupper = ovl_inode_upper(inode);
> >         const struct cred *old_cred;
> > +       int index_nlink;
> >         int err;
> >
> >         if (WARN_ON(!inode))
> > @@ -764,7 +766,26 @@ int ovl_nlink_start(struct dentry *dentry)
> >         if (err)
> >                 return err;
> >
> > -       if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, inode))
> > +       if (d_is_dir(dentry))
> > +               goto out;
> > +
> > +       /* index adds +1 to upper nlink */
> > +       index_nlink = !!ovl_test_flag(OVL_INDEX, inode);
> > +       if (iupper && (iupper->i_nlink - index_nlink) > inode->i_nlink) {
>
> Racy with link/unlink directly on upper.  Possibly our original nlink
> calculation is also racy in a similar way, need to look at that.
>
> But that doesn't matter, as long as we don't get to zero nlink with
> hashed aliases.  Since inode lock is held on overlay inode, the number
> of hashed aliases cannot change, so that's a better way to address
> this issue, I think.
>

OK. Just as long as there is sufficient commentary in ovl_drop_nlink().

> > +               pr_warn_ratelimited("inode nlink too low (%pd2, ino=%lu, nlink=%u, upper_nlink=%u)\n",
> > +                                   dentry, inode->i_ino, inode->i_nlink,
> > +                                   iupper->i_nlink - index_nlink);
>
> Why warn?  This is user triggerable, so the point is to not warn in this case.
>

I thought the point was that user cannot trigger WARN_ON().
I though pr_warn on non fatal filesystem inconsistency, like the one in
ovl_cleanup_index() is fare game.
The purpose of the warning is to alert the admin of a corrupted overlayfs
and possibly run fsck.overlay (when it becomes an official tool).

Thanks,
Amir.
