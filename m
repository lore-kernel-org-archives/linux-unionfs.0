Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 4/5] ovl: enforce 'strict' unique uuid requirement with metacopy=on
Date: Thu,  1 Nov 2018 02:48:12 +0200
Message-Id: <20181101004813.31349-5-amir73il@gmail.com>
In-Reply-To: <20181101004813.31349-1-amir73il@gmail.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

With metacopy=on, fail mount instead of disabling index feature on
detection of non unique uuid among underlying filesystems.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4aca0cc67455..d848112f4fc9 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1323,6 +1323,12 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 		pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
 			uuid_is_null(&sb->s_uuid) ? "null" : "conflicting",
 			path->dentry);
+
+		err = ovl_feature_requires(&ofs->config,
+					   "NFS export and inode index",
+					   "unique uuid with multiple underlying fs");
+		if (err)
+			return err;
 	}
 
 	err = get_anon_bdev(&dev);
-- 
2.17.1
