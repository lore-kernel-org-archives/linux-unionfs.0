Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3EA2C77B73
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 12:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234817AbjDTMPF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 08:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbjDTMO7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 08:14:59 -0400
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2705E7A9F
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 05:14:37 -0700 (PDT)
Received: by mail-ua1-x936.google.com with SMTP id x8so1988272uau.9
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 05:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681992875; x=1684584875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qaylrUdg0+csiYgaM5+2CX7gGdXl19IxIjKJHzKB4FY=;
        b=T59oQAg2MWq7i3cq5xS92GokDfg8LSKQr6n//AMVeN/y8m1wWCfWxlr3tJRQHm0oi8
         c2d8EIeviic20oNZHKw+sfJMe7woMPxh6L2OxU0J21cCQNcjccUX+WNpfMIH8Pu+xhd0
         sO6fkmqilDo/93nMbAJZ4QrtmxbhLHOOQ7GNKum2MQm05Ds/Hhm8iHwZM8dSoVq68B7R
         WixL8YinjCpOI/oAE4je9+/3lCUocqV7q+YWIWXqn74TftuKPnAw4+ieTBAaY17WPrHt
         VODnwMnGJE2C5meZrMYvmthpuDioqyGageYgv4e666vT7GK+rq7iv5Ce8lRB0c48W72i
         vtFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681992875; x=1684584875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qaylrUdg0+csiYgaM5+2CX7gGdXl19IxIjKJHzKB4FY=;
        b=L4GJEPco11ZkJsUkDABHif+pZIiI3BOhYmvsN1fbL5EobO6/JTgDUSOZRlyF+nR7h2
         mpX4Gl5wzSQ6q6gd1hwlodwVPCIwc4CCVsKvE7h+lwZT6C/YqnlobfDmxBRJMWw+wIyr
         CvT5Ohpj3P66bi37nTkpXlo6j30+gh8HC+JPuTK9/UxMXKkHQ8kHEEZA4DQrJ/jc0iSa
         xaGQqTNNKN/IFU0W//ufbr+AxRCMMfPQOHmN7p+a7/Wfhtg5ygu0xUvi4dw9s7EAfMSF
         hJjtD3dq9HbCS4PIq27yGwWVKdIH348VO8bJz09L0T/R/2/CreeWhCVn7SAnxoFFGCHX
         BcDg==
X-Gm-Message-State: AAQBX9eWroZnhDXqhkOGTGPflcR1YbdABv9qA1JxIk2PprVgfZTHPpqb
        uF5r5RbXCMFo2dKcGAdiznekzZIKkqRf/6KP/C0=
X-Google-Smtp-Source: AKy350Yrv4NYwerSTBFmlWC65yBwWFEnf0PlTtRdRTVul1G1PUYzblBBWp37FTc5NhUJghGF9mgjX7tbs1+jP1CKVe4=
X-Received: by 2002:a1f:a294:0:b0:443:e6f7:e37e with SMTP id
 l142-20020a1fa294000000b00443e6f7e37emr852770vke.0.1681992875635; Thu, 20 Apr
 2023 05:14:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681917551.git.alexl@redhat.com> <69fa1af45ee0f51b50c1ff8a386a57d2842379c9.1681917551.git.alexl@redhat.com>
In-Reply-To: <69fa1af45ee0f51b50c1ff8a386a57d2842379c9.1681917551.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 20 Apr 2023 15:14:24 +0300
Message-ID: <CAOQ4uxidTC7ZqxRjxDQ1cBGm0m4nzsjBjE-TRMjrk7XsS34qgg@mail.gmail.com>
Subject: Re: [PATCH 3/6] ovl: Break out ovl_entry_path_lowerdata() from ovl_path_lowerdata()
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 20, 2023 at 10:44=E2=80=AFAM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> This will be needed later when getting the lowerdata path from the
> ovl_entry in ovl_lookup() before the dentry is set up.
>
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> ---
>  fs/overlayfs/overlayfs.h |  1 +
>  fs/overlayfs/util.c      | 11 +++++++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 477008186d18..3d14770dc711 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -395,6 +395,7 @@ void ovl_path_upper(struct dentry *dentry, struct pat=
h *path);
>  void ovl_path_lower(struct dentry *dentry, struct path *path);
>  void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
>  void ovl_i_path_real(struct inode *inode, struct path *path);
> +void ovl_entry_path_lowerdata(struct ovl_entry *oe, struct path *path);
>  void ovl_entry_path_real(struct ovl_fs *ofs, struct ovl_entry *oe,
>                          struct dentry *upperdentry, struct path *path);
>  enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *pat=
h);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 77c954591daa..17eff3e31239 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -242,9 +242,9 @@ void ovl_path_lower(struct dentry *dentry, struct pat=
h *path)
>         }
>  }
>
> -void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
> +void ovl_entry_path_lowerdata(struct ovl_entry *oe,

Nit: I would use ovl_e_ prefix. Not critical.

> +                             struct path *path)
>  {
> -       struct ovl_entry *oe =3D OVL_E(dentry);
>         struct ovl_path *lowerdata =3D ovl_lowerdata(oe);
>         struct dentry *lowerdata_dentry =3D ovl_lowerdata_dentry(oe);
>
> @@ -262,6 +262,13 @@ void ovl_path_lowerdata(struct dentry *dentry, struc=
t path *path)
>         }
>  }
>
> +void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
> +{
> +       struct ovl_entry *oe =3D OVL_E(dentry);
> +
> +       return ovl_entry_path_lowerdata(oe, path);

Nit: I wouldn't use a helper var here.

Otherwise you may add (also to the previous helper patch):

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
