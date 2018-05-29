From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 09/11] vfs: factor out inode_insert5()
Date: Tue, 29 May 2018 16:41:41 +0200
Message-ID: <20180529144143.16378-10-mszeredi@redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>

Split out common helper for race free insertion of an already allocated
inode into the cache.  Use this from iget5_locked() and
insert_inode_locked4().  Make iget5_locked() use new_inode()/iput() instead
of alloc_inode()/destroy_inode() directly.

Also export to modules for use by filesystems which want to preallocate an
inode before file/directory creation.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/inode.c         | 164 ++++++++++++++++++++++++-----------------------------
 include/linux/fs.h |   4 ++
 2 files changed, 79 insertions(+), 89 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 13ceb98c3bd3..1bea65d37afe 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1002,6 +1002,70 @@ void unlock_two_nondirectories(struct inode *inode1, struct inode *inode2)
 }
 EXPORT_SYMBOL(unlock_two_nondirectories);
 
+/**
+ * inode_insert5 - obtain an inode from a mounted file system
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
+struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
+			    int (*test)(struct inode *, void *),
+			    int (*set)(struct inode *, void *), void *data)
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
+	if (set && unlikely(set(inode, data))) {
+		inode = NULL;
+		goto unlock;
+	}
+
+	/*
+	 * Return the locked inode with I_NEW set, the
+	 * caller is responsible for filling in the contents
+	 */
+	spin_lock(&inode->i_lock);
+	inode->i_state |= I_NEW;
+	hlist_add_head(&inode->i_hash, head);
+	spin_unlock(&inode->i_lock);
+unlock:
+	spin_unlock(&inode_hash_lock);
+
+	return inode;
+}
+EXPORT_SYMBOL(inode_insert5);
+
 /**
  * iget5_locked - obtain an inode from a mounted file system
  * @sb:		super block of file system
@@ -1026,66 +1090,18 @@ struct inode *iget5_locked(struct super_block *sb, unsigned long hashval,
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
+	if (!inode) {
+		struct inode *new = new_inode(sb);
 
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
-
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
+			inode = inode_insert5(new, hashval, test, set, data);
+			if (unlikely(inode != new))
+				iput(new);
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
 
@@ -1426,43 +1442,13 @@ EXPORT_SYMBOL(insert_inode_locked);
 int insert_inode_locked4(struct inode *inode, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data)
 {
-	struct super_block *sb = inode->i_sb;
-	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
+	struct inode *old = inode_insert5(inode, hashval, test, NULL, data);
 
-	while (1) {
-		struct inode *old = NULL;
-
-		spin_lock(&inode_hash_lock);
-		hlist_for_each_entry(old, head, i_hash) {
-			if (old->i_sb != sb)
-				continue;
-			if (!test(old, data))
-				continue;
-			spin_lock(&old->i_lock);
-			if (old->i_state & (I_FREEING|I_WILL_FREE)) {
-				spin_unlock(&old->i_lock);
-				continue;
-			}
-			break;
-		}
-		if (likely(!old)) {
-			spin_lock(&inode->i_lock);
-			inode->i_state |= I_NEW;
-			hlist_add_head(&inode->i_hash, head);
-			spin_unlock(&inode->i_lock);
-			spin_unlock(&inode_hash_lock);
-			return 0;
-		}
-		__iget(old);
-		spin_unlock(&old->i_lock);
-		spin_unlock(&inode_hash_lock);
-		wait_on_inode(old);
-		if (unlikely(!inode_unhashed(old))) {
-			iput(old);
-			return -EBUSY;
-		}
+	if (old != inode) {
 		iput(old);
+		return -EBUSY;
 	}
+	return 0;
 }
 EXPORT_SYMBOL(insert_inode_locked4);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 760d8da1b6c7..4f637a9b213d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2879,6 +2879,10 @@ extern struct inode *ilookup5(struct super_block *sb, unsigned long hashval,
 		int (*test)(struct inode *, void *), void *data);
 extern struct inode *ilookup(struct super_block *sb, unsigned long ino);
 
+extern struct inode *inode_insert5(struct inode *inode, unsigned long hashval,
+		int (*test)(struct inode *, void *),
+		int (*set)(struct inode *, void *),
+		void *data);
 extern struct inode * iget5_locked(struct super_block *, unsigned long, int (*test)(struct inode *, void *), int (*set)(struct inode *, void *), void *);
 extern struct inode * iget_locked(struct super_block *, unsigned long);
 extern struct inode *find_inode_nowait(struct super_block *,
-- 
2.14.3
