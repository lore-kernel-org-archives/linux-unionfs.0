From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/15] VFS: Impose ordering on accesses of d_inode and
 d_flags
Date: Wed, 25 Mar 2015 14:45:34 +0000
Message-ID: <20150325144534.17670.31293.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
List-Id: linux-unionfs@vger.kernel.org

Impose ordering on accesses of d_inode and d_flags to avoid the need to do
this:

	if (!dentry->d_inode || d_is_negative(dentry)) {

when this:

	if (d_is_negative(dentry)) {

should suffice.

This check is especially problematic if a dentry can have its type field set
to something other than DENTRY_MISS_TYPE when d_inode is NULL (as in
unionmount).

What we really need to do is stick a write barrier between setting d_inode and
setting d_flags and a read barrier between reading d_flags and reading
d_inode.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/dcache.c            |   47 +++++++++++++++++++++++++++++++++++++++--------
 include/linux/dcache.h |   21 +++------------------
 2 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index c71e3732e53b..b9e8b41459a4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -269,6 +269,41 @@ static inline int dname_external(const struct dentry *dentry)
 	return dentry->d_name.name != dentry->d_iname;
 }
 
+/*
+ * Make sure other CPUs see the inode attached before the type is set.
+ */
+static inline void __d_set_inode_and_type(struct dentry *dentry,
+					  struct inode *inode,
+					  unsigned type_flags)
+{
+	unsigned flags;
+
+	dentry->d_inode = inode;
+	smp_wmb();
+	flags = READ_ONCE(dentry->d_flags);
+	flags &= ~(DCACHE_ENTRY_TYPE | DCACHE_FALLTHRU);
+	flags |= type_flags;
+	WRITE_ONCE(dentry->d_flags, flags);
+}
+
+/*
+ * Ideally, we want to make sure that other CPUs see the flags cleared before
+ * the inode is detached, but this is really a violation of RCU principles
+ * since the ordering suggests we should always set inode before flags.
+ *
+ * We should instead replace or discard the entire dentry - but that sucks
+ * performancewise on mass deletion/rename.
+ */
+static inline void __d_clear_type_and_inode(struct dentry *dentry)
+{
+	unsigned flags = READ_ONCE(dentry->d_flags);
+
+	flags &= ~(DCACHE_ENTRY_TYPE | DCACHE_FALLTHRU);
+	WRITE_ONCE(dentry->d_flags, flags);
+	smp_wmb();
+	dentry->d_inode = NULL;
+}
+
 static void dentry_free(struct dentry *dentry)
 {
 	WARN_ON(!hlist_unhashed(&dentry->d_u.d_alias));
@@ -311,7 +346,7 @@ static void dentry_iput(struct dentry * dentry)
 {
 	struct inode *inode = dentry->d_inode;
 	if (inode) {
-		dentry->d_inode = NULL;
+		__d_clear_type_and_inode(dentry);
 		hlist_del_init(&dentry->d_u.d_alias);
 		spin_unlock(&dentry->d_lock);
 		spin_unlock(&inode->i_lock);
@@ -335,8 +370,7 @@ static void dentry_unlink_inode(struct dentry * dentry)
 	__releases(dentry->d_inode->i_lock)
 {
 	struct inode *inode = dentry->d_inode;
-	__d_clear_type(dentry);
-	dentry->d_inode = NULL;
+	__d_clear_type_and_inode(dentry);
 	hlist_del_init(&dentry->d_u.d_alias);
 	dentry_rcuwalk_barrier(dentry);
 	spin_unlock(&dentry->d_lock);
@@ -1715,11 +1749,9 @@ static void __d_instantiate(struct dentry *dentry, struct inode *inode)
 	unsigned add_flags = d_flags_for_inode(inode);
 
 	spin_lock(&dentry->d_lock);
-	dentry->d_flags &= ~(DCACHE_ENTRY_TYPE | DCACHE_FALLTHRU);
-	dentry->d_flags |= add_flags;
 	if (inode)
 		hlist_add_head(&dentry->d_u.d_alias, &inode->i_dentry);
-	dentry->d_inode = inode;
+	__d_set_inode_and_type(dentry, inode, add_flags);
 	dentry_rcuwalk_barrier(dentry);
 	spin_unlock(&dentry->d_lock);
 	fsnotify_d_instantiate(dentry, inode);
@@ -1937,8 +1969,7 @@ static struct dentry *__d_obtain_alias(struct inode *inode, int disconnected)
 		add_flags |= DCACHE_DISCONNECTED;
 
 	spin_lock(&tmp->d_lock);
-	tmp->d_inode = inode;
-	tmp->d_flags |= add_flags;
+	__d_set_inode_and_type(tmp, inode, add_flags);
 	hlist_add_head(&tmp->d_u.d_alias, &inode->i_dentry);
 	hlist_bl_lock(&tmp->d_sb->s_anon);
 	hlist_bl_add_head(&tmp->d_hash, &tmp->d_sb->s_anon);
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index e83768ee38fc..df334cbacc6d 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -404,26 +404,11 @@ static inline bool d_mountpoint(const struct dentry *dentry)
 /*
  * Directory cache entry type accessor functions.
  */
-static inline void __d_set_type(struct dentry *dentry, unsigned type)
-{
-	dentry->d_flags = (dentry->d_flags & ~DCACHE_ENTRY_TYPE) | type;
-}
-
-static inline void __d_clear_type(struct dentry *dentry)
-{
-	__d_set_type(dentry, DCACHE_MISS_TYPE);
-}
-
-static inline void d_set_type(struct dentry *dentry, unsigned type)
-{
-	spin_lock(&dentry->d_lock);
-	__d_set_type(dentry, type);
-	spin_unlock(&dentry->d_lock);
-}
-
 static inline unsigned __d_entry_type(const struct dentry *dentry)
 {
-	return dentry->d_flags & DCACHE_ENTRY_TYPE;
+	unsigned type = READ_ONCE(dentry->d_flags);
+	smp_rmb();
+	return type & DCACHE_ENTRY_TYPE;
 }
 
 static inline bool d_is_miss(const struct dentry *dentry)
