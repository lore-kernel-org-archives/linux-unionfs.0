From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 20/35] ovl: add O_DIRECT support
Date: Mon,  7 May 2018 10:37:52 +0200
Message-ID: <20180507083807.28792-21-mszeredi@redhat.com>
References: <20180507083807.28792-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507083807.28792-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 2028f6886649..ce871a15e185 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -110,6 +110,9 @@ static int ovl_open(struct inode *inode, struct file *file)
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
+	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
+	file->f_mapping = realfile->f_mapping;
+
 	file->private_data = realfile;
 
 	return 0;
-- 
2.14.3
