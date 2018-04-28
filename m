Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-27-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-27-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 02:05:03 -0700
Message-ID: <CAOQ4uxhQ4kM2R5d3u3C9YD2NRMiuiiaPk_aM+B8fWng6X-tFYg@mail.gmail.com>
Subject: Re: [PATCH v14 26/31] ovl: Allow ovl_open_realfile() to open metacopy inode
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Most of the time we need to open inode containing data (and not metacopy)
> but when fsync happens, in that case we need to make sure upper metacopy
> inode is fsynced too. In that case we need to open metacopy inode
> temporarily.
>
> Add a parameter to ovl_open_realfile() which specifies whether to open
> data inode or metacopy inode. Later fsync patch will make use of this
> functionality.

I don't think fsync patch is needed so
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/file.c | 34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 558a859b2658..08387639ba6e 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -14,7 +14,7 @@
>  #include <linux/uio.h>
>  #include "overlayfs.h"
>
> -static struct file *ovl_open_realfile(const struct file *file)
> +static struct file *ovl_open_realfile(const struct file *file, bool meta)
>  {
>         struct inode *inode = file_inode(file);
>         struct inode *upperinode = ovl_inode_upper(inode);
> @@ -28,7 +28,13 @@ static struct file *ovl_open_realfile(const struct file *file)
>
>         /* Always open file which contains data. Do not open metacopy. */
>         realinode = upperreal ? upperinode : ovl_inode_lowerdata(inode);
> -
> +       if (upperinode && (meta || ovl_has_upperdata(inode))) {
> +               realinode = upperinode;
> +               upperreal = true;
> +       } else {
> +               realinode = meta ? ovl_inode_lower(inode) :
> +                                ovl_inode_lowerdata(inode);
> +       }
>         old_cred = ovl_override_creds(inode->i_sb);
>         realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
>                              realinode, current_cred(), false);
> @@ -80,17 +86,23 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
>         return 0;
>  }
>
> -static int ovl_real_file(const struct file *file, struct fd *real)
> +static int _ovl_real_file(const struct file *file, struct fd *real, bool meta)

I don't think you need to change this function.
I think you need to use ovl_open_realfile() from ovl_fsync_file()
if you realize this is metacopy case.

Thanks,
Amir.
