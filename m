From: Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5/5] fscrypt: fix race where ->lookup() marks
 plaintext dentry as ciphertext
Date: Sun, 17 Mar 2019 13:04:44 -0700
Message-ID: <20190317200444.5967-6-ebiggers@kernel.org>
References: <20190317200444.5967-1-ebiggers@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20190317200444.5967-1-ebiggers@kernel.org>
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

->lookup() in an encrypted directory begins as follows:

1. fscrypt_prepare_lookup():
    a. Try to load the directory's encryption key.
    b. If the key is unavailable, mark the dentry as a ciphertext name
       via d_flags.
2. fscrypt_setup_filename():
    a. Try to load the directory's encryption key.
    b. If the key is available, encrypt the name (treated as a plaintext
       name) to get the on-disk name.  Otherwise decode the name
       (treated as a ciphertext name) to get the on-disk name.

But if the key is concurrently added, it may be found at (2a) but not at
(1a).  In this case, the dentry will be wrongly marked as a ciphertext
name even though it was actually treated as plaintext.

This will cause the dentry to be wrongly invalidated on the next lookup,
potentially causing problems.  For example, if the racy ->lookup() was
part of sys_mount(), then the new mount will be detached when anything
tries to access it.  This is despite the mountpoint having a plaintext
path, which should remain valid now that the key was added.

Of course, this is only possible if there's a userspace race.  Still,
the additional kernel-side race is confusing and unexpected.

Close the kernel-side race by changing fscrypt_prepare_lookup() to also
set the on-disk filename (step 2b), consistent with the d_flags update.

Fixes: 28b4c263961c ("ext4 crypto: revalidate dentry after adding or removing the key")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fname.c       |  1 +
 fs/crypto/hooks.c       | 11 +++---
 fs/ext4/ext4.h          | 62 +++++++++++++++++++++++++--------
 fs/ext4/namei.c         | 76 ++++++++++++++++++++++++++++-------------
 fs/f2fs/namei.c         | 17 +++++----
 fs/ubifs/dir.c          |  8 ++---
 include/linux/fscrypt.h | 31 ++++++++++-------
 7 files changed, 138 insertions(+), 68 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 7ff40a73dbec..dea65c091f71 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -356,6 +356,7 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 	}
 	if (!lookup)
 		return -ENOKEY;
+	fname->is_ciphertext_name = true;
 
 	/*
 	 * We don't have the key and we are doing a lookup; decode the
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 9d8910e86ee5..042d5b44f4ed 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -104,20 +104,21 @@ int __fscrypt_prepare_rename(struct inode *old_dir, struct dentry *old_dentry,
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_rename);
 
-int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry)
+int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
+			     struct fscrypt_name *fname)
 {
-	int err = fscrypt_get_encryption_info(dir);
+	int err = fscrypt_setup_filename(dir, &dentry->d_name, 1, fname);
 
-	if (err)
+	if (err && err != -ENOENT)
 		return err;
 
-	if (!fscrypt_has_encryption_key(dir)) {
+	if (fname->is_ciphertext_name) {
 		spin_lock(&dentry->d_lock);
 		dentry->d_flags |= DCACHE_ENCRYPTED_NAME;
 		spin_unlock(&dentry->d_lock);
 		d_set_d_op(dentry, &fscrypt_d_ops);
 	}
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL_GPL(__fscrypt_prepare_lookup);
 
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 82ffdacdc7fa..e64a4ee96d30 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2287,23 +2287,47 @@ extern unsigned ext4_free_clusters_after_init(struct super_block *sb,
 ext4_fsblk_t ext4_inode_to_goal_block(struct inode *);
 
 #ifdef CONFIG_FS_ENCRYPTION
+static inline void ext4_fname_from_fscrypt_name(struct ext4_filename *dst,
+						const struct fscrypt_name *src)
+{
+	memset(dst, 0, sizeof(*dst));
+
+	dst->usr_fname = src->usr_fname;
+	dst->disk_name = src->disk_name;
+	dst->hinfo.hash = src->hash;
+	dst->hinfo.minor_hash = src->minor_hash;
+	dst->crypto_buf = src->crypto_buf;
+}
+
 static inline int ext4_fname_setup_filename(struct inode *dir,
-			const struct qstr *iname,
-			int lookup, struct ext4_filename *fname)
+					    const struct qstr *iname,
+					    int lookup,
+					    struct ext4_filename *fname)
 {
 	struct fscrypt_name name;
 	int err;
 
-	memset(fname, 0, sizeof(struct ext4_filename));
-
 	err = fscrypt_setup_filename(dir, iname, lookup, &name);
+	if (err)
+		return err;
 
-	fname->usr_fname = name.usr_fname;
-	fname->disk_name = name.disk_name;
-	fname->hinfo.hash = name.hash;
-	fname->hinfo.minor_hash = name.minor_hash;
-	fname->crypto_buf = name.crypto_buf;
-	return err;
+	ext4_fname_from_fscrypt_name(fname, &name);
+	return 0;
+}
+
+static inline int ext4_fname_prepare_lookup(struct inode *dir,
+					    struct dentry *dentry,
+					    struct ext4_filename *fname)
+{
+	struct fscrypt_name name;
+	int err;
+
+	err = fscrypt_prepare_lookup(dir, dentry, &name);
+	if (err)
+		return err;
+
+	ext4_fname_from_fscrypt_name(fname, &name);
+	return 0;
 }
 
 static inline void ext4_fname_free_filename(struct ext4_filename *fname)
@@ -2317,19 +2341,27 @@ static inline void ext4_fname_free_filename(struct ext4_filename *fname)
 	fname->usr_fname = NULL;
 	fname->disk_name.name = NULL;
 }
-#else
+#else /* !CONFIG_FS_ENCRYPTION */
 static inline int ext4_fname_setup_filename(struct inode *dir,
-		const struct qstr *iname,
-		int lookup, struct ext4_filename *fname)
+					    const struct qstr *iname,
+					    int lookup,
+					    struct ext4_filename *fname)
 {
 	fname->usr_fname = iname;
 	fname->disk_name.name = (unsigned char *) iname->name;
 	fname->disk_name.len = iname->len;
 	return 0;
 }
