From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 1/4] ovl: use insert_inode_locked4() to hash a newly created inode
Date: Tue, 15 May 2018 13:26:09 +0300
Message-ID: <1526379972-20923-2-git-send-email-amir73il@gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, "#v4 . 16" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Currently, there is a small window where ovl_obtain_alias() can
race with ovl_instantiate() and create two different overlay inodes
with the same underlying real non-dir non-hardlink inode.

The race requires an adversary to guess the file handle of the
yet to be created upper inode and decode the guessed file handle
after ovl_creat_real(), but before ovl_instantiate().

This patch fixes the race, by using insert_inode_locked4() to add
a newly created inode to icache.

If the newly created inode apears to already exist in icache (hashed
by the same real upper inode), we export this error to user instead
of silently not hashing the new inode.

This race does not affect overlay directory inodes, because those
are decoded via ovl_lookup_real() and not with ovl_obtain_alias(),
so avoid using the new helper d_instantiate_new() to reduce backport
dependencies.

Backporting only makes sense for v4.16 where NFS export was introduced.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org> #v4.16
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 24 ++++++++++++++++++------
 fs/overlayfs/inode.c     | 18 ++++++++++++++++++
 fs/overlayfs/overlayfs.h |  1 +
 3 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 47dc980e8b33..62e6733b755c 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -183,14 +183,24 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
 }
 
 /* Common operations required to be done after creation of file on upper */
-static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
-			    struct dentry *newdentry, bool hardlink)
+static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
+			   struct dentry *newdentry, bool hardlink)
 {
 	ovl_dir_modified(dentry->d_parent, false);
-	ovl_copyattr(d_inode(newdentry), inode);
 	ovl_dentry_set_upper_alias(dentry);
 	if (!hardlink) {
-		ovl_inode_update(inode, newdentry);
+		int err;
+
+		ovl_inode_init(inode, newdentry, NULL);
+		/*
+		 * XXX: if we ever use ovl_obtain_alias() to decode directory
+		 * file handles, need to use ovl_insert_inode_locked() and
+		 * d_instantiate_new() here to prevent ovl_obtain_alias()
+		 * from sneaking in before d_instantiate().
+		 */
+		err = ovl_insert_inode(inode, d_inode(newdentry));
+		if (err)
+			return err;
 	} else {
 		WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
 		dput(newdentry);
@@ -200,6 +210,8 @@ static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
 	/* Force lookup of new upper hardlink to find its lower */
 	if (hardlink)
 		d_drop(dentry);
+
+	return 0;
 }
 
 static bool ovl_type_merge(struct dentry *dentry)
@@ -238,7 +250,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 		ovl_set_opaque(dentry, newdentry);
 	}
 
-	ovl_instantiate(dentry, inode, newdentry, !!hardlink);
+	err = ovl_instantiate(dentry, inode, newdentry, !!hardlink);
 	newdentry = NULL;
 out_dput:
 	dput(newdentry);
@@ -439,7 +451,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		if (err)
 			goto out_cleanup;
 	}
-	ovl_instantiate(dentry, inode, newdentry, !!hardlink);
+	err = ovl_instantiate(dentry, inode, newdentry, !!hardlink);
 	newdentry = NULL;
 out_dput2:
 	dput(upper);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7abcf96e94fc..060c534998d1 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -741,6 +741,24 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
 	return true;
 }
 
+static int ovl_insert_inode_locked(struct inode *inode, struct inode *realinode)
+{
+	return insert_inode_locked4(inode, (unsigned long) realinode,
+				    ovl_inode_test, realinode);
+}
+
+int ovl_insert_inode(struct inode *inode, struct inode *realinode)
+{
+	int err;
+
+	err = ovl_insert_inode_locked(inode, realinode);
+	if (err)
+		return err;
+
+	unlock_new_inode(inode);
+	return 0;
+}
+
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper)
 {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index caaa47cea2aa..642b25702092 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -343,6 +343,7 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
+int ovl_insert_inode(struct inode *inode, struct inode *realinode);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-- 
2.7.4
