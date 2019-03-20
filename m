From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 3/5] fs,
 fscrypt: clear DCACHE_ENCRYPTED_NAME when unaliasing directory
Date: Wed, 20 Mar 2019 11:39:11 -0700
Message-ID: <20190320183913.12686-4-ebiggers@kernel.org>
References: <20190320183913.12686-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190320183913.12686-1-ebiggers@kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-fscrypt@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, Sarthak Kukreti <sarthakkukreti@chromium.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make __d_move() clear DCACHE_ENCRYPTED_NAME on the source dentry.  This
is needed for when d_splice_alias() moves a directory's encrypted alias
to its decrypted alias as a result of the encryption key being added.

Otherwise, the decrypted alias will incorrectly be invalidated on the
next lookup, causing problems such as unmounting a mount the user just
mount()ed there.

Note that we don't have to support arbitrary moves of this flag because
fscrypt doesn't allow dentries with DCACHE_ENCRYPTED_NAME to be the
source or target of a rename().

Fixes: 28b4c263961c ("ext4 crypto: revalidate dentry after adding or removing the key")
Reported-by: Sarthak Kukreti <sarthakkukreti@chromium.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/dcache.c             |  2 ++
 include/linux/fscrypt.h | 16 ++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/fs/dcache.c b/fs/dcache.c
index aac41adf47433..647e6ed426e20 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -18,6 +18,7 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/fscrypt.h>
 #include <linux/fsnotify.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -2795,6 +2796,7 @@ static void __d_move(struct dentry *dentry, struct dentry *target,
 	list_move(&dentry->d_child, &dentry->d_parent->d_subdirs);
 	__d_rehash(dentry);
 	fsnotify_update_flags(dentry);
+	fscrypt_handle_d_move(dentry);
 
 	write_seqcount_end(&target->d_seq);
 	write_seqcount_end(&dentry->d_seq);
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 4ad7a856e0f1c..39bd2619a3424 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -88,6 +88,18 @@ static inline bool fscrypt_dummy_context_enabled(struct inode *inode)
 		inode->i_sb->s_cop->dummy_context(inode);
 }
 
+/*
+ * When d_splice_alias() moves a directory's encrypted alias to its decrypted
+ * alias as a result of the encryption key being added, DCACHE_ENCRYPTED_NAME
+ * must be cleared.  Note that we don't have to support arbitrary moves of this
+ * flag because fscrypt doesn't allow encrypted aliases to be the source or
+ * target of a rename().
+ */
+static inline void fscrypt_handle_d_move(struct dentry *dentry)
+{
+	dentry->d_flags &= ~DCACHE_ENCRYPTED_NAME;
+}
+
 /* crypto.c */
 extern void fscrypt_enqueue_decrypt_work(struct work_struct *);
 extern struct fscrypt_ctx *fscrypt_get_ctx(const struct inode *, gfp_t);
@@ -243,6 +255,10 @@ static inline bool fscrypt_dummy_context_enabled(struct inode *inode)
 	return false;
 }
 
+static inline void fscrypt_handle_d_move(struct dentry *dentry)
+{
+}
+
 /* crypto.c */
 static inline void fscrypt_enqueue_decrypt_work(struct work_struct *work)
 {
-- 
2.21.0.225.g810b269d1ac-goog
