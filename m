From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 01/23] ovl: disable index when no xattr support
Date: Thu,  4 Jan 2018 18:39:56 +0200
Message-ID: <1515084018-25134-2-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:46178 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753310AbeADQja (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:30 -0500
Received: by mail-wr0-f196.google.com with SMTP id g17so2007317wrd.13
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:29 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Overlayfs falls back to index=off if lower/upper fs does not support
file handles. Do the same if upper fs does not support xattr.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5f6d2385c0b3..5d5e2b39ba69 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -967,7 +967,8 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	err = ovl_do_setxattr(ofs->workdir, OVL_XATTR_OPAQUE, "0", 1, 0);
 	if (err) {
 		ofs->noxattr = true;
-		pr_warn("overlayfs: upper fs does not support xattr.\n");
+		ofs->config.index = false;
+		pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off.\n");
 		err = 0;
 	} else {
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
-- 
2.7.4
