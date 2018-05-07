From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 27/35] vfs: fix freeze protection in mnt_want_write_file() for overlayfs
Date: Mon,  7 May 2018 10:37:59 +0200
Message-ID: <20180507083807.28792-28-mszeredi@redhat.com>
References: <20180507083807.28792-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507083807.28792-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

The underlying real file used by overlayfs still contains the overlay path.
This results in mnt_want_write_file() calls by the filesystem getting
freeze protection on the wrong inode (the overlayfs one instead of the real
one).

Fix by using file_inode(file)->i_sb instead of file->f_path.mnt->mnt_sb.

Reported-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/namespace.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 5286c5313e67..0d9023a9af4f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -441,10 +441,10 @@ int mnt_want_write_file(struct file *file)
 {
 	int ret;
 
-	sb_start_write(file->f_path.mnt->mnt_sb);
+	sb_start_write(file_inode(file)->i_sb);
 	ret = __mnt_want_write_file(file);
 	if (ret)
-		sb_end_write(file->f_path.mnt->mnt_sb);
+		sb_end_write(file_inode(file)->i_sb);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mnt_want_write_file);
@@ -486,7 +486,8 @@ void __mnt_drop_write_file(struct file *file)
 
 void mnt_drop_write_file(struct file *file)
 {
-	mnt_drop_write(file->f_path.mnt);
+	__mnt_drop_write_file(file);
+	sb_end_write(file_inode(file)->i_sb);
 }
 EXPORT_SYMBOL(mnt_drop_write_file);
 
-- 
2.14.3
