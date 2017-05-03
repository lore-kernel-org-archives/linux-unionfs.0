From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix visible whiteout on not merged dir
Date: Wed, 3 May 2017 11:38:37 +0300
Message-ID: <CAOQ4uxiiVxZt+bQ-vo7QAekm8KP51uGx87h=hyYVRRLfyyNySA@mail.gmail.com>
References: <1493797155-43637-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34784 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752065AbdECIij (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2017 04:38:39 -0400
Received: by mail-oi0-f65.google.com with SMTP id w10so5194335oif.1
        for <linux-unionfs@vger.kernel.org>; Wed, 03 May 2017 01:38:38 -0700 (PDT)
In-Reply-To: <1493797155-43637-1-git-send-email-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, miaoxie@huawei.com, zhaohongjiang@huawei.com

On Wed, May 3, 2017 at 10:39 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> When we mount overlayfs which have whiteout on the directory that
> are not merged(single lower or upper layer only), the whiteout will
> be visible on the merge layer, because of readdir on this directory
> is simply handled by the underlying directory.
>

Hi Zhang,

I am interested in one specific use case of visible whiteouts in non-merge
dir and that is the use case of a lower dir that has been deleted leaving
upper with possible visible whiteouts.

With some of my patches related to constant inode numbers, that use case
could be fixed simply by replacing OVL_TYPE_MERGE in readdir.c with
OVL_TYPE_COPYUP. Every dir that has *ever* been copied up is marked
with an xattr overlay.origin, which may or may not be uptodate, but will
forever indicate that this is a 'suspect impure' directory.

My question is whether this solution is sufficient to cover your use cases
and if not, where and how did those whiteouts get to your lower/upper
impure directory?

You patch does provide extra optimization for 'purifying' a 'suspect impure'
directory, but:
1. Not sure if that optimization is that important.
2. Upcoming changes related to constant inode numbers will have to use
    ovl_dir_read_merged() for 'suspect impure' dir, not only if that dir may
    contain whiteouts, but also if that dir may contain copyups, namely files
    with overlay.origin, which may need to report non-real d_ino.

[...]

> @@ -271,6 +275,9 @@ static void ovl_dir_reset(struct file *file)
>         WARN_ON(!od->is_real && !OVL_TYPE_MERGE(type));
>         if (od->is_real && OVL_TYPE_MERGE(type))
>                 od->is_real = false;
> +
> +       if (od->is_real)
> +               od->is_pure = ovl_dir_pure(dentry);
>  }
>

[...]

> @@ -362,7 +374,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
>         if (!ctx->pos)
>                 ovl_dir_reset(file);
>
> -       if (od->is_real)
> +       if (od->is_real && likely(od->is_pure))
>                 return iterate_dir(od->realfile, ctx);
>

[...]

> @@ -396,7 +408,7 @@ static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
>         if (!file->f_pos)
>                 ovl_dir_reset(file);
>
> -       if (od->is_real) {
> +       if (od->is_real && likely(od->is_pure)) {
>                 res = vfs_llseek(od->realfile, offset, origin);
>                 file->f_pos = od->realfile->f_pos;

[...]

> @@ -504,6 +518,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
>         od->realfile = realfile;
>         od->is_real = !OVL_TYPE_MERGE(type);
>         od->is_upper = OVL_TYPE_UPPER(type);
> +       od->is_pure = ovl_dir_pure(dentry);

Isn't is_real (or is_pure) redundant?, i.e.:
            od->is_real = !OVL_TYPE_MERGE(type) && ovl_dir_pure(dentry);

You always && them together and the only place you use them separately
is ovl_dir_reset(), but you also check OVL_TYPE_MERGE(type) and
ovl_dir_pure(dentry) in that function anyway, so you could just reset
od->real to the definition above.

Cheers,
Amir.
