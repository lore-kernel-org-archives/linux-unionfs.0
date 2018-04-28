Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-10-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-10-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 01:14:24 -0700
Message-ID: <CAOQ4uxg5xDZJVuys69QtGBRGcs3=zfkJQoZgTZRp+cG+GGVzEQ@mail.gmail.com>
Subject: Re: [PATCH v14 09/31] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> This patch modifies ovl_lookup() and friends to lookup metacopy dentries.
> It also allows for presence of metacopy dentries in lower layer.
>
> During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
> set OVL_UPPERDATA bit in flags.
>
> We don't support metacopy feature with nfs_export. So in nfs_export code,
> we set OVL_UPPERDATA flag set unconditionally if upper inode exists.
>
> Do not follow metacopy origin if we find a metacopy only inode and metacopy
> feature is not enabled for that mount. Like redirect, this can have security
> implications where an attacker could hand craft upper and try to gain
> access to file on lower which it should not have to begin with.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Except for one comment below...

> ---
>  fs/overlayfs/export.c    |   3 ++
>  fs/overlayfs/inode.c     |  11 ++++-
>  fs/overlayfs/namei.c     | 102 ++++++++++++++++++++++++++++++++++++++++-------
>  fs/overlayfs/overlayfs.h |   1 +
>  fs/overlayfs/util.c      |  22 ++++++++++
>  5 files changed, 124 insertions(+), 15 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 5b7fee1a81ec..e1f6546b6c84 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -311,6 +311,9 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
>                 return ERR_CAST(inode);
>         }
>
> +       if (upper)
> +               ovl_set_flag(OVL_UPPERDATA, inode);
> +
>         dentry = d_find_any_alias(inode);
>         if (!dentry) {
>                 dentry = d_alloc_anon(inode->i_sb);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 59b1c84076ec..40509b7a50d2 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -776,7 +776,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>         struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
>         bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
>         int fsid = bylower ? lowerpath->layer->fsid : 0;
> -       bool is_dir;
> +       bool is_dir, metacopy = false;
>         unsigned long ino = 0;
>         int err = -ENOMEM;
>
> @@ -836,6 +836,15 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>         if (index)
>                 ovl_set_flag(OVL_INDEX, inode);
>
> +       if (upperdentry) {
> +               err = ovl_check_metacopy_xattr(upperdentry);
> +               if (err < 0)
> +                       goto out_err;
> +               metacopy = err;
> +               if (!metacopy)
> +                       ovl_set_flag(OVL_UPPERDATA, inode);
> +       }
> +

There is no reason to ovl_check_metacopy_xattr again here, right?
so it should get the same treatment as upperredirect.
This would make 3 new arguments to ovl_get_inode added by your patch set.

How about initializing this struct during lookup and passing it into
ovl_get_inode()?:

struct ovl_inode_info {
        struct ovl_dir_cache *cache;
        const char *redirect;
        u64 version;
        unsigned long flags;
        struct dentry *__upperdentry;
        struct inode *lower;
};

struct ovl_inode {
        struct ovl_inode_info info;
        struct inode vfs_inode;

        /* synchronize copy up and more */
        struct mutex lock;
};

static inline struct ovl_inode_info *OVL_I_INFO(struct inode *inode)
{
        return &OVL_I(inode)->info;
}

Thanks,
Amir.
