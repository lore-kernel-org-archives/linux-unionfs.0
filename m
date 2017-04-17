From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH 02/13] ovl: redirect dir by file handle on copy up
Date: Mon, 17 Apr 2017 15:49:56 -0400
Message-ID: <20170417194956.GB10833@redhat.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <1492387183-18847-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753810AbdDQTt5 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Apr 2017 15:49:57 -0400
Content-Disposition: inline
In-Reply-To: <1492387183-18847-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon, Apr 17, 2017 at 02:59:32AM +0300, Amir Goldstein wrote:
> When mounted with mount option redirect_dir=fh,
> every copy up of lower directory stores the lower
> dir file handle in overlay.fh xattr of upper dir.
> 
> This method has some advantages over absolute path redirect:
> - it is more compact in stored xattr size
> - it is not limited by lengths of full paths
> - lookup redirect is more efficient for very nested directories
> 
> It also has some disadvantages over absolute path redirect:
> - it requires that all lower layers are on the same file system,
>   which support exportfs ops
> - file handles will become stale if overlay lower directories
>   were to be copied to another location
> 
> Therefore, redirect by file handle is considered an optimization
> and file handle is stored on copy up in addition to setting
> redirect by path on rename.

Hi Amir, 

If this is just an optimization to redirect, then why not store it
only during rename (like redirct path). 

Given you are storing it all the time for merged dir during copy up, 
looks like you plan to use it for other use cases too. May be it
makes sense to either mention those use cases here or in this patch
just create file handle over rename and then in later patches change
it with explanation.

Or I missed the intent completely?

> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/Kconfig     | 16 +++++++++
>  fs/overlayfs/copy_up.c   | 87 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/overlayfs/overlayfs.h | 15 +++++++++
>  fs/overlayfs/ovl_entry.h |  1 +
>  fs/overlayfs/super.c     | 28 ++++++++++++++--
>  fs/overlayfs/util.c      | 14 ++++++++
>  6 files changed, 159 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> index 0daac51..351b61a 100644
> --- a/fs/overlayfs/Kconfig
> +++ b/fs/overlayfs/Kconfig
> @@ -22,3 +22,19 @@ config OVERLAY_FS_REDIRECT_DIR
>  	  Note, that redirects are not backward compatible.  That is, mounting
>  	  an overlay which has redirects on a kernel that doesn't support this
>  	  feature will have unexpected results.
> +
> +config OVERLAY_FS_REDIRECT_FH
> +	bool "Overlayfs: turn on redirect by file handle by default"
> +	depends on OVERLAY_FS_REDIRECT_DIR
> +	help
> +	  If this config option is enabled then overlay filesystems will use
> +	  redirect by file handle for merged directories by default.  It is
> +	  also possible to turn on redirect by file handle globally with the
> +	  "redirect_fh=on" module option or on a filesystem instance basis
> +	  with the "redirect_dir=fh" mount option.
> +
> +	  Redirect by file handle provides faster lookup compared to redirect
> +	  by absolute path, but it only works when all layers are on the same
> +	  underlying file system that supports NFS export ops.  Redirect by
> +	  file handle breaks if layers are taken offline and copied to another
> +	  location.  In that case, lookup falls back to redirect by path.
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 906ea6c..428dc26 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -20,6 +20,7 @@
>  #include <linux/namei.h>
>  #include <linux/fdtable.h>
>  #include <linux/ratelimit.h>
> +#include <linux/exportfs.h>
>  #include "overlayfs.h"
>  #include "ovl_entry.h"
>  
> @@ -232,6 +233,80 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
>  	return err;
>  }
>  
> +static struct ovl_fh *ovl_get_redirect_fh(struct dentry *lower)
> +{
> +	const struct export_operations *nop = lower->d_sb->s_export_op;
> +	struct ovl_fh *fh;
> +	int fh_type, fh_len, dwords;
> +	void *buf, *ret;
> +	int buflen = MAX_HANDLE_SZ;
> +
> +	/* Do not encode file handle if we cannot decode it later */
> +	if (!nop || !nop->fh_to_dentry) {
> +		pr_info("overlay: redirect by file handle not supported "
> +			"by lower - turning off redirect\n");

This message probably should go where you are actually turning off the
feature?

> +		return ERR_PTR(-EOPNOTSUPP);
> +	}
> +
> +	buf = kmalloc(buflen, GFP_TEMPORARY);
> +	if (!buf)
> +		return ERR_PTR(-ENOMEM);
> +
> +	fh = buf;
> +	dwords = (buflen - offsetof(struct ovl_fh, fid)) >> 2;
> +	fh_type = exportfs_encode_fh(lower,
> +				     (struct fid *)fh->fid,
> +				     &dwords, 0);
> +	fh_len = (dwords << 2) + offsetof(struct ovl_fh, fid);
> +
> +	ret = ERR_PTR(-EOVERFLOW);
> +	if (fh_len > buflen || fh_type <= 0 || fh_type == FILEID_INVALID)
> +		goto out;
> +
> +	fh->version = OVL_FH_VERSION;
> +	fh->magic = OVL_FH_MAGIC;
> +	fh->type = fh_type;
> +	fh->len = fh_len;
> +
> +	ret = kmalloc(fh_len, GFP_KERNEL);
> +	if (!ret) {
> +		ret = ERR_PTR(-ENOMEM);
> +		goto out;
> +	}
> +
> +	memcpy(ret, buf, fh_len);
> +out:
> +	kfree(buf);
> +	return ret;
> +}
> +
> +static int ovl_set_redirect_fh(struct dentry *dentry, struct dentry *upper)
> +{
> +	int err;
> +	const struct ovl_fh *fh;
> +
> +	fh = ovl_get_redirect_fh(ovl_dentry_lower(dentry));
> +	err = PTR_ERR(fh);
> +	if (IS_ERR(fh))
> +		goto out_err;
> +
> +	err = ovl_do_setxattr(upper, OVL_XATTR_FH, fh, fh->len, 0);
> +	if (err)
> +		goto out_free;
> +
> +	return 0;
> +
> +out_free:
> +	kfree(fh);
> +out_err:
> +	if (err == -EOPNOTSUPP) {
> +		ovl_clear_redirect_fh(dentry->d_sb);
> +		return 0;
> +	}
> +	pr_warn_ratelimited("overlay: failed to set redirect fh (%i)\n", err);
> +	return err;
> +}
> +
>  static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>  			      struct dentry *dentry, struct path *lowerpath,
>  			      struct kstat *stat, const char *link,
> @@ -316,6 +391,18 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>  	if (err)
>  		goto out_cleanup;
>  
> +	if (S_ISDIR(stat->mode) &&
> +	    ovl_redirect_dir(dentry->d_sb) &&
> +	    ovl_redirect_fh(dentry->d_sb)) {

Do we need to check for redirect_dir. Looks like redirect_dir has to
be enabled if redirect_fh is enabled?

> +		/*
> +		 * Store file handle of lower dir in upper dir xattr to
> +		 * create a chain of file handles for merged dir stack
> +		 */
> +		err = ovl_set_redirect_fh(dentry, temp);
> +		if (err)
> +			goto out_cleanup;
> +	}
> +
>  	if (tmpfile)
>  		err = ovl_do_link(temp, udir, upper, true);
>  	else
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index c851158..49be199 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -20,6 +20,7 @@ enum ovl_path_type {
>  #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
>  #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
>  #define OVL_XATTR_REDIRECT OVL_XATTR_PREFIX "redirect"
> +#define OVL_XATTR_FH OVL_XATTR_PREFIX "fh"
>  
>  #define OVL_ISUPPER_MASK 1UL
>  
> @@ -146,6 +147,18 @@ static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
>  	return (struct inode *) (x & ~OVL_ISUPPER_MASK);
>  }
>  
> +/* redirect data format for redirect by file handle */
> +struct ovl_fh {
> +	unsigned char version;	/* 0 */
> +	unsigned char magic;	/* 0xfb */
> +	unsigned char len;	/* size of this header + size of fid */
> +	unsigned char type;	/* fid_type of fid */
> +	unsigned char fid[0];	/* file identifier */
> +} __packed;
> +
> +#define OVL_FH_VERSION	0
> +#define OVL_FH_MAGIC	0xfb
> +
>  /* util.c */
>  int ovl_want_write(struct dentry *dentry);
>  void ovl_drop_write(struct dentry *dentry);
> @@ -171,6 +184,8 @@ bool ovl_redirect_dir(struct super_block *sb);
>  void ovl_clear_redirect_dir(struct super_block *sb);
>  const char *ovl_dentry_get_redirect(struct dentry *dentry);
>  void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
> +bool ovl_redirect_fh(struct super_block *sb);
> +void ovl_clear_redirect_fh(struct super_block *sb);
>  void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
>  void ovl_inode_init(struct inode *inode, struct inode *realinode,
>  		    bool is_upper);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index e294f22..cf22992 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -14,6 +14,7 @@ struct ovl_config {
>  	char *workdir;
>  	bool default_permissions;
>  	bool redirect_dir;
> +	bool redirect_fh;
>  };
>  
>  /* private information held for overlayfs's superblock */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 79500d9..3036b2d 100644
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
> @@ -34,6 +35,12 @@ module_param_named(redirect_dir, ovl_redirect_dir_def, bool, 0644);
>  MODULE_PARM_DESC(ovl_redirect_dir_def,
>  		 "Default to on or off for the redirect_dir feature");
>  
> +static bool ovl_redirect_fh_def =
> +	    IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_FH);
> +module_param_named(redirect_fh, ovl_redirect_fh_def, bool, 0644);
> +MODULE_PARM_DESC(ovl_redirect_fh_def,
> +		 "Default to on or off for redirect by file handle");
> +
>  static void ovl_dentry_release(struct dentry *dentry)
>  {
>  	struct ovl_entry *oe = dentry->d_fsdata;
> @@ -246,9 +253,11 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>  	}
>  	if (ufs->config.default_permissions)
>  		seq_puts(m, ",default_permissions");
> -	if (ufs->config.redirect_dir != ovl_redirect_dir_def)
> +	if (ufs->config.redirect_dir != ovl_redirect_dir_def ||
> +	    ufs->config.redirect_fh != ovl_redirect_fh_def)
>  		seq_printf(m, ",redirect_dir=%s",
> -			   ufs->config.redirect_dir ? "on" : "off");
> +			   !ufs->config.redirect_dir ? "off" :
> +			   ufs->config.redirect_fh ? "fh" : "on");
>  	return 0;
>  }
>  
> @@ -278,6 +287,7 @@ enum {
>  	OPT_DEFAULT_PERMISSIONS,
>  	OPT_REDIRECT_DIR_ON,
>  	OPT_REDIRECT_DIR_OFF,
> +	OPT_REDIRECT_DIR_FH,
>  	OPT_ERR,
>  };
>  
> @@ -288,6 +298,7 @@ static const match_table_t ovl_tokens = {
>  	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
>  	{OPT_REDIRECT_DIR_ON,		"redirect_dir=on"},
>  	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
> +	{OPT_REDIRECT_DIR_FH,		"redirect_dir=fh"},
>  	{OPT_ERR,			NULL}
>  };
>  
> @@ -354,10 +365,17 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  
>  		case OPT_REDIRECT_DIR_ON:
>  			config->redirect_dir = true;
> +			config->redirect_fh = false;
>  			break;

