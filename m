From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/7] Create origin xattr on copy up for all files
Date: Mon, 2 Oct 2017 22:10:01 +0300
Message-ID: <CAOQ4uxix6ccqp2hVqOCBDQrPfgTK-J4ea5FWAPLsO=XiZpz+-A@mail.gmail.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com> <1506951605-31440-2-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f195.google.com ([209.85.216.195]:33928 "EHLO
        mail-qt0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751084AbdJBTKC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2017 15:10:02 -0400
Received: by mail-qt0-f195.google.com with SMTP id d13so171588qta.1
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Oct 2017 12:10:02 -0700 (PDT)
In-Reply-To: <1506951605-31440-2-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 2, 2017 at 4:39 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now my understanding is that origin xattr is created for all copied
> up files if index=on. And if index=off, then we create it for all type
> of files except hardlinks (nlink != 1).
>
> With metadata only copy up, I will still require origin xattr to copy up
> data later, so create it even for hardlinks even with index=off. I am
> hoping it does not break anything because we do OVL_INDEX test before
> using inode number of origin.

It does break index consistency if 2 different upper inodes point to the same
lower ORIGIN.
If you must support METACOPY with index=off (which I prefer not to)
then you will have to set a different xattr to follow to data copy up
source or set a BROKENHARDLINK xattr for this case so index=on lookup
knows it cannot use ORIGIN as index key.

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index aad97b30d5e6..f1b15e5c37d3 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -538,9 +538,6 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
>             c->stat.nlink > 1)
>                 indexed = true;
>
> -       if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || indexed)
> -               c->origin = true;
> -
>         if (indexed) {
>                 c->destdir = ovl_indexdir(c->dentry->d_sb);
>                 err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
> @@ -598,6 +595,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>                 .parent = parent,
>                 .dentry = dentry,
>                 .workdir = ovl_workdir(dentry),
> +               .origin = true,
>         };
>
>         if (WARN_ON(!ctx.workdir))
> --
> 2.13.5
>
