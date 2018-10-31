Return-Path: <miklos@szeredi.hu>
Date: Wed, 31 Oct 2018 09:31:09 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: do not hash ovl dentry when inode is NULL in
 ovl_lookup
Message-ID: <20181031083109.GE23439@veci.piliscsaba.redhat.com>
References: <877bef77-3434-656f-a989-143179c2e1b7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877bef77-3434-656f-a989-143179c2e1b7@gmail.com>
To: kaixuxia <xiakaixu1987@gmail.com>
Cc: linux-unionfs@vger.kernel.org, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 03:12:03PM +0800, kaixuxia wrote:
> The dentry is hashed even if the inode is NULL in ovl_lookup and
> later we get this dentry in lookup_dcache. But this dentry may
> become stale when someone could (mistakenly or maliciously) manually
> unlink the whiteout file directly from upperdir. So the NUll pointer
> error occur when create the same name directory and system crash.
> 
> Simple reproducer:
>   $ mkdir lower upper work merge
>   $ touch lower/file
>   $ mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work
> merge
>   $ rm merge/file
>   $ ls -al merge/file
> ls: cannot access merge/file: No such file or directory
>   $ rm upper/file
>   $ ls -al merge/
> ls: cannot access merge/file: No such file or directory
> total 0
> drwxr-xr-x 1 root root  6 Oct 30 09:16 .
> drwxr-xr-x 6 root root 57 Oct 30 09:15 ..
> -????????? ? ?    ?     ?            ? file
>   $ mkdir merge/file
> Killed
> 
> [ 2313.705789] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000000

Good catch!

Not hashing a negative dentry is not a good solution, however, because in the
normal case cached negative dentries are quite useful and improve performance of
various workloads.

Here's a tested patch that should fix the real issue: vfs_rename() with
RENAME_EXCHANGE must get two positive dentries.

Amir, we need a test for this in one of the suites.  Which one is more
appropriate, unionmount-testsuite or xfstests?

Thanks,
Miklos
---

From: Miklos Szeredi <mszeredi@redhat.com>
Subject: ovl: check whiteout in ovl_create_over_whiteout()

Kaixuxia repors that it's possible to crash overlayfs by removing the
whiteout on the upper layer before creating an object over it.  This is a
reproducer:

 mkdir lower upper work merge
 touch lower/file
 mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merge
 rm merge/file
 ls -al merge/file
 rm upper/file
 ls -al merge/
 mkdir merge/file

Before commencing with a vfs_rename(..., RENAME_EXCHANGE) verify that the
lookup of "upper" is positive and is a whiteout, and return ESTALE
otherwise.

Reported by: kaixuxia <xiakaixu1987@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -462,6 +462,10 @@ static int ovl_create_over_whiteout(stru
 	if (IS_ERR(upper))
 		goto out_unlock;
 
+	err = -ESTALE;
+	if (d_is_negative(upper) || !IS_WHITEOUT(d_inode(upper)))
+		goto out_dput;
+
 	newdentry = ovl_create_temp(workdir, cattr);
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
