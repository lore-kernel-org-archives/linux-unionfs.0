Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 7/9] vfs: export alloc_inode() and destroy_inode()
Date: Fri, 18 May 2018 11:29:35 +0300
Message-Id: <1526632177-28832-8-git-send-email-amir73il@gmail.com>
In-Reply-To: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

They are needed by overlayfs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/inode.c         | 6 ++++--
 include/linux/fs.h | 2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6bb3950ae896..5171807da7e8 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -201,7 +201,7 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 }
 EXPORT_SYMBOL(inode_init_always);
 
-static struct inode *alloc_inode(struct super_block *sb)
+struct inode *alloc_inode(struct super_block *sb)
 {
 	struct inode *inode;
 
@@ -223,6 +223,7 @@ static struct inode *alloc_inode(struct super_block *sb)
 
 	return inode;
 }
+EXPORT_SYMBOL(alloc_inode);
 
 void free_inode_nonrcu(struct inode *inode)
 {
@@ -258,7 +259,7 @@ static void i_callback(struct rcu_head *head)
 	kmem_cache_free(inode_cachep, inode);
 }
 
-static void destroy_inode(struct inode *inode)
+void destroy_inode(struct inode *inode)
 {
 	BUG_ON(!list_empty(&inode->i_lru));
 	__destroy_inode(inode);
@@ -267,6 +268,7 @@ static void destroy_inode(struct inode *inode)
 	else
 		call_rcu(&inode->i_rcu, i_callback);
 }
+EXPORT_SYMBOL(destroy_inode);
 
 /**
  * drop_nlink - directly drop an inode's link count
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3114c1fe5c83..7559f51a14d3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2911,6 +2911,8 @@ extern void __iget(struct inode * inode);
 extern void iget_failed(struct inode *);
 extern void clear_inode(struct inode *);
 extern void __destroy_inode(struct inode *);
+extern void destroy_inode(struct inode *inode);
+extern struct inode *alloc_inode(struct super_block *sb);
 extern struct inode *new_inode_pseudo(struct super_block *sb);
 extern struct inode *new_inode(struct super_block *sb);
 extern void free_inode_nonrcu(struct inode *inode);
-- 
2.7.4
