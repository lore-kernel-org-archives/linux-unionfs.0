From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 1/3] vfs: ftruncate check IS_APPEND() on real inode
Date: Fri, 7 Apr 2017 15:10:25 +0200
Message-ID: <CAJfpegvRd7gwVj0iT9OfT7Vxx2=4vHUjDg4rYm31iFpNCQjgmg@mail.gmail.com>
References: <1491555701-16608-1-git-send-email-amir73il@gmail.com> <1491555701-16608-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34119 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933761AbdDGNK1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 09:10:27 -0400
Received: by mail-oi0-f65.google.com with SMTP id w197so1627190oiw.1
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 06:10:26 -0700 (PDT)
In-Reply-To: <1491555701-16608-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Fri, Apr 7, 2017 at 11:01 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> ftruncate an overlayfs inode was checking IS_APPEND() on
> overlay inode, but overlay inode does not have the S_APPEND flag.
>
> Set 'inode' var to file_inode() so all checks are performed on
> the real inode and use the overlay inode/sb explicitly for
> freeze protection and file lock checks.

If you'd just add the file_inode() to the IS_APPEND check then the
patch would look a lot less complicated and the effect should be
exactly the same.  Am I missing something?

Thanks,
Miklos

>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/open.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/open.c b/fs/open.c
> index 949cef2..b7d5ab1 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -182,7 +182,7 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
>                 small = 0;
>
>         dentry = f.file->f_path.dentry;
> -       inode = dentry->d_inode;
> +       inode = file_inode(f.file);
>         error = -EINVAL;
>         if (!S_ISREG(inode->i_mode) || !(f.file->f_mode & FMODE_WRITE))
>                 goto out_putf;
> @@ -196,13 +196,13 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
>         if (IS_APPEND(inode))
>                 goto out_putf;
>
> -       sb_start_write(inode->i_sb);
> -       error = locks_verify_truncate(inode, f.file, length);
> +       sb_start_write(dentry->d_sb);
> +       error = locks_verify_truncate(d_inode(dentry), f.file, length);
>         if (!error)
>                 error = security_path_truncate(&f.file->f_path);
>         if (!error)
>                 error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, f.file);
> -       sb_end_write(inode->i_sb);
> +       sb_end_write(dentry->d_sb);
>  out_putf:
>         fdput(f);
>  out:
> --
> 2.7.4
>
