From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 7/9] selinux: Implement dentry_create_files_as() hook
Date: Wed, 13 Jul 2016 10:59:38 -0400
Message-ID: <948a8737-6f77-4e11-c7b9-f2ef23a96382@tycho.nsa.gov>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
 <1468421095-22322-8-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468421095-22322-8-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, miklos@szeredi.hu, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 07/13/2016 10:44 AM, Vivek Goyal wrote:
> Calculate what would be the label of newly created file and set that secid
> in the passed creds.
> 
> Context of the task which is actually creating file is retrieved from
> set of creds passed in. (old->security).
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  security/selinux/hooks.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index ae11fd9..77eb5a8 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2825,6 +2825,27 @@ static int selinux_dentry_init_security(struct dentry *dentry, int mode,
>  	return security_sid_to_context(newsid, (char **)ctx, ctxlen);
>  }
>  
> +static int selinux_dentry_create_files_as(struct dentry *dentry, int mode,
> +					  struct qstr *name,
> +					  const struct cred *old,
> +					  struct cred *new)
> +{
> +	u32 newsid;
> +	int rc;
> +	struct task_security_struct *tsec;
> +
> +	rc = selinux_determine_inode_label(old->security,
> +					   d_inode(dentry->d_parent), name,
> +					   inode_mode_to_security_class(mode),
> +					   &newsid);
> +	if (rc)
> +		return rc;
> +
> +	tsec = new->security;
> +	tsec->create_sid = newsid;
> +	return 0;
> +}
> +
>  static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
>  				       const struct qstr *qstr,
>  				       const char **name,
> @@ -6066,6 +6087,7 @@ static struct security_hook_list selinux_hooks[] = {
>  	LSM_HOOK_INIT(sb_parse_opts_str, selinux_parse_opts_str),
>  
>  	LSM_HOOK_INIT(dentry_init_security, selinux_dentry_init_security),
> +	LSM_HOOK_INIT(dentry_create_files_as, selinux_dentry_create_files_as),
>  
>  	LSM_HOOK_INIT(inode_alloc_security, selinux_inode_alloc_security),
>  	LSM_HOOK_INIT(inode_free_security, selinux_inode_free_security),
> 
