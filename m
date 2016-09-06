From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: Fix for filesystems without POSIX ACL support
Date: Tue, 6 Sep 2016 14:47:01 +0200
Message-ID: <CAJfpegt5JJM7zvb=AOmuhs1fEMz002Gb8=sGH1pONs6phpdDKw@mail.gmail.com>
References: <1473164020-13364-1-git-send-email-agruenba@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36791 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932406AbcIFMrC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Sep 2016 08:47:02 -0400
Received: by mail-oi0-f66.google.com with SMTP id u131so5320888oif.3
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Sep 2016 05:47:02 -0700 (PDT)
In-Reply-To: <1473164020-13364-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Sep 6, 2016 at 2:13 PM, Andreas Gruenbacher <agruenba@redhat.com> wrote:
> On filesystems without POSIX ACL support such as ubifs, trying to remove
> a POSIX ACL with vfs_removexattr will result in -EOPNOTSUPP.  Don't fail
> in that case.
>

Yep, already fixed in overlayfs-linus.

Thanks,
Miklos

> Reported-by: Richard Weinberger <richard@nod.at>
> Fixes: c11b9fdd
> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/overlayfs/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index a4585f9..e2a94a2 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -835,11 +835,11 @@ retry:
>                         goto out_dput;
>
>                 err = vfs_removexattr(work, XATTR_NAME_POSIX_ACL_DEFAULT);
> -               if (err && err != -ENODATA)
> +               if (err && err != -ENODATA && err != -EOPNOTSUPP)
>                         goto out_dput;
>
>                 err = vfs_removexattr(work, XATTR_NAME_POSIX_ACL_ACCESS);
> -               if (err && err != -ENODATA)
> +               if (err && err != -ENODATA && err != -EOPNOTSUPP)
>                         goto out_dput;
>
>                 /* Clear any inherited mode bits */
> --
> 2.7.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
