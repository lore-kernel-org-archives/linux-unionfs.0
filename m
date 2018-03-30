Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-28-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-28-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 13:53:24 +0300
Message-ID: <CAOQ4uxhU6U=PRXod37xNJPC0B081CrLtuVBmOECnTG7j6VWn+g@mail.gmail.com>
Subject: Re: [PATCH v13 27/28] ovl: Verify a data dentry has been found for
 metacopy inode
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If we find a upper metacopy inode, make sure we also found associated data
> dentry in lower. Otherwise copy up operation later will fail.
>
> There are two cases where this can happen. First case is that somehow
> data file was removed from lower layer. Other case is that REDIRECT
> xattr was removed due to copy up of file on another cpu (when inode is
> shared between two dentries) and hence ovl_lookup() could not find the
> correct dentry.
>

Remind me again why we remove REDIRECT xattr?
Is it a must for functionality or just for being boy scouts?
I would prefer to avoid having to deal with races of this sort.
You can cleanup REDIRECT for non-dir that is not metacopy
on lookup when finding a I_NEW inode.


> First case is an error while second case is not error. If file has been
> copied up, then it does not matter if data dentry was found or not.
>
> Redirect removal is protected using ovl_inode->lock and ovl_lookup() does
> not have access to that lock. So to differentiate between these two
> cases, take appropriate inode lock in ovl_get_inode() and make sure a
> data dentry has been found for metacopy inode. Otherwise lookup failed
> and its an error.
>
> For example, say two files are hardlinked, foo.txt and bar.txt. Say foo.txt
> is renamed to foo-renamed.txt gets copied up metadata only. This will also
> put a redirect "/foo.txt" on hardlnk  inode. Now assume foo-renamed.txt
> is opened for write and is undergoing data copy up on one cpu and bar.txt
> is under going ovl_lookup() on other cpu. Data copy up path will remove
> REDIRECT and METACOPY xattr. It is possible that METACOPY xattr is
> visible to ovl_lookup() but by the REDIRECT xattr was gone by the time.
> That means no data dentry will be found but at the same time now inode
> is not metacopy inode. So data dentry is not required. So this is not
> error case. But if inode was still metacopy but data dentry was not found
> this is error case. (May be due to underlying layer changed). Fix it by
> returning -ESTALE.
>
> If inode was found in cache, then take ovl_inode->lock before checking
> status of inode. If inode has been allocated, then it is returned with
> inode lock anyway and other threads will block on that lock, so no need
> to take ovl_inode->lock.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/export.c    |  3 ++-
>  fs/overlayfs/inode.c     | 49 +++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/overlayfs/namei.c     | 14 ++++----------
>  fs/overlayfs/overlayfs.h |  3 ++-
>  4 files changed, 56 insertions(+), 13 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 1c233096e59c..e8575d4d2c77 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -305,7 +305,8 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>         if (d_is_dir(upper ?: lower))
>                 return ERR_PTR(-EIO);
>
> -       inode = ovl_get_inode(sb, dget(upper), lower, index, !!lower, NULL);
> +       inode = ovl_get_inode(sb, dget(upper), lower, index, !!lower, NULL,
> +                             false);
>         if (IS_ERR(inode)) {
>                 dput(upper);
>                 return ERR_CAST(inode);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 6a0c85699024..7e30f4a7cdd9 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -685,9 +685,42 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
>         return true;
>  }
>
> +static bool ovl_verify_metacopy_data(struct super_block *sb,
> +                                    struct inode *inode, bool metacopydata)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +       struct ovl_inode *oi = OVL_I(inode);
> +       bool metacopy = false;
> +
> +       /* A metacopy data dentry was found. So no need to do further checks */
> +       if (metacopydata)
> +               return true;
> +
> +       /*
> +        * Metacopy feature not enabled. No metadata data copy up should take
> +        * place. So no further checks needed.
> +        */
> +       if (!ofs->config.metacopy)
> +               return true;
> +
> +       if (!S_ISREG(inode->i_mode))
> +               return true;
> +
> +       /*
> +        * Metacopy feature is enabled and we have not found metacopy data
> +        * dentry. Make sure this inode is not metacopy inode.
> +        */
> +       mutex_lock(&oi->lock);
> +       metacopy = !ovl_test_flag(OVL_UPPERDATA, inode);
> +       mutex_unlock(&oi->lock);
> +

FYI, the reason you need mutex_lock_interruptible is so if other CPU
is busy with large copy up, the process that does lookup() can
be interrupted by user.
This is not likley to be a problem here, because race condition suggests that
copy up of data is complete by now, but nevertheless.

Thanks,
Amir.
