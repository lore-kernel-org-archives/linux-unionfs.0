From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 15/15] ovl: Enable metadata only feature
Date: Thu,  9 Nov 2017 15:50:19 -0500
Message-ID: <20171109205019.11409-16-vgoyal@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2393 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753751AbdKIUuc (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:50:32 -0500
In-Reply-To: <20171109205019.11409-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

All the bits are in patches before this. So it is time to enable the
metadata only copy up feature.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/util.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 81b307c20a8d..9bda6ff611d4 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -235,9 +235,6 @@ bool ovl_metaonly_copy_up(struct dentry *dentry, umode_t mode, int flags)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 
-	/* TODO: Will enable metacopy in last patch of series */
-	return false;
-
 	if (!ofs->config.metacopy)
 		return false;
 
-- 
2.13.6