Is this ->redirect_fh=false declarations needed? We do ufs allocation
using kzalloc() and that means all the fields are 0 value.
>  
>  		case OPT_REDIRECT_DIR_OFF:
>  			config->redirect_dir = false;
> +			config->redirect_fh = false;
> +			break;
> +
> +		case OPT_REDIRECT_DIR_FH:
> +			config->redirect_dir = true;
> +			config->redirect_fh = true;
>  			break;
>  
>  		default:
> @@ -754,6 +772,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  
>  	init_waitqueue_head(&ufs->copyup_wq);
>  	ufs->config.redirect_dir = ovl_redirect_dir_def;
> +	ufs->config.redirect_fh = ovl_redirect_fh_def;
>  	err = ovl_parse_opt((char *) data, &ufs->config);
>  	if (err)
>  		goto out_free_config;
> @@ -934,6 +953,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  	else
>  		sb->s_d_op = &ovl_dentry_operations;
>  
> +	/* Redirect by fhandle only if all layers on same sb with export ops */
> +	if (!ufs->same_sb || !ufs->same_sb->s_export_op ||
> +	    !ufs->same_sb->s_export_op->fh_to_dentry)
> +		ufs->config.redirect_fh = false;
> +
>  	ufs->creator_cred = cred = prepare_creds();
>  	if (!cred)
>  		goto out_put_lower_mnt;
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index dcebef0..17530c5 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -215,6 +215,20 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
>  	oe->redirect = redirect;
>  }
>  
> +bool ovl_redirect_fh(struct super_block *sb)
> +{
> +	struct ovl_fs *ofs = sb->s_fs_info;
> +
> +	return ofs->config.redirect_fh;
> +}
> +
> +void ovl_clear_redirect_fh(struct super_block *sb)
> +{
> +	struct ovl_fs *ofs = sb->s_fs_info;
> +
> +	ofs->config.redirect_fh = false;
> +}
> +
>  void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
>  {
>  	struct ovl_entry *oe = dentry->d_fsdata;
> -- 
> 2.7.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
