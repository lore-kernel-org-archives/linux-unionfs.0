Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH v2 5/5] ovl: noop aops to test filemap operations and lazy copy up
Date: Tue, 22 Jan 2019 14:34:57 +0200
Message-Id: <20190122123457.10600-6-amir73il@gmail.com>
In-Reply-To: <20190122123457.10600-1-amir73il@gmail.com>
References: <20190122123457.10600-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

WIP - DO NOT MERGE!!!

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 35c75e9d8111..80d60a33a2a3 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -392,9 +392,21 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return ovl_real_fsync(file, start, end, datasync);
 }
 
+/* Noop aops to test filemap operations and lazy copy up */
+static int ovl_noop_writepage(struct page *page, struct writeback_control *wbc)
+{
+	unlock_page(page);
+	return 0;
+}
+
 const struct address_space_operations ovl_aops = {
+	.readpage	= simple_readpage,
+	.write_begin	= simple_write_begin,
+	.write_end	= simple_write_end,
+	.set_page_dirty	= __set_page_dirty_no_writeback,
+	.writepage	= ovl_noop_writepage,
 	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
-	.direct_IO		= noop_direct_IO,
+	.direct_IO	= noop_direct_IO,
 };
 
 static vm_fault_t ovl_fault(struct vm_fault *vmf)
-- 
2.17.1
