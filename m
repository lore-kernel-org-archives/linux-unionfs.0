Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181029174059.38326-1-olga.kornievskaia@gmail.com> <20181029174059.38326-3-olga.kornievskaia@gmail.com>
In-Reply-To: <20181029174059.38326-3-olga.kornievskaia@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 29 Oct 2018 20:02:58 +0200
Message-ID: <CAOQ4uxiUCPb7vDU9c34UL5RkzBemiq49YqOoXfHL4T=+rrL8vg@mail.gmail.com>
Subject: Re: [PATCH v5 01/12] VFS: move cross device copy_file_range() check
 into filesystems
Content-Type: text/plain; charset="UTF-8"
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, Anna Schumaker <anna.schumaker@netapp.com>, Al Viro <viro@zeniv.linux.org.uk>, Steve French <smfrench@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-cifs@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Oct 29, 2018 at 7:41 PM Olga Kornievskaia
<olga.kornievskaia@gmail.com> wrote:
>
> From: Olga Kornievskaia <kolga@netapp.com>
>
> This patch makes it the responsibility of individual filesystems to
> allow or deny cross device copies.  Both NFS and CIFS have operations
> for cross-server copies, and later patches will implement this feature.
>
> Note that as of this patch, the copy_file_range() function might be passed
> superblocks from different filesystem types. -EXDEV should be returned
> if cross device copies aren't supported.

This Note is not ok.
As Dave commented, you shoud make this change in a separate path.
I will explain...

>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Reviewed-by: Matthew Wilcox <willy@infradead.org>
> Reviewed-by: Steve French <stfrench@microsoft.com>
> Reviewed-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> ---
>  Documentation/filesystems/porting | 7 +++++++
>  fs/cifs/cifsfs.c                  | 3 +++
>  fs/nfs/nfs4file.c                 | 3 +++
>  fs/overlayfs/file.c               | 3 +++
>  fs/read_write.c                   | 7 ++-----
>  5 files changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
> index 7b7b845..897e1e7 100644
> --- a/Documentation/filesystems/porting
> +++ b/Documentation/filesystems/porting
> @@ -622,3 +622,10 @@ in your dentry operations instead.
>         alloc_file_clone(file, flags, ops) does not affect any caller's references.
>         On success you get a new struct file sharing the mount/dentry with the
>         original, on failure - ERR_PTR().
> +--
> +[mandatory]
> +       ->copy_file_range() may now be passed files which belong to two
> +       different superblocks of the same file system type or which belong
> +       to two different filesystems types all together. As before, the
> +       destination's copy_file_range() is the function which is called.
> +       If it cannot copy ranges from the source, it should return -EXDEV.
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 7065426..ca8fc87 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1114,6 +1114,9 @@ static ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
>         unsigned int xid = get_xid();
>         ssize_t rc;
>
> +       if (file_inode(src_file)->i_sb != file_inode(dst_file)->i_sb)
> +               return -EXDEV;
> +
>         rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
>                                         len, flags);
>         free_xid(xid);
> diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
> index 4288a6e..5a73c90 100644
> --- a/fs/nfs/nfs4file.c
> +++ b/fs/nfs/nfs4file.c
> @@ -135,6 +135,9 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
>  {
>         ssize_t ret;
>
> +       if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> +               return -EXDEV;
> +
>         if (file_inode(file_in) == file_inode(file_out))
>                 return -EINVAL;
>  retry:
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index aeaefd2..0331e33 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -483,6 +483,9 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
>                                    struct file *file_out, loff_t pos_out,
>                                    size_t len, unsigned int flags)
>  {
> +       if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
> +               return -EXDEV;
> +
>         return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
>                             OVL_COPY);
>  }
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 39b4a21..7a912e3 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1575,10 +1575,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>             (file_out->f_flags & O_APPEND))
>                 return -EBADF;
>
> -       /* this could be relaxed once a method supports cross-fs copies */
> -       if (inode_in->i_sb != inode_out->i_sb)
> -               return -EXDEV;
> -

IMO, series will look the least awkward, if you start with "moving"
this check to before
 file_in->f_op->clone_file_range() AND before file_in->f_op->copy_file_range().
The title of the patch would be something like:
"VFS: generic cross-device copy_file_range() support for all filesystems"
(Dave's suggested commit message)

Then, in the next patch, which is this patch you posted
"VFS: move cross device copy_file_range() check into filesystems"

You will only need to remove the same fs check from before
file_in->f_op->copy_file_range() and add it inside filesystems.

I hope that is clear.

Thanks,
Amir.
