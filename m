From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 5/7] SELinux: Handle opening of a unioned file
Date: Wed, 05 Nov 2014 11:35:23 -0500
Message-ID: <545A51CB.6070107@tycho.nsa.gov>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154307.2555.9847.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20141105154307.2555.9847.stgit@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 11/05/2014 10:43 AM, David Howells wrote:
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
>  security/selinux/hooks.c          |   56 +++++++++++++++++++++++++++++++++++++
>  security/selinux/include/objsec.h |    1 +
>  2 files changed, 57 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 6fd8090cc7a5..f43f07fdc028 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3431,6 +3431,58 @@ static int selinux_file_receive(struct file *file)
>  	return file_has_perm(cred, file, file_to_av(file));
>  }
>  
> +/*
> + * We have a file opened on a unioned file system that falls through to a file
> + * on a lower layer.  If there is a union inode, we try to get the label from
> + * that, otherwise we need to get it from the superblock.
> + */
> +static int selinux_file_open_union(struct file *file,
> +				   const struct path *union_path,
> +				   struct file_security_struct *fsec,
> +				   const struct cred *cred)
> +{
> +	const struct superblock_security_struct *sbsec;
> +	const struct inode_security_struct *isec, *dsec;
> +	const struct task_security_struct *tsec = current_security();
> +	struct common_audit_data ad;
> +	const struct inode *inode = union_path->dentry->d_inode;
> +	struct dentry *dir;
> +	int rc;
> +
> +	sbsec = union_path->dentry->d_sb->s_security;
> +
> +	if (inode) {
> +		isec = inode->i_security;
> +		fsec->union_isid = isec->sid;
> +	} else if ((sbsec->flags & SE_SBINITIALIZED) &&
> +		   (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
> +		fsec->union_isid = sbsec->mntpoint_sid;
> +	} else {
> +		dir = dget_parent(union_path->dentry);
> +		dsec = dir->d_inode->i_security;
> +
> +		rc = security_transition_sid(
> +			tsec->sid, dsec->sid,
> +			inode_mode_to_security_class(file_inode(file)->i_mode),
> +			&union_path->dentry->d_name,
> +			&fsec->union_isid);
> +		dput(dir);
> +		if (rc) {
> +			printk(KERN_WARNING "%s:  "
> +			       "security_transition_sid failed, rc=%d (name=%pD)\n",
> +			       __func__, -rc, file);
> +			return rc;
> +		}
> +	}

How do we know that this union_isid will bear any relation to the actual
SID assigned to the union inode when it is created?  If the union inode
does not already exist, when/where does it get created?

Also, would be good to create a common helper for use here, by
selinux_dentry_init_security(), selinux_inode_init_security(), and
may_create().  Already some seeming potential for inconsistencies there.

> +
> +	/* We need to check that the union file is allowed to be opened as well
> +	 * as checking that the lower file is allowed to be opened.
> +	 */
> +	ad.type = LSM_AUDIT_DATA_PATH;
> +	ad.u.path = *union_path;
> +	return inode_has_perm(cred, file_inode(file), fsec->union_isid, &ad);

Something is seriously wrong here; you are passing fsec->union_isid
where we expect a permissions bitmap / access vector.

> +}
> +
>  static int selinux_file_open(struct file *file, const struct path *union_path,
>  			     const struct cred *cred)
>  {
> @@ -3456,6 +3508,10 @@ static int selinux_file_open(struct file *file, const struct path *union_path,
>  	 * new inode label or new policy.
>  	 * This check is not redundant - do not remove.
>  	 */
> +
> +	if (union_path->dentry != file->f_path.dentry)
> +		selinux_file_open_union(file, union_path, fsec, cred);

Ignored return value.

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
> _______________________________________________
> Selinux mailing list
> Selinux@tycho.nsa.gov
> To unsubscribe, send email to Selinux-leave@tycho.nsa.gov.
> To get help, send an email containing "help" to Selinux-request@tycho.nsa.gov.
> 

