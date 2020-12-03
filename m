Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74F9DC64E8A
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Dec 2020 10:17:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2110920671
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Dec 2020 10:17:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbgLCKRW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 3 Dec 2020 05:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728659AbgLCKRV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Dec 2020 05:17:21 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218ADC061A4F
        for <linux-unionfs@vger.kernel.org>; Thu,  3 Dec 2020 02:16:41 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id f23so2659883ejk.2
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Dec 2020 02:16:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8Vd4Hb/TndV5DzmZy3SbrxOWhXctHLB4WnGdapRV8BU=;
        b=Pn6etdlwD/T2EjXQWsXsw168LeDHPyreiwEV0TVtDviyZhULIiKfVCPeVs4CojpnNB
         ijAXbZKsqwbVH9Lj1zhMWC9QDcvQ/2k/HQ6LvE/3dzorb1T4MAmAoLc0op+xPmABnZHx
         9UzyszDdf1FoAxVxRzRaKxuMBw8DsGstxIytk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8Vd4Hb/TndV5DzmZy3SbrxOWhXctHLB4WnGdapRV8BU=;
        b=XPcz0A+/gyz0tDiCYOHP6RaXfB7L9vQhGqKCnaoEtTu7WImDNN0BRVC/eZMtaOKRZ7
         oq455EvTr/tcA5xhZqWR5+znB+9CI+3qY8uc6DkxV16Fa8UwBMg95zkLqan9nZiHDXyt
         Pr55ymj0MLw+Syu+PnjpFiZAie96KvUVvexY+EuNgUHMClHvkCMa/yGXUNvW7vjJPpAq
         fHpy5xn3x0lMVW+dAdDYE1ZTish28KNJtuLkuyL4cnuwtTtZ2Y6vs6RYsDlDzES/7E7K
         uqGb1fqc7KVv5X1DhcihRbGacjo+l1pjrbNZr3MyGme+z1eAi6Q5fuDxo+MdCfKc6GA3
         zXPw==
X-Gm-Message-State: AOAM5322TO2PD+WAofto6pbF2lM0jNy7EbBGps7/CQWrD+CKmQV7IZA8
        zWWVhrOvRKLbHPbT1ll158o4s5UG5JTjiqlnlgCloKZrunY=
X-Google-Smtp-Source: ABdhPJxlNTG8XKj15t0YRYFTePX7CW/ReHMhjCpyO61mVK+2pSJ+gGXQlOWHHy/gyv15rkqqASSEX4Wjrn6oflPHZN8=
X-Received: by 2002:a17:906:1450:: with SMTP id q16mr1871092ejc.524.1606990599597;
 Thu, 03 Dec 2020 02:16:39 -0800 (PST)
MIME-Version: 1.0
References: <20201130030039.596801-1-sargun@sargun.me>
In-Reply-To: <20201130030039.596801-1-sargun@sargun.me>
From:   Sargun Dhillon <sargun@sargun.me>
Date:   Thu, 3 Dec 2020 02:16:03 -0800
Message-ID: <CAMp4zn-c6gOPTPBqqkPoQi3NVeZ0yW-WfVPFzpDiazj8PeUgBw@mail.gmail.com>
Subject: Re: [PATCH] overlay: Plumb through flush method
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Nov 29, 2020 at 7:00 PM Sargun Dhillon <sargun@sargun.me> wrote:
>
> Filesystems can implement their own flush method that release
> resources, or manipulate caches. Currently if one of these
> filesystems is used with overlayfs, the flush method is not called.
>
> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-unionfs@vger.kernel.org
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/file.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index efccb7c1f9bc..802259f33c28 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -787,6 +787,16 @@ static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
>                             remap_flags, op);
>  }
>
> +static int ovl_flush(struct file *file, fl_owner_t id)
> +{
> +       struct file *realfile = file->private_data;
> +
> +       if (realfile->f_op->flush)
> +               return realfile->f_op->flush(realfile, id);
> +
> +       return 0;
> +}
> +
>  const struct file_operations ovl_file_operations = {
>         .open           = ovl_open,
>         .release        = ovl_release,
> @@ -798,6 +808,7 @@ const struct file_operations ovl_file_operations = {
>         .fallocate      = ovl_fallocate,
>         .fadvise        = ovl_fadvise,
>         .unlocked_ioctl = ovl_ioctl,
> +       .flush          = ovl_flush,
>  #ifdef CONFIG_COMPAT
>         .compat_ioctl   = ovl_compat_ioctl,
>  #endif
> --
> 2.25.1
>

Amir, Miklos,
Is this acceptable? I discovered this being a problem when we had the discussion
of whether the volatile fs should return an error on close on dirty files.

It seems like it would be useful if anyone uses NFS, or CIFS as an upperdir.
