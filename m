From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 6/8] SELinux: Handle opening of a unioned file
Date: Thu, 18 Jun 2015 10:54:17 -0400
Message-ID: <5582DB99.70001@tycho.nsa.gov>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk> <20150618133302.12722.14996.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150618133302.12722.14996.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, Selinux@tycho.nsa.gov, Paul Moore <paul@paul-moore.com>
List-Id: linux-unionfs@vger.kernel.org

On 06/18/2015 09:33 AM, David Howells wrote:
> Handle the opening of a unioned file by trying to derive the label that would
> be attached to the union-layer inode if it doesn't exist.
> 
> If the union-layer inode does exist (as it necessarily does in overlayfs, but
> not in unionmount), we assume that it has the right label and use that.
> Otherwise we try to get it from the superblock.
> 
> If the superblock has a globally-applied label, we use that, otherwise we try
> to transition to an appropriate label.  This union label is then stored in the
> file_security_struct.
> 
> We then perform an additional check to make sure that the calling task is
> granted permission by the union-layer inode label to open the file in addition
> to a check to make sure that the task is granted permission to open the lower
> file with the lower inode label.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  security/selinux/hooks.c          |   69 +++++++++++++++++++++++++++++++++++++
>  security/selinux/include/objsec.h |    1 +
>  2 files changed, 70 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c5d893e2ff23..c4495a797eb1 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3490,10 +3490,72 @@ static int selinux_file_receive(struct file *file)
>  	return file_has_perm(cred, file, file_to_av(file));
>  }
>  
> +/*
> + * We have a file opened on a unioned file system that falls through to a file
> + * on a lower layer.  If there is a union inode, we try to get the label from
> + * that, otherwise we need to get it from the superblock.
> + *
> + * file->f_path points to the union layer and file->f_inode points to the lower
> + * layer.
> + */
> +static int selinux_file_open_union(struct file *file,
> +				   struct file_security_struct *fsec,
> +				   const struct cred *cred)
> +{
> +	const struct superblock_security_struct *sbsec;
> +	const struct inode_security_struct *isec, *dsec, *fisec;
> +	const struct task_security_struct *tsec = current_security();
> +	struct common_audit_data ad;
> +	struct dentry *union_dentry = file->f_path.dentry;
> +	const struct inode *union_inode = d_inode(union_dentry);
> +	const struct inode *lower_inode = file_inode(file);
> +	struct dentry *dir;
> +	int rc;
> +
> +	sbsec = union_dentry->d_sb->s_security;
> +
> +	if (union_inode) {
> +		isec = union_inode->i_security;
> +		fsec->union_isid = isec->sid;
> +	} else if ((sbsec->flags & SE_SBINITIALIZED) &&
> +		   (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
> +		fsec->union_isid = sbsec->mntpoint_sid;
> +	} else {
> +		dir = dget_parent(union_dentry);
> +		dsec = d_inode(dir)->i_security;
> +
> +		rc = security_transition_sid(
> +			tsec->sid, dsec->sid,
> +			inode_mode_to_security_class(lower_inode->i_mode),
> +			&union_dentry->d_name,
> +			&fsec->union_isid);
> +		dput(dir);
> +		if (rc) {
> +			pr_warn("%s:  security_transition_sid failed, rc=%d (name=%pD)\n",
> +				__func__, -rc, file);

I would drop this pr_warn altogether (and ultimately the printk from
inode_init_security).  Not necessary.

> +			return rc;
> +		}
> +	}
> +
> +	/* We need to check that the union file is allowed to be opened as well
> +	 * as checking that the lower file is allowed to be opened.

Hmm...so if I try to open a file for write access, then we are going to
require that the process be allowed to write to both the union/overlay
inode and to the lower inode?  That seems problematic for the containers
use case where no write access will be granted to the lower files.

> +	 */
> +	if (unlikely(IS_PRIVATE(lower_inode)))
> +		return 0;
> +
> +	ad.type = LSM_AUDIT_DATA_PATH;
> +	ad.u.path = file->f_path;
> +
> +	fisec = lower_inode->i_security;
> +	return avc_has_perm(cred_sid(cred), fsec->union_isid, fisec->sclass,
> +			    open_file_to_av(file), &ad);
> +}
> +
>  static int selinux_file_open(struct file *file, const struct cred *cred)
>  {
>  	struct file_security_struct *fsec;
>  	struct inode_security_struct *isec;
> +	int rc;
>  
>  	fsec = file->f_security;
>  	isec = file_inode(file)->i_security;
> @@ -3514,6 +3576,13 @@ static int selinux_file_open(struct file *file, const struct cred *cred)
>  	 * new inode label or new policy.
>  	 * This check is not redundant - do not remove.
>  	 */
> +
> +	if (d_inode(file->f_path.dentry) != file->f_inode) {
> +		rc = selinux_file_open_union(file, fsec, cred);
> +		if (rc < 0)
> +			return rc;
> +	}
> +
>  	return file_path_has_perm(cred, file, open_file_to_av(file));
>  }
>  
> diff --git a/security/selinux/include/objsec.h b/security/selinux/include/objsec.h
> index 81fa718d5cb3..f088c080aa9e 100644
> --- a/security/selinux/include/objsec.h
> +++ b/security/selinux/include/objsec.h
> @@ -54,6 +54,7 @@ struct file_security_struct {
>  	u32 sid;		/* SID of open file description */
>  	u32 fown_sid;		/* SID of file owner (for SIGIO) */
>  	u32 isid;		/* SID of inode at the time of file open */
> +	u32 union_isid;		/* SID of would-be inodes in union top (or 0) */
>  	u32 pseqno;		/* Policy seqno at the time of file open */
>  };
>  
> 
> 
