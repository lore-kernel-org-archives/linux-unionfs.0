From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v10 18/18] ovl: Enable metadata only feature
Date: Mon, 22 Jan 2018 13:40:04 -0500
Message-ID: <20180122184004.26026-19-vgoyal@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36246 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751239AbeAVSkP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:40:15 -0500
In-Reply-To: <20180122184004.26026-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

All the bits are in patches before this. So it is time to enable the
metadata only copy up feature.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f4ece4754725..c2ce2b9c4ebe 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -247,9 +247,6 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 
-	/* TODO: Will enable metacopy in last patch of series */
-	return false;
-
 	if (!ofs->config.metacopy)
 		return false;
 
-- 
2.13.6
