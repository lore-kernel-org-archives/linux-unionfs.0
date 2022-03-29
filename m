Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55B4C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 11:24:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbiC2LZx (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 07:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiC2LY2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 07:24:28 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17AA17F3F8
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 04:22:45 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id pv16so34489258ejb.0
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 04:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=42bAhGzwavzb97qEV5DI4qkWwBnPK8TiKGlDfg+xUX0=;
        b=O3DrrFhHfSzoNV8kAeF5QKMWqHr0nocO0mDc+LEnApvbBCjlF6S0HPi9Cr9wlOcRUL
         w01Q0eeFZCOqfIfv4g7iIPPv7iJJwUk7odbZD8Mn6nh6PRb3s/tlx26TiBj3gMJmOkNS
         hmpVInj35Qc6dAdBEi3PFG4j/DTWUfYpthL9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=42bAhGzwavzb97qEV5DI4qkWwBnPK8TiKGlDfg+xUX0=;
        b=M1hMtr5h9Z1DCm9BnIrv7TixPLQvMutmRHRyKOJm7t4xfZOyKMTWVZoRUye5H7x8Pu
         XLYwvaw6/KteIgjRUaLGHzH9jjtQVnagO3x4Ylh8/nkgvpuOQj/yy74xEiWrgHls1vqE
         KCkM1SYZk54bM80RXoXrAR31FWY+9P+1sFBcXkDDFTTQAsqPA5eC3u/M7J1u5ZYQqa/P
         TCJVAcrwuZmzvfsHyMC3tA/px+deKj3E/0kPXRdVnTldBK1RqrxSv1VkPJgjEf5hr3Ka
         J6qfCvmbmfx+4IeysG9v+hdz1GVVCPadAAfGI5lR8kBzMx2ptbhL5fKqXDfH8nJfaSlZ
         3xgg==
X-Gm-Message-State: AOAM530JKUS+dFXTp4BKE8JjPLgsBldX8EkQ0gu6YaZua7OtF1ZAdC4u
        Ww6tFzoGyzKMJ/NImiQB5ZIW6PiuPHaY4AbjRGBReA==
X-Google-Smtp-Source: ABdhPJy9mC0dNLw8YR+PYnPbDQE5NYFxs6QR+a+pwEUTBoL3DT3KiiBpTa1+U393dakxtH8pem2OvoaMvXsKnBHieFU=
X-Received: by 2002:a17:907:c16:b0:6db:1dfc:ca73 with SMTP id
 ga22-20020a1709070c1600b006db1dfcca73mr33880351ejc.192.1648552964226; Tue, 29
 Mar 2022 04:22:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220329103526.1207086-1-brauner@kernel.org> <20220329103526.1207086-6-brauner@kernel.org>
In-Reply-To: <20220329103526.1207086-6-brauner@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 29 Mar 2022 13:22:33 +0200
Message-ID: <CAJfpegubSaYDW1_=8cfU20ho2=s1NmCRbhAPzSU=AJe6DeF3tA@mail.gmail.com>
Subject: Re: [PATCH 05/18] ovl: handle idmappings in creation operations
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 29 Mar 2022 at 12:36, Christian Brauner <brauner@kernel.org> wrote:
>
> When creating objects in the upper layer we need to pass down the upper
> idmapping into the respective vfs helpers in order to support idmapped
> base layers. The vfs helpers will take care of the rest.
>
> Cc: <linux-unionfs@vger.kernel.org>
> Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
>  fs/overlayfs/overlayfs.h | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 8fae64722eda..27f79be097b1 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -125,7 +125,7 @@ static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
>  static inline int ovl_do_rmdir(struct ovl_fs *ofs,
>                                struct inode *dir, struct dentry *dentry)
>  {
> -       int err = vfs_rmdir(&init_user_ns, dir, dentry);
> +       int err = vfs_rmdir(ovl_upper_idmap(ofs), dir, dentry);

ovl_upper_idmap() is not defined by this or earlier patches.

Thanks,
Miklos
