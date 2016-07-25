From: Vito Caputo <vito.caputo@coreos.com>
Subject: Re: Stable inode numbers
Date: Mon, 25 Jul 2016 14:25:21 -0700
Message-ID: <CAKp8XJ7p38vuP_AY7Ky27ui7w=4G5TiwGTB6ZDpfr96dX_hVeQ@mail.gmail.com>
References: <CAKp8XJ41QeG03E_AW4cxsuyp4-uxrPWAkhKc60OMp3vK2YAADA@mail.gmail.com>
 <20160722121503.GC20504@veci.piliscsaba.szeredi.hu> <CAKp8XJ4Lfx06of5D4aVkg2up77xESZ9cy0z2PGn1g6-AoHvE8g@mail.gmail.com>
 <20160725113400.GF20504@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:32869 "EHLO
	mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753211AbcGYVZX (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 25 Jul 2016 17:25:23 -0400
Received: by mail-io0-f180.google.com with SMTP id 38so176694333iol.0
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Jul 2016 14:25:22 -0700 (PDT)
In-Reply-To: <20160725113400.GF20504@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

I think this strategy is an improvement, but I'm a bit apprehensive
about how specific it is to this particular style of untar-like
directory metadata preservation failure in only providing stability to
directory inode numbers.

Additionally it introduces a userspace-visible mount option, for
something which /feels/ like a stop-gap kludge to make some things
work better in the short-term.  Maybe it's acceptable, since a more
general solution could be implemented later which ignores the added
mount option without conflict.

As overlayfs usage increases in the "enterprise" via containers I
suspect we'll be seeing substantial support load from unsuspecting
users tripping over quirks like this and at some point there's a
threshold where user confidence is lost.  That is the lens I view
overlayfs problems like these through, hence I'd prefer a more general
solution with stable inode numbers making overlayfs behavior more
consistent with the filesystems backing it.

It's difficult for me to define what is "good enough" for overlayfs
correctness, and this situation seems like it might be one of those
epitomizing the saying "perfect is the enemy of good".

Thanks,
Vito Caputo

On Mon, Jul 25, 2016 at 4:34 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Fri, Jul 22, 2016 at 01:55:56PM -0700, Vito Caputo wrote:
>
>> The patch eliminates the errors from tar in the test I've been using
>> to reproduce the user-reported issues.  However, I'm doubtful of it
>> being a satisfactory general solution because the inode number of a
>> pre-existing directory which undergoes copy-up spuriously changes.
>>
>> There's probably a scenario where this still upsets tar when
>> extracting over an partial tree pre-existing in the lower layer,
>> adding names to existing directories, causing their inode numbers to
>> change.
>>
>> The relevant code where tar detects these shenanigans may be seen here:
>> http://git.savannah.gnu.org/cgit/tar.git/tree/src/extract.c#n867
>>
>> Perhaps we can come up with a better, more general solution without
>> adding substantial complexity or overhead?
>
> Here's another try.  It's simple enough, as to overhead, please let me know if
> you are comfortable with this.
>
> Thanks,
> Miklos
>
> ---
> From: Miklos Szeredi <mszeredi@redhat.com>
> Subject: ovl: optionally copy up directory on getattr
>
> This is to make directory dev/ino stable.
>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/dir.c       |   15 +++++++++++++--
>  fs/overlayfs/overlayfs.h |    6 ++++++
>  fs/overlayfs/super.c     |   19 +++++++++++++++++++
>  3 files changed, 38 insertions(+), 2 deletions(-)
>
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -139,6 +139,15 @@ static int ovl_dir_getattr(struct vfsmou
>         enum ovl_path_type type;
>         struct path realpath;
>         const struct cred *old_cred;
> +       bool devino_from_ovl = true;
> +
> +       if (ovl_copy_up_type(dentry) == OVL_COPY_UP_ON_GETATTR) {
> +               err = ovl_copy_up(dentry);
> +               if (err)
> +                       return err;
> +
> +               devino_from_ovl = false;
> +       }
>
>         type = ovl_path_real(dentry, &realpath);
>         old_cred = ovl_override_creds(dentry->d_sb);
> @@ -147,8 +156,10 @@ static int ovl_dir_getattr(struct vfsmou
>         if (err)
>                 return err;
>
> -       stat->dev = dentry->d_sb->s_dev;
> -       stat->ino = dentry->d_inode->i_ino;
> +       if (devino_from_ovl) {
> +               stat->dev = dentry->d_sb->s_dev;
> +               stat->ino = dentry->d_inode->i_ino;
> +       }
>
>         /*
>          * It's probably not worth it to count subdirs to get the
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -24,6 +24,11 @@ enum ovl_path_type {
>         (OVL_TYPE_MERGE(type) || !OVL_TYPE_UPPER(type))
>
>
> +enum ovl_copy_up_type {
> +       OVL_COPY_UP_ON_MODIF,
> +       OVL_COPY_UP_ON_GETATTR,
> +};
> +
>  #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay"
>  #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX ".opaque"
>
> @@ -172,6 +177,7 @@ struct file *ovl_path_open(struct path *
>
>  struct dentry *ovl_upper_create(struct dentry *upperdir, struct dentry *dentry,
>                                 struct kstat *stat, const char *link);
> +enum ovl_copy_up_type ovl_copy_up_type(struct dentry *dentry);
>
>  /* readdir.c */
>  extern const struct file_operations ovl_dir_operations;
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -31,6 +31,7 @@ struct ovl_config {
>         char *upperdir;
>         char *workdir;
>         bool default_permissions;
> +       enum ovl_copy_up_type dir_copy_up_type;
>  };
>
>  /* private information held for overlayfs's superblock */
> @@ -203,6 +204,16 @@ struct dentry *ovl_workdir(struct dentry
>         return ofs->workdir;
>  }
>
> +enum ovl_copy_up_type ovl_copy_up_type(struct dentry *dentry)
> +{
> +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> +
> +       if (d_is_dir(dentry))
> +               return ofs->config.dir_copy_up_type;
> +
> +       return OVL_COPY_UP_ON_MODIF;
> +}
> +
>  bool ovl_dentry_is_opaque(struct dentry *dentry)
>  {
>         struct ovl_entry *oe = dentry->d_fsdata;
> @@ -681,6 +692,8 @@ static int ovl_show_options(struct seq_f
>         }
>         if (ufs->config.default_permissions)
>                 seq_puts(m, ",default_permissions");
> +       if (ufs->config.dir_copy_up_type == OVL_COPY_UP_ON_GETATTR)
> +               seq_puts(m, ",dir_copy_up_on=getattr");
>         return 0;
>  }
>
> @@ -707,6 +720,7 @@ enum {
>         OPT_UPPERDIR,
>         OPT_WORKDIR,
>         OPT_DEFAULT_PERMISSIONS,
> +       OPT_DIR_COPY_UP_ON_GETATTR,
>         OPT_ERR,
>  };
>
> @@ -715,6 +729,7 @@ static const match_table_t ovl_tokens =
>         {OPT_UPPERDIR,                  "upperdir=%s"},
>         {OPT_WORKDIR,                   "workdir=%s"},
>         {OPT_DEFAULT_PERMISSIONS,       "default_permissions"},
> +       {OPT_DIR_COPY_UP_ON_GETATTR,    "dir_copy_up_on=getattr"},
>         {OPT_ERR,                       NULL}
>  };
>
> @@ -779,6 +794,10 @@ static int ovl_parse_opt(char *opt, stru
>                         config->default_permissions = true;
>                         break;
>
> +               case OPT_DIR_COPY_UP_ON_GETATTR:
> +                       config->dir_copy_up_type = OVL_COPY_UP_ON_GETATTR;
> +                       break;
> +
>                 default:
>                         pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
>                         return -EINVAL;
