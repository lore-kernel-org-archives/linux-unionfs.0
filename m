From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: overlayfs stopped working in v4.8-rc4-359-g4b30b6d
Date: Mon, 5 Sep 2016 14:11:43 +0200
Message-ID: <20160905121143.GN25404@veci.piliscsaba.szeredi.hu>
References: <E1bgKVE-0007is-60@tux00.mathematik.uni-freiburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34264 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754418AbcIEMLs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Sep 2016 08:11:48 -0400
Received: by mail-wm0-f67.google.com with SMTP id w12so3562751wmf.1
        for <linux-unionfs@vger.kernel.org>; Mon, 05 Sep 2016 05:11:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <E1bgKVE-0007is-60@tux00.mathematik.uni-freiburg.de>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: ziegler@uni-freiburg.de
Cc: linux-unionfs@vger.kernel.org

On Sun, Sep 04, 2016 at 01:37:36AM +0200, ziegler@uni-freiburg.de wrote:
> Dear Miklos,
> 
> overlayfs works still in  v4.8-rc4, but not longer in the newest kernel:
> 
> 
> If the four directories test_lowerdir,test/upperd, test/workd,
> test_mountdir exist, the command
> 
>   mount -t overlay -o lowerdir=test_lowerdir,upperdir=test/upperd,workdir=test/workd,noatime overlay test_mountdir
> 
> does not produce a writable files system. The kernel says:
> 
> 
>   kernel: overlayfs: failed to create directory /root/test/workd/work (errno: 95); mounting read-only
> 
> 
> I bisected between v4.8-rc4 and v4.8-rc4-359-g4b30b6d and found
> 
>   c11b9fdd6a612f376a5e886505f1c54c16d8c380
>   Author: Miklos Szeredi <mszeredi@redhat.com>
>   Date:   Thu Sep 1 11:11:59 2016 +0200
> 
>     ovl: remove posix_acl_default from workdir
> 
> responsible. Reverting this makes overlayfs work again.
>

Thanks for spotting this bug!

The following patch should fix it.  Pushed to overlayfs-linus branch of
git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git

Thanks,
Miklos
---

From: Miklos Szeredi <mszeredi@redhat.com>
Subject: ovl: fix workdir creation

Workdir creation fails in latest kernel.

Fix by allowing EOPNOTSUPP as a valid return value from
vfs_removexattr(XATTR_NAME_POSIX_ACL_*).  Upper filesystem may not support
ACL and still be perfectly able to support overlayfs.

Reported-by: Martin Ziegler <ziegler@uni-freiburg.de>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: c11b9fdd6a61 ("ovl: remove posix_acl_default from workdir")
Cc: <stable@vger.kernel.org>
---
 fs/overlayfs/super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -835,11 +835,11 @@ static struct dentry *ovl_workdir_create
 			goto out_dput;
 
 		err = vfs_removexattr(work, XATTR_NAME_POSIX_ACL_DEFAULT);
-		if (err && err != -ENODATA)
+		if (err && err != -ENODATA && err != -EOPNOTSUPP)
 			goto out_dput;
 
 		err = vfs_removexattr(work, XATTR_NAME_POSIX_ACL_ACCESS);
-		if (err && err != -ENODATA)
+		if (err && err != -ENODATA && err != -EOPNOTSUPP)
 			goto out_dput;
 
 		/* Clear any inherited mode bits */
