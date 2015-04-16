From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/4] Overlayfs: Convert S_ISDIR(dentry->d_inode) to
 d_is_dir()/d_can_lookup()
Date: Thu, 16 Apr 2015 15:42:08 +0100
Message-ID: <20150416144208.12573.4266.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbbDPOmN (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 16 Apr 2015 10:42:13 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Convert S_ISDIR(dentry->d_inode) to d_is_dir(dentry) or d_can_lookup(dentry)
as appropriate.  This is slightly complicated as there are two options for
directories.  The difference is whether the directory in question is a real
dir with a ->lookup op or whether it's a fake dir with a ->d_automount op.

Note that if there is a directory at this position, in both overlayfs and
unionmount it must be represented as a directory inode in the union layer and
will not be represented as a dentry with NULL ->d_inode with a fallthrough.
This means that the d_is_dir() and d_can_lookup() tests are safe no matter
whether we're looking at overlayfs's own inodes or its subordinate inodes.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/inode.c |    2 +-
 fs/overlayfs/super.c |    8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 04f124884687..8c8f024edcc0 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -239,7 +239,7 @@ static bool ovl_need_xattr_filter(struct dentry *dentry,
 				  enum ovl_path_type type)
 {
 	if ((type & (__OVL_PATH_PURE | __OVL_PATH_UPPER)) == __OVL_PATH_UPPER)
-		return S_ISDIR(dentry->d_inode->i_mode);
+		return d_is_dir(dentry);
 	else
 		return false;
 }
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5f0d1993e6e3..d5f7117caf5e 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -76,7 +76,7 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 		type = __OVL_PATH_UPPER;
 
 		if (oe->numlower) {
-			if (S_ISDIR(dentry->d_inode->i_mode))
+			if (d_is_dir(dentry))
 				type |= __OVL_PATH_MERGE;
 		} else if (!oe->opaque) {
 			type |= __OVL_PATH_PURE;
@@ -395,8 +395,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (i < poe->numlower - 1 && ovl_is_opaquedir(this))
 			opaque = true;
 
-		if (prev && (!S_ISDIR(prev->d_inode->i_mode) ||
-			     !S_ISDIR(this->d_inode->i_mode))) {
+		if (prev && (!d_is_dir(prev) ||
+			     !d_is_dir(this))) {
 			/*
 			 * FIXME: check for upper-opaqueness maybe better done
 			 * in remove code.
@@ -731,7 +731,7 @@ static int ovl_mount_dir_noesc(const char *name, struct path *path)
 		pr_err("overlayfs: filesystem on '%s' not supported\n", name);
 		goto out_put;
 	}
-	if (!S_ISDIR(path->dentry->d_inode->i_mode)) {
+	if (!d_can_lookup(path->dentry)) {
 		pr_err("overlayfs: '%s' not a directory\n", name);
 		goto out_put;
 	}

