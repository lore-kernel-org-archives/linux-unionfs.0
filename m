From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v10 13/18] ovl: Check metacopy attributes on a chain of origin
Date: Mon, 22 Jan 2018 13:39:59 -0500
Message-ID: <20180122184004.26026-14-vgoyal@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751199AbeAVSkP (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:40:15 -0500
In-Reply-To: <20180122184004.26026-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

So far our check for metacopy is simple. That is we check for presence
of OVL_XATTR_METACOPY only on upper inode. But with the possibility of
metacopy inode being present on lower layer also, we should check it
on the whole origin chain and keep track of which lower dentries are
metacopy.

So this patch adds enahnces ovl_check_metacopy() so that it checks
for metacopy not only on dentry being passed, but also travels through
the chain of origins for that dentry and checks metacopy xattr.

We also need to remember metacopy state of each dentry/inode so that
we don't have to look it up all the time. Hence I added a field
"metacopy" in "struct ovl_path" and set this when a particular dentry
is metacopy only. This only applies to lower dentries as we keep
ovl_path only for lower dentries. Upper dentry continues to rely on
ovl inode flag OVL_UPPERDATA to figure out if upper is metacopy
only inode or not.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c     | 45 ++++++++++++++++++++++++++++++++++++++++-----
 fs/overlayfs/ovl_entry.h |  1 +
 2 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 99f896e7bcf2..f6f0d97bd0ca 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -47,11 +47,36 @@ static int ovl_check_metacopy_xattr(struct dentry *dentry)
 	return res;
 }
 
+static int ovl_check_origin_metacopy(struct ovl_path *stackp, unsigned int ctr)
+{
+	int i, metacopy;
+
+	if (!ctr)
+		return 0;
+
+	for (i = 0; i < ctr; i++) {
+		metacopy = ovl_check_metacopy_xattr(stackp[i].dentry);
+		if (metacopy <= 0)
+			return metacopy;
+		stackp[i].metacopy = true;
+	}
+
+	if (stackp[i - 1].metacopy) {
+		/*
+		 * Last origin should not have metacopy set. It should be
+		 * the source of metacopy. Something is wrong.
+		 */
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /* err < 0, 0 if upper does not have metacopy, 1 if metacopy found */
 static int ovl_check_metacopy(struct ovl_fs *ofs, struct dentry *dentry,
-			      unsigned int ctr)
+			      struct ovl_path *stackp, unsigned int ctr)
 {
-	int metacopy;
+	int metacopy, err;
 
 	metacopy = ovl_check_metacopy_xattr(dentry);
 	if (metacopy <= 0 )
@@ -75,6 +100,9 @@ static int ovl_check_metacopy(struct ovl_fs *ofs, struct dentry *dentry,
 		return -EPERM;
 	}
 
+	err = ovl_check_origin_metacopy(stackp, ctr);
+	if (err)
+		return err;
 	return metacopy;
 }
 
@@ -348,8 +376,6 @@ static int ovl_check_origin(struct dentry *dentry,
 	bool mem_allocated = false;
 	struct ovl_path *origin_stack;
 
-	BUG_ON(*ctrp);
-
 	if (!*stackp) {
 		origin_stack = kmalloc(sizeof(struct ovl_path) * nr_path, GFP_KERNEL);
 		if (!origin_stack)
@@ -721,7 +747,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			if (err)
 				goto out_put_upper;
 
-			err = ovl_check_metacopy(ofs, upperdentry, ctr);
+			err = ovl_check_metacopy(ofs, upperdentry, stack, ctr);
 			metacopy = err;
 			if (err < 0)
 				goto out_put_upper;
@@ -818,6 +844,15 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out_put;
 
 		ctr += nr_origins;
+
+		err = ovl_check_metacopy(ofs, stack[0].dentry, &stack[1],
+					 nr_origins);
+		metacopy = err;
+		if (err < 0)
+			goto out_put;
+
+		if (metacopy)
+			stack[0].metacopy = true;
 	}
 
 	oe = ovl_alloc_entry(ctr);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 92a4db0bd18c..a8cfdae4df89 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -28,6 +28,7 @@ struct ovl_layer {
 struct ovl_path {
 	struct ovl_layer *layer;
 	struct dentry *dentry;
+	bool metacopy;
 };
 
 /* private information held for overlayfs's superblock */
-- 
2.13.6
