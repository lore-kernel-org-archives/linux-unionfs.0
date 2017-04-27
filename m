From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 04/16] ovl: store file handle of lower inode on copy up
Date: Thu, 27 Apr 2017 09:23:32 +0200
Message-ID: <CAJfpegukDqh8VUQtTTjXnxZtDHktMzg_ZVRHfaWGRq-oSNxkPA@mail.gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com> <1493242518-15266-5-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1493242518-15266-5-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 26, 2017 at 11:35 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Sometimes it is interesting to know if an upper file is pure
> upper or a copy up target, and if it is a copy up target, it
> may be interesting to find the copy up origin.
>
> This will be used to preserve lower inode numbers across copy up.
>
> Store the lower inode file handle in upper inode extended attribute
> overlay.origin.fh on copy up to use it later for these cases.
> Store the lower layer root file handle and lower filesystem uuid in
> overlay.origin.root and overlay.origin.uuid, to validate that we
> are looking for the origin file in the original layer.
>
> On failure to encode lower file handle, store an invalid 'null'
> handle, so we can always use the overlay.origin.fh xattr to tell
> between a copy up and a pure upper inode.
>
> If lower fs does not support NFS export ops or if not all lower
> layers are on the same fs, don't try to encode a lower file handle
> and use the 'null' handle instead.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c   | 142 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/overlayfs/overlayfs.h |  29 ++++++++++
>  fs/overlayfs/ovl_entry.h |   2 +
>  fs/overlayfs/super.c     |  14 +++++
>  fs/overlayfs/util.c      |  14 +++++
>  5 files changed, 201 insertions(+)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 906ea6c..7cc7aea 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -20,6 +20,8 @@
>  #include <linux/namei.h>
>  #include <linux/fdtable.h>
>  #include <linux/ratelimit.h>
> +#include <linux/mount.h>
> +#include <linux/exportfs.h>
>  #include "overlayfs.h"
>  #include "ovl_entry.h"
>
> @@ -232,6 +234,138 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
>         return err;
>  }
>
> +static bool ovl_can_decode_fh(struct super_block *sb)
> +{
> +       return sb->s_export_op && sb->s_export_op->fh_to_dentry;
> +}
> +
> +static struct ovl_fh *ovl_decode_fh(struct dentry *lower)
> +{
> +       struct ovl_fh *fh;
> +       int fh_type, fh_len, dwords;
> +       void *buf = NULL;
> +       void *ret = NULL;
> +       int buflen = MAX_HANDLE_SZ;
> +       int err;
> +
> +       err = -EOPNOTSUPP;
> +       /* Do not encode file handle if we cannot decode it later */
> +       if (!ovl_can_decode_fh(lower->d_sb))
> +               goto out_err;
> +
> +       err = -ENOMEM;
> +       buf = kmalloc(buflen, GFP_TEMPORARY);
> +       if (!buf)
> +               goto out_err;
> +
> +       fh = buf;
> +       dwords = (buflen - offsetof(struct ovl_fh, fid)) >> 2;
> +       fh_type = exportfs_encode_fh(lower,
> +                                    (struct fid *)fh->fid,
> +                                    &dwords, 1);
> +       fh_len = (dwords << 2) + offsetof(struct ovl_fh, fid);
> +
> +       err = -EOVERFLOW;
> +       if (fh_len > buflen || fh_type <= 0 || fh_type == FILEID_INVALID)
> +               goto out_err;
> +
> +       fh->version = OVL_FH_VERSION;
> +       fh->magic = OVL_FH_MAGIC;
> +       fh->type = fh_type;
> +       fh->len = fh_len;
> +
> +       err = -ENOMEM;
> +       ret = kmalloc(fh_len, GFP_KERNEL);
> +       if (!ret)
> +               goto out_err;
> +
> +       memcpy(ret, buf, fh_len);
> +
> +       kfree(buf);
> +       return ret;
> +
> +out_err:
> +       pr_warn_ratelimited("overlay: failed to get redirect fh (%i)\n", err);
> +       kfree(buf);
> +       kfree(ret);
> +       return ERR_PTR(err);
> +}
> +
> +static const struct ovl_fh null_fh = {
> +       .version = OVL_FH_VERSION,
> +       .magic = OVL_FH_MAGIC,
> +       .type = FILEID_INVALID,
> +       .len = sizeof(struct ovl_fh),
> +};
> +
> +static int ovl_set_origin(struct dentry *dentry, struct dentry *upper)
> +{
> +       struct path lowerpath;
> +       struct super_block *lower_sb;
> +       const struct ovl_fh *fh = NULL;
> +       const struct ovl_fh *rootfh = NULL;
> +       int err;
> +
> +       ovl_path_lower(dentry, &lowerpath);
> +       if (WARN_ON(!lowerpath.mnt))
> +               return -EIO;
> +
> +       /*
> +        * Encoding a lower file handle where several layers are on the
> +        * same fs, require ecoding the layer root as well, because when
> +        * decoding the lower file handle we must provide the lowermnt.
> +        */
> +       lower_sb = lowerpath.mnt->mnt_sb;
> +       if (ovl_redirect_fh(dentry->d_sb) && ovl_can_decode_fh(lower_sb)) {
> +               fh = ovl_decode_fh(lowerpath.dentry);
> +               rootfh = ovl_decode_fh(lowerpath.mnt->mnt_root);
> +       }
> +       /*
> +        * On failure to encode lower fh, store an invalid 'null' fh, so
> +        * we can use the overlay.origin.fh xattr to distignuish between
> +        * a copy up and a pure upper inode.  If lower fs does not support
> +        * encoding fh, don't try to encode again (for any lower layer).
> +        */
> +       err = 0;
> +       if (IS_ERR_OR_NULL(fh)) {
> +               err = PTR_ERR(fh);
> +               fh = &null_fh;
> +       }
> +       if (IS_ERR_OR_NULL(rootfh)) {
> +               if (err != -EOPNOTSUPP)
> +                       err = PTR_ERR(rootfh);
> +               rootfh = NULL;
> +       }
> +       if (err == -EOPNOTSUPP) {
> +               pr_warn("overlay: file handle not supported by lower - turning off redirect_fh\n");
> +               ovl_clear_redirect_fh(dentry->d_sb);
> +       }
> +
> +       err = ovl_do_setxattr(upper, OVL_XATTR_ORIGIN_FH, fh, fh->len, 0);
> +       if (err)
> +               goto out_err;
> +
> +       if (rootfh) {
> +               err = ovl_do_setxattr(upper, OVL_XATTR_ORIGIN_ROOT, rootfh,
> +                                     rootfh->len, 0);
> +       }
> +       if (err)
> +               goto out_err;
> +
> +       if (fh != &null_fh) {
> +               err = ovl_do_setxattr(upper, OVL_XATTR_ORIGIN_UUID,
> +                                     lower_sb->s_uuid,
> +                                     sizeof(lower_sb->s_uuid), 0);
> +       }
> +
> +out_err:
> +       if (fh != &null_fh)
> +               kfree(fh);
> +       return err;
> +       if (rootfh != &null_fh)
> +               kfree(rootfh);
> +}
> +
>  static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>                               struct dentry *dentry, struct path *lowerpath,
>                               struct kstat *stat, const char *link,
> @@ -316,6 +450,14 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>         if (err)
>                 goto out_cleanup;
>
> +       /*
> +        * Store identifier of lower inode in upper inode xattr to
> +        * allow lookup of the copy up origin inode.
> +        */
> +       err = ovl_set_origin(dentry, temp);
> +       if (err)
> +               goto out_cleanup;
> +
>         if (tmpfile)
>                 err = ovl_do_link(temp, udir, upper, true);
>         else
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 48d0dae..2395dd7 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -22,6 +22,33 @@ enum ovl_path_type {
>  #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
>  #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
>  #define OVL_XATTR_REDIRECT OVL_XATTR_PREFIX "redirect"
> +/*
> + * The tuple origin.{fh,layer,uuid} is a universal unique identifier
> + * for a copy up origin, where:
> + * origin.fh   - exported file handle of the lower file
> + * origin.root - exported file handle of the lower layer root
> + * origin.uuid - uuid of the lower filesystem
> + *
> + * origin.{fh,root} are stored in format of a variable length binary blob
> + * with struct ovl_fh header (total blob size up to 20 bytes).
> + * uuid is stored in raw format (16 bytes) as published by sb->s_uuid.
> + */
> +#define OVL_XATTR_ORIGIN_      OVL_XATTR_PREFIX "origin."
> +#define OVL_XATTR_ORIGIN_FH    OVL_XATTR_ORIGIN_ "fh"
> +#define OVL_XATTR_ORIGIN_ROOT  OVL_XATTR_ORIGIN_ "root"
> +#define OVL_XATTR_ORIGIN_UUID  OVL_XATTR_ORIGIN_ "uuid"


What do we gain by having these in separate xattrs?

They are binary blobs anyway, and fh is structured so it could
incorporate the others as well.   And "overlay.origin" would be a good
name for the combo.

> +
> +/* On-disk and in-memeory format for redirect by file handle */
> +#define OVL_FH_VERSION 0
> +#define OVL_FH_MAGIC   0xfb
> +
> +struct ovl_fh {
> +       unsigned char version;  /* 0 */
> +       unsigned char magic;    /* 0xfb */
> +       unsigned char len;      /* size of this header + size of fid */
> +       unsigned char type;     /* fid_type of fid */
> +       unsigned char fid[0];   /* file identifier */
> +} __packed;
>
>  #define OVL_ISUPPER_MASK 1UL
>
> @@ -175,6 +202,8 @@ bool ovl_redirect_dir(struct super_block *sb);
>  void ovl_clear_redirect_dir(struct super_block *sb);
>  const char *ovl_dentry_get_redirect(struct dentry *dentry);
>  void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
> +bool ovl_redirect_fh(struct super_block *sb);
> +void ovl_clear_redirect_fh(struct super_block *sb);
>  void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
>  void ovl_inode_init(struct inode *inode, struct inode *realinode,
>                     bool is_upper);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 41708bf..2172dc5 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -32,6 +32,8 @@ struct ovl_fs {
>         /* sb common to all (or all lower) layers */
>         struct super_block *same_lower_sb;
>         struct super_block *same_sb;
> +       /* redirect by file handle */
> +       bool redirect_fh;
>  };
>
>  enum ovl_path_type;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index b8830ee..1b47557 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -17,6 +17,7 @@
>  #include <linux/statfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/posix_acl_xattr.h>
> +#include <linux/exportfs.h>
>  #include "overlayfs.h"
>  #include "ovl_entry.h"
>
> @@ -929,6 +930,19 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         else if (ufs->upper_mnt->mnt_sb == ufs->same_lower_sb)
>                 ufs->same_sb = ufs->same_lower_sb;
>
> +       /*
> +        * Redirect by file handle is used to find a lower entry in one of the
> +        * lower layers,  so the handle must be unique across all lower layers.
> +        * Therefore, enable redirect by file handle, only if all lower layers
> +        * are on the same sb which supports lookup by file handles.
> +        *
> +        * TODO: add support for looking up by (uuid,fh) tuple to enable
> +        *       redirect_fh for !same_lower_sb
> +        */
> +       if (ufs->same_lower_sb && ufs->same_lower_sb->s_export_op &&
> +           ufs->same_lower_sb->s_export_op->fh_to_dentry)
> +               ufs->redirect_fh = true;
> +
>         if (remote)
>                 sb->s_d_op = &ovl_reval_dentry_operations;
>         else
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index e015bc3..84f0c1f 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -240,6 +240,20 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
>         oe->redirect = redirect;
>  }
>
> +bool ovl_redirect_fh(struct super_block *sb)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +
> +       return ofs->redirect_fh;
> +}
> +
> +void ovl_clear_redirect_fh(struct super_block *sb)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +
> +       ofs->redirect_fh = false;
> +}
> +
>  void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
>  {
>         struct ovl_entry *oe = dentry->d_fsdata;
> --
> 2.7.4
>
