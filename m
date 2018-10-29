Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH v5 02/12] VFS: generic cross-device copy_file_range() support for all filesystems
Date: Mon, 29 Oct 2018 13:40:49 -0400
Message-Id: <20181029174059.38326-4-olga.kornievskaia@gmail.com>
In-Reply-To: <20181029174059.38326-1-olga.kornievskaia@gmail.com>
References: <20181029174059.38326-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

If a filesystem does not support cross device or cross file system
type copy offload functionality, then this patch provides a fallback
to a page cache based physical data copy. This means the
copy_file_range() systemcall will never fail with EXDEV, and so in
future userspace will not need to detect or provide a fallback for
failed cross-device copies anymore.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
---
 fs/read_write.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 7a912e3..cff59bd 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1597,7 +1597,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (file_out->f_op->copy_file_range) {
 		ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
 						      pos_out, len, flags);
-		if (ret != -EOPNOTSUPP)
+		if (ret != -EOPNOTSUPP && ret != -EXDEV)
 			goto done;
 	}
 
-- 
1.8.3.1
