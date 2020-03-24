Return-Path: <SRS0=nA/m=5J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E5E8C4332B
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Mar 2020 09:48:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FA912070A
	for <linux-unionfs@archiver.kernel.org>; Tue, 24 Mar 2020 09:48:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="jUHjqnWr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgCXJsj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 24 Mar 2020 05:48:39 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:46638 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbgCXJsj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Mar 2020 05:48:39 -0400
Received: by mail-il1-f193.google.com with SMTP id e8so16079161ilc.13
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Mar 2020 02:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S0ZI42BNcxYvyafyJi7ZZ8F5/zlLeikqSshUkPEtmbU=;
        b=jUHjqnWrA+R7IWPRGIoWX/Hc3oSw2nUAq0JO9D3Y/q6lxyZEuZ5GxJeihyrSAF0/iQ
         m+RwTujpWvvp0r9Kb98sVC45iPZY+uDNu5FweKhYb3P7grgL/g8ijItfrzDcVzfYuiMk
         Vjas2YObboGWJRKamSH88gwEkzIGFRRVQ7Mug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S0ZI42BNcxYvyafyJi7ZZ8F5/zlLeikqSshUkPEtmbU=;
        b=gFjCmil6p91BCGMtAqR42ALkWNc/7nvdOZUtwy0t+U0+lrJPhvVbH1WMtHtTI0SVi2
         OX4YnlK8YmelxmsLgTfdBYYELdJtl/CiSyjVascGvIc57P01PCKLYUx2AjYl9R4q7dCi
         7ePi1SG96+xniymgCP8HJEvv4aEwLioA0lVzrb6bKqGuKT6qiM56S9atbwf0o/Rwg4iT
         yPidYEoLGkElCsLMaoLOji+naSxBU2ku+d1IVfWK6ozlyw1nhJc2CZor2gfwUzgx6RGX
         CKfqsE6oYfeIrgoZWCsxAPtN/zUoYtfp57qpn36NGorWveDvfrYdOCxqYt8Z5Z4byJig
         BDPQ==
X-Gm-Message-State: ANhLgQ1C0sMvnOAWtL6xy1BU/XDJE5BarauiNaJQ3iL3xOle7VmF+3Xj
        AaDELw2FDX/oCkT1Rba8jw+zraJVWFPFQwdld6BzYQ==
X-Google-Smtp-Source: ADFU+vt1vlituXxjM/19xbCvhYAXeIdn2BW7bDmlDMuJGGx2geeJrX+m5Vunr8deHT4uGS4ZB57ZBp76ydA4fk/Y0VA=
X-Received: by 2002:a92:9fd0:: with SMTP id z77mr25949645ilk.257.1585043319000;
 Tue, 24 Mar 2020 02:48:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200323190850.3091-1-amir73il@gmail.com>
In-Reply-To: <20200323190850.3091-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 24 Mar 2020 10:48:28 +0100
Message-ID: <CAJfpeguyREKNnkGWmdUpDNP6U2J53_wzRipKyxvYj30cpkOpiA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix WARN_ON nlink drop to zero
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 23, 2020 at 8:08 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Changes to underlying layers should not cause WARN_ON(), but this repro
> does:
>
>  mkdir w l u mnt
>  sudo mount -t overlay -o workdir=w,lowerdir=l,upperdir=u overlay mnt
>  touch mnt/h
>  ln u/h u/k
>  rm -rf mnt/k
>  rm -rf mnt/h
>  dmesg
>
>  ------------[ cut here ]------------
>  WARNING: CPU: 1 PID: 116244 at fs/inode.c:302 drop_nlink+0x28/0x40
>
> After upper hardlinks were added while overlay is mounted, unlinking all
> overlay hardlinks drops overlay nlink to zero before all upper inodes
> are unlinked.
>
> Detect too low i_nlink before unlink/rename and set the overlay nlink
> to the upper inode nlink (minus one for an index entry).
>
> Reported-by: Phasip <phasip@gmail.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/util.c | 23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
>
> Miklos,
>
> This fix passed the reported reproducers (with index=off),
> overlay/034 with (index=on) and overlay/034 with s/LOWER/UPPER:
>
>  -lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
>  +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
>   workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
>
> As well as the rest of overlay/quick group.
>
> I will post the overlay/034 fork as a separate test later.
>
> Thanks,
> Amir.
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 36b60788ee47..e894a14857c7 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -734,7 +734,9 @@ static void ovl_cleanup_index(struct dentry *dentry)
>  int ovl_nlink_start(struct dentry *dentry)
>  {
>         struct inode *inode = d_inode(dentry);
> +       struct inode *iupper = ovl_inode_upper(inode);
>         const struct cred *old_cred;
> +       int index_nlink;
>         int err;
>
>         if (WARN_ON(!inode))
> @@ -764,7 +766,26 @@ int ovl_nlink_start(struct dentry *dentry)
>         if (err)
>                 return err;
>
> -       if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, inode))
> +       if (d_is_dir(dentry))
> +               goto out;
> +
> +       /* index adds +1 to upper nlink */
> +       index_nlink = !!ovl_test_flag(OVL_INDEX, inode);
> +       if (iupper && (iupper->i_nlink - index_nlink) > inode->i_nlink) {

Racy with link/unlink directly on upper.  Possibly our original nlink
calculation is also racy in a similar way, need to look at that.

But that doesn't matter, as long as we don't get to zero nlink with
hashed aliases.  Since inode lock is held on overlay inode, the number
of hashed aliases cannot change, so that's a better way to address
this issue, I think.

> +               pr_warn_ratelimited("inode nlink too low (%pd2, ino=%lu, nlink=%u, upper_nlink=%u)\n",
> +                                   dentry, inode->i_ino, inode->i_nlink,
> +                                   iupper->i_nlink - index_nlink);

Why warn?  This is user triggerable, so the point is to not warn in this case.

Thanks,
Miklos
