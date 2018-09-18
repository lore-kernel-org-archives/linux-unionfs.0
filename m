Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/4] ovl: fix freeze protection bypass in ovl_write_iter()
Date: Tue, 18 Sep 2018 16:34:32 +0300
Message-Id: <20180918133434.27437-3-amir73il@gmail.com>
In-Reply-To: <20180918133434.27437-1-amir73il@gmail.com>
References: <20180918133434.27437-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Tested by re-writing to an open overlayfs file while upper ext4 is frozen:

  xfs_io -f /ovl/x
  xfs_io> pwrite 0 4096
                             fsfreeze -f /ext4
  xfs_io> pwrite 0 4096

  WARNING: CPU: 0 PID: 1492 at fs/ext4/ext4_jbd2.c:53 \
           ext4_journal_check_start+0x48/0x82

After the fix, the second write blocks in ovl_write_iter() and avoids
hitting WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE) in
ext4_journal_check_start().

Fixes: 2a92e07edc5e ("ovl: add ovl_write_iter()")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index aeaefd2a551b..986313da0c88 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -240,8 +240,10 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		goto out_unlock;
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
+	file_start_write(real.file);
 	ret = vfs_iter_write(real.file, iter, &iocb->ki_pos,
 			     ovl_iocb_to_rwf(iocb));
+	file_end_write(real.file);
 	revert_creds(old_cred);
 
 	/* Update size */
-- 
2.17.1
