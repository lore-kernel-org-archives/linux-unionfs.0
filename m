From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 17/28] ovl: Move some dir related ovl_lookup_single() code in else block
Date: Tue, 29 May 2018 16:46:01 +0200
Message-ID: <20180529144612.16675-18-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Move some directory related code in else block.  This is pure code
reorganization and no functionality change.

Next patch enables redirect processing on metacopy files and needs this
change.  By keeping non-functional changes in a separate patch, next patch
looks much smaller and cleaner.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/namei.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b28b255ea8e2..451cd6effcf6 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -273,17 +273,18 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		d->metacopy = err;
 		d->stop = !d->metacopy;
 		goto out;
-	}
-	if (last_element)
-		d->is_dir = true;
-	if (d->last)
-		goto out;
-
-	if (ovl_is_opaquedir(this)) {
-		d->stop = true;
+	} else {
 		if (last_element)
-			d->opaque = true;
-		goto out;
+			d->is_dir = true;
+		if (d->last)
+			goto out;
+
+		if (ovl_is_opaquedir(this)) {
+			d->stop = true;
+			if (last_element)
+				d->opaque = true;
+			goto out;
+		}
 	}
 	err = ovl_check_redirect(this, d, prelen, post);
 	if (err)
-- 
2.14.3
