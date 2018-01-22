From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v10 07/18] ovl: Add mechanism to create a chain of origin dentries
Date: Mon, 22 Jan 2018 13:39:53 -0500
Message-ID: <20180122184004.26026-8-vgoyal@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751140AbeAVSkO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:40:14 -0500
In-Reply-To: <20180122184004.26026-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

There is a need to support metacopy dentry in midlayer. That means there
could be a chain of metacopy dentries.

For example, upper could be metacopy, midlayer lower could be metacopy and
lowest layer could be actual data inode. This means when we copy up actual
data, we should be able to reach to lowest data inode and copy up data from
there. And that means we should keep track of all the dentries in origin
chain which lead to data inode.

Current ovl_check_origin() logic only looks for one origin dentry. This patch
enhances ovl_check_origin() to continue to follow origin chain and return
all the origin entries found. This is done only if caller of the function
set "follow_chain" argument.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 66 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index beb945e1963c..5b834abde37a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -283,39 +283,61 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 	return 0;
 }
 
-
-static int ovl_check_origin(struct dentry *upperdentry,
+static int ovl_check_origin(struct dentry *dentry,
 			    struct ovl_path *lower, unsigned int numlower,
-			    struct ovl_path **stackp, unsigned int *ctrp)
+			    struct ovl_path **stackp, unsigned int *ctrp,
+			    bool follow_chain)
 {
 	struct vfsmount *mnt;
 	struct dentry *origin = NULL;
-	int i;
+	int i, nr_path = (follow_chain ? numlower : 1), err = 0;
+	int idx = 0;
+	bool mem_allocated = false;
+	struct ovl_path *origin_stack;
+
+	BUG_ON(*ctrp);
+
+	if (!*stackp) {
+		origin_stack = kmalloc(sizeof(struct ovl_path) * nr_path, GFP_KERNEL);
+		if (!origin_stack)
+			return -ENOMEM;
+		mem_allocated = true;
+	} else
+		origin_stack = *stackp;
 
 	for (i = 0; i < numlower; i++) {
 		mnt = lower[i].layer->mnt;
-		origin = ovl_get_origin(upperdentry, mnt);
-		if (IS_ERR(origin))
-			return PTR_ERR(origin);
+		origin = ovl_get_origin(dentry, mnt);
+		if (IS_ERR(origin)) {
+			err = PTR_ERR(origin);
+			goto out_err;
+		}
 
-		if (origin)
-			break;
+		if (origin) {
+			origin_stack[idx++] = (struct ovl_path){.dentry = origin, .layer = lower[i].layer};
+			if (!follow_chain)
+				break;
+			else
+				dentry = origin;
+		}
 	}
 
-	if (!origin)
+	if (mem_allocated && !idx) {
+		kfree(origin_stack);
 		return 0;
-
-	BUG_ON(*ctrp);
-	if (!*stackp)
-		*stackp = kmalloc(sizeof(struct ovl_path), GFP_KERNEL);
-	if (!*stackp) {
-		dput(origin);
-		return -ENOMEM;
 	}
-	**stackp = (struct ovl_path){.dentry = origin, .layer = lower[i].layer};
-	*ctrp = 1;
 
+	*stackp = origin_stack;
+	*ctrp = idx;
 	return 0;
+out_err:
+	for (i = 0; i < idx; i++)
+		dput(origin_stack[i].dentry);
+
+	if (mem_allocated)
+		kfree(origin_stack);
+
+	return err;
 }
 
 /*
@@ -427,7 +449,7 @@ int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
 	if (err)
 		goto fail;
 
-	err = ovl_check_origin(index, lower, numlower, &stack, &ctr);
+	err = ovl_check_origin(index, lower, numlower, &stack, &ctr, false);
 	if (!err && !ctr)
 		err = -ESTALE;
 	if (err)
@@ -602,6 +624,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	bool origin_chain = ofs->config.metacopy ? true : false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
 		.is_dir = false,
@@ -639,7 +662,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			 * to a dentry in lower layer that was moved under us.
 			 */
 			err = ovl_check_origin(upperdentry, roe->lowerstack,
-					       roe->numlower, &stack, &ctr);
+					       roe->numlower, &stack, &ctr,
+					       origin_chain);
 			if (err)
 				goto out_put_upper;
 		}
-- 
2.13.6
