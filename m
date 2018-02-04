From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: hash non-dir by lower inode for fsnotify
Date: Sun,  4 Feb 2018 22:50:10 +0200
Message-ID: <1517777410-16282-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40386 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751724AbeBDUtK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 4 Feb 2018 15:49:10 -0500
Received: by mail-wr0-f196.google.com with SMTP id i56so27618601wra.7
        for <linux-unionfs@vger.kernel.org>; Sun, 04 Feb 2018 12:49:09 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

Commit 31747eda41ef ("ovl: hash directory inodes for fsnotify")
fixed an issue of inotify watch on directory that stops getting
events after dropping dentry caches.

A similar issue exists for non-dir non-upper files, for example:

$ mkdir -p lower upper work merged
$ touch lower/foo
$ mount -t overlay -o
lowerdir=lower,workdir=work,upperdir=upper none merged
$ inotifywait merged/foo &
$ echo 2 > /proc/sys/vm/drop_caches
$ cat merged/foo

inotifywait doesn't get the OPEN event, because ovl_lookup() called
from 'cat' allocates a new overlay inode and does not reuse the
watched inode.

Fix this by hashing non-dir overlay inodes by lower real inode in
the following cases that were not hashed before this change:
- A non-upper overlay mount
- A lower non-hardlink when index=off

A helper ovl_hash_bylower() was added to put all the logic and
documentation about which real inode an overlay inode is hashed by
into one place.

The issue dates back to initial version of overlayfs, but this
patch depends on ovl_inode code that was introduced in kernel v4.13.

Cc: <stable@vger.kernel.org> #v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

I found this while working on 'hash inode by lower file handle'.
This patch is currently at the tip of my NFS export fixes branch [1],
although the fix is not related to NFS export and could be applied to
stable kernel along with "ovl: hash directory inodes for fsnotify".

This patch makes some order in the mess that started piling up in
ovl_get_inode(), so it is the starting point of my WIP branch [2] for
hashing by lower file handle.

The WIP has been manually tested with some extra debug prints and
seems to be working fine, but I still need to improve the naiive
hash function and test some more, so I'm sending out this bugfix
is case you want to include it in 4.16 pull request.

Thanks,
Amir.

[1] https://github.com/amir73il/xfstests/commits/ovl-nfs-export
[2] https://github.com/amir73il/xfstests/commits/ovl-nfs-export-wip


 fs/overlayfs/inode.c | 58 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index fcd97b783fa1..b6b44cf9ec26 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -669,38 +669,59 @@ struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 	return inode;
 a}
 
+/*
+ * Does overlay inode need to be hashes by lower inode?
+ */
+static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
+			     struct dentry *lower, struct dentry *index)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	/* No, if pure upper */
+	if (!lower)
+		return false;
+
+	/* Yes, if already indexed */
+	if (index)
+		return true;
+
+	/* Yes, if won't be copied up */
+	if (!ofs->upper_mnt)
+		return true;
+
+	/* No, if lower hardlink is or will be broken on copy up */
+	if ((upper || !ovl_indexdir(sb)) &&
+	    !d_is_dir(lower) && d_inode(lower)->i_nlink > 1)
+		return false;
+
+	/* No, if non-indexed upper with NFS export */
+	if (sb->s_export_op && upper)
+		return false;
+
+	/* Otherwise, hash by lower inode for fsnotify */
+	return true;
+}
+
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			    struct dentry *lowerdentry, struct dentry *index,
 			    unsigned int numlower)
 {
-	struct ovl_fs *ofs = sb->s_fs_info;
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
-	/* Already indexed or could be indexed on copy up? */
-	bool indexed = (index || (ovl_indexdir(sb) && !upperdentry));
-	struct dentry *origin = indexed ? lowerdentry : NULL;
+	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
 	bool is_dir;
 
-	if (WARN_ON(upperdentry && indexed && !lowerdentry))
-		return ERR_PTR(-EIO);
-
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
 
 	/*
-	 * Copy up origin (lower) may exist for non-indexed non-dir upper, but
-	 * we must not use lower as hash key in that case.
-	 * Hash non-dir that is or could be indexed by origin inode.
-	 * Hash dir that is or could be merged by origin inode.
-	 * Hash pure upper and non-indexed non-dir by upper inode.
-	 * Hash non-indexed dir by upper inode for NFS export.
+	 * Copy up origin (lower) may exist for non-indexed upper, but we must
+	 * not use lower as hash key if this is a broken hardlink.
 	 */
 	is_dir = S_ISDIR(realinode->i_mode);
-	if (is_dir && (indexed || !sb->s_export_op || !ofs->upper_mnt))
-		origin = lowerdentry;
-
-	if (upperdentry || origin) {
-		struct inode *key = d_inode(origin ?: upperdentry);
+	if (upperdentry || bylower) {
+		struct inode *key = d_inode(bylower ? lowerdentry :
+						      upperdentry);
 		unsigned int nlink = is_dir ? 1 : realinode->i_nlink;
 
 		inode = iget5_locked(sb, (unsigned long) key,
@@ -728,6 +749,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			nlink = ovl_get_nlink(lowerdentry, upperdentry, nlink);
 		set_nlink(inode, nlink);
 	} else {
+		/* Lower hardlink that will be broken on copy up */
 		inode = new_inode(sb);
 		if (!inode)
 			goto out_nomem;
-- 
2.7.4
