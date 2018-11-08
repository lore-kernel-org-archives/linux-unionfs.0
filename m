Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/3] vfs: introduce the concept of inode number domains
Date: Thu,  8 Nov 2018 13:49:40 +0200
Message-Id: <20181108114942.32531-2-amir73il@gmail.com>
In-Reply-To: <20181108114942.32531-1-amir73il@gmail.com>
References: <20181108114942.32531-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Added super_block fields s_max_ino_bits and s_ino_domain that may be
used by stacking filesystems that want to harness unique inode numbers
of underlying filesystem.

s_ino_domain is a key that described a unique inode numbers domain.
For non stacked filesystem, s_ino_domain defaults to s_dev.

Stacking filesystem may "inherit" s_ino_domain from underlying
filesystem when inode numbers of stacked inode are the same as the
underlying inode numbers.

A filesystem may advertise the maximum used inode number bits by
setting s_max_ino_bits to non zero value.
Stacking filesystems may use this information to multiplex several
inode number domains into a new domain of unique inode numbers.

Change the type of s_stack_depth from int to unsigned short to pack
the "stacked" context variables nicely. FILESYSTEM_MAX_STACK_DEPTH
is not likely to grow far beyond the current value of 2.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c |  3 ++-
 fs/super.c           |  2 ++
 include/linux/fs.h   | 16 +++++++++++++++-
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0116735cc321..1afe67c4599a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -775,7 +775,8 @@ static int ovl_check_namelen(struct path *path, struct ovl_fs *ofs,
 }
 
 static int ovl_lower_dir(const char *name, struct path *path,
-			 struct ovl_fs *ofs, int *stack_depth, bool *remote)
+			 struct ovl_fs *ofs, unsigned short *stack_depth,
+			 bool *remote)
 {
 	int fh_type;
 	int err;
diff --git a/fs/super.c b/fs/super.c
index ca53a08497ed..860ca3311f05 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -529,6 +529,8 @@ struct super_block *sget_userns(struct file_system_type *type,
 		return ERR_PTR(err);
 	}
 	s->s_type = type;
+	/* May be overridden by stacked filesystem */
+	s->s_ino_domain = s->s_dev;
 	strlcpy(s->s_id, type->name, sizeof(s->s_id));
 	list_add_tail(&s->s_list, &super_blocks);
 	hlist_add_head(&s->s_instances, &type->fs_supers);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c95c0807471f..7d45b5158cd0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1487,7 +1487,21 @@ struct super_block {
 	/*
 	 * Indicates how deep in a filesystem stack this SB is
 	 */
-	int s_stack_depth;
+	unsigned short		s_stack_depth;
+	/*
+	 * s_max_ino_bits and s_ino_domain may be used by stacking filesystems
+	 * that want to harness unique inode numbers of underlying filesystem.
+	 * For non stacked filesystem, s_ino_domain defaults to s_dev.
+	 * Stacking filesystem may "inherit" s_ino_domain from underlying
+	 * filesystem when inode numbers of stacked inode are the same as the
+	 * underlying inode numbers.
+	 * A filesystem may advertise the maximum used inode number bits by
+	 * setting s_max_ino_bits to non zero value.
+	 * Stacking filesystems may use this information to multiplex several
+	 * inode number domains into a new domain of unique inode numbers.
+	 */
+	unsigned short		s_max_ino_bits;
+	dev_t			s_ino_domain;
 
 	/* s_inode_list_lock protects s_inodes */
 	spinlock_t		s_inode_list_lock ____cacheline_aligned_in_smp;
-- 
2.17.1
