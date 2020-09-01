Return-Path: <SRS0=Ys2z=CK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6640C433E6
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FB76206A5
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 09:17:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Teprho7b"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgIAJRM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 05:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725848AbgIAJRL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Sep 2020 05:17:11 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74549C061244
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Sep 2020 02:17:11 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id n12so158608vkk.11
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Sep 2020 02:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nfr0MzRbuHMCa5xd1u6LskrD6qM8vjU3/LLsjVpo+jU=;
        b=Teprho7bLEDfI8x9QiAlP3nFDVXJeAtnFXlhZkkqID2CwSvdM/TSoNacjftl+mg2Vb
         PJ6BPzMOsvM7iIDiBSBezZ3vHEcfwD4SoR42vmQtC/3GA4QCvHorL2jQWKew7K2MqMQx
         gCWXHhkZcrpbWSZKvLZ/rU5Wj4qFOOgK2eFs0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nfr0MzRbuHMCa5xd1u6LskrD6qM8vjU3/LLsjVpo+jU=;
        b=hPvGkbcKMioUFP11X08C+J4ZVs7PIPKhrrOYngK1owPjbZKLbz6L4dl6q+gcvOrdID
         R5a4sr6YJn6GJexocKuLBbxrwkymYIq0i1iouJdxKOSyt1wDfvdD8pZKd64AjnFhscxi
         T2UBryruoKXUAm0uc4h6nIrzVVqc8QC2s+MPqOXayZkQgLaG9JOZuGxxSUCn1WDgwPmS
         XXBcG6yDFl4mugJZpUZo97DHssAfoaIy/DUYo8WDHA7wPILMHulI6ukSrnhdZSwyVS9w
         3e4HRklvowucczsC38GGrXsWIA8Sj6vyo7vhSRdYgnvxT6HIprSq8koeBlVbVJQ4JMpr
         2thg==
X-Gm-Message-State: AOAM532JG19Y6brHyeDRBMToPcBswkYk09N6QGcEjlrz5YABDmDO823w
        yZdXKWJss1ekraheRCwDXX2MV2KEpHz9a/974yFI+g==
X-Google-Smtp-Source: ABdhPJyuolkNisXOG6Wn2wa2JMiJrVJkD/o4RYzaVlYRs1A3hzx1Gfq0AQ+zOY8cqbcmFUb1y64HaWyEVAOz220y9FM=
X-Received: by 2002:a1f:4a05:: with SMTP id x5mr352270vka.20.1598951830645;
 Tue, 01 Sep 2020 02:17:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200830202803.25028-1-amir73il@gmail.com>
In-Reply-To: <20200830202803.25028-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 1 Sep 2020 11:16:59 +0200
Message-ID: <CAJfpeguB+JeQN-trDY0qLiO4O2WaBfD2Ltxqc8T6-KV-_fwvCA@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: check for incomapt features in work dir
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Aug 30, 2020 at 10:28 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> An incompatible feature is marked by a non-empty directory nested
> 2 levels deep under "work" dir, e.g.:
> workdir/work/incompat/volatile.
>
> This commit checks for marked incompat features, warns about them
> and fails to mount the overlay, for example:
>   overlayfs: overlay with incompat feature 'volatile' cannot be mounted
>
> Very old kernels (i.e. v3.18) will fail to remove a non-empty "work"
> dir and fail the mount.  Newer kernels will fail to remove a "work"
> dir with entries nested 3 levels and fall back to read-only mount.
>
> User mounting with old kernel will see a warning like these in dmesg:
>   overlayfs: cleanup of 'incompat/...' failed (-39)
>   overlayfs: cleanup of 'work/incompat' failed (-39)
>   overlayfs: cleanup of 'ovl-work/work' failed (-39)
>   overlayfs: failed to create directory /vdf/ovl-work/work (errno: 17);
>              mounting read-only
>
> These warnings should give the hint to the user that:
> 1. mount failure is caused by backward incompatible features
> 2. mount failure can be resolved by manually removing the "work" directory
>
> There is nothing preventing users on old kernels from manually removing
> workdir entirely or mounting overlay with a new workdir, so this is in
> no way a full proof backward compatibility enforcement, but only a best
> effort.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Vivek,
>
> Re-posting with minor cleanups.
> Also pushed to branch ovl-incompat.
>
> Thanks,
> Amir.
>
> Changes since v1:
> - Move check for "incompat" name to ovl_workdir_cleanup_recurse()
>
>
>  fs/overlayfs/readdir.c | 30 +++++++++++++++++++++++++-----
>  fs/overlayfs/super.c   | 25 ++++++++++++++++++-------
>  2 files changed, 43 insertions(+), 12 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 6918b98faeb6..683c6f27ab77 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -1051,7 +1051,9 @@ int ovl_check_d_type_supported(struct path *realpath)
>         return rdd.d_type_supported;
>  }
>
> -static void ovl_workdir_cleanup_recurse(struct path *path, int level)
> +#define OVL_INCOMPATDIR_NAME "incompat"
> +
> +static int ovl_workdir_cleanup_recurse(struct path *path, int level)
>  {
>         int err;
>         struct inode *dir = path->dentry->d_inode;
> @@ -1065,6 +1067,15 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
>                 .root = &root,
>                 .is_lowest = false,
>         };
> +       bool incompat = false;
> +
> +       /*
> +        * The "work/incompat" directory is treated specially - if it is not
> +        * empty, instead of printing a generic error and mounting read-only,
> +        * we will error about incompat features and fail the mount.
> +        */
> +       if (level == 2 && !strcmp(path->dentry->d_name.name, OVL_INCOMPATDIR_NAME))
> +               incompat = true;

Should the test be specific to "work/incompat"?  AFAICS this will
trigger under "index" as well...

>
>         err = ovl_dir_read(path, &rdd);
>         if (err)
> @@ -1079,21 +1090,29 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
>                                 continue;
>                         if (p->len == 2 && p->name[1] == '.')
>                                 continue;
> +               } else if (incompat) {
> +                       pr_warn("overlay with incompat feature '%.*s' cannot be mounted\n",
> +                               p->len, p->name);
> +                       err = -EEXIST;

EEXIST feels counterintuitive.  I'd rather opt for EINVAL.

Thanks,
Miklos
