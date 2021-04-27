Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 987F9C433ED
	for <linux-unionfs@archiver.kernel.org>; Tue, 27 Apr 2021 09:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 656FD61175
	for <linux-unionfs@archiver.kernel.org>; Tue, 27 Apr 2021 09:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhD0JYq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 05:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235259AbhD0JXu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 27 Apr 2021 05:23:50 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC0EC061574
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Apr 2021 02:23:07 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id i22so6240518ila.11
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Apr 2021 02:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i9Ulj7jmTv9qGaBCRfQTI+hNPyZsIDunFfxpMivHPGU=;
        b=KOh0M8+A3MRxs9O+ghchsj04bgQu+RZD9xZAPI1HO0XthjUPCgPRGi5+l+Rah0MzjO
         F3btL+xW0WJqEG+34xVAVXkayTCI1Q/BxG19jlBkB3r7fItT7srND+xsCp/oPEXSTUiA
         k3FNqTt5BZoPUZSJ9lbDk9cdFwuFmFcfvPZqIhriOFf1lGXdFw9wTNDRFNPFBv5ij2n5
         NZUxF7haHZ/7t7JlS559Ej29F8RUpX3ByL3KYtkNRk95DGgQ4kBqSKdp/b0qKw5nCtRc
         GnmBNaYEyPG8+WKbFq680bf2YlYTBRn58m0HS6UlmWvFV4BYk0+kLe+BvNbXoNbXZojW
         PUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i9Ulj7jmTv9qGaBCRfQTI+hNPyZsIDunFfxpMivHPGU=;
        b=ImivFpEnkUogdzIafP8XiXg6yGlKY8VsHEvUmaNpI8ne2ikfSolUAuKe1jOgPEILlk
         ty3puFktWT6FvLNH6oT1XYmRTMU9OtxrnLExrmqsb1IZTJKLep1sxbTM0eCgeYst4gmx
         YrF2FKEyon3p3JkUajKoPXEolUfJqh4exr+RmpevTQtVdBZmAslHmsTUTS1k+GVXSUuL
         q1D2VpFZVs5SkUIMz4IqhVyXL4Kw1Bu+HTGWff4nGZC7UwvyxMntCZkyUSRjSL3mai6U
         Rfb5Gyk9Mvlfxtw66iIoJwhVN5xDKpFh822HafmRHB28dMdplioLyfQJfVPi2CvPcqRO
         +eKw==
X-Gm-Message-State: AOAM530k40yj8+GXobGRQTi9HUPfePtaoKaT6yxm8pgIapyWjekpV86a
        Xl8R0tJ/FmAWydzqJd+FQ5XdIk7CO6cF8qg9rDE=
X-Google-Smtp-Source: ABdhPJxQI886kpmLizK2ibRWXbcNnOsV3oo5bQEChI+esq6J3w8G1kwDXmy7cZywBlozj0xRGdgCHJpzHfGWJ4e/gPI=
X-Received: by 2002:a92:c548:: with SMTP id a8mr17270280ilj.137.1619515386765;
 Tue, 27 Apr 2021 02:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <6312af55.47e2.178d53227d0.Coremail.ouyangxuan10@163.com>
 <CAOQ4uxgPq9E9xxwU2CDyHy-_yCZZeymg+3n+-6AqkGGE1YtwvQ@mail.gmail.com>
 <29d44208.9fc.178d85082a4.Coremail.ouyangxuan10@163.com> <32845770.3a85.179127be38c.Coremail.ouyangxuan10@163.com>
In-Reply-To: <32845770.3a85.179127be38c.Coremail.ouyangxuan10@163.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 27 Apr 2021 12:22:55 +0300
Message-ID: <CAOQ4uxg=T+guwrikFBVUsf22Ckm4zPwZBO9GRycMVPR0M4dunQ@mail.gmail.com>
Subject: Re: Re:Re: [kernel]:overlayfs: invalid origin (root/bmcweb_persistent_data.json,
 ftype=8000, origin ftype=4000)
To:     www <ouyangxuan10@163.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        kernelnewbies@kernelnewbies.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 27, 2021 at 11:40 AM www <ouyangxuan10@163.com> wrote:
>
> Hi Amir,
>
> To solve this problem, we are trying to upgrade the kernel version or upgrade the file system separately, but because the kernel version we are using is quite different from the one that solves the problem. So I would like to ask you a few questions:
>
> 1. What is the root cause of this problem?

As I wrote:
I suppose lower squashfs was recreated and mounted with an existing
upper dir that already contains upper files with origin references to the
old squashfs lower fs.

>
> 2. Can we just upgrade overlay fs to solve this problem without upgrading the kernel or all file systems?
>

No.

> 3. If we upgrade overlayfs separately, we are not very good at verifying that we have solved this problem, because the recurrence probability of this problem is very low. So I want to ask, how can we quickly reproduce this problem?

Re-creating a lower squashfs after files have been copied to upper should
reproduce the problem quite often.

>
> 4. Do you have any good suggestions?
>

Is the creation of the lower image under your control?
Did you try the workaround I suggested to create lower squashfs
with the "-no-exports" mksquashfs option?

Try this patch:

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 71e264e2f16b..850c0a37f1f0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -392,7 +392,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct
ovl_fh *fh, bool connected,
                            upperdentry, d_inode(upperdentry)->i_mode & S_IFMT,
                            d_inode(origin)->i_mode & S_IFMT);
        dput(origin);
-       return -EIO;
+       return -EINVAL;
 }

 static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
@@ -408,7 +408,7 @@ static int ovl_check_origin(struct ovl_fs *ofs,
struct dentry *upperdentry,
        kfree(fh);

        if (err) {
-               if (err == -ESTALE)
+               if (err == -ESTALE || err == -EINVAL)
                        return 0;
                return err;
        }

It should apply to any kernel and if not it's quite easy to manually apply it.
This fix will not get rid of the warning printed to kmsg, but it will hide the
error from userspace.

If it fixes your problem I think we should apply it to upstream and stable
kernels as well.

Thanks,
Amir.
