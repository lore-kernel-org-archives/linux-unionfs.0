Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B101C0015E
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Jul 2023 14:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjGXOnV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Jul 2023 10:43:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjGXOnU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Jul 2023 10:43:20 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3791610F
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Jul 2023 07:43:19 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-9939fbb7191so936627266b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Jul 2023 07:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1690209797; x=1690814597;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oWtBMwxjTwxYWh+dw3/8mngiuHp6BECAcQUcMWQtOq0=;
        b=n3iSISe9tTfRu/kre2x1L0mivaM2UTKHvN14BmPHSiAYxxhP7GU6tXtSn5XYsmzJpo
         /djMPW3gg4HNLg0vRfL4Cd/7V9DaPexQyrMIFvMUriPY2tPllshxIdp4MsqVhu1Us+jB
         QXVnY9J1rTKpCqI1tKlEq+YtOi6knWXbR8ibI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690209797; x=1690814597;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oWtBMwxjTwxYWh+dw3/8mngiuHp6BECAcQUcMWQtOq0=;
        b=Ol0NnWbiBFwSPUgj+EJ+4sUxLRZ+RW48YMjDn3AqUIG2Cpk4RG1U+gz1MpG+LtxO2y
         cRSoi/DSfyayQM5AeEd+gn8LtaznMBEiplLP+gELPlaj7ZZHAUV2KT6fjTYqkfxmkzFs
         c+NluW7H5aDpONI+0sR4MVszdpSJtkBqegOmPjDa25PS8QNDHhxZnESNoEIqIYoggTDS
         WHR6pMgDk4NQwVYjKeJO/FlUxLhAlLE5e9KRjAPvQDr12qpiafkzHIQs8Vw2mqD97Rdk
         lrMhK9RdMZg/pi/IgqI0SCteUAZCxlxC0fsIutkePfUm5xEHu//27LfmntwEz2bUz21U
         8i+g==
X-Gm-Message-State: ABy/qLYK8TzkonIGyeZU0keeeiXDKtYuDMwYBIrwutHookDdF6iwa6WY
        LYIinfinzMEo+lTtxnS9/iAs6XXaeiozD9dHL7bxwA==
X-Google-Smtp-Source: APBJJlEJ++BMwaJfOYS5QSck6VeKtoXZyF5jK7NnG0gtqQ6srKymRKQXQJQUpiGGU+gMOiFVmkOUMH2YV3pKOuj5RBA=
X-Received: by 2002:a17:907:86a8:b0:966:1bf2:2af5 with SMTP id
 qa40-20020a17090786a800b009661bf22af5mr16284235ejc.22.1690209797651; Mon, 24
 Jul 2023 07:43:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230521082813.17025-1-andrea.righi@canonical.com> <20230521082813.17025-4-andrea.righi@canonical.com>
In-Reply-To: <20230521082813.17025-4-andrea.righi@canonical.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 24 Jul 2023 16:43:06 +0200
Message-ID: <CAJfpegtK=dh0yNdvxSC8YF6vOYqGPM5EOWny07jYDdFc0qfhTQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ovl: validate superblock in OVL_FS()
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, 21 May 2023 at 10:28, Andrea Righi <andrea.righi@canonical.com> wrote:
>
> When CONFIG_OVERLAY_FS_DEBUG is enabled add an explicit check to make
> sure that OVL_FS() is always used with a valid overlayfs superblock.
> Otherwise trigger a WARN_ON_ONCE().
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> ---
>  fs/overlayfs/ovl_entry.h | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index b32c38fdf3c7..e156649d9c71 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -97,8 +97,20 @@ static inline struct mnt_idmap *ovl_upper_mnt_idmap(struct ovl_fs *ofs)
>
>  extern struct file_system_type ovl_fs_type;
>
> +static inline bool is_ovl_fs_sb(struct super_block *sb)
> +{
> +       return sb->s_type == &ovl_fs_type;
> +}
> +
> +#ifdef CONFIG_OVERLAY_FS_DEBUG
> +#define OVL_VALIDATE_SB(__sb)  WARN_ON_ONCE(!is_ovl_fs_sb(__sb))
> +#else
> +#define OVL_VALIDATE_SB(__sb)
> +#endif
> +
>  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
>  {
> +       OVL_VALIDATE_SB(sb);

This could be written simply and naturally:

    if (IS_ENABLED(CONFIG_OVERLAY_FS_DEBUG))
         WARN_ON_ONCE(sb->s_type != &ovl_fs_type)

Thanks,
Miklos
