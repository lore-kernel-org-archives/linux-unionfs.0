From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH] vfs: lockdep annotate of stacked inode_lock()
Date: Thu,  1 Dec 2016 23:48:11 +0200
Message-ID: <1480628891-15937-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:35849 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbcLAVsg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Dec 2016 16:48:36 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>, Quentin Casasnovas <quentin.casasnovas@oracle.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

An overlayfs instance can be the lower layer of another stacked
overlayfs instance.

This setup triggers a lockdep splat of possible recursive locking
of sb->s_type->i_mutex_key in iterate_dir().

Fix this by annotating stackable inode_lock() according to stack
level of the super block instance.

Stackable fs inode_lock() is annotated at lockdep_class level,
so it is independent of the inner fs I_MUTEX subclass annotations.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/inode.c         | 10 ++++++----
 include/linux/fs.h | 14 ++++++++++++--
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 88110fd..f46b267 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -169,7 +169,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
 
 	init_rwsem(&inode->i_rwsem);
-	lockdep_set_class(&inode->i_rwsem, &sb->s_type->i_mutex_key);
+	lockdep_set_class(&inode->i_rwsem,
+			  &sb->s_type->i_mutex_key[FS_STACK_NESTING(sb)]);
 
 	atomic_set(&inode->i_dio_count, 0);
 
@@ -927,16 +928,17 @@ void lockdep_annotate_inode_mutex_key(struct inode *inode)
 {
 	if (S_ISDIR(inode->i_mode)) {
 		struct file_system_type *type = inode->i_sb->s_type;
+		int nesting = FS_STACK_NESTING(inode->i_sb);
 
 		/* Set new key only if filesystem hasn't already changed it */
-		if (lockdep_match_class(&inode->i_rwsem, &type->i_mutex_key)) {
+		if (lockdep_match_class(&inode->i_rwsem,
+					&type->i_mutex_key[nesting])) {
 			/*
 			 * ensure nobody is actually holding i_mutex
 			 */
-			// mutex_destroy(&inode->i_mutex);
 			init_rwsem(&inode->i_rwsem);
 			lockdep_set_class(&inode->i_rwsem,
-					  &type->i_mutex_dir_key);
+					  &type->i_mutex_dir_key[nesting]);
 		}
 	}
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 55c9314..586534a 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2057,9 +2057,19 @@ struct file_system_type {
 	struct lock_class_key s_vfs_rename_key;
 	struct lock_class_key s_writers_key[SB_FREEZE_LEVELS];
 
+	/*
+	 * Most file systems are not stackable. The ones that are stackable
+	 * (i.e. overlayfs) cannot be at stack level 0. It is possible to
+	 * stack FILESYSTEM_MAX_STACK_DEPTH fs of the same type on top of
+	 * each other with the lower being read-only. We need to annonate
+	 * stackable i_mutex locks according to stack level of the super
+	 * block instance.
+	 */
+#define FS_STACK_NESTING(sb) \
+	((sb)->s_stack_depth ? (sb)->s_stack_depth - 1 : 0)
 	struct lock_class_key i_lock_key;
-	struct lock_class_key i_mutex_key;
-	struct lock_class_key i_mutex_dir_key;
+	struct lock_class_key i_mutex_key[FILESYSTEM_MAX_STACK_DEPTH];
+	struct lock_class_key i_mutex_dir_key[FILESYSTEM_MAX_STACK_DEPTH];
 };
 
 #define MODULE_ALIAS_FS(NAME) MODULE_ALIAS("fs-" NAME)
-- 
2.7.4
