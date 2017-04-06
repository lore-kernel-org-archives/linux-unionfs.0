From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/4] vfs: open check IS_APPEND() on backing inode
Date: Thu,  6 Apr 2017 11:13:49 +0300
Message-ID: <1491466429-30333-5-git-send-email-amir73il@gmail.com>
References: <1491466429-30333-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1491466429-30333-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

For overlay file open, check IS_APPEND() on real backing inode
inside vfs_open(), because the overlay inode does not have the
S_APPEND flag.

This seems like the wrong place for this check.
Probably better to propagate S_APPEND flag to overlay inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/open.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/open.c b/fs/open.c
index baf67cd..8f1754d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -859,6 +859,15 @@ int vfs_open(const struct path *path, struct file *file,
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
+	/* Check append-only open flags also against real inode */
+	if (dentry != path->dentry && IS_APPEND(d_backing_inode(dentry))) {
+		if  ((file->f_flags & O_ACCMODE) != O_RDONLY &&
+		     !(file->f_flags & O_APPEND))
+			return -EPERM;
+		if (file->f_flags & O_TRUNC)
+			return -EPERM;
+	}
+
 	file->f_path = *path;
 	return do_dentry_open(file, d_backing_inode(dentry), NULL, cred);
 }
-- 
2.7.4
