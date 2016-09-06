From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH] ovl: Fix for filesystems without POSIX ACL support
Date: Tue,  6 Sep 2016 14:13:40 +0200
Message-ID: <1473164020-13364-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755749AbcIFMNo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Sep 2016 08:13:44 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>

On filesystems without POSIX ACL support such as ubifs, trying to remove
a POSIX ACL with vfs_removexattr will result in -EOPNOTSUPP.  Don't fail
in that case.

Reported-by: Richard Weinberger <richard@nod.at>
Fixes: c11b9fdd
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/overlayfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a4585f9..e2a94a2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -835,11 +835,11 @@ retry:
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
-- 
2.7.4
