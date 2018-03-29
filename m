Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 28/28] ovl: Enable metadata only feature
Date: Thu, 29 Mar 2018 15:38:54 -0400
Message-Id: <20180329193854.13814-29-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

All the bits are in patches before this. So it is time to enable the
metadata only copy up feature.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index fbaf5fbfdf88..bfdd7dbb4ad7 100644
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
