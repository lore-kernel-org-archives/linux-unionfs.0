From: Krisztian Litkey <kli@iki.fi>
Subject: Re: [PATCH 1/1] ovl: setxattr: avoid deadlock when writing IMA xattrs.
Date: Sun, 15 May 2016 20:26:24 +0300
Message-ID: <CAH4bDXj7QVoFzJoqgqmAKLuq9eaWMLtp3-DfgG0TS65REE9rSg@mail.gmail.com>
References: <201605150256.u4F2uQnX030109@d03av04.boulder.ibm.com>
	<1463332466-26930-1-git-send-email-kli@iki.fi>
	<1463332466-26930-2-git-send-email-kli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35977 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbcEOR00 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 15 May 2016 13:26:26 -0400
Received: by mail-wm0-f65.google.com with SMTP id w143so13441041wmw.3
        for <linux-unionfs@vger.kernel.org>; Sun, 15 May 2016 10:26:25 -0700 (PDT)
In-Reply-To: <1463332466-26930-2-git-send-email-kli@iki.fi>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: zohar@us.ibm.com, Krisztian Litkey <kli@iki.fi>

  Hi,

Duh... sorry, I forgot to send a cover-letter.

So here is my attempt at rolling a fix for the deadlock, based on your
suggestions.
Does this resemble anything you had in mind ?

While I could not reproduce the original deadlock with this patch in
place, I have
to say that this feels pretty much 'opportunistic programming' for me.
I've never touched
any filesystem code in the kernel before, so I have no idea if this is
anywhere close to
what it should be. Someone who really understands the VFS and the LSM
hooks should
take a look at this. And also should check if the resulting
side-effects are okay from a
security perspective: the original code calls security_inode_setxattr,
the new code path
for IMA attributes does not.

  Cheers,
    Krisztian


On Sun, May 15, 2016 at 8:14 PM, Krisztian Litkey <kli@iki.fi> wrote:
> If we're writing an extended attribute used by IMA, don't
> try to lock sb_writers (mnt_want_write) or i_mutex. We're
> being called from ima_file_free and the necessary locks
> are already being held. Trying to lock them again will
> deadlock.
>
> In practice we test if the real inode has the S_IMA flag
> set and if it does we call __vfs_setxattr_noperm instead
> of the usual vfs_setxattr we call for all other cases.
>
> Signed-off-by: Krisztian Litkey <kli@iki.fi>
> ---
>  fs/overlayfs/inode.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index b29036a..9257e8d 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -222,12 +222,18 @@ static bool ovl_is_private_xattr(const char *name)
>  int ovl_setxattr(struct dentry *dentry, const char *name,
>                  const void *value, size_t size, int flags)
>  {
> -       int err;
> +       int err, ima;
>         struct dentry *upperdentry;
> +       struct inode *inode;
>
> -       err = ovl_want_write(dentry);
> -       if (err)
> -               goto out;
> +       inode = ovl_dentry_real(dentry)->d_inode;
> +       ima = IS_IMA(inode);
> +
> +       if (!ima) {
> +               err = ovl_want_write(dentry);
> +               if (err)
> +                       goto out;
> +       }
>
>         err = -EPERM;
>         if (ovl_is_private_xattr(name))
> @@ -238,10 +244,16 @@ int ovl_setxattr(struct dentry *dentry, const char *name,
>                 goto out_drop_write;
>
>         upperdentry = ovl_dentry_upper(dentry);
> -       err = vfs_setxattr(upperdentry, name, value, size, flags);
> +
> +       if (!ima)
> +               err = vfs_setxattr(upperdentry, name, value, size, flags);
> +       else
> +               err = __vfs_setxattr_noperm(upperdentry, name, value, size,
> +                                           flags);
>
>  out_drop_write:
> -       ovl_drop_write(dentry);
> +       if (!ima)
> +               ovl_drop_write(dentry);
>  out:
>         return err;
>  }
> --
> 2.5.5
>
