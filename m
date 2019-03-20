From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 1/5] fscrypt: clean up and improve dentry
 revalidation
Date: Wed, 20 Mar 2019 11:39:09 -0700
Message-ID: <20190320183913.12686-2-ebiggers@kernel.org>
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

Make various improvements to fscrypt dentry revalidation:

- Don't try to handle the case where the per-directory key is removed,
  as this can't happen without the inode (and dentries) being evicted.

- Flag ciphertext dentries rather than plaintext dentries, since it's
  ciphertext dentries that need the special handling.

- Avoid doing unnecessary work for non-ciphertext dentries.

- When revalidating ciphertext dentries, try to set up the directory's
  i_crypt_info to make sure the key is really still absent, rather than
  invalidating all negative dentries as the previous code did.  An old
  comment suggested we can't do this for locking reasons, but AFAICT
  this comment was outdated and it actually works fine.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/crypto.c      | 58 +++++++++++++++++++++--------------------
 fs/crypto/hooks.c       |  4 +--
 include/linux/dcache.h  |  2 +-
 include/linux/fscrypt.h |  6 ++---
 4 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 4dc788e3bc96b..3fc84bf2b1e52 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -313,45 +313,47 @@ int fscrypt_decrypt_page(const struct inode *inode, struct page *page,
 EXPORT_SYMBOL(fscrypt_decrypt_page);
 
 /*
- * Validate dentries for encrypted directories to make sure we aren't
- * potentially caching stale data after a key has been added or
- * removed.
+ * Validate dentries in encrypted directories to make sure we aren't potentially
+ * caching stale dentries after a key has been added.
  */
 static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct dentry *dir;
-	int dir_has_key, cached_with_key;
+	int err;
+	int valid;
+
+	/*
+	 * Plaintext names are always valid, since fscrypt doesn't support
+	 * reverting to ciphertext names without evicting the directory's inode
+	 * -- which implies eviction of the dentries in the directory.
+	 */
+	if (!(dentry->d_flags & DCACHE_ENCRYPTED_NAME))
+		return 1;
+
+	/*
+	 * Ciphertext name; valid if the directory's key is still unavailable.
+	 *
+	 * Although fscrypt forbids rename() on ciphertext names, we still must
+	 * use dget_parent() here rather than use ->d_parent directly.  That's
+	 * because a corrupted fs image may contain directory hard links, which
+	 * the VFS handles by moving the directory's dentry tree in the dcache
+	 * each time ->lookup() finds the directory and it already has a dentry
+	 * elsewhere.  Thus ->d_parent can be changing, and we must safely grab
+	 * a reference to some ->d_parent to prevent it from being freed.
+	 */
 
 	if (flags & LOOKUP_RCU)
 		return -ECHILD;
 
 	dir = dget_parent(dentry);
-	if (!IS_ENCRYPTED(d_inode(dir))) {
-		dput(dir);
-		return 0;
-	}
-
-	spin_lock(&dentry->d_lock);
-	cached_with_key = dentry->d_flags & DCACHE_ENCRYPTED_WITH_KEY;
-	spin_unlock(&dentry->d_lock);
-	dir_has_key = (d_inode(dir)->i_crypt_info != NULL);
+	err = fscrypt_get_encryption_info(d_inode(dir));
+	valid = (d_inode(dir)->i_crypt_info == NULL);
 	dput(dir);
 
-	/*
-	 * If the dentry was cached without the key, and it is a
-	 * negative dentry, it might be a valid name.  We can't check
-	 * if the key has since been made available due to locking
-	 * reasons, so we fail the validation so ext4_lookup() can do
-	 * this check.
-	 *
-	 * We also fail the validation if the dentry was created with
-	 * the key present, but we no longer have the key, or vice versa.
-	 */
-	if ((!cached_with_key && d_is_negative(dentry)) ||
-			(!cached_with_key && dir_has_key) ||
-			(cached_with_key && !dir_has_key))
-		return 0;
-	return 1;
+	if (err < 0)
+		return err;
+
+	return valid;
 }
 
 const struct dentry_operations fscrypt_d_ops = {
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 56debb1fcf5eb..a9492f75bbe13 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -101,9 +101,9 @@ int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry)
 	if (err)
 		return err;
 
-	if (fscrypt_has_encryption_key(dir)) {
+	if (!fscrypt_has_encryption_key(dir)) {
 		spin_lock(&dentry->d_lock);
-		dentry->d_flags |= DCACHE_ENCRYPTED_WITH_KEY;
+		dentry->d_flags |= DCACHE_ENCRYPTED_NAME;
 		spin_unlock(&dentry->d_lock);
 	}
 
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 60996e64c5798..9b3b75d3bd211 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -212,7 +212,7 @@ struct dentry_operations {
 
 #define DCACHE_MAY_FREE			0x00800000
 #define DCACHE_FALLTHRU			0x01000000 /* Fall through to lower layer */
-#define DCACHE_ENCRYPTED_WITH_KEY	0x02000000 /* dir is encrypted with a valid key */
+#define DCACHE_ENCRYPTED_NAME		0x02000000 /* Encrypted name (dir key was unavailable) */
 #define DCACHE_OP_REAL			0x04000000
 
 #define DCACHE_PAR_LOOKUP		0x10000000 /* being looked up (with parent locked shared) */
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index e5194fc3983e9..5a0c3fee1ea2b 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -545,10 +545,8 @@ static inline int fscrypt_prepare_rename(struct inode *old_dir,
  * filenames are presented in encrypted form.  Therefore, we'll try to set up
  * the directory's encryption key, but even without it the lookup can continue.
  *
- * To allow invalidating stale dentries if the directory's encryption key is
- * added later, we also install a custom ->d_revalidate() method and use the
- * DCACHE_ENCRYPTED_WITH_KEY flag to indicate whether a given dentry is a
- * plaintext name (flag set) or a ciphertext name (flag cleared).
+ * This also installs a custom ->d_revalidate() method which will invalidate the
+ * dentry if it was created without the key and the key is later added.
  *
  * Return: 0 on success, -errno if a problem occurred while setting up the
  * encryption key
-- 
2.21.0.225.g810b269d1ac-goog
