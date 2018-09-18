Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/4] ovl: fix freeze protection bypass in ovl_clone_file_range()
Date: Tue, 18 Sep 2018 16:34:33 +0300
Message-Id: <20180918133434.27437-4-amir73il@gmail.com>
In-Reply-To: <20180918133434.27437-1-amir73il@gmail.com>
References: <20180918133434.27437-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Tested by doing clone on overlayfs while upper xfs+reflink is frozen:

  xfs_io -f /ovl/y
                             fsfreeze -f /xfs
  xfs_io> reflink /ovl/x

Before the fix xfs_io enters xfs_reflink_remap_range() and blocks
in xfs_trans_alloc(). After the fix, xfs_io blocks outside xfs code
in ovl_clone_file_range().

Fixes: 8ede205541ff ("ovl: add reflink/copyfile/dedup support")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 986313da0c88..5d1b4b38f743 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -461,7 +461,7 @@ static ssize_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 		break;
 
 	case OVL_CLONE:
-		ret = vfs_clone_file_range(real_in.file, pos_in,
+		ret = do_clone_file_range(real_in.file, pos_in,
 					   real_out.file, pos_out, len);
 		break;
 
-- 
2.17.1
