Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F7FBC48BDF
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E7F6120A
	for <linux-unionfs@archiver.kernel.org>; Fri, 18 Jun 2021 13:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234236AbhFRN7h (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 18 Jun 2021 09:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbhFRN7g (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 18 Jun 2021 09:59:36 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E66FC061767
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Jun 2021 06:57:27 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id c1so4983617vsh.8
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Jun 2021 06:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Th1luTE+flQ1ibQkW/dflmlqhx1lpymscyXRyTet58=;
        b=rL5urwChIoToJ61AknABSoxitUKAyDy+pL5fb7VoknOYGToo94Usn97nGZNtPtU8E9
         Wq599Posjr1oVLP0LN63euSNjXiPz+CjQMV41CvcSMA4ddUlOa9693o6l9v7PEIdSLW+
         egCnkP9ccdMqFt7QBis+qrarIavtnxw0iabNY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Th1luTE+flQ1ibQkW/dflmlqhx1lpymscyXRyTet58=;
        b=gTAd6WxkqEdPJgIIehsTRSXGGIZY+NZ5H6RCRGUxBOSpik+NwuxAcsuNvHles8BZ1T
         Lr43+QCBPe1QrWWB+uAiHCXSd3CDIU05zdj67rcpKUeYJUpNFsO7QDcVyZGK7KEr3C8z
         1OXCnda6+is7RWPJcgAmf/qm46/ohfkYKvYPtLgKBF4kvpIje1kW06ur7MS//glN/RkQ
         2wczeqsIZ2CCZAEmrIuBndKPeok3TqhFiqJlILAQRmmDeemeaErDeJwBD5C0zXBig2QH
         /L8uckBXSxQgXk6bMc4KySP8D9YmUWSAhmh+voAlH7eCqIORMn5l4oEcZqx/Ij2SMhuF
         pqcw==
X-Gm-Message-State: AOAM532Q/Spn7u7jq2VtN5RicjTryrmPJCrI+0flqSB0wL3Uu0yRewOi
        Tdq/Hm86wpLbBMPN2xBnnC5OGOCs5cAobbs6qcFIIQ==
X-Google-Smtp-Source: ABdhPJzWdlVIhAQR46BEDFa1VNbF/tmrGU63L1yicj4YDkd1ubCvANAvh43T/vP7QMRWbQr67h70WSE0IWpVPtw9tTA=
X-Received: by 2002:a05:6102:208:: with SMTP id z8mr7260462vsp.7.1624024645518;
 Fri, 18 Jun 2021 06:57:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210617152241.987010-1-amir73il@gmail.com> <20210617152241.987010-4-amir73il@gmail.com>
In-Reply-To: <20210617152241.987010-4-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 18 Jun 2021 15:57:14 +0200
Message-ID: <CAJfpegv9e1oTyu+9Z-TyZQmNG0NrJhokXd8UbaRNft3_bwBEjQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: consistent behavior for immutable/append-only inodes
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 17 Jun 2021 at 17:22, Amir Goldstein <amir73il@gmail.com> wrote:

> Instead, if any of the fileattr flags of interest exist on the lower
> inode, we store them in overlay.xflags xattr on the upper inode and we
> we read the flags from xattr on lookup and on fileattr_get().

Calling this xflags, especially near fileattr code, makes it easy to
confuse with fsx_xflags.   Can we find a more distinctive name?

> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index aec353a2dc80..d66e51b9c347 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -162,7 +162,8 @@ int ovl_getattr(struct user_namespace *mnt_userns, const struct path *path,
>         enum ovl_path_type type;
>         struct path realpath;
>         const struct cred *old_cred;
> -       bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
> +       struct inode *inode = d_inode(dentry);
> +       bool is_dir = S_ISDIR(inode->i_mode);
>         int fsid = 0;
>         int err;
>         bool metacopy_blocks = false;
> @@ -175,6 +176,10 @@ int ovl_getattr(struct user_namespace *mnt_userns, const struct path *path,
>         if (err)
>                 goto out;
>
> +       /* Report immutable/append-only STATX flags */
> +       if (ovl_test_flag(OVL_XFLAGS, inode))
> +               ovl_fill_xflags(inode, stat, NULL);
> +

Filesystems are doing these transformations: (already down one from
before fileattr)

internal flags -> statx->attributes
internal flags -> inode->i_flags
internal flags <-> fa->flags or fa->fsx_xflags

To further improve this situation the statx filling could be moved to
generic code based on i_flags.  I'm not asking you to convert all
filesystems (though that would be nice), but adding the helpers and
using them here would be a good first step.

> @@ -639,6 +642,174 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
>         return err;
>  }
>
> +
> +/*
> + * Overlayfs stores immutable/append-only attributes in overlay.xflags xattr.
> + * If upper inode does have those fileattr flags set (i.e. from old kernel),
> + * overlayfs does not clear them on fileattr_get(), but it will clear them on
> + * fileattr_set().
> + */
> +#define OVL_XFLAG(c, x) \
> +       { c, S_ ## x, FS_ ## x ## _FL, FS_XFLAG_ ## x, STATX_ATTR_ ## x }
> +
> +struct ovl_xflag {
> +       char code;
> +       u32 i_flag;
> +       u32 fs_flag;
> +       u32 fsx_flag;
> +       u64 statx_attr;
> +} const ovl_xflags[] = {
> +       OVL_XFLAG('a', APPEND),
> +       OVL_XFLAG('i', IMMUTABLE),
> +};

This would be really nice for a dozen flags, but for two...

My guess is that many lines of code could be saved by un-generalizing this.

> +/* Set inode flags and xflags xattr from fileattr */
> +int ovl_set_xflags(struct inode *inode, struct dentry *upper,
> +                  struct fileattr *fa)
> +{
> +       struct ovl_fs *ofs = OVL_FS(inode->i_sb);
> +       char buf[OVL_XFLAGS_NUM];
> +       int len, err = 0;
> +
> +       BUILD_BUG_ON(OVL_XFLAGS_NUM >= OVL_XFLAGS_MAX);
> +       len = ovl_xflags_to_buf(inode, buf, OVL_XFLAGS_NUM, fa);
> +
> +       /*
> +        * Do not fail when upper doesn't support xattrs, but also do not
> +        * mask out the xattr xflags from real fileattr to continue
> +        * supporting fileattr_set() on fs without xattr support.
> +        * Remove xattr if it exist and all flags are cleared.
> +        */

Does this matter in practice?   I.e. is there any filesystem with
immutable/append attribute but not xattr that could be an upper layer?

If yes, then this could end up as a copy-up regression (failure to
copy up files having immutable/append).

Thanks,
Miklos
