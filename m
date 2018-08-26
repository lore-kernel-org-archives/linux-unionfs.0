Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/6] ovl: respect FIEMAP_FLAG_SYNC flag
Date: Sun, 26 Aug 2018 19:25:13 +0300
Message-Id: <1535300717-26686-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Stacked overlayfs fiemap operation broke xfstests that test delayed
allocation (with "_test_generic_punch -d"), because ovl_fiemap()
failed to write dirty pages when requested.

Fixes: 9e142c4102db ("ovl: add ovl_fiemap()")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index e0bb217c01e2..5014749fd4b4 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -467,6 +467,10 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 		return -EOPNOTSUPP;
 
 	old_cred = ovl_override_creds(inode->i_sb);
+
+	if (fieinfo->fi_flags & FIEMAP_FLAG_SYNC)
+		filemap_write_and_wait(realinode->i_mapping);
+
 	err = realinode->i_op->fiemap(realinode, fieinfo, start, len);
 	revert_creds(old_cred);
 
-- 
2.7.4
