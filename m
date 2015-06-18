From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 7/8] SELinux: Create a common helper to determine an inode
 label
Date: Thu, 18 Jun 2015 10:56:15 -0400
Message-ID: <5582DC0F.7090800@tycho.nsa.gov>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk> <20150618133310.12722.16624.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:60980 "EHLO
	emvm-gh1-uea09.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbbFRO5S (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 10:57:18 -0400
In-Reply-To: <20150618133310.12722.16624.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, SELinux <selinux@tycho.nsa.gov>, Paul Moore <paul@paul-moore.com>

On 06/18/2015 09:33 AM, David Howells wrote:
> Create a common helper function to determine the label for a new inode.  This
> is then used by:
> 
> 	- may_create()
> 	- selinux_dentry_init_security()
> 	- selinux_inode_init_security()
> 	- selinux_file_open_union()
> 
> This will change the behaviour of the first two functions slightly, bringing
> them into line with the third.  The fourth function is newly created in a
> preceding patch and applied only in the case of a filesystem union or overlay.
> 
> Suggested-by: Stephen Smalley <sds@tycho.nsa.gov>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  security/selinux/hooks.c |  124 ++++++++++++++++++++++------------------------
>  1 file changed, 60 insertions(+), 64 deletions(-)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c4495a797eb1..7eef1032c11a 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1684,6 +1684,42 @@ out:
>  	return rc;
>  }
>  
> +/*
> + * Determine the label for an inode that might be unioned.
> + */
> +static int selinux_determine_inode_label(const struct inode *dir,
> +					 const struct qstr *name,
> +					 const char *caller,
> +					 u16 tclass,
> +					 u32 *_new_isid)
> +{
> +	const struct superblock_security_struct *sbsec;
> +	const struct inode_security_struct *dsec;
> +	const struct task_security_struct *tsec = current_security();
> +	int rc;
> +
> +	sbsec = dir->i_sb->s_security;
> +
> +	if ((sbsec->flags & SE_SBINITIALIZED) &&
> +		   (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
> +		*_new_isid = sbsec->mntpoint_sid;
> +	} else if (tsec->create_sid) {

This doesn't quite match the logic in inode_init_security today, see its
checking of SBLABEL_MNT.

> +		*_new_isid = tsec->create_sid;
> +	} else {
> +		dsec = dir->i_security;
> +
> +		rc = security_transition_sid(tsec->sid, dsec->sid, tclass,
> +					     name, _new_isid);
> +		if (rc) {
> +			pr_warn("%s:  security_transition_sid failed, rc=%d (name=%*.*s)\n",
> +				caller, -rc, name->len, name->len, name->name);

Let's drop this pr_warn call.

> +			return rc;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
>  /* Check whether a task can create a file. */
>  static int may_create(struct inode *dir,
>  		      struct dentry *dentry,
> @@ -1700,7 +1736,6 @@ static int may_create(struct inode *dir,
>  	sbsec = dir->i_sb->s_security;
>  
>  	sid = tsec->sid;
> -	newsid = tsec->create_sid;
>  
>  	ad.type = LSM_AUDIT_DATA_DENTRY;
>  	ad.u.dentry = dentry;
> @@ -1711,12 +1746,10 @@ static int may_create(struct inode *dir,
>  	if (rc)
>  		return rc;
>  
> -	if (!newsid || !(sbsec->flags & SBLABEL_MNT)) {
> -		rc = security_transition_sid(sid, dsec->sid, tclass,
> -					     &dentry->d_name, &newsid);
> -		if (rc)
> -			return rc;
> -	}
> +	rc = selinux_determine_inode_label(dir, &dentry->d_name, __func__,
> +					   tclass, &newsid);
> +	if (rc)
> +		return rc;
>  
>  	rc = avc_has_perm(sid, newsid, tclass, FILE__CREATE, &ad);
>  	if (rc)
> @@ -2723,32 +2756,14 @@ static int selinux_dentry_init_security(struct dentry *dentry, int mode,
>  					struct qstr *name, void **ctx,
>  					u32 *ctxlen)
>  {
> -	const struct cred *cred = current_cred();
> -	struct task_security_struct *tsec;
> -	struct inode_security_struct *dsec;
> -	struct superblock_security_struct *sbsec;
> -	struct inode *dir = d_backing_inode(dentry->d_parent);
>  	u32 newsid;
>  	int rc;
>  
> -	tsec = cred->security;
> -	dsec = dir->i_security;
> -	sbsec = dir->i_sb->s_security;
> -
> -	if (tsec->create_sid && sbsec->behavior != SECURITY_FS_USE_MNTPOINT) {
> -		newsid = tsec->create_sid;
> -	} else {
> -		rc = security_transition_sid(tsec->sid, dsec->sid,
> -					     inode_mode_to_security_class(mode),
> -					     name,
> -					     &newsid);
> -		if (rc) {
> -			printk(KERN_WARNING
> -				"%s: security_transition_sid failed, rc=%d\n",
> -			       __func__, -rc);
> -			return rc;
> -		}
> -	}
> +	rc = selinux_determine_inode_label(d_inode(dentry), name, __func__,
> +					   inode_mode_to_security_class(mode),
> +					   &newsid);
> +	if (rc)
> +		return rc;
>  
>  	return security_sid_to_context(newsid, (char **)ctx, ctxlen);
>  }
> @@ -2771,22 +2786,12 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
>  	sid = tsec->sid;
>  	newsid = tsec->create_sid;
>  
> -	if ((sbsec->flags & SE_SBINITIALIZED) &&
> -	    (sbsec->behavior == SECURITY_FS_USE_MNTPOINT))
> -		newsid = sbsec->mntpoint_sid;
> -	else if (!newsid || !(sbsec->flags & SBLABEL_MNT)) {
> -		rc = security_transition_sid(sid, dsec->sid,
> -					     inode_mode_to_security_class(inode->i_mode),
> -					     qstr, &newsid);
> -		if (rc) {
> -			printk(KERN_WARNING "%s:  "
> -			       "security_transition_sid failed, rc=%d (dev=%s "
> -			       "ino=%ld)\n",
> -			       __func__,
> -			       -rc, inode->i_sb->s_id, inode->i_ino);
> -			return rc;
> -		}
> -	}
> +	rc = selinux_determine_inode_label(
> +		dir, qstr, __func__,
> +		inode_mode_to_security_class(inode->i_mode),
> +		&newsid);
> +	if (rc)
> +		return rc;
>  
>  	/* Possibly defer initialization to selinux_complete_init. */
>  	if (sbsec->flags & SE_SBINITIALIZED) {
> @@ -3502,9 +3507,7 @@ static int selinux_file_open_union(struct file *file,
>  				   struct file_security_struct *fsec,
>  				   const struct cred *cred)
>  {
> -	const struct superblock_security_struct *sbsec;
> -	const struct inode_security_struct *isec, *dsec, *fisec;
> -	const struct task_security_struct *tsec = current_security();
> +	const struct inode_security_struct *isec, *fisec;
>  	struct common_audit_data ad;
>  	struct dentry *union_dentry = file->f_path.dentry;
>  	const struct inode *union_inode = d_inode(union_dentry);
> @@ -3512,29 +3515,22 @@ static int selinux_file_open_union(struct file *file,
>  	struct dentry *dir;
>  	int rc;
>  
> -	sbsec = union_dentry->d_sb->s_security;
> -
>  	if (union_inode) {
> +		/* If we're opening an overlay inode, use the label from that
> +		 * in preference to the label on a lower inode which we might
> +		 * actually be opening.
> +		 */
>  		isec = union_inode->i_security;
>  		fsec->union_isid = isec->sid;
> -	} else if ((sbsec->flags & SE_SBINITIALIZED) &&
> -		   (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
> -		fsec->union_isid = sbsec->mntpoint_sid;
>  	} else {
>  		dir = dget_parent(union_dentry);
> -		dsec = d_inode(dir)->i_security;
> -
> -		rc = security_transition_sid(
> -			tsec->sid, dsec->sid,
> -			inode_mode_to_security_class(lower_inode->i_mode),
> +		rc = selinux_determine_inode_label(
> +			d_inode(dir),
>  			&union_dentry->d_name,
> +			__func__,
> +			inode_mode_to_security_class(lower_inode->i_mode),
>  			&fsec->union_isid);
>  		dput(dir);
> -		if (rc) {
> -			pr_warn("%s:  security_transition_sid failed, rc=%d (name=%pD)\n",
> -				__func__, -rc, file);
> -			return rc;
> -		}
>  	}
>  
>  	/* We need to check that the union file is allowed to be opened as well
> 
> 
