From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH] ovl: fix getcwd() failure after unsuccessful rmdir
Date: Sat, 30 Jan 2016 12:44:14 +0300
Message-ID: <CALYGNiNMvxVD8yByL_3GnaH1n9nCiWjFoLGJuf3jRdLG4Rn5Sw@mail.gmail.com>
References: <1452265799-4549-1-git-send-email-rui.y.wang@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:34637 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbcA3JoQ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 30 Jan 2016 04:44:16 -0500
In-Reply-To: <1452265799-4549-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Rui Wang <rui.y.wang@intel.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Fri, Jan 8, 2016 at 6:09 PM, Rui Wang <rui.y.wang@intel.com> wrote:
> ovl_remove_upper() should do d_drop() only after it successfully
> removes the dir, otherwise a subsequent getcwd() system call will
> fail, breaking userspace programs.
>
> This is to fix: https://bugzilla.kernel.org/show_bug.cgi?id=110491
>
> Signed-off-by: Rui Wang <rui.y.wang@intel.com>

Reviewed-by: Konstantin Khlebnikov <koct9i@gmail.com>

The same problem also in ovl_remove_and_whiteout() - when we
remove non-pure dentry. It checks that directory isn't empty before,
but I'm sure that vfs_rename which exchanges dentry and whiteout
could fail for some reason and we'll end with unhashed dentry when
nothing actually has been changed.

> ---
>  fs/overlayfs/dir.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 692ceda..36d6a5b 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -618,7 +618,8 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
>          * sole user of this dentry.  Too tricky...  Just unhash for
>          * now.
>          */
> -       d_drop(dentry);
> +       if (!err)
> +               d_drop(dentry);
>         mutex_unlock(&dir->i_mutex);
>
>         return err;
> --
> 1.7.5.4
>
