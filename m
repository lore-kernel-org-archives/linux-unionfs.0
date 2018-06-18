From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: overlayfs: caller_credentials option bypass creator_cred
Date: Mon, 18 Jun 2018 14:54:48 -0400
Message-ID: <20180618185448.GA8749@redhat.com>
References: <20180618154222.19279-1-salyzyn@android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180618154222.19279-1-salyzyn@android.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salyzyn <salyzyn@android.com>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Jonathan Corbet <corbet@lwn.net>, linux-unionfs@vger.kernel.org, linux-doc@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jun 18, 2018 at 08:42:15AM -0700, Mark Salyzyn wrote:
> All accesses to the lower filesystems reference the creator (mount)
> and not the source context.  This is a security issue.

Can you elaborate with an example that how this is a security issue. 
mounter's check is in addition to caller's check. So we have two 
checks in ovl_permission(). overlay inode gets the credentials from
underlying inode and we first check if caller is allowed to the
operation and if that's allowed, then we check if mounter is allowed
to do the operation.

IOW, mounter's check happen in addition to caller's checks. I am
wondering how did it end up being a security issue.

Vivek

> 
> A module bool parameter and mount option caller_credentials is added
> to set the default, and to act as a presence check for this feature.
> The module parameter is used to change the default behavior because
> the 'normal' behavior of overlayfs is a _security_ violation
> providing the privileges of the creator to the user when accessing
> the files in the filesystems.  But since I can not break user API,
> I have to preserve the original behavior as default.
> 
> On MAC security model expect to set the caller_credentials to Y as
> part of early initialization to preserve security model when the
> option of iether caller_credentials or creator_credentials is not
> explicitly specified in the mount.
> 
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> Cc: Miklos Szeredi <miklos@szeredi.hu>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-unionfs@vger.kernel.org 
> Cc: linux-doc@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/filesystems/overlayfs.txt |  7 +++++++
>  fs/overlayfs/copy_up.c                  |  3 ++-
>  fs/overlayfs/dir.c                      | 12 ++++++++----
>  fs/overlayfs/inode.c                    | 24 ++++++++++++++++--------
>  fs/overlayfs/namei.c                    |  9 ++++++---
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/readdir.c                  |  6 ++++--
>  fs/overlayfs/super.c                    | 22 ++++++++++++++++++++++
>  fs/overlayfs/util.c                     |  8 ++++++--
>  9 files changed, 72 insertions(+), 20 deletions(-)
> 
> diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> index 72615a2c0752..4328be5cdaa9 100644
> --- a/Documentation/filesystems/overlayfs.txt
> +++ b/Documentation/filesystems/overlayfs.txt
> @@ -106,6 +106,13 @@ Only the lists of names from directories are merged.  Other content
>  such as metadata and extended attributes are reported for the upper
>  directory only.  These attributes of the lower directory are hidden.
>  
> +credentials
> +-----------
> +
> +All access to the upper, lower and work directories is the creator's
> +credentials.  If caller_credentials is set, then the access caller's
> +instance credentials will be used.
> +
>  whiteouts and opaque directories
>  --------------------------------
>  
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index ddaddb4ce4c3..abc21844f712 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -790,7 +790,8 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
>  		dput(parent);
>  		dput(next);
>  	}
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  
>  	return err;
>  }
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index f480b1a2cd2e..97473bb2ee60 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -561,7 +561,8 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
>  		override_cred->fsgid = inode->i_gid;
>  		if (!attr->hardlink) {
>  			err = security_dentry_create_files_as(dentry,
> -					attr->mode, &dentry->d_name, old_cred,
> +					stat->mode, &dentry->d_name,
> +					old_cred ? old_cred : current_cred(),
>  					override_cred);
>  			if (err) {
>  				put_cred(override_cred);
> @@ -577,7 +578,8 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
>  			err = ovl_create_over_whiteout(dentry, inode, attr);
>  	}
>  out_revert_creds:
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  	return err;
>  }
>  
> @@ -824,7 +826,8 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
>  		err = ovl_remove_upper(dentry, is_dir, &list);
>  	else
>  		err = ovl_remove_and_whiteout(dentry, &list);
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  	if (!err) {
>  		if (is_dir)
>  			clear_nlink(dentry->d_inode);
> @@ -1150,7 +1153,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>  out_unlock:
>  	unlock_rename(new_upperdir, old_upperdir);
>  out_revert_creds:
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  	ovl_nlink_end(new, locked);
>  out_drop_write:
>  	ovl_drop_write(old);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index ed16a898caeb..222678b6e67e 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -49,7 +49,8 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
>  		inode_lock(upperdentry->d_inode);
>  		old_cred = ovl_override_creds(dentry->d_sb);
>  		err = notify_change(upperdentry, attr, NULL);
> -		revert_creds(old_cred);
> +		if (old_cred)
> +			revert_creds(old_cred);
>  		if (!err)
>  			ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
>  		inode_unlock(upperdentry->d_inode);
> @@ -208,7 +209,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>  		stat->nlink = dentry->d_inode->i_nlink;
>  
>  out:
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  
>  	return err;
>  }
> @@ -242,7 +244,8 @@ int ovl_permission(struct inode *inode, int mask)
>  		mask |= MAY_READ;
>  	}
>  	err = inode_permission(realinode, mask);
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  
>  	return err;
>  }
> @@ -259,7 +262,8 @@ static const char *ovl_get_link(struct dentry *dentry,
>  
>  	old_cred = ovl_override_creds(dentry->d_sb);
>  	p = vfs_get_link(ovl_dentry_real(dentry), done);
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  	return p;
>  }
>  
> @@ -302,7 +306,8 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
>  		WARN_ON(flags != XATTR_REPLACE);
>  		err = vfs_removexattr(realdentry, name);
>  	}
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  
>  out_drop_write:
>  	ovl_drop_write(dentry);
> @@ -320,7 +325,8 @@ int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
>  
>  	old_cred = ovl_override_creds(dentry->d_sb);
>  	res = vfs_getxattr(realdentry, name, value, size);
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  	return res;
>  }
>  
> @@ -344,7 +350,8 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
>  
>  	old_cred = ovl_override_creds(dentry->d_sb);
>  	res = vfs_listxattr(realdentry, list, size);
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  	if (res <= 0 || size == 0)
>  		return res;
>  
> @@ -379,7 +386,8 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
>  
>  	old_cred = ovl_override_creds(inode->i_sb);
>  	acl = get_acl(realinode, type);
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  
>  	return acl;
>  }
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index c993dd8db739..c8b84d262ec2 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1024,7 +1024,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  		OVL_I(inode)->redirect = upperredirect;
>  	}
>  
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  	dput(index);
>  	kfree(stack);
>  	kfree(d.redirect);
> @@ -1043,7 +1044,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>  	kfree(upperredirect);
>  out:
>  	kfree(d.redirect);
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  	return ERR_PTR(err);
>  }
>  
> @@ -1097,7 +1099,8 @@ bool ovl_lower_positive(struct dentry *dentry)
>  			dput(this);
>  		}
>  	}
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  
>  	return positive;
>  }
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 41655a7d6894..7e17db561a04 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -18,6 +18,7 @@ struct ovl_config {
>  	const char *redirect_mode;
>  	bool index;
>  	bool nfs_export;
> +	bool caller_credentials;
>  	int xino;
>  };
>  
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index ef1fe42ff7bb..af3874d589ad 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -289,7 +289,8 @@ static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
>  		}
>  		inode_unlock(dir->d_inode);
>  	}
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  
>  	return err;
>  }
> @@ -906,7 +907,8 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
>  
>  	old_cred = ovl_override_creds(dentry->d_sb);
>  	err = ovl_dir_read_merged(dentry, list, &root);
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  	if (err)
>  		return err;
>  
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 704b37311467..184688ab35cb 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -56,6 +56,11 @@ module_param_named(xino_auto, ovl_xino_auto_def, bool, 0644);
>  MODULE_PARM_DESC(ovl_xino_auto_def,
>  		 "Auto enable xino feature");
>  
> +static bool __read_mostly ovl_caller_credentials;
> +module_param_named(caller_credentials, ovl_caller_credentials, bool, 0644);
> +MODULE_PARM_DESC(ovl_caller_credentials,
> +		 "Use caller credentials rather than creator credentials for accesses");
> +
>  static void ovl_entry_stack_free(struct ovl_entry *oe)
>  {
>  	unsigned int i;
> @@ -376,6 +381,10 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>  						"on" : "off");
>  	if (ofs->config.xino != ovl_xino_def())
>  		seq_printf(m, ",xino=%s", ovl_xino_str[ofs->config.xino]);
> +	if (ofs->config.caller_credentials)
> +		seq_puts(m, ",caller_credentials");
> +	else
> +		seq_puts(m, ",creator_credentials");
>  	return 0;
>  }
>  
> @@ -413,6 +422,8 @@ enum {
>  	OPT_XINO_ON,
>  	OPT_XINO_OFF,
>  	OPT_XINO_AUTO,
> +	OPT_CREATOR_CREDENTIALS,
> +	OPT_CALLER_CREDENTIALS,
>  	OPT_ERR,
>  };
>  
> @@ -429,6 +440,8 @@ static const match_table_t ovl_tokens = {
>  	{OPT_XINO_ON,			"xino=on"},
>  	{OPT_XINO_OFF,			"xino=off"},
>  	{OPT_XINO_AUTO,			"xino=auto"},
> +	{OPT_CREATOR_CREDENTIALS,	"creator_credentials"},
> +	{OPT_CALLER_CREDENTIALS,	"caller_credentials"},
>  	{OPT_ERR,			NULL}
>  };
>  
> @@ -486,6 +499,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  	if (!config->redirect_mode)
>  		return -ENOMEM;
>  
> +	config->caller_credentials = ovl_caller_credentials;
>  	while ((p = ovl_next_opt(&opt)) != NULL) {
>  		int token;
>  		substring_t args[MAX_OPT_ARGS];
> @@ -555,6 +569,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  			config->xino = OVL_XINO_AUTO;
>  			break;
>  
> +		case OPT_CREATOR_CREDENTIALS:
> +			config->caller_credentials = false;
> +			break;
> +
> +		case OPT_CALLER_CREDENTIALS:
> +			config->caller_credentials = true;
> +			break;
> +
>  		default:
>  			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
>  			return -EINVAL;
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 6f1078028c66..538802289511 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -40,6 +40,8 @@ const struct cred *ovl_override_creds(struct super_block *sb)
>  {
>  	struct ovl_fs *ofs = sb->s_fs_info;
>  
> +	if (ofs->config.caller_credentials)
> +		return NULL;
>  	return override_creds(ofs->creator_cred);
>  }
>  
> @@ -630,7 +632,8 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
>  	 * value relative to the upper inode nlink in an upper inode xattr.
>  	 */
>  	err = ovl_set_nlink_upper(dentry);
> -	revert_creds(old_cred);
> +	if (old_cred)
> +		revert_creds(old_cred);
>  
>  out:
>  	if (err)
> @@ -650,7 +653,8 @@ void ovl_nlink_end(struct dentry *dentry, bool locked)
>  
>  			old_cred = ovl_override_creds(dentry->d_sb);
>  			ovl_cleanup_index(dentry);
> -			revert_creds(old_cred);
> +			if (old_cred)
> +				revert_creds(old_cred);
>  		}
>  
>  		mutex_unlock(&OVL_I(d_inode(dentry))->lock);
> -- 
> 2.18.0.rc1.244.gcf134e6275-goog
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
