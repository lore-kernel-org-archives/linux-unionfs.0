Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6/7] ovl: enable xino automatically in more cases
Date: Wed,  1 Jan 2020 19:58:13 +0200
Message-Id: <20200101175814.14144-7-amir73il@gmail.com>
In-Reply-To: <20200101175814.14144-1-amir73il@gmail.com>
References: <20200101175814.14144-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

So far, with xino=auto, we only enable xino if we know that all
underlying filesystem use 32bit inode numbers.

When users configure overlay with xino=auto, they already declare that
they are ready to handle 64bit inode number from overlay.

It is a very common case, that underlying filesystem uses 64bit ino,
but rarely or never uses the high inode number bits (e.g. tmpfs, xfs).
Leaving it for the users to declare high ino bits are unused with
xino=on is not a recipe for many users to enjoy the benefits of xino.

There appears to be very little reason not to enable xino when users
declare xino=auto even if we do not know how many bits underlying
filesystem uses for inode numbers.

In the worst case of xino bits overflow by real inode number, we
already fall back to the non-xino behavior - real inode number with
unique pseudo dev or to non persistent inode number and overlay st_dev
(for directories).

The only annoyance from auto enabling xino is that xino bits overflow
emits a warning to kmsg. Suppress those warnings unless users explicitly
asked for xino=on, suggesting that they expected high ino bits to be
unused by underlying filesystem.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |  8 ++++----
 fs/overlayfs/overlayfs.h | 10 ++++++++++
 fs/overlayfs/readdir.c   | 17 +++++++++++------
 fs/overlayfs/super.c     |  2 +-
 4 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 415d9efa4799..7b94f0338536 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -98,13 +98,13 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 		 * and all inodes use overlay st_dev. Inode numbers are also
 		 * persistent for a given layer configuration.
 		 */
-		if (stat->ino >> shift) {
-			pr_warn_ratelimited("overlayfs: inode number too big (%pd2, ino=%llu, xinobits=%d)\n",
-					    dentry, stat->ino, xinobits);
-		} else {
+		if (likely(!(stat->ino >> shift))) {
 			stat->ino |= ((u64)fsid) << shift;
 			stat->dev = dentry->d_sb->s_dev;
 			return 0;
+		} else if (ovl_xino_warn(dentry->d_sb)) {
+			pr_warn_ratelimited("overlayfs: inode number too big (%pd2, ino=%llu, xinobits=%d)\n",
+					    dentry, stat->ino, xinobits);
 		}
 	}
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index c0b15fd2b395..667e8096f56c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -318,6 +318,16 @@ static inline struct ovl_sb *ovl_dentry_fs(struct dentry *dentry, int fsid)
 	return &OVL_FS(dentry->d_sb)->fs[fsid >> 1];
 }
 
+/*
+ * With xino=auto, we do best effort to keep all inodes on same st_dev and
+ * d_ino consistent with st_ino.
+ * With xino=on, we do the same effort but we warn if we failed.
+ */
+static inline bool ovl_xino_warn(struct super_block *sb)
+{
+	return OVL_FS(sb)->config.xino == OVL_XINO_ON;
+}
+
 /* All layers on same fs? */
 static inline bool ovl_same_fs(struct super_block *sb)
 {
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 0f5ab53b4184..7dbf3df99150 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -438,11 +438,13 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 
 /* Map inode number to lower fs unique range */
 static u64 ovl_remap_lower_ino(u64 ino, int xinobits, int fsid,
-			       const char *name, int namelen)
+			       const char *name, int namelen, bool warn)
 {
-	if (ino >> (64 - xinobits)) {
-		pr_warn_ratelimited("overlayfs: d_ino too big (%.*s, ino=%llu, xinobits=%d)\n",
-				    namelen, name, ino, xinobits);
+	if (unlikely(ino >> (64 - xinobits))) {
+		if (warn) {
+			pr_warn_ratelimited("overlayfs: d_ino too big (%.*s, ino=%llu, xinobits=%d)\n",
+					    namelen, name, ino, xinobits);
+		}
 		return ino;
 	}
 
@@ -515,7 +517,8 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 	} else if (xinobits && !OVL_TYPE_UPPER(type)) {
 		ino = ovl_remap_lower_ino(ino, xinobits,
 					  ovl_dentry_layer(this)->fsid,
-					  p->name, p->len);
+					  p->name, p->len,
+					  ovl_xino_warn(dir->d_sb));
 	}
 
 out:
@@ -645,6 +648,7 @@ struct ovl_readdir_translate {
 	u64 parent_ino;
 	int fsid;
 	int xinobits;
+	bool xinowarn;
 };
 
 static int ovl_fill_real(struct dir_context *ctx, const char *name,
@@ -665,7 +669,7 @@ static int ovl_fill_real(struct dir_context *ctx, const char *name,
 			ino = p->ino;
 	} else if (rdt->xinobits) {
 		ino = ovl_remap_lower_ino(ino, rdt->xinobits, rdt->fsid,
-					  name, namelen);
+					  name, namelen, rdt->xinowarn);
 	}
 
 	return orig_ctx->actor(orig_ctx, name, namelen, offset, ino, d_type);
@@ -695,6 +699,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
 		.xinobits = ovl_xino_bits(dir->d_sb),
+		.xinowarn = ovl_xino_warn(dir->d_sb),
 	};
 
 	if (rdt.xinobits)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d636a23df541..ca3204fe87bc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1407,7 +1407,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 			pr_info("overlayfs: \"xino=on\" is useless with all layers on same fs, ignore.\n");
 		ofs->xino_bits = 0;
 		ofs->config.xino = OVL_XINO_SAME_FS;
-	} else if (ofs->config.xino == OVL_XINO_ON && !ofs->xino_bits) {
+	} else if (ofs->config.xino != OVL_XINO_OFF && !ofs->xino_bits) {
 		/*
 		 * This is a roundup of number of bits needed for encoding
 		 * fsid, where fsid 0 is reserved for upper fs (even with
-- 
2.17.1
