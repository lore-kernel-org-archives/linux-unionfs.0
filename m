MIME-Version: 1.0
Date: Tue, 26 Feb 2019 17:07:46 +0100
References: <20190226152739.26408-1-amir73il@gmail.com>
In-Reply-To: <20190226152739.26408-1-amir73il@gmail.com>
Message-ID: <CAJfpegt8sHTJ-CRZhQ+hNj7XWASKa4L0HUDcsyf2vM+BYs0aag@mail.gmail.com>
Subject: Re: [PATCH] ovl: support stacked SEEK_HOLE/SEEK_DATA
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eddie Horng <eddiehorng.tw@gmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Feb 26, 2019 at 4:27 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Overlay file f_pos is the master copy that is preserved
> through copy up, but only real fs knows how to SEEK_HOLE/
> SEEK_DATA. So we copy f_pos from overlay file, perform the seek
> on real file and copy f_pos back to overlay file.
>
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Reported-by: Eddie Horng <eddiehorng.tw@gmail.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> I verified no regressions with xfstests quick tests.
> The improved generic/seek tests that I posted to fstests
> are failing on master and passing with this fix.
>
> Thanks,
> Amir.
>
>  fs/overlayfs/file.c | 27 +++++++++++++++++++++++----
>  1 file changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 84dd957efa24..0d472940ce9e 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -145,11 +145,30 @@ static int ovl_release(struct inode *inode, struct file *file)
>
>  static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
>  {
> -       struct inode *realinode = ovl_inode_real(file_inode(file));
> +       struct fd real;
> +       const struct cred *old_cred;
> +       ssize_t ret;
>
> -       return generic_file_llseek_size(file, offset, whence,
> -                                       realinode->i_sb->s_maxbytes,
> -                                       i_size_read(realinode));
> +       ret = ovl_real_fdget(file, &real);
> +       if (ret)
> +               return ret;
> +
> +       /*
> +        * Overlay file f_pos is the master copy that is preserved
> +        * through copy up, but only real fs knows how to SEEK_HOLE/
> +        * SEEK_DATA.
> +        */
> +       real.file->f_pos = file->f_pos;

Parallel invocations of ovl_llseek would mean trouble.   I suggest
doing generic_file_llseek_size for SET/CUR/END and doing the recursive
one under ovl inode lock for HOLE/DATA.

Thanks,
Miklos


> +
> +       old_cred = ovl_override_creds(file_inode(file)->i_sb);
> +       ret = vfs_llseek(real.file, offset, whence);
> +       revert_creds(old_cred);
> +
> +       file->f_pos = real.file->f_pos;
> +
> +       fdput(real);
> +
> +       return ret;
>  }
>
>  static void ovl_file_accessed(struct file *file)
> --
> 2.17.1
>
