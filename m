From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 4/9] selinux: Implementation for inode_copy_up_xattr()
 hook
Date: Wed, 13 Jul 2016 10:54:39 -0400
Message-ID: <f8bcf395-e07d-2d8d-ee47-a7628b4835c1@tycho.nsa.gov>
References: <1468421095-22322-1-git-send-email-vgoyal@redhat.com>
 <1468421095-22322-5-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from emsm-gh1-uea10.nsa.gov ([8.44.101.8]:57559 "EHLO
	emsm-gh1-uea10.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbcGMOxO (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 13 Jul 2016 10:53:14 -0400
In-Reply-To: <1468421095-22322-5-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>, miklos@szeredi.hu, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

On 07/13/2016 10:44 AM, Vivek Goyal wrote:
> When a file is copied up in overlay, we have already created file on upper/
> with right label and there is no need to copy up selinux label/xattr from
> lower file to upper file. In fact in case of context mount, we don't want
> to copy up label as newly created file got its label from context= option.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Stephen Smalley <sds@tycho.nsa.gov>

> ---
>  security/selinux/hooks.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index c82ee54..4fda548 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3290,6 +3290,21 @@ static int selinux_inode_copy_up(struct dentry *src, struct cred **new)
>  	return 0;
>  }
>  
> +static int selinux_inode_copy_up_xattr(const char *name)
> +{
> +	/* The copy_up hook above sets the initial context on an inode, but we
> +	 * don't then want to overwrite it by blindly copying all the lower
> +	 * xattrs up.  Instead, we have to filter out SELinux-related xattrs.
> +	 */
> +	if (strcmp(name, XATTR_NAME_SELINUX) == 0)
> +		return 1; /* Discard */
> +	/*
> +	 * Any other attribute apart from SELINUX is not claimed, supported
> +	 * by selinux.
> +	 */
> +	return -EOPNOTSUPP;
> +}
> +
>  /* file security operations */
>  
>  static int selinux_revalidate_file_permission(struct file *file, int mask)
> @@ -6077,6 +6092,7 @@ static struct security_hook_list selinux_hooks[] = {
>  	LSM_HOOK_INIT(inode_listsecurity, selinux_inode_listsecurity),
>  	LSM_HOOK_INIT(inode_getsecid, selinux_inode_getsecid),
>  	LSM_HOOK_INIT(inode_copy_up, selinux_inode_copy_up),
> +	LSM_HOOK_INIT(inode_copy_up_xattr, selinux_inode_copy_up_xattr),
>  
>  	LSM_HOOK_INIT(file_permission, selinux_file_permission),
>  	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
> 
