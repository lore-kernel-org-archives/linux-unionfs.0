From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: free file dentry immediately
Date: Tue, 3 Mar 2015 18:01:47 +0100
Message-ID: <CAJfpegvCf6QawG4_hoFZy7XjC-bMjk9-BNnGxDNRwCT57SGS5w@mail.gmail.com>
References: <CAPBX1xJDVd9HxS0qT=4b22hDH5vPYh5=-2C9epiRqyRP=A13_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:45809 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbbCCRBs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 3 Mar 2015 12:01:48 -0500
Received: by mail-qa0-f52.google.com with SMTP id v10so28962964qac.11
        for <linux-unionfs@vger.kernel.org>; Tue, 03 Mar 2015 09:01:47 -0800 (PST)
In-Reply-To: <CAPBX1xJDVd9HxS0qT=4b22hDH5vPYh5=-2C9epiRqyRP=A13_g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: =?UTF-8?B?546L5pet?= <xuw2015@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Feb 9, 2015 at 8:23 AM, =E7=8E=8B=E6=97=AD <xuw2015@gmail.com> =
wrote:
> Do not cache the overlay file dentries in dentry lru. For the fs dent=
ry of
> overlay is fake, the real operations happen either lower dentry or up=
per dentry.
> So it's not helpful to performance.

Lookup of an uncached dentry causes acquisition of parent's i_mutex.
This can very much degrade performance if multiple lookups are being
performed in the same directory at the same time.  So I don't think
dropping the overlay dentry is a good idea.

> And for a special use, the fnctl F_SETLEASE F_WRLCK needs the dentry =
count is 1.
> If we cache the ovl dentry, which will hold the reference for upper d=
entry, and
> the fcntl will do operation on upper dentry, whose reference will be =
2. And
> finally the fcntl F_SETLEASE F_WRLCK will fail with -EAGAIN. The ltp =
fcntl24,
> fcntl25 and fcntl26 test case cover it.

The F_WRLOCK check looks somewhat bogus because it will succeed or
fail depending on whether or not a file with multiple hard links has
more than one of it's dentries cached.   I guess that needs to be
cleaned up similar to how F_RDLOCK is handled (i.e. have a separate
opencount in the inode, instead of trying to guess that based on
d_count and i_count).

Thanks,
Miklos

>
> Signed-off-by: George Wang <xuw@redhat.com>
> ---
>  fs/overlayfs/super.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index f16d318..80b9ea8 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -256,6 +256,17 @@ static bool ovl_is_opaquedir(struct dentry *dent=
ry)
>      return false;
>  }
>
> +static int ovl_dentry_delete(struct dentry *dentry)
> +{
> +    struct inode *inode =3D dentry->d_inode;
> +
> +    //dir dentry holds ovl_dir_cache, which will speed up readdir
> +    if (inode && S_ISDIR(inode->i_mode))
> +        return 0;
> +
> +    return 1;
> +}
> +
>  static void ovl_dentry_release(struct dentry *dentry)
>  {
>      struct ovl_entry *oe =3D dentry->d_fsdata;
> @@ -268,7 +279,8 @@ static void ovl_dentry_release(struct dentry *den=
try)
>  }
>
>  static const struct dentry_operations ovl_dentry_operations =3D {
> -    .d_release =3D ovl_dentry_release,
> +    .d_delete    =3D ovl_dentry_delete,
> +    .d_release    =3D ovl_dentry_release,
>  };
>
>  static struct ovl_entry *ovl_alloc_entry(void)
> --
> 1.9.3
--
To unsubscribe from this list: send the line "unsubscribe linux-unionfs=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
