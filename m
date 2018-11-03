From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] vfs: swap names of {do,vfs}_clone_file_range()
Date: Sat, 3 Nov 2018 18:17:09 +0200
Message-ID: <CAOQ4uxjWKZtjrERj3LGLE8D1B9c=0mR7XQc4oWx_Suwj0bccHQ@mail.gmail.com>
References: <20181022175646.20146-1-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181022175646.20146-1-amir73il@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, stable <stable@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "Darrick J. Wong" <darrick.wong@oracle.com>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Oct 22, 2018 at 8:56 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> commit a725356b6659469d182d662f22d770d83d3bc7b5 upstream.
>
> Commit 031a072a0b8a ("vfs: call vfs_clone_file_range() under freeze
> protection") created a wrapper do_clone_file_range() around
> vfs_clone_file_range() moving the freeze protection to former, so
> overlayfs could call the latter.
>
> The more common vfs practice is to call do_xxx helpers from vfs_xxx
> helpers, where freeze protecction is taken in the vfs_xxx helper, so
> this anomality could be a source of confusion.
>
> It seems that commit 8ede205541ff ("ovl: add reflink/copyfile/dedup
> support") may have fallen a victim to this confusion -
> ovl_clone_file_range() calls the vfs_clone_file_range() helper in the
> hope of getting freeze protection on upper fs, but in fact results in
> overlayfs allowing to bypass upper fs freeze protection.
>
> Swap the names of the two helpers to conform to common vfs practice
> and call the correct helpers from overlayfs and nfsd.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Fixes: 031a072a0b8a ("vfs: call vfs_clone_file_range() under freeze...")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Greg,
>
> The upstream commit (-rc8) is not a bug fix, it's a vfs API fix.
> If we do not apply it to stable kernels, we are going to have a
> backporting landmine, should a future fix use vfs_clone_file_range()
> it will not do the same thing upstream and in stable.
>
> I backported the change to linux-4.18.y and added the Fixes label.
> I verified that there are no pathces between the Fixes commit and
> current master that use {vfs,do}_clone_file_range() and could be
> considered for backporting to stable (all thoses that can be considered
> are already in stable).
>
> I verified that that with this backport applies to v4.18.16 there are no
> regression of quick clone tests in xfstests with overlayfs and with xfs.
> Backport patch also applies cleanly to v4.14.78.
>

Hi Greg,

I hope this email finds you well rested... I am going to assume that your
memory has been reset, so pinging to remind you on this with some new
information.

commit 452ce65951a2 ("vfs: plumb remap flags through the vfs clone
functions") is now in master as part of a patch series by Darrick to fix
several clone_file_range() issues. I am not sure if anyone is going to
backport that series, but just in case, its best to have the vfs API fix
in stable for this or any future commits that use the vfs helpers.
Specifically, the above commit will not apply to stable without $SUBJECT
patch, so there is no risk of silent stable regression, but the risk exists for
future patches.

I tested that my backport patch cleanly to v4.14.78 and that there are no
regression of quick clone tests in xfstests with overlayfs and with xfs.

I found another unrelated issue with xfs in stable kernels. Will report it
with fix patch to xfs and stable lists soon.

Thanks,
Amir.

>
>
>  fs/ioctl.c             |  2 +-
>  fs/nfsd/vfs.c          |  3 ++-
>  fs/overlayfs/copy_up.c |  2 +-
>  fs/read_write.c        | 17 +++++++++++++++--
>  include/linux/fs.h     | 17 +++--------------
>  5 files changed, 22 insertions(+), 19 deletions(-)
>
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index b445b13fc59b..5444fec607ce 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -229,7 +229,7 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
>         ret = -EXDEV;
>         if (src_file.file->f_path.mnt != dst_file->f_path.mnt)
>                 goto fdput;
> -       ret = do_clone_file_range(src_file.file, off, dst_file, destoff, olen);
> +       ret = vfs_clone_file_range(src_file.file, off, dst_file, destoff, olen);
>  fdput:
>         fdput(src_file);
>         return ret;
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index b0555d7d8200..613d2fe2dddd 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -541,7 +541,8 @@ __be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
>  __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
>                 u64 dst_pos, u64 count)
>  {
> -       return nfserrno(do_clone_file_range(src, src_pos, dst, dst_pos, count));
> +       return nfserrno(vfs_clone_file_range(src, src_pos, dst, dst_pos,
> +                                            count));
>  }
>
>  ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index ddaddb4ce4c3..26b477f2538d 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -156,7 +156,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
>         }
>
>         /* Try to use clone_file_range to clone up within the same fs */
> -       error = vfs_clone_file_range(old_file, 0, new_file, 0, len);
> +       error = do_clone_file_range(old_file, 0, new_file, 0, len);
>         if (!error)
>                 goto out;
>         /* Couldn't clone, so now we try to copy the data */
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 153f8f690490..c9d489684335 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1818,8 +1818,8 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
>  }
>  EXPORT_SYMBOL(vfs_clone_file_prep_inodes);
>
> -int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
> -               struct file *file_out, loff_t pos_out, u64 len)
> +int do_clone_file_range(struct file *file_in, loff_t pos_in,
> +                       struct file *file_out, loff_t pos_out, u64 len)
>  {
>         struct inode *inode_in = file_inode(file_in);
>         struct inode *inode_out = file_inode(file_out);
> @@ -1866,6 +1866,19 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
>
>         return ret;
>  }
> +EXPORT_SYMBOL(do_clone_file_range);
> +
> +int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
> +                        struct file *file_out, loff_t pos_out, u64 len)
> +{
> +       int ret;
> +
> +       file_start_write(file_out);
> +       ret = do_clone_file_range(file_in, pos_in, file_out, pos_out, len);
> +       file_end_write(file_out);
> +
> +       return ret;
> +}
>  EXPORT_SYMBOL(vfs_clone_file_range);
>
>  /*
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index a3afa50bb79f..e73363bd8646 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1813,8 +1813,10 @@ extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
>  extern int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
>                                       struct inode *inode_out, loff_t pos_out,
>                                       u64 *len, bool is_dedupe);
> +extern int do_clone_file_range(struct file *file_in, loff_t pos_in,
> +                              struct file *file_out, loff_t pos_out, u64 len);
>  extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
> -               struct file *file_out, loff_t pos_out, u64 len);
> +                               struct file *file_out, loff_t pos_out, u64 len);
>  extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>                                          struct inode *dest, loff_t destoff,
>                                          loff_t len, bool *is_same);
> @@ -2755,19 +2757,6 @@ static inline void file_end_write(struct file *file)
>         __sb_end_write(file_inode(file)->i_sb, SB_FREEZE_WRITE);
>  }
>
> -static inline int do_clone_file_range(struct file *file_in, loff_t pos_in,
> -                                     struct file *file_out, loff_t pos_out,
> -                                     u64 len)
> -{
> -       int ret;
> -
> -       file_start_write(file_out);
> -       ret = vfs_clone_file_range(file_in, pos_in, file_out, pos_out, len);
> -       file_end_write(file_out);
> -
> -       return ret;
> -}
> -
>  /*
>   * get_write_access() gets write permission for a file.
>   * put_write_access() releases this write permission.
> --
> 2.7.4
>
