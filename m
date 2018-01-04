From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 12/23] ovl: cleanup temp index entries
Date: Thu,  4 Jan 2018 18:40:07 +0200
Message-ID: <1515084018-25134-13-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:39329 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbeADQjm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:42 -0500
Received: by mail-wm0-f68.google.com with SMTP id i11so4424051wmf.4
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:42 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

A previous failed attempt to create or whiteout a directory index may leave
index entries named '#%x' in the index dir.
Cleanup those temp entries on mount instead of failing the mount.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index e53c54ecb7cc..4987d7df1581 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -9,6 +9,7 @@
 
 #include <linux/fs.h>
 #include <linux/cred.h>
+#include <linux/ctype.h>
 #include <linux/namei.h>
 #include <linux/xattr.h>
 #include <linux/ratelimit.h>
@@ -452,6 +453,24 @@ static struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
 	return upper.dentry;
 }
 
+/* Is this a leftover from create/whiteout of directory index entry? */
+static bool ovl_is_temp_index(struct dentry *index)
+{
+	const char *p = index->d_name.name;
+	int len = index->d_name.len;
+
+	if (!d_is_dir(index) && !ovl_is_whiteout(index))
+		return false;
+
+	if (*p++ != '#' || len < 2)
+		return false;
+
+	while (--len > 0 && isdigit(*p))
+		p++;
+
+	return !len;
+}
+
 /*
  * Verify that an index entry name matches the origin file handle stored in
  * OVL_XATTR_ORIGIN and that origin file handle can be decoded to lower path.
@@ -469,6 +488,11 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 	if (!d_inode(index))
 		return 0;
 
+	/* Cleanup leftover from index create/cleanup attempt */
+	err = -ESTALE;
+	if (ovl_is_temp_index(index))
+		goto fail;
+
 	err = -EINVAL;
 	if (index->d_name.len < sizeof(struct ovl_fh)*2)
 		goto fail;
-- 
2.7.4
