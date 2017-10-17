From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/7] ovl: disable redirect_dir and index when no xattr support
Date: Tue, 17 Oct 2017 18:23:50 +0300
Message-ID: <1508253833-9866-5-git-send-email-amir73il@gmail.com>
References: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:55536 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936323AbdJQPXZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:23:25 -0400
Received: by mail-wm0-f66.google.com with SMTP id u138so4743361wmu.4
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:23:25 -0700 (PDT)
In-Reply-To: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

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
index e2ff17d5022b..a908f4f2e7c3 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1009,7 +1009,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 					      "0", 1, 0);
 			if (err) {
 				ufs->noxattr = true;
-				pr_warn("overlayfs: upper fs does not support xattr.\n");
+				ufs->config.redirect_dir = false;
+				ufs->config.index = false;
+				pr_warn("overlayfs: upper fs does not support xattr, falling back to redirect_dir=off, index=off and no opaque dir.\n");
 			} else {
 				vfs_removexattr(ufs->workdir, OVL_XATTR_OPAQUE);
 			}
-- 
2.7.4
