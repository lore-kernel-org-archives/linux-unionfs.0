From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 08/16] ovl: validate lower layer uuid and root on
 redirect by fh
Date: Thu, 27 Apr 2017 10:15:52 +0300
Message-ID: <CAOQ4uxgEchbkZmgB8WXA0okLZE_2ArGc=U5JmSfYJ3+eA2_OZQ@mail.gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com> <1493242518-15266-9-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35803 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932589AbdD0HPx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 03:15:53 -0400
In-Reply-To: <1493242518-15266-9-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Apr 27, 2017 at 12:35 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On copy up, we store xattr overlay.origin.uuid and
> overlay.origin.root along with overlay.origin.fh.
>
> Before decoding the file handle at overlay.origin.fh verify:
> - All lower layers are on the same fs
> - UUID of lower fs matches the stored uuid
>
> If there are more than one lower layer, find the lower layer mount
> in which origin.fh should be decoded by decoding origin.root and
> matching the result to a lower layer root dentry.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/namei.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 75 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 28d54e3..970d8158 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -27,6 +27,8 @@ struct ovl_lookup_data {
>         char *redirect;         /* - path to follow */
>         bool by_fh;             /* redirect by file handle: */
>         struct ovl_fh *fh;      /* - file handle to follow */
> +       struct ovl_fh *rootfh;  /* - file handle of layer root */
> +       unsigned char uuid[16]; /* - uuid of layer filesystem */
>  };
>
>  static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
> @@ -121,8 +123,24 @@ static struct ovl_fh *ovl_get_fh(struct dentry *dentry, const char *name)
>  static int ovl_check_redirect_fh(struct dentry *dentry,
>                                  struct ovl_lookup_data *d)
>  {
> +       int res;
> +
>         kfree(d->fh);
>         d->fh = ovl_get_fh(dentry, OVL_XATTR_ORIGIN_FH);
> +       kfree(d->rootfh);
> +       d->rootfh = ovl_get_fh(dentry, OVL_XATTR_ORIGIN_ROOT);
> +
> +       res = vfs_getxattr(dentry, OVL_XATTR_ORIGIN_UUID, d->uuid,
> +                          sizeof(d->uuid));
> +       if (res == sizeof(d->uuid))
> +               return 0;
> +
> +       if (res != -ENODATA && res != -EOPNOTSUPP) {
> +               pr_warn_ratelimited("overlayfs: failed to get %s (%i)\n",
> +                                   OVL_XATTR_ORIGIN_UUID, res);
> +       }
> +
> +       memset(d->uuid, 0, sizeof(d->uuid));
>         return 0;
>  }
>
> @@ -130,6 +148,9 @@ static void ovl_reset_redirect_fh(struct ovl_lookup_data *d)
>  {
>         kfree(d->fh);
>         d->fh = NULL;
> +       kfree(d->rootfh);
> +       d->rootfh = NULL;
> +       memset(d->uuid, 0, sizeof(d->uuid));
>  }
>
>  static bool ovl_is_opaquedir(struct dentry *dentry)
> @@ -309,6 +330,53 @@ static int ovl_lookup_layer_fh(struct vfsmount *mnt, struct ovl_lookup_data *d,
>         return ovl_lookup_data(this, d, 0, "", ret);
>  }
>
> +static int ovl_is_dir(void *ctx, struct dentry *dentry)
> +{
> +       return d_is_dir(dentry);
> +}
> +
> +/* Find lower layer index by layer root file handle and uuid */
> +static int ovl_find_layer_by_fh(struct dentry *dentry, struct ovl_lookup_data *d)
> +{
> +       struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
> +       struct super_block *lower_sb = ovl_same_lower_sb(dentry->d_sb);
> +       struct dentry *this;
> +       int i;
> +
> +       /*
> +        * For now, we only support lookup by fh for all lower layers on the
> +        * same sb.  Not all filesystems set sb->s_uuid.  For those who don't
> +        * this code will compare zeros, which at least ensures us that the
> +        * file handles are not crossing from filesystem with sb->s_uuid to
> +        * a filesystem without sb->s_uuid and vice versa.

Nah. On second thought, it's better to disable redirect_fh at mount time
if lower s_uuid is NULL.

> +        */
> +       if (!lower_sb || memcmp(lower_sb->s_uuid, &d->uuid, sizeof(d->uuid)))
> +               return -1;
> +
> +       /* Don't bother verifying rootfh with a single lower layer */
> +       if (roe->numlower == 1)
> +               return 0;
> +
> +       /*
> +        * Layer root dentries are pinned, there are no aliases for dirs, and
> +        * all lower layers are on the same sb.  If rootfh is correct,
> +        * exportfs_decode_fh() will find it in dcache and return the only
> +        * instance, regardless of the mnt argument and we can compare the
> +        * returned pointer with the pointers in lowerstack.
> +        */
> +       this = ovl_decode_fh(roe->lowerstack[0].mnt, d->rootfh, ovl_is_dir);
> +       if (IS_ERR(this))
> +               return -1;
> +
> +       for (i = 0; i < roe->numlower; i++) {
> +               if (this == roe->lowerstack[i].dentry)
> +                       break;
> +       }
> +
> +       dput(this);
> +       return i < roe->numlower ? i : -1;
> +}
> +
>  /*
>   * Returns next layer in stack starting from top.
>   * Returns -1 if this is the last layer.
> @@ -357,6 +425,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 .redirect = NULL,
>                 .by_fh = true,
>                 .fh = NULL,
> +               .rootfh = NULL,
>         };
>
>         if (dentry->d_name.len > ofs->namelen)
> @@ -405,8 +474,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         /* Try to lookup lower layers by file handle */
>         d.by_path = false;
>         if (!d.stop && d.fh) {
> -               struct vfsmount *lowermnt = roe->lowerstack[0].mnt;
> +               struct vfsmount *lowermnt;
> +               int layer = ovl_find_layer_by_fh(dentry, &d);
> +
> +               if (layer < 0 || layer >= roe->numlower)
> +                       goto lookup_by_path;
>
> +               lowermnt = roe->lowerstack[layer].mnt;
>                 d.last = true;
>                 err = ovl_lookup_layer_fh(lowermnt, &d, &this);
>                 if (err)
> --
> 2.7.4
>
