Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH v3 11/11] NFS replace cross device with cross filesystem check in copy_file_range
Date: Thu, 25 Oct 2018 17:51:47 -0400
Message-Id: <20181025215147.36248-13-olga.kornievskaia@gmail.com>
In-Reply-To: <20181025215147.36248-1-olga.kornievskaia@gmail.com>
References: <20181025215147.36248-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

VFS copy_file_range was relaxed to allow for cross-device copy.
NFS code was added to support for server to server copy offload.
Add a check to disallow cross file systems copy offload, both
files are expected to be of NFS type.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
---
 fs/nfs/nfs4file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 4f142db..aab3720 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -139,7 +139,7 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
 	nfs4_stateid *cnrs = NULL;
 	ssize_t ret;
 
-	if (file_in->f_inode->i_sb != file_out->f_inode->i_sb)
+	if (file_in->f_inode->i_sb->s_type != file_out->f_inode->i_sb->s_type)
 		return -EXDEV;
 
 	if (file_inode(file_in) == file_inode(file_out))
-- 
1.8.3.1
