Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH v7 11/11] NFS: replace cross device check in copy_file_range
Date: Tue, 30 Oct 2018 16:56:14 -0400
Message-Id: <20181030205614.40754-13-olga.kornievskaia@gmail.com>
In-Reply-To: <20181030205614.40754-1-olga.kornievskaia@gmail.com>
References: <20181030205614.40754-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

Add a check to disallow cross file systems copy offload, both
files are expected to be of NFS4.2+ type.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
---
 fs/nfs/nfs4file.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 989f174..69e2705 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -142,7 +142,10 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (pos_in >= i_size_read(file_inode(file_in)))
 		return -EINVAL;
 
-	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
+	if (file_in->f_op != &nfs4_file_operations)
+		return -EXDEV;
+
+	if ((NFS_SERVER(file_inode(file_in)))->nfs_client->cl_minorversion < 2)
 		return -EXDEV;
 
 	if (file_inode(file_in) == file_inode(file_out))
-- 
1.8.3.1
