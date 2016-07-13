From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 2/9] selinux: Implementation for inode_copy_up() hook
Date: Wed, 13 Jul 2016 10:53:40 -0400
Message-ID: <96e3a1f0-eb87-72c4-5d69-482973a8088f@tycho.nsa.gov>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
 <1468421095-22322-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1468421095-22322-3-git-send-email-vgoyal@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, miklos@szeredi.hu, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 07/13/2016 10:44 AM, Vivek Goyal wrote:
> A file is being copied up for overlay file system. Prepare a new set of
> creds and set create_sid appropriately so that new file is created with
> appropriate label.
> 
> Overlay inode has right label for both context and non-context mount
> cases. In case of non-context mount, overlay inode will have the label
> of lower file and in case of context mount, overlay inode will have
> the label from context= mount option.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  security/selinux/hooks.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index a86d537..c82ee54 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3270,6 +3270,26 @@ static void selinux_inode_getsecid(struct inode *inode, u32 *secid)
>  	*secid = isec->sid;
>  }
>  
> +static int selinux_inode_copy_up(struct dentry *src, struct cred **new)
> +{
> +	u32 sid;
> +	struct task_security_struct *tsec;
> +	struct cred *new_creds = *new;
> +
> +	if (new_creds == NULL) {
> +		new_creds = prepare_creds();
> +		if (!new_creds)
> +			return -ENOMEM;
> +	}
> +
> +	tsec = new_creds->security;
> +	/* Get label from overlay inode and set it in create_sid */
> +	selinux_inode_getsecid(d_inode(src), &sid);
> +	tsec->create_sid = sid;
> +	*new = new_creds;
> +	return 0;
> +}
> +
>  /* file security operations */
>  
>  static int selinux_revalidate_file_permission(struct file *file, int mask)
> @@ -6056,6 +6076,7 @@ static struct security_hook_list selinux_hooks[] = {
>  	LSM_HOOK_INIT(inode_setsecurity, selinux_inode_setsecurity),
>  	LSM_HOOK_INIT(inode_listsecurity, selinux_inode_listsecurity),
>  	LSM_HOOK_INIT(inode_getsecid, selinux_inode_getsecid),
> +	LSM_HOOK_INIT(inode_copy_up, selinux_inode_copy_up),
>  
>  	LSM_HOOK_INIT(file_permission, selinux_file_permission),
>  	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
> 

