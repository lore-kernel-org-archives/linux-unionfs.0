Return-Path: <jencce.kernel@gmail.com>
MIME-Version: 1.0
References: <20190424163950.14123-1-amir73il@gmail.com>
In-Reply-To: <20190424163950.14123-1-amir73il@gmail.com>
From: Murphy Zhou <jencce.kernel@gmail.com>
Date: Sun, 28 Apr 2019 11:08:52 +0800
Message-ID: <CADJHv_tDBdHNBqrO_uARQhMZYEeadPcoshtXFVnvpcVpOFGdhQ@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: do not generate duplicate fsnotify events for
 "fake" path
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 25, 2019 at 12:39 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Overlayfs "fake" path is used for stacked file operations on
> underlying files.  Operations on files with "fake" path must not
> generate fsnotify events with path data, because those events have
> already been generated at overlayfs layer and because the reported
> event->fd for fanotify marks on underlying inode/filesystem will
> have the wrong path (the overlayfs path).
>
> Link: https://lore.kernel.org/linux-fsdevel/20190423065024.12695-1-jencce.kernel@gmail.com/
> Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> V1 was addressed to Jan and was trying to teach fsnotify about fake path.
> V2 leaves fsnotify subsystem alone and just sets the FMODE_NONOTIFY
> flag on realfile. All the rest of the complications with mark mounts
> are irrelevant.
>
> Same extended fanotify06 that was used to verify V1 also verified V2.

Thanks for fixing this!

My overlayfs tests on this patch looks good.

M

>
> Thanks,
> Amir.
>
>  fs/overlayfs/file.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index ddfd93f13cc5..7d2f01957e40 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -29,10 +29,11 @@ static struct file *ovl_open_realfile(const struct file *file,
>         struct inode *inode = file_inode(file);
>         struct file *realfile;
>         const struct cred *old_cred;
> +       int flags = file->f_flags | O_NOATIME | FMODE_NONOTIFY;
>
>         old_cred = ovl_override_creds(inode->i_sb);
> -       realfile = open_with_fake_path(&file->f_path, file->f_flags | O_NOATIME,
> -                                      realinode, current_cred());
> +       realfile = open_with_fake_path(&file->f_path, flags, realinode,
> +                                      current_cred());
>         revert_creds(old_cred);
>
>         pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
> @@ -50,7 +51,7 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
>         int err;
>
>         /* No atime modificaton on underlying */
> -       flags |= O_NOATIME;
> +       flags |= O_NOATIME | FMODE_NONOTIFY;
>
>         /* If some flag changed that cannot be changed then something's amiss */
>         if (WARN_ON((file->f_flags ^ flags) & ~OVL_SETFL_MASK))
> --
> 2.17.1
>
