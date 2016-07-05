From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 3/5] selinux: Pass security pointer to
 determine_inode_label()
Date: Tue, 5 Jul 2016 13:25:22 -0700
Message-ID: <7669deeb-12db-deeb-abd2-1743acf3721b@schaufler-ca.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-4-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1467733854-6314-4-git-send-email-vgoyal@redhat.com>
Sender: owner-linux-security-module@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 7/5/2016 8:50 AM, Vivek Goyal wrote:
> Right now selinux_determine_inode_label() works on security pointer of
> current task. Soon I need this to work on a security pointer retrieved
> from a set of creds. So start passing in a pointer and caller can decide
> where to fetch security pointer from.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  security/selinux/hooks.c | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c68223c..86a07ed 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1785,13 +1785,13 @@ out:
>  /*
>   * Determine the label for an inode that might be unioned.
>   */
> -static int selinux_determine_inode_label(struct inode *dir,
> -					 const struct qstr *name,
> -					 u16 tclass,
> +static int selinux_determine_inode_label(const void *security,

You know the type. Why not use it?

	static int selinux_determine_inode_label(const struct task_security_struct *tsec,

> +					 struct inode *dir,
> +					 const struct qstr *name, u16 tclass,
>  					 u32 *_new_isid)
>  {
>  	const struct superblock_security_struct *sbsec = dir->i_sb->s_security;
> -	const struct task_security_struct *tsec = current_security();
> +	const struct task_security_struct *tsec = security;
>  
>  	if ((sbsec->flags & SE_SBINITIALIZED) &&
>  	    (sbsec->behavior == SECURITY_FS_USE_MNTPOINT)) {
> @@ -1834,8 +1834,8 @@ static int may_create(struct inode *dir,
>  	if (rc)
>  		return rc;
>  
> -	rc = selinux_determine_inode_label(dir, &dentry->d_name, tclass,
> -					   &newsid);
> +	rc = selinux_determine_inode_label(current_security(), dir,
> +					   &dentry->d_name, tclass, &newsid);
>  	if (rc)
>  		return rc;
>  
> @@ -2815,7 +2815,8 @@ static int selinux_dentry_init_security(struct dentry *dentry, int mode,
>  	u32 newsid;
>  	int rc;
>  
> -	rc = selinux_determine_inode_label(d_inode(dentry->d_parent), name,
> +	rc = selinux_determine_inode_label(current_security(),
> +					   d_inode(dentry->d_parent), name,
>  					   inode_mode_to_security_class(mode),
>  					   &newsid);
>  	if (rc)
> @@ -2840,7 +2841,7 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
>  	sid = tsec->sid;
>  	newsid = tsec->create_sid;
>  
> -	rc = selinux_determine_inode_label(
> +	rc = selinux_determine_inode_label(current_security(),
>  		dir, qstr,
>  		inode_mode_to_security_class(inode->i_mode),
>  		&newsid);

