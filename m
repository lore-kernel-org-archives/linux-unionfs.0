From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: tentative fix for broken vfs_open() on stacked
 overlayfs.
Date: Tue, 29 Nov 2016 10:32:29 +0100
Message-ID: <20161129093229.GD2622@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35855 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756753AbcK2Jce (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Nov 2016 04:32:34 -0500
Received: by mail-wm0-f65.google.com with SMTP id m203so23207871wma.3
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Nov 2016 01:32:33 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>

On Mon, Nov 28, 2016 at 12:06:09PM +0100, Quentin Casasnovas wrote:

> > > > But it looks like it was re-introduced in:
> > > > 
> > > >   2d902671ce1c ("vfs: merge .d_select_inode() into .d_real()")

Here's a slightly different patch.  It should work exactly the same, but the
error handling is hopefully less broken.

Thanks,
Miklos
---

From: Miklos Szeredi <mszeredi@redhat.com>
Subject: ovl: fix d_real() for stacked fs

Handling of recursion in d_real() is completely broken.  Recursion is only
done in the 'inode != NULL' case.  But when opening the file we have
'inode == NULL' hence d_real() will return an overlay dentry.  This won't
work since overlayfs doesn't define its own file operations, so all file
ops will fail.

Fix by doing the recursion first and the check against the inode second.

Bash script to reproduce the issue written by Quentin:

 - 8< - - - - - 8< - - - - - 8< - - - - - 8< - - - -
tmpdir=$(mktemp -d)
pushd ${tmpdir}

mkdir -p {upper,lower,work}
echo -n 'rocks' > lower/ksplice
mount -t overlay level_zero upper -o lowerdir=lower,upperdir=upper,workdir=work
cat upper/ksplice

tmpdir2=$(mktemp -d)
pushd ${tmpdir2}

mkdir -p {upper,work}
mount -t overlay level_one upper -o lowerdir=${tmpdir}/upper,upperdir=upper,workdir=work
ls -l upper/ksplice
cat upper/ksplice
 - 8< - - - - - 8< - - - - - 8< - - - - - 8< - - - - 

Reported-by: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: 2d902671ce1c ("vfs: merge .d_select_inode() into .d_real()")
Cc: <stable@vger.kernel.org> # v4.8+
---
 fs/overlayfs/super.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -328,11 +328,11 @@ static struct dentry *ovl_d_real(struct
 	if (!real)
 		goto bug;
 
+	/* Handle recursion */
+	real = d_real(real, inode, open_flags);
+
 	if (!inode || inode == d_inode(real))
 		return real;
-
-	/* Handle recursion */
-	return d_real(real, inode, open_flags);
 bug:
 	WARN(1, "ovl_d_real(%pd4, %s:%lu): real dentry not found\n", dentry,
 	     inode ? inode->i_sb->s_id : "NULL", inode ? inode->i_ino : 0);
