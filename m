Return-Path: <iforster@suse.com>
From: Ignaz Forster <iforster@suse.com>
Subject: [PATCH 3/5] Execute IMA post create hook in vfs_create
Date: Mon, 11 Feb 2019 17:53:21 +0100
Message-Id: <20190211165323.9369-4-iforster@suse.com>
In-Reply-To: <20190211165323.9369-1-iforster@suse.com>
References: <20190211165323.9369-1-iforster@suse.com>
To: Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Cc: Fabian Vogt <fvogt@suse.com>, Ignaz Forster <iforster@suse.de>, Fabian Vogt <fvogt@suse.de>
List-ID: <linux-unionfs@vger.kernel.org>

From: Ignaz Forster <iforster@suse.de>

When creating a new file on overlayfs, the file can not be accessed
due to missing security.ima / security.evm xattrs, as the creation of
the required hashes is never triggered.

Similarly to the existing handling of tmpfiles, trigger file hash
generation by calling ima_post_create_file.

Co-developed-by: Fabian Vogt <fvogt@suse.de>
Signed-off-by: Fabian Vogt <fvogt@suse.de>
Signed-off-by: Ignaz Forster <iforster@suse.de>
---
 fs/namei.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 744e89474cda..3b4021e4fc32 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2910,8 +2910,10 @@ int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 	if (error)
 		return error;
 	error = dir->i_op->create(dir, dentry, mode, want_excl);
-	if (!error)
+	if (!error) {
 		fsnotify_create(dir, dentry);
+		ima_post_create_file(dentry->d_inode);
+	}
 	return error;
 }
 EXPORT_SYMBOL(vfs_create);
-- 
2.20.1
