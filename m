Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v12 09/17] ovl: Do not mark a non dir as _OVL_PATH_MERGE in ovl_path_type()
Date: Tue,  6 Mar 2018 15:54:00 -0500
Message-Id: <20180306205408.23383-10-vgoyal@redhat.com>
In-Reply-To: <20180306205408.23383-1-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

With the addition of an origin chain for regular files, it is possible
that we don't have an upperdentry and oe->numlower > 1 for non-dir. So
mark a path __OVL_TYPE_MERGE only if it is a directory.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7929cc872df6..19b936b0a551 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -122,7 +122,7 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 				type |= __OVL_PATH_MERGE;
 		}
 	} else {
-		if (oe->numlower > 1)
+		if (oe->numlower > 1 && d_is_dir(dentry))
 			type |= __OVL_PATH_MERGE;
 	}
 	return type;
-- 
2.13.6
