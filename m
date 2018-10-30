Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH v7 02/11] NFS: validity check for source offset in copy_file_range
Date: Tue, 30 Oct 2018 16:56:05 -0400
Message-Id: <20181030205614.40754-4-olga.kornievskaia@gmail.com>
In-Reply-To: <20181030205614.40754-1-olga.kornievskaia@gmail.com>
References: <20181030205614.40754-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

Input source offset can not be beyond the end of the file.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
---
 fs/nfs/nfs4file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 5a73c90..7838bdf 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -135,6 +135,9 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
 {
 	ssize_t ret;
 
+	if (pos_in >= i_size_read(file_inode(file_in)))
+		return -EINVAL;
+
 	if (file_inode(file_in)->i_sb != file_inode(file_out)->i_sb)
 		return -EXDEV;
 
-- 
1.8.3.1
