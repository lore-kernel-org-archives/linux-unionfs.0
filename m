From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v11 02/18] ovl: disable redirect_dir and index when no xattr support
Date: Wed, 31 Jan 2018 16:13:13 -0500
Message-ID: <20180131211329.16328-3-vgoyal@redhat.com>
References: <20180131211329.16328-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54778 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752044AbeAaVNm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 16:13:42 -0500
In-Reply-To: <20180131211329.16328-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

From: Amir Goldstein <amir73il@gmail.com>

Overlayfs falls back to index=off if lower/upper fs does not support
file handles. We should do the same if upper fs does not support xattr.

The redirect_dir feature is implicitly disabled when upper fs does not
support xattr via the check in ovl_redirect_dir(). Make the feature
explicitly disabled in this case by emitting a warning at mount time
and setting redirect_dir to off so its true state is visible in
/proc/mounts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76440feb79f6..e9419faaa156 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -967,7 +967,9 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	err = ovl_do_setxattr(ofs->workdir, OVL_XATTR_OPAQUE, "0", 1, 0);
 	if (err) {
 		ofs->noxattr = true;
-		pr_warn("overlayfs: upper fs does not support xattr.\n");
+		ofs->config.redirect_dir = false;
+		ofs->config.index = false;
+		pr_warn("overlayfs: upper fs does not support xattr, falling back to redirect_dir=off, index=off and no opaque dir.\n");
 	} else {
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
 	}
-- 
2.13.6
