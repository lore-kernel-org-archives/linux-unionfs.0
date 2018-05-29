From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 10/39] ovl: copy up inode flags
Date: Tue, 29 May 2018 16:43:10 +0200
Message-ID: <20180529144339.16538-11-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On inode creation copy certain inode flags from the underlying real inode
to the overlay inode.

This is in preparation for moving overlay functionality out of the VFS.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/overlayfs.h | 7 +++++++
 fs/overlayfs/util.c      | 1 +
 2 files changed, 8 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index eeaad0710704..e9dab319c8b2 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -350,6 +350,13 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 	to->i_ctime = from->i_ctime;
 }
 
+static inline void ovl_copyflags(struct inode *from, struct inode *to)
+{
+	unsigned int mask = S_SYNC | S_IMMUTABLE | S_APPEND | S_NOATIME;
+
+	inode_set_flags(to, from->i_flags & mask, mask);
+}
+
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
 int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 30a05d1d679d..25d202b47326 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -310,6 +310,7 @@ void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 		OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
 
 	ovl_copyattr(realinode, inode);
+	ovl_copyflags(realinode, inode);
 	if (!inode->i_ino)
 		inode->i_ino = realinode->i_ino;
 }
-- 
2.14.3
