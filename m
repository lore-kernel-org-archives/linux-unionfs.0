From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Can ovl_drop_write() be called earlier in ovl_dentry_open()
Date: Mon, 1 Jun 2015 16:22:40 +0200
Message-ID: <CAJfpegsuVxOAGenfxeSsQEKZR+_+OfR6uOxm2USGvbAuCWRhvg@mail.gmail.com>
References: <21902.1433166736@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:35889 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbbFAOWl (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 1 Jun 2015 10:22:41 -0400
Received: by qgf2 with SMTP id 2so47837271qgf.3
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Jun 2015 07:22:40 -0700 (PDT)
In-Reply-To: <21902.1433166736@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Jun 1, 2015 at 3:52 PM, David Howells <dhowells@redhat.com> wrote:
> In ovl_dentry_open(), ovl_drop_write() is called after vfs_open() - but is
> this actually necessary?  Can't we just drop it post-copyup?  After all,
> that's all we wanted the write lock for, right?

Hmm,  that could result in a race where remount r/o of upper fs comes
in between copy-up and vfs_open() so copy-up succeeds but the actual
open fails.  It's harmless, though, and not  very likely.  So I guess
your patch is OK.

Thanks,
Miklos




>
> David
> ---
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -356,16 +356,14 @@ static int ovl_dentry_open(struct dentry *dentry, struct inode *inode,
>                         err = ovl_copy_up_last(dentry, NULL, true);
>                 else
>                         err = ovl_copy_up(dentry);
> +               ovl_drop_write(dentry);
>                 if (err)
> -                       goto out_drop_write;
> +                       goto out;
>
>                 ovl_path_upper(dentry, &realpath);
>         }
>
>         err = vfs_open(&realpath, d_backing_inode(realpath.dentry), file, cred);
> -out_drop_write:
> -       if (want_write)
> -               ovl_drop_write(dentry);
>  out:
>         return err;
>  }
