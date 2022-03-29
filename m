Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 150E5C433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 11:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbiC2LUn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 07:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiC2LUm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 07:20:42 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5152821800
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 04:18:58 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id bq8so20453132ejb.10
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 04:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E/2L7L90fXe/HBZjswfmfQoaGa16Qx5iB6ITUi5myhs=;
        b=CjbNAH8w1nFVF6/ecDeTD2ufZVtgAN4Hmgytq+KXZrEMoQ+OQoUKWwiKYnlGJe6gKw
         6b81pWPdm+yFL87hxUZKS5y4U/CKV6iHZlz5YEzGb2hHDYNEzB0q6SOfNTvK0PCBmqqV
         I/plNBTEMg3tD8EsDz5fRu2HDyOhQZomypgko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E/2L7L90fXe/HBZjswfmfQoaGa16Qx5iB6ITUi5myhs=;
        b=vRbGpWTQHQSLQNAQkZE45tbxukTgVRhI9QqQRzVas1HMEOnM79LD2jLKvsMb5ZGX2X
         qSb1oJtoYNCunsnW2jyy2Ei2XX1rL8JXKsGZid8gWEZz3y+24NtergYv5RTfY4f4FYYc
         A5CwCeZrLUfG07rn1WXgCt+9tE/HS2uYtdldn+V5446w1Z73ah0/ROlaJvdO2aoFz2tk
         9rKxrFup1cAkyhOLecb9mkYBUBi9dzckArWTZSMRZiyWfl/0w5l0dBERrcuyzrQu+QPY
         a4AOmCFuPOXeZPTgnV5Hz91bUFe6yszBeC70QldCaaMtM4DszNFExHHjdf/DaPMtINDM
         xC6A==
X-Gm-Message-State: AOAM532uUXbJE1whs3/57WDvgfqaytOnXGBGSWh6ISHDsCNnvNlk9Uka
        wmZLXjNgfuMFJWxLHqs6UjaHu9orR7dPpFaYDDYNCA==
X-Google-Smtp-Source: ABdhPJw7yPn0f6u15VM6jzcY4HEk5HuQQ9oO4I6ZpYxo6rMQTGvM3n+DnElDetVajaNJPo9QtlwWzQ+u2UuCB2VpWWQ=
X-Received: by 2002:a17:907:9605:b0:6d7:24d1:f4ce with SMTP id
 gb5-20020a170907960500b006d724d1f4cemr33577509ejc.524.1648552736848; Tue, 29
 Mar 2022 04:18:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220329103526.1207086-1-brauner@kernel.org> <20220329103526.1207086-4-brauner@kernel.org>
In-Reply-To: <20220329103526.1207086-4-brauner@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 29 Mar 2022 13:18:45 +0200
Message-ID: <CAJfpegvH32i1xiSTo_Z3XQhTirPjNmExshVsZCR=MjPoeoDQfA@mail.gmail.com>
Subject: Re: [PATCH 03/18] ovl: use wrappers to all vfs_*xattr() calls
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

> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 2cd5741c873b..6a53ca0d2c96 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -183,10 +183,9 @@ static inline int ovl_do_symlink(struct inode *dir, struct dentry *dentry,
>  }
>
>  static inline ssize_t ovl_do_getxattr(struct ovl_fs *ofs, struct dentry *dentry,
> -                                     enum ovl_xattr ox, void *value,
> +                                     const char *name, void *value,
>                                       size_t size)
>  {
> -       const char *name = ovl_xattr(ofs, ox);
>         int err = vfs_getxattr(&init_user_ns, dentry, name, value, size);
>         int len = (value && err > 0) ? err : 0;

Previously direct calls to vfs_*xattr() didn't print debug info.  This
was deliberate as debugging normal operations would drown out the
interesting calls.  But perhaps it doesn't matter nowadays, since
overlayfs is stable and nobody enables debugging anymore...

Anyway, I feel that this should be a separate change, or at least
documented in the patch header.

Thanks,
Miklos
