From: Anisse Astier <anisse@astier.eu>
Subject: ca4c8a3a800039 ovl: treat special files like a regular fs
Date: Fri, 27 Oct 2017 17:20:48 +0200
Message-ID: <20171027152048.GA1246@bifrost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
To: stable@vger.kernel.org
Cc: Sasha Levin <alexander.levin@verizon.com>, Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi,

Would it be possible to backport upstream commit
ca4c8a3a800039c2681d609c5b7491c1bd17c0a7 into 4.9 ?

	From: Miklos Szeredi <mszeredi@redhat.com>
	ovl: treat special files like a regular fs

	No sense in opening special files on the underlying layers, they work just
	as well if opened on the overlay.

	Side effect is that it's no longer possible to connect one side of a pipe
	opened on overlayfs with the other side opened on the underlying layer.


Before this it's impossible to do in-kernel resolution of a device file,
for example to mount or use dmsetup.

Miklos, you say this might cause a behaviour change in a very
particular case; but did it cause an issue upstream since it was merged
in 4.10 ?

I also wish this was fixed in 4.1, so I did a tentative backport below.
What do you think Sasha, Miklos ?

Regards,

Anisse

-- 

Tentative backport of upstream commit ca4c8a3a800039c2681d609c5b7491c1bd17c0a7 for 4.1:

	From: Miklos Szeredi <mszeredi@redhat.com>
	Date: Fri, 16 Dec 2016 11:02:55 +0100
	Subject: [PATCH] ovl: treat special files like a regular fs

	No sense in opening special files on the underlying layers, they work just
	as well if opened on the overlay.

	Side effect is that it's no longer possible to connect one side of a pipe
	opened on overlayfs with the other side opened on the underlying layer.

It's quite different becauso this is so far in the future (applied in
4.10), but should work, maybe.
---
 fs/overlayfs/dir.c       |  2 +-
 fs/overlayfs/inode.c     | 16 +++++-----------
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/super.c     |  4 ++--
 4 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 692ceda..215404f 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -393,7 +393,7 @@ static int ovl_create_or_link(struct dentry *dentry, int mode, dev_t rdev,
 	};
 
 	err = -ENOMEM;
-	inode = ovl_new_inode(dentry->d_sb, mode, dentry->d_fsdata);
+	inode = ovl_new_inode(dentry->d_sb, mode, dentry->d_fsdata, rdev);
 	if (!inode)
 		goto out;
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a1b069e..2a7fb55 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -401,7 +401,7 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 };
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
-			    struct ovl_entry *oe)
+			    struct ovl_entry *oe, dev_t rdev)
 {
 	struct inode *inode;
 
@@ -409,13 +409,11 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
 	if (!inode)
 		return NULL;
 
-	mode &= S_IFMT;
-
 	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_flags |= S_NOATIME | S_NOCMTIME;
 
-	switch (mode) {
+	switch (mode & S_IFMT) {
 	case S_IFDIR:
 		inode->i_private = oe;
 		inode->i_op = &ovl_dir_inode_operations;
@@ -427,17 +425,13 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
 		break;
 
 	case S_IFREG:
-	case S_IFSOCK:
-	case S_IFBLK:
-	case S_IFCHR:
-	case S_IFIFO:
 		inode->i_op = &ovl_file_inode_operations;
 		break;
 
 	default:
-		WARN(1, "illegal file type: %i\n", mode);
-		iput(inode);
-		inode = NULL;
+		inode->i_op = &ovl_file_inode_operations;
+		init_special_inode(inode, mode, rdev);
+		break;
 	}
 
 	return inode;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index ea5a40b..1933536 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -176,7 +176,7 @@ int ovl_removexattr(struct dentry *dentry, const char *name);
 struct inode *ovl_d_select_inode(struct dentry *dentry, unsigned file_flags);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
-			    struct ovl_entry *oe);
+			    struct ovl_entry *oe, dev_t rdev);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bd6d5c1..3f8d5b8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -434,7 +434,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		err = -ENOMEM;
 		inode = ovl_new_inode(dentry->d_sb, realdentry->d_inode->i_mode,
-				      oe);
+				      oe, realdentry->d_inode->i_rdev);
 		if (!inode)
 			goto out_free_oe;
 		ovl_copyattr(realdentry->d_inode, inode);
@@ -969,7 +969,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!oe)
 		goto out_put_lower_mnt;
 
-	root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR, oe));
+	root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR, oe, 0));
 	if (!root_dentry)
 		goto out_free_oe;
 
-- 
2.7.5
