Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 6/9] vfs: factor out iget5_prealloc()
Date: Fri, 18 May 2018 11:29:34 +0300
Message-Id: <1526632177-28832-7-git-send-email-amir73il@gmail.com>
In-Reply-To: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Miklos Szeredi <miklos@szeredi.hu>

Split a helper out of iget5_locked() that takes a preallocated
inode.  This is needed by overlayfs, but also makes iget5_locked()
more readable.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/inode.c         | 127 ++++++++++++++++++++++++++++++-----------------------
 include/linux/fs.h |  12 ++++-
 2 files changed, 82 insertions(+), 57 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9818c0f48cfa..6bb3950ae896 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1003,6 +1003,71 @@ void unlock_two_nondirectories(struct inode *inode1, struct inode *inode2)
 EXPORT_SYMBOL(unlock_two_nondirectories);
 
 /**
+ * iget5_prealloc - obtain an inode from a mounted file system
+ * @inode:	pre-allocated inode to use for insert to cache
+ * @hashval:	hash value (usually inode number) to get
+ * @test:	callback used for comparisons between inodes
+ * @set:	callback used to initialize a new struct inode
+ * @data:	opaque data pointer to pass to @test and @set
+ *
+ * Search for the inode specified by @hashval and @data in the inode cache,
+ * and if present it is return it with an increased reference count. This is
+ * a variant of iget5_locked() for callers that don't want to fail on memory
+ * allocation of inode.
+ *
+ * If the inode is not in cache, insert the pre-allocated inode to cache and
+ * return it locked, hashed, and with the I_NEW flag set. The file system gets
+ * to fill it in before unlocking it via unlock_new_inode().
+ *
+ * Note both @test and @set are called with the inode_hash_lock held, so can't
+ * sleep.
+ */
+struct inode *iget5_prealloc(struct inode *inode, unsigned long hashval,
+			     int (*test)(struct inode *, void *),
+			     int (*set)(struct inode *, void *), void *data)
+{
+	struct hlist_head *head = inode_hashtable + hash(inode->i_sb, hashval);
+	struct inode *old;
+
+again:
+	spin_lock(&inode_hash_lock);
+	old = find_inode(inode->i_sb, head, test, data);
+	if (unlikely(old)) {
+		/*
+		 * Uhhuh, somebody else created the same inode under us.
+		 * Use the old inode instead of the preallocated one.
+		 */
+		spin_unlock(&inode_hash_lock);
+		wait_on_inode(old);
+		if (unlikely(inode_unhashed(old))) {
+			iput(old);
+			goto again;
+		}
+		return old;
+	}
+
+	if (unlikely(set(inode, data))) {
+		inode = NULL;
+		goto unlock;
+	}
+
+	/*
+	 * Return the locked inode with I_NEW set, the
+	 * caller is responsible for filling in the contents
+	 */
+	spin_lock(&inode->i_lock);
+	inode->i_state = I_NEW;
+	hlist_add_head(&inode->i_hash, head);
+	spin_unlock(&inode->i_lock);
+	inode_sb_list_add(inode);
+unlock:
+	spin_unlock(&inode_hash_lock);
+
+	return inode;
+}
+EXPORT_SYMBOL(iget5_prealloc);
+
+/**
  * iget5_locked - obtain an inode from a mounted file system
  * @sb:		super block of file system
  * @hashval:	hash value (usually inode number) to get
@@ -1026,66 +1091,18 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *),
 		int (*set)(struct inode *, void *), void *data)
 {
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
-	struct inode *inode;
-again:
-	spin_lock(&inode_hash_lock);
-	inode = find_inode(sb, head, test, data);
-	spin_unlock(&inode_hash_lock);
+	struct inode *inode = ilookup5(sb, hashval, test, data);
 
-	if (inode) {
-		wait_on_inode(inode);
-		if (unlikely(inode_unhashed(inode))) {
-			iput(inode);
-			goto again;
-		}
-		return inode;
-	}
-
-	inode = alloc_inode(sb);
-	if (inode) {
-		struct inode *old;
-
-		spin_lock(&inode_hash_lock);
-		/* We released the lock, so.. */
-		old = find_inode(sb, head, test, data);
-		if (!old) {
-			if (set(inode, data))
-				goto set_failed;
-
-			spin_lock(&inode->i_lock);
-			inode->i_state = I_NEW;
-			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode->i_lock);
-			inode_sb_list_add(inode);
-			spin_unlock(&inode_hash_lock);
+	if (!inode) {
+		struct inode *new = alloc_inode(sb);
 
-			/* Return the locked inode with I_NEW set, the
-			 * caller is responsible for filling in the contents
-			 */
-			return inode;
-		}
-
-		/*
-		 * Uhhuh, somebody else created the same inode under
-		 * us. Use the old inode instead of the one we just
-		 * allocated.
-		 */
-		spin_unlock(&inode_hash_lock);
-		destroy_inode(inode);
-		inode = old;
-		wait_on_inode(inode);
-		if (unlikely(inode_unhashed(inode))) {
-			iput(inode);
-			goto again;
+		if (new) {
+			inode = iget5_prealloc(new, hashval, test, set, data);
+			if (inode != new)
+				destroy_inode(new);
 		}
 	}
 	return inode;
-
-set_failed:
-	spin_unlock(&inode_hash_lock);
-	destroy_inode(inode);
-	return NULL;
 }
 EXPORT_SYMBOL(iget5_locked);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8b8d793b3774..3114c1fe5c83 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2880,9 +2880,17 @@ extern struct inode *ilookup5_nowait(struct super_block *sb,
 extern struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data);
 extern struct inode *ilookup(struct super_block *sb, unsigned long ino);
+extern struct inode *iget5_prealloc(struct inode *inode, unsigned long hashval,
+		int (*test)(struct inode *, void *),
+		int (*set)(struct inode *, void *),
+		void *data);
+extern struct inode *iget5_locked(struct super_block *sb,
+		unsigned long hashval,
+		int (*test)(struct inode *, void *),
+		int (*set)(struct inode *, void *),
+		void *data);
+extern struct inode *iget_locked(struct super_block *sb, unsigned long ino);
 
-extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
-extern struct inode * iget_locked(struct super_block *, unsigned long);
 extern struct inode *find_inode_nowait(struct super_block *,
 				       unsigned long,
 				       int (*match)(struct inode *,
-- 
2.7.4
