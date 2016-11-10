From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATH 2/4] vfs: introduce delete trylock/unlock
Date: Fri, 11 Nov 2016 00:44:41 +0200
Message-ID: <1478817883-27662-3-git-send-email-amir73il@gmail.com>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

A delete lock prevents a dentry from being unlinked and renamed,
for as long as the dentry remains in cache.

Introduce the helpers delete_trylock() and delete_unlock(), which
use test_and_set and test_and_clear semantics to ser/clear a delete
lock on a dentry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/dcache.h | 24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 94cd40c..90584b9 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -356,11 +356,33 @@ static inline int cant_delete(const struct dentry *dentry)
 	return (dentry->d_flags & DCACHE_DELETE_LOCK);
 }
 
-static inline void dont_delete(struct dentry *dentry)
+static inline int delete_trylock(struct dentry *dentry)
 {
+	int locked;
+
 	spin_lock(&dentry->d_lock);
+	locked = likely(!cant_delete(dentry));
 	dentry->d_flags |= DCACHE_DELETE_LOCK;
 	spin_unlock(&dentry->d_lock);
+
+	return locked;
+}
+
+static inline void dont_delete(struct dentry *dentry)
+{
+	delete_trylock(dentry);
+}
+
+static inline int delete_unlock(struct dentry *dentry)
+{
+	int unlocked;
+
+	spin_lock(&dentry->d_lock);
+	unlocked = likely(cant_delete(dentry));
+	dentry->d_flags &= ~DCACHE_DELETE_LOCK;
+	spin_unlock(&dentry->d_lock);
+
+	return unlocked;
 }
 
 extern void __d_lookup_done(struct dentry *);
-- 
2.7.4