-static inline void ext4_fname_free_filename(struct ext4_filename *fname) { }
 
-#endif
+static inline int ext4_fname_prepare_lookup(struct inode *dir,
+					    struct dentry *dentry,
+					    struct ext4_filename *fname)
+{
+	return ext4_fname_setup_filename(dir, &dentry->d_name, 1, fname);
+}
+
+static inline void ext4_fname_free_filename(struct ext4_filename *fname) { }
+#endif /* !CONFIG_FS_ENCRYPTION */
 
 /* dir.c */
 extern int __ext4_check_dir_entry(const char *, unsigned int, struct inode *,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 980166a8122a..3ba6f30db8d9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -1327,7 +1327,7 @@ static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
 }
 
 /*
- *	ext4_find_entry()
+ *	__ext4_find_entry()
  *
  * finds an entry in the specified directory with the wanted name. It
  * returns the cache buffer in which the entry was found, and the entry
@@ -1337,39 +1337,32 @@ static int is_dx_internal_node(struct inode *dir, ext4_lblk_t block,
  * The returned buffer_head has ->b_count elevated.  The caller is expected
  * to brelse() it when appropriate.
  */
-static struct buffer_head * ext4_find_entry (struct inode *dir,
-					const struct qstr *d_name,
-					struct ext4_dir_entry_2 **res_dir,
-					int *inlined)
+static struct buffer_head *__ext4_find_entry(struct inode *dir,
+					     struct ext4_filename *fname,
+					     struct ext4_dir_entry_2 **res_dir,
+					     int *inlined)
 {
 	struct super_block *sb;
 	struct buffer_head *bh_use[NAMEI_RA_SIZE];
 	struct buffer_head *bh, *ret = NULL;
 	ext4_lblk_t start, block;
-	const u8 *name = d_name->name;
+	const u8 *name = fname->usr_fname->name;
 	size_t ra_max = 0;	/* Number of bh's in the readahead
 				   buffer, bh_use[] */
 	size_t ra_ptr = 0;	/* Current index into readahead
 				   buffer */
 	ext4_lblk_t  nblocks;
 	int i, namelen, retval;
-	struct ext4_filename fname;
 
 	*res_dir = NULL;
 	sb = dir->i_sb;
-	namelen = d_name->len;
+	namelen = fname->usr_fname->len;
 	if (namelen > EXT4_NAME_LEN)
 		return NULL;
 
-	retval = ext4_fname_setup_filename(dir, d_name, 1, &fname);
-	if (retval == -ENOENT)
-		return NULL;
-	if (retval)
-		return ERR_PTR(retval);
-
 	if (ext4_has_inline_data(dir)) {
 		int has_inline_data = 1;
-		ret = ext4_find_inline_entry(dir, &fname, res_dir,
+		ret = ext4_find_inline_entry(dir, fname, res_dir,
 					     &has_inline_data);
 		if (has_inline_data) {
 			if (inlined)
@@ -1389,7 +1382,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 		goto restart;
 	}
 	if (is_dx(dir)) {
-		ret = ext4_dx_find_entry(dir, &fname, res_dir);
+		ret = ext4_dx_find_entry(dir, fname, res_dir);
 		/*
 		 * On success, or if the error was file not found,
 		 * return.  Otherwise, fall back to doing a search the
@@ -1453,7 +1446,7 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 			goto cleanup_and_exit;
 		}
 		set_buffer_verified(bh);
-		i = search_dirblock(bh, dir, &fname,
+		i = search_dirblock(bh, dir, fname,
 			    block << EXT4_BLOCK_SIZE_BITS(sb), res_dir);
 		if (i == 1) {
 			EXT4_I(dir)->i_dir_start_lookup = block;
@@ -1484,10 +1477,50 @@ static struct buffer_head * ext4_find_entry (struct inode *dir,
 	/* Clean up the read-ahead blocks */
 	for (; ra_ptr < ra_max; ra_ptr++)
 		brelse(bh_use[ra_ptr]);
-	ext4_fname_free_filename(&fname);
 	return ret;
 }
 
+static struct buffer_head *ext4_find_entry(struct inode *dir,
+					   const struct qstr *d_name,
+					   struct ext4_dir_entry_2 **res_dir,
+					   int *inlined)
+{
+	int err;
+	struct ext4_filename fname;
+	struct buffer_head *bh;
+
+	err = ext4_fname_setup_filename(dir, d_name, 1, &fname);
+	if (err == -ENOENT)
+		return NULL;
+	if (err)
+		return ERR_PTR(err);
+
+	bh = __ext4_find_entry(dir, &fname, res_dir, inlined);
+
+	ext4_fname_free_filename(&fname);
+	return bh;
+}
+
+static struct buffer_head *ext4_lookup_entry(struct inode *dir,
+					     struct dentry *dentry,
+					     struct ext4_dir_entry_2 **res_dir)
+{
+	int err;
+	struct ext4_filename fname;
+	struct buffer_head *bh;
+
+	err = ext4_fname_prepare_lookup(dir, dentry, &fname);
+	if (err == -ENOENT)
+		return NULL;
+	if (err)
+		return ERR_PTR(err);
+
+	bh = __ext4_find_entry(dir, &fname, res_dir, NULL);
+
+	ext4_fname_free_filename(&fname);
+	return bh;
+}
+
 static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
 			struct ext4_filename *fname,
 			struct ext4_dir_entry_2 **res_dir)
@@ -1546,16 +1579,11 @@ static struct dentry *ext4_lookup(struct inode *dir, struct dentry *dentry, unsi
 	struct inode *inode;
 	struct ext4_dir_entry_2 *de;
 	struct buffer_head *bh;
-	int err;
-
-	err = fscrypt_prepare_lookup(dir, dentry, flags);
-	if (err)
-		return ERR_PTR(err);
 
 	if (dentry->d_name.len > EXT4_NAME_LEN)
 		return ERR_PTR(-ENAMETOOLONG);
 
-	bh = ext4_find_entry(dir, &dentry->d_name, &de, NULL);
+	bh = ext4_lookup_entry(dir, dentry, &de);
 	if (IS_ERR(bh))
 		return ERR_CAST(bh);
 	inode = NULL;
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index f5e34e467003..c3e8a901d47a 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -436,19 +436,23 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 	nid_t ino = -1;
 	int err = 0;
 	unsigned int root_ino = F2FS_ROOT_INO(F2FS_I_SB(dir));
+	struct fscrypt_name fname;
 
 	trace_f2fs_lookup_start(dir, dentry, flags);
 
-	err = fscrypt_prepare_lookup(dir, dentry, flags);
-	if (err)
-		goto out;
-
 	if (dentry->d_name.len > F2FS_NAME_LEN) {
 		err = -ENAMETOOLONG;
 		goto out;
 	}
 
-	de = f2fs_find_entry(dir, &dentry->d_name, &page);
+	err = fscrypt_prepare_lookup(dir, dentry, &fname);
+	if (err == -ENOENT)
+		goto out_splice;
+	if (err)
+		goto out;
+	de = __f2fs_find_entry(dir, &fname, &page);
+	fscrypt_free_filename(&fname);
+
 	if (!de) {
 		if (IS_ERR(page)) {
 			err = PTR_ERR(page);
@@ -488,8 +492,7 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 	}
 out_splice:
 	new = d_splice_alias(inode, dentry);
-	if (IS_ERR(new))
-		err = PTR_ERR(new);
+	err = PTR_ERR_OR_ZERO(new);
 	trace_f2fs_lookup_end(dir, dentry, ino, err);
 	return new;
 out_iput:
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 5767b373a8ff..b73de6d04fa3 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -220,11 +220,9 @@ static struct dentry *ubifs_lookup(struct inode *dir, struct dentry *dentry,
 
 	dbg_gen("'%pd' in dir ino %lu", dentry, dir->i_ino);
 
-	err = fscrypt_prepare_lookup(dir, dentry, flags);
-	if (err)
-		return ERR_PTR(err);
-
-	err = fscrypt_setup_filename(dir, &dentry->d_name, 1, &nm);
+	err = fscrypt_prepare_lookup(dir, dentry, &nm);
+	if (err == -ENOENT)
+		return d_splice_alias(NULL, dentry);
 	if (err)
 		return ERR_PTR(err);
 
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 4ad7a856e0f1..44e7a576c5be 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -33,6 +33,7 @@ struct fscrypt_name {
 	u32 hash;
 	u32 minor_hash;
 	struct fscrypt_str crypto_buf;
+	bool is_ciphertext_name;
 };
 
 #define FSTR_INIT(n, l)		{ .name = n, .len = l }
@@ -221,7 +222,8 @@ extern int __fscrypt_prepare_rename(struct inode *old_dir,
 				    struct inode *new_dir,
 				    struct dentry *new_dentry,
 				    unsigned int flags);
-extern int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry);
+extern int __fscrypt_prepare_lookup(struct inode *dir, struct dentry *dentry,
+				    struct fscrypt_name *fname);
 extern int __fscrypt_prepare_symlink(struct inode *dir, unsigned int len,
 				     unsigned int max_len,
 				     struct fscrypt_str *disk_link);
@@ -331,7 +333,7 @@ static inline int fscrypt_setup_filename(struct inode *dir,
 	if (IS_ENCRYPTED(dir))
 		return -EOPNOTSUPP;
 
-	memset(fname, 0, sizeof(struct fscrypt_name));
+	memset(fname, 0, sizeof(*fname));
 	fname->usr_fname = iname;
 	fname->disk_name.name = (unsigned char *)iname->name;
 	fname->disk_name.len = iname->len;
@@ -418,7 +420,8 @@ static inline int __fscrypt_prepare_rename(struct inode *old_dir,
 }
 
 static inline int __fscrypt_prepare_lookup(struct inode *dir,
-					   struct dentry *dentry)
+					   struct dentry *dentry,
+					   struct fscrypt_name *fname)
 {
 	return -EOPNOTSUPP;
 }
@@ -539,25 +542,29 @@ static inline int fscrypt_prepare_rename(struct inode *old_dir,
  * fscrypt_prepare_lookup - prepare to lookup a name in a possibly-encrypted directory
  * @dir: directory being searched
  * @dentry: filename being looked up
- * @flags: lookup flags
+ * @fname: (output) the name to use to search the on-disk directory
  *
- * Prepare for ->lookup() in a directory which may be encrypted.  Lookups can be
- * done with or without the directory's encryption key; without the key,
- * filenames are presented in encrypted form.  Therefore, we'll try to set up
- * the directory's encryption key, but even without it the lookup can continue.
+ * Prepare for ->lookup() in a directory which may be encrypted by determining
+ * the name that will actually be used to search the directory on-disk.
  *
  * This also installs a custom ->d_revalidate() method which will invalidate the
  * dentry if it was created without the key and the key is later added.
  *
- * Return: 0 on success, -errno if a problem occurred while setting up the
- * encryption key
+ * Return: 0 on success; -ENOENT if key is unavailable but the filename isn't a
+ * correctly formed encoded ciphertext name, so a negative dentry should be
+ * created; or another -errno code.
  */
 static inline int fscrypt_prepare_lookup(struct inode *dir,
 					 struct dentry *dentry,
-					 unsigned int flags)
+					 struct fscrypt_name *fname)
 {
 	if (IS_ENCRYPTED(dir))
-		return __fscrypt_prepare_lookup(dir, dentry);
+		return __fscrypt_prepare_lookup(dir, dentry, fname);
+
+	memset(fname, 0, sizeof(*fname));
+	fname->usr_fname = &dentry->d_name;
+	fname->disk_name.name = (unsigned char *)dentry->d_name.name;
+	fname->disk_name.len = dentry->d_name.len;
 	return 0;
 }
 
-- 
2.21.0
