From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: lockdep annotate of nested OVL_I(inode)->lock
Date: Fri, 27 Oct 2017 16:12:07 +0300
Message-ID: <1509109927-2346-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:50805 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752311AbdJ0NLZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Oct 2017 09:11:25 -0400
Received: by mail-wr0-f196.google.com with SMTP id p96so6112605wrb.7
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Oct 2017 06:11:24 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

This fixes a lockdep splat when mounting a nested overlayfs.

Fixes: a015dafcaf5b ("ovl: use ovl_inode mutex to synchronize...")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Another v4.13 fix for a very minor false positive lockdep regression.
Not critical, so if there is no rc8 this cycle can wait for next cycle.

Amir.

 fs/overlayfs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a623c0b60583..ab2e24f43087 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -14,6 +14,7 @@
 #include <linux/posix_acl.h>
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
+#include "ovl_entry.h"
 
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -411,6 +412,7 @@ static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
 #ifdef CONFIG_LOCKDEP
 	static struct lock_class_key ovl_i_mutex_key[OVL_MAX_NESTING];
 	static struct lock_class_key ovl_i_mutex_dir_key[OVL_MAX_NESTING];
+	static struct lock_class_key ovl_i_lock_key[OVL_MAX_NESTING];
 
 	int depth = inode->i_sb->s_stack_depth - 1;
 
@@ -421,6 +423,8 @@ static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
 		lockdep_set_class(&inode->i_rwsem, &ovl_i_mutex_dir_key[depth]);
 	else
 		lockdep_set_class(&inode->i_rwsem, &ovl_i_mutex_key[depth]);
+
+	lockdep_set_class(&OVL_I(inode)->lock, &ovl_i_lock_key[depth]);
 #endif
 }
 
-- 
2.7.4
