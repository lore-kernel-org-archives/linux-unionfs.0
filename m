Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH v8 02/11] NFS: validity check for source offset in copy_file_range
Date: Thu,  1 Nov 2018 12:45:14 -0400
Message-Id: <20181101164523.41812-3-olga.kornievskaia@gmail.com>
In-Reply-To: <20181101164523.41812-1-olga.kornievskaia@gmail.com>
References: <20181101164523.41812-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

copy_file_range() man page mandates that EINVAL is returned
if the specified range is beyond the end of the file but
currently does not enforce it.

NFS RFC 7832 states that "if the source offset or the source
offset plus count is greater than the size of the source file,
the operation MUST fail with NFS4ERR_INVAL."

>From the NFS community discussion from earlier on
https://www.spinics.net/lists/linux-nfs/msg62627.html
in was thought that offset plus count should instead be a
short read.

In this patch only proposing to enforce the offset check:
Input source offset can not be beyond the end of the file.

Future work in VFS might perform the arguments checks and
we can remove this check.

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
