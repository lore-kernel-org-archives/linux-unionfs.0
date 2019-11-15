Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/2] ovl: don't use a temp buf for encoding real fh
Date: Fri, 15 Nov 2019 13:33:04 +0200
Message-Id: <20191115113304.16209-3-amir73il@gmail.com>
In-Reply-To: <20191115113304.16209-1-amir73il@gmail.com>
References: <20191115113304.16209-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

We can allocate maximum fh size and encode into it directly.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 7f744a9541e5..6220642fe113 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -227,13 +227,17 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
 {
 	struct ovl_fh *fh;
-	int fh_type, fh_len, dwords;
-	void *buf;
+	int fh_type, dwords;
 	int buflen = MAX_HANDLE_SZ;
 	uuid_t *uuid = &real->d_sb->s_uuid;
+	int err;
 
-	buf = kmalloc(buflen, GFP_KERNEL);
-	if (!buf)
+	/* Make sure the real fid stays 32bit aligned */
+	BUILD_BUG_ON(OVL_FH_FID_OFFSET % 4);
+	BUILD_BUG_ON(MAX_HANDLE_SZ + OVL_FH_FID_OFFSET > 255);
+
+	fh = kzalloc(buflen + OVL_FH_FID_OFFSET, GFP_KERNEL);
+	if (!fh)
 		return ERR_PTR(-ENOMEM);
 
 	/*
@@ -242,24 +246,14 @@ struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
 	 * the price or reconnecting the dentry.
 	 */
 	dwords = buflen >> 2;
-	fh_type = exportfs_encode_fh(real, buf, &dwords, 0);
+	fh_type = exportfs_encode_fh(real, (void *)fh->fb.fid, &dwords, 0);
 	buflen = (dwords << 2);
 
-	fh = ERR_PTR(-EIO);
+	err = -EIO;
 	if (WARN_ON(fh_type < 0) ||
 	    WARN_ON(buflen > MAX_HANDLE_SZ) ||
 	    WARN_ON(fh_type == FILEID_INVALID))
-		goto out;
-
-	/* Make sure the real fid stays 32bit aligned */
-	BUILD_BUG_ON(OVL_FH_FID_OFFSET % 4);
-	BUILD_BUG_ON(MAX_HANDLE_SZ + OVL_FH_FID_OFFSET > 255);
-	fh_len = OVL_FH_FID_OFFSET + buflen;
-	fh = kzalloc(fh_len, GFP_KERNEL);
-	if (!fh) {
-		fh = ERR_PTR(-ENOMEM);
-		goto out;
-	}
+		goto out_err;
 
 	fh->fb.version = OVL_FH_VERSION;
 	fh->fb.magic = OVL_FH_MAGIC;
@@ -273,13 +267,14 @@ struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
 	 */
 	if (is_upper)
 		fh->fb.flags |= OVL_FH_FLAG_PATH_UPPER;
-	fh->fb.len = fh_len - OVL_FH_WIRE_OFFSET;
+	fh->fb.len = sizeof(fh->fb) + buflen;
 	fh->fb.uuid = *uuid;
-	memcpy(fh->fb.fid, buf, buflen);
 
-out:
-	kfree(buf);
 	return fh;
+
+out_err:
+	kfree(fh);
+	return ERR_PTR(err);
 }
 
 int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
-- 
2.17.1
