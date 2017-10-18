From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 05/11] ovl: Copy up only metadata during copy up where it
 makes sense
Date: Wed, 18 Oct 2017 07:46:30 +0300
Message-ID: <CAOQ4uxhnisFDQpTb-HAg6wkgNgkjEW=a4Xd8Bik_atOj6JQV-g@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com> <1508274358-17456-6-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:51494 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933581AbdJREqb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 00:46:31 -0400
Received: by mail-qt0-f196.google.com with SMTP id h4so8265650qtk.8
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 21:46:30 -0700 (PDT)
In-Reply-To: <1508274358-17456-6-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If it makes sense to copy up only metadata during copy up, do it. This
> is done for regular files which are not opened for WRITE and have origin
> being saved.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

See one nit below

Also, for bisectability, it may make better sense to organize the patch series
so that data copy is skipped after reading a metacopy file is implemented,
but with metacopy being a new opt-in feature, I guess it doesn't matter
that much. up to Mikos.

> ---
>  fs/overlayfs/copy_up.c | 28 ++++++++++++++++++++--------
>  1 file changed, 20 insertions(+), 8 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 4c0acb2a23ea..cf0b36518a3a 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -306,11 +306,8 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
>                         return PTR_ERR(fh);
>         }
>
> -       /*
> -        * Do not fail when upper doesn't support xattrs.
> -        */
>         err = ovl_check_setxattr(dentry, upper, OVL_XATTR_ORIGIN, fh,
> -                                fh ? fh->len : 0, 0);
> +                                fh ? fh->len : 0, -EOPNOTSUPP);
>         kfree(fh);
>
>         return err;
> @@ -328,6 +325,7 @@ struct ovl_copy_up_ctx {
>         struct dentry *workdir;
>         bool tmpfile;
>         bool origin;
> +       bool metadata_only;

Why not metacopy? to be consistent?
