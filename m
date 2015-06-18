From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 5/8] SELinux: Stub in copy-up handling
Date: Thu, 18 Jun 2015 10:44:35 -0400
Message-ID: <5582D953.2030209@tycho.nsa.gov>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk> <20150618133254.12722.33339.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:58007 "EHLO
	emvm-gh1-uea09.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802AbbFROpj (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 18 Jun 2015 10:45:39 -0400
In-Reply-To: <20150618133254.12722.33339.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: David Howells <dhowells@redhat.com>, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, Paul Moore <paul@paul-moore.com>, SELinux <selinux@tycho.nsa.gov>

On 06/18/2015 09:32 AM, David Howells wrote:
> Provide stubs for union/overlay copy-up handling.  The xattr copy up stub
> discards lower SELinux xattrs rather than letting them be copied up so that
> the security label on the copy doesn't get corrupted.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  security/selinux/hooks.c |   16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index ffa5a642629a..c5d893e2ff23 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3200,6 +3200,20 @@ static void selinux_inode_getsecid(const struct inode *inode, u32 *secid)
>  	*secid = isec->sid;
>  }
>  
> +static int selinux_inode_copy_up(struct dentry *src, struct dentry *dst)
> +{
> +	return 0;
> +}
> +
> +static int selinux_inode_copy_up_xattr(struct dentry *src, struct dentry *dst,
> +				       const char *name, void *value,
> +				       size_t *size)
> +{
> +	if (strcmp(name, XATTR_NAME_SELINUX) == 0)
> +		return 1; /* Discard */
> +	return 0;
> +}
> +

(expanded cc list)

I'm not sure we never want to copy up the SELinux attribute.  See my
other email about ecryptfs and supporting per-file labeling and
consistent access control over the upper and lower inodes.

>  /* file security operations */
>  
>  static int selinux_revalidate_file_permission(struct file *file, int mask)
> @@ -5917,6 +5931,8 @@ static struct security_operations selinux_ops = {
>  	.inode_setsecurity =		selinux_inode_setsecurity,
>  	.inode_listsecurity =		selinux_inode_listsecurity,
>  	.inode_getsecid =		selinux_inode_getsecid,
> +	.inode_copy_up =		selinux_inode_copy_up,
> +	.inode_copy_up_xattr =		selinux_inode_copy_up_xattr,
>  
>  	.file_permission =		selinux_file_permission,
>  	.file_alloc_security =		selinux_file_alloc_security,
> 
> 
