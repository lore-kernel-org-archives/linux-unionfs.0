Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH v2 02/13] CIFS: add cross-device check for copy_file_range
Date: Wed, 24 Oct 2018 15:58:26 -0400
Message-Id: <20181024195837.35532-4-olga.kornievskaia@gmail.com>
In-Reply-To: <20181024195837.35532-1-olga.kornievskaia@gmail.com>
References: <20181024195837.35532-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

VFS copy_file_range was relaxed to allow for cross-device copy.
Add a check for now, to disallow cross-device copy offload until
appropriate support is added.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
---
 fs/cifs/cifsfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 7065426..1f41e74 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1114,6 +1114,8 @@ static ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
 	unsigned int xid = get_xid();
 	ssize_t rc;
 
+	if (src_file->f_inode->i_sb != dst_file->f_inode->i_sb)
+		return -EXDEV;
 	rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
 					len, flags);
 	free_xid(xid);
-- 
1.8.3.1
