From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH 3/7] SELinux: Stub in copy-up handling
Date: Fri, 07 Nov 2014 16:44:03 -0500
Message-ID: <1791526.rYj1Ea3vWT@sifl>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154248.2555.15813.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20141105154248.2555.15813.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wednesday, November 05, 2014 03:42:48 PM David Howells wrote:
> Provide stubs for union/overlay copy-up handling.  The xattr copy up stub
> discards lower SELinux xattrs rather than letting them be copied up so that
> the security label on the copy doesn't get corrupted.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  security/selinux/hooks.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index e66314138b38..f3fe7dbbf741 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -3142,6 +3142,19 @@ static void selinux_inode_getsecid(const struct inode
> *inode, u32 *secid) *secid = isec->sid;
>  }
> 
> +static int selinux_inode_copy_up(struct dentry *src, struct dentry *dst)
> +{
> +	return 0;
> +}
> +
> +static int selinux_inode_copy_up_xattr(struct dentry *src, struct dentry
> ...*dst,
> +				       const char *name, void *value, size_t *size)
> +{
> +	if (strcmp(name, XATTR_NAME_SELINUX) == 0)
> +		return 1; /* Discard */

I understand that this is just a stub, but I we need to discuss this at some 
point and I figure better in this patch than elsewhere where it might get 
lost.

For the docker, context= mount use case (similar to SELinux/sVirt) dropping 
the SELinux xattr is probably an okay behavior.  However, I would expect that 
ultimately this is something we would want to control by policy and/or the 
presence of a context= label.

> +	return 0;
> +}
> +
>  /* file security operations */
> 
>  static int selinux_revalidate_file_permission(struct file *file, int mask)
> @@ -5868,6 +5881,8 @@ static struct security_operations selinux_ops = {
>  	.inode_setsecurity =		selinux_inode_setsecurity,
>  	.inode_listsecurity =		selinux_inode_listsecurity,
>  	.inode_getsecid =		selinux_inode_getsecid,
> +	.inode_copy_up =		selinux_inode_copy_up,
> +	.inode_copy_up_xattr =		selinux_inode_copy_up_xattr,
> 
>  	.file_permission =		selinux_file_permission,
>  	.file_alloc_security =		selinux_file_alloc_security,
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-security-module" in the body of a message to
> majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
paul moore
www.paul-moore.com

