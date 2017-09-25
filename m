From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/4] ovl: fix dentry leak in ovl_indexdir_cleanup()
Date: Mon, 25 Sep 2017 12:36:21 +0300
Message-ID: <1506332181-19319-5-git-send-email-amir73il@gmail.com>
References: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34861 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932817AbdIYJfz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2017 05:35:55 -0400
In-Reply-To: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 13" <stable@vger.kernel.org>

index dentry was not released when breaking out of the loop
due to index verification error.

Fixes: 415543d5c64f ("ovl: cleanup bad and stale index entries on mount")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 62e9b22a2077..0f85ee9c3268 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -988,6 +988,7 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			 struct path *lowerstack, unsigned int numlower)
 {
 	int err;
+	struct dentry *index = NULL;
 	struct inode *dir = dentry->d_inode;
 	struct path path = { .mnt = mnt, .dentry = dentry };
 	LIST_HEAD(list);
@@ -1007,8 +1008,6 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
 	list_for_each_entry(p, &list, l_node) {
-		struct dentry *index;
-
 		if (p->name[0] == '.') {
 			if (p->len == 1)
 				continue;
@@ -1018,6 +1017,7 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 		index = lookup_one_len(p->name, dentry, p->len);
 		if (IS_ERR(index)) {
 			err = PTR_ERR(index);
+			index = NULL;
 			break;
 		}
 		err = ovl_verify_index(index, lowerstack, numlower);
@@ -1029,7 +1029,9 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 				break;
 		}
 		dput(index);
+		index = NULL;
 	}
+	dput(index);
 	inode_unlock(dir);
 out:
 	ovl_cache_free(&list);
-- 
2.7.4
