From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 02/13] ovl: Create origin xattr on copy up for all files
Date: Thu, 26 Oct 2017 08:31:48 +0300
Message-ID: <CAOQ4uxj88gEpnuPY1R9sAJn6OmZBzWK-N5u8-OoeL1SLnqHLmw@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com> <1508958575-14086-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:47919 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751009AbdJZFbt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 01:31:49 -0400
Received: by mail-yw0-f194.google.com with SMTP id u142so1965368ywg.4
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Oct 2017 22:31:49 -0700 (PDT)
In-Reply-To: <1508958575-14086-3-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now my understanding is that origin xattr is created for all copied
> up files if index=on. And if index=off, then we create it for all type
> of files except hardlinks (nlink != 1).
>
> With metadata only copy up, I will still require origin xattr to copy up
> data later, so create it even for hardlinks even with index=off.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index c441f93..8a8f538 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -470,9 +470,6 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>         /*
>          * Store identifier of lower inode in upper inode xattr to
>          * allow lookup of the copy up origin inode.
> -        *
> -        * Don't set origin when we are breaking the association with a lower
> -        * hard link.
>          */
>         if (c->origin) {
>                 err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
> @@ -538,9 +535,6 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
>             c->stat.nlink > 1)
>                 indexed = true;
>
> -       if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || indexed)
> -               c->origin = true;
> -
>         if (indexed) {
>                 c->destdir = ovl_indexdir(c->dentry->d_sb);
>                 err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
> @@ -596,6 +590,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>                 .parent = parent,
>                 .dentry = dentry,
>                 .workdir = ovl_workdir(dentry),
> +               .origin = true,

If its always true, please remove the condition variable, but if it
were up to me,
I would set it to true only when metacopy is enabled for now and maybe relax it
unconditionally later on

>         };
>
>         if (WARN_ON(!ctx.workdir))
> --
> 2.5.5
>
