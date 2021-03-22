Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C866C433E5
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:26:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 339F16199F
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Mar 2021 12:26:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhCVM0g (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 22 Mar 2021 08:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhCVMZ4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Mar 2021 08:25:56 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04096C061756
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Mar 2021 05:25:55 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id b10so13660248iot.4
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Mar 2021 05:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SQ96Aj6wqJSTlu+KOYifmwJ+p96uZzgdGaOGzb0D6gA=;
        b=khs0k1q5e9BVWnZhLi1awAPOTvs4+0ANr/S5atTb+C2NhhsLR/MTiP+7T4u73CToI1
         ASxMyyQQF5uJIL3vz7khP0x4vxkx8YnOUfmXFHrviT/quE7Pddy0O26ASXabzY7NWxoW
         J4H8L5JbAMJvICyta8XJl5H1hO+7DKh6y+d2FJ99GdKNuvhJ9MW/LwvHavJox4IyeFkL
         7YySmb65e9ViFRGaGxdsO6Dg7TM652zXtBwWc2mT6HXnAdQBxt3u3BZWyS3ATW62yGA3
         vh+PgK23/lWPljQRoqraBX0qoh64X2djzzOvgJ6DxnRaSxSUTfdHG8yv0R2rPKJhrKUD
         5Zhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SQ96Aj6wqJSTlu+KOYifmwJ+p96uZzgdGaOGzb0D6gA=;
        b=CSxz0leFbh9SvyTvSuu7tWO3+9wJ7jZQdAMUg3jLB/ql2B+HjWLWqIJ2Egq0avRfHx
         NbrO+zOFNWCc9h0U0D7Vaac/MvnkffyC511c8VCMoU2E6EhotDlzD0v3rL4isUxKz10v
         gBPrSsen7B6zDmXpSf2UutdrpBgGEzytyzgTLuq24a2X2jN4VKumR+zlbl4wId38rUh5
         /nFnHSUttPZ55JMECetx0WkIMLuAwpeqUtu5Ukyl3r7vsapfGG4OOmqVTkplWaQXC23v
         b3zjBU2z78U1cGJpJrd6j4FbsIC9JpeFzEKRZT3ItpjRVMxWlJpSjfNUzucf4NUU2Iw5
         vdOA==
X-Gm-Message-State: AOAM531HCzFKeqOuHyjFSyz/1fIs3Slge123PeTAvu7OysNgXYFatAMw
        z6kwYJk1IdlL6fzJqCArzXcZKyyIDtpAikuHJgG8pBVYo8Q=
X-Google-Smtp-Source: ABdhPJw7hbS0FqYage6+x4DBEp7ResVErbxrETKTVZxQ/dd+WYRGCxBYEa4KgxiTr8mOrv1vZ963npRs3j6PwsVvSIw=
X-Received: by 2002:a02:a796:: with SMTP id e22mr10925912jaj.93.1616415955475;
 Mon, 22 Mar 2021 05:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <YFiK/GhGReGqh52w@mwanda>
In-Reply-To: <YFiK/GhGReGqh52w@mwanda>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 22 Mar 2021 14:25:44 +0200
Message-ID: <CAOQ4uxjNVHGReF5_TXBXHdVb0asJ4RQH_CT6Gy7r1J8MWEe1yg@mail.gmail.com>
Subject: Re: [bug report] ovl: copy up of disconnected dentries
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 22, 2021 at 2:18 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Amir Goldstein,
>
> The patch aa3ff3c152ff: "ovl: copy up of disconnected dentries" from
> Oct 15, 2017, leads to the following static checker warning:

Heh! that's fashionably late :)

>
>         fs/overlayfs/copy_up.c:972 ovl_copy_up_flags()
>         warn: 'old_cred' not released on lines: 944.
>
> fs/overlayfs/copy_up.c
>    932  static int ovl_copy_up_flags(struct dentry *dentry, int flags)
>    933  {
>    934          int err = 0;
>    935          const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
>    936          bool disconnected = (dentry->d_flags & DCACHE_DISCONNECTED);
>    937
>    938          /*
>    939           * With NFS export, copy up can get called for a disconnected non-dir.
>    940           * In this case, we will copy up lower inode to index dir without
>    941           * linking it to upper dir.
>    942           */
>    943          if (WARN_ON(disconnected && d_is_dir(dentry)))
>    944                  return -EIO;
>
> Should this call revert_creds(old_cred); before returning?

Yes. Here's a simple fix, care to post it?

Thanks,
Amir.

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0b2891c6c71e..2846b943e80c 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -932,7 +932,7 @@ static int ovl_copy_up_one(struct dentry *parent,
struct dentry *dentry,
 static int ovl_copy_up_flags(struct dentry *dentry, int flags)
 {
        int err = 0;
-       const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
+       const struct cred *old_cred;
        bool disconnected = (dentry->d_flags & DCACHE_DISCONNECTED);

        /*
@@ -943,6 +943,7 @@ static int ovl_copy_up_flags(struct dentry
*dentry, int flags)
        if (WARN_ON(disconnected && d_is_dir(dentry)))
                return -EIO;

+       old_cred = ovl_override_creds(dentry->d_sb);
        while (!err) {
                struct dentry *next;
                struct dentry *parent = NULL;
