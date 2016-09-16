From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] ovl: Fix info leak in ovl_lookup_temp()
Date: Fri, 16 Sep 2016 13:36:09 -0700
Message-ID: <CAGXu5j+9ozB07MMtwZjL6ATtSFyvawX0pM4K0S4h1A6L8+uarA@mail.gmail.com>
References: <1474019124-11340-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38752 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752144AbcIPUgM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Sep 2016 16:36:12 -0400
Received: by mail-wm0-f49.google.com with SMTP id 1so61778469wmz.1
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Sep 2016 13:36:10 -0700 (PDT)
In-Reply-To: <1474019124-11340-1-git-send-email-richard@nod.at>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Fri, Sep 16, 2016 at 2:45 AM, Richard Weinberger <richard@nod.at> wrote:
> The function uses the memory address of a struct dentry as unique id.
> While the address-based directory entry is only visible to root
> it is IMHO still worth fixing since the temporary name does not have
> to be a kernel address. It can be any unique number. Replace it by an
> atomic integer which is allowed to wrap around.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Nice catch!

Reviewed-by: Kees Cook <keescook@chromium.org>

We'll have to remember this for when atomic_t wrap checking gets added
to mark this as "intended to wrap".

Thanks,

-Kees

> ---
>  fs/overlayfs/dir.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 1560fdc..6e00a08 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -14,6 +14,7 @@
>  #include <linux/cred.h>
>  #include <linux/posix_acl.h>
>  #include <linux/posix_acl_xattr.h>
> +#include <linux/atomic.h>
>  #include "overlayfs.h"
>
>  void ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
> @@ -37,8 +38,9 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir, struct dentry *dentry)
>  {
>         struct dentry *temp;
>         char name[20];
> +       static atomic_t temp_id = ATOMIC_INIT(0);
>
> -       snprintf(name, sizeof(name), "#%lx", (unsigned long) dentry);
> +       snprintf(name, sizeof(name), "#%x", atomic_inc_return(&temp_id));
>
>         temp = lookup_one_len(name, workdir, strlen(name));
>         if (!IS_ERR(temp) && temp->d_inode) {
> --
> 2.7.3
>



-- 
Kees Cook
Nexus Security
