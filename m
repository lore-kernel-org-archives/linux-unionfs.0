From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] tmpfs: allow decoding a file handle of an unlinked file
Date: Tue, 07 Nov 2017 12:58:00 -0800
Message-ID: <1510088280.3118.42.camel@HansenPartnership.com>
References: <1510087801-20663-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50906 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932298AbdKGU6C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 15:58:02 -0500
In-Reply-To: <1510087801-20663-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Hugh Dickins <hughd@google.com>, Al Viro <viro@zeniv.linux.org.uk>

On Tue, 2017-11-07 at 22:50 +0200, Amir Goldstein wrote:
> tmpfs uses the helper d_find_alias() to find a dentry from a decoded
> inode, but d_find_alias() skips unhashed dentries, so unlinked files
> cannot be decoded from a file handle.
> 
> This can be reproduced using xfstests test program open_by_handle:
> $ open_by handle -c /tmp/testdir
> $ open_by_handle -dk /tmp/testdir
> open_by_handle(/tmp/testdir/file000000) returned 116 incorrectly on
> an
> unlinked open file!
> 
> To fix this, use a variant of d_find_alias() that returns any alias,
> even an unhashed one.
> 
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  mm/shmem.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> Miklos,
> 
> Please see if that patch looks correct.
> 
> Bruce and Jeff indicated that the current tmpfs behavior is not
> desirable
> for nfsd. It may be uncommon to export a tmpfs, but it is going to
> become
> a lot more common when exporting an overlayfs with upper tmpfs.
> 
> Thanks,
> Amir.
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 07a1d22807be..f7c555ebf0f2 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3404,6 +3404,26 @@ static int shmem_match(struct inode *ino, void
> *vfh)
>  	return ino->i_ino == inum && fh[0] == ino->i_generation;
>  }
>  
> +/* Find any alias of inode, even an unhashed one */
> +static struct dentry *shmem_find_alias(struct inode *inode)
> +{
> +	struct dentry *alias;
> +
> +	spin_lock(&inode->i_lock);
> +	hlist_for_each_entry(alias, &inode->i_dentry, d_u.d_alias) {
> +		dget(alias);
> +		if (alias->d_inode == inode) {
> +			spin_unlock(&inode->i_lock);
> +			return alias;
> +		}
> +		dput(alias);
> +	}
> +	spin_unlock(&inode->i_lock);
> +
> +	return NULL;
> +}

This doesn't look right in the case of a multiply linked inode for
which you've removing some of the link names because it will return the
first alias it finds, which may be unhashed.  Isn't what you want for
it to return the first hashed alias if one exists, or the first
unhashed one if none do, so this code

> @@ -3420,7 +3440,7 @@ static struct dentry *shmem_fh_to_dentry(struct
> super_block *sb,
>         inode = ilookup5(sb, (unsigned long)(inum + fid->raw[0]),
>                         shmem_match, fid->raw);
>         if (inode) {
> -               dentry = d_find_alias(inode);
> +               dentry = shmem_find_alias(inode);
>                 iput(inode);
>         } 


Should actually be

if (inode) {
	dentry = d_find_alias(inode);
	if (!dentry)
		dentry = shmem_find_alias(inode);
	iput(inode)
}

?

James
