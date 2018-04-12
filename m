Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:40068 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752917AbeDLPyh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Apr 2018 11:54:37 -0400
Date: Thu, 12 Apr 2018 23:54:09 +0800
From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH miklos-vfs] ovl: ovl_fallocate() can be static
Message-ID: <20180412155409.GA51729@lkp-sb-ep06>
References: <201804122351.HBN7GKZh%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201804122351.HBN7GKZh%fengguang.wu@intel.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: kbuild-all@01.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>


Fixes: 9283a5d72622 ("ovl: readd fallocate")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index b7b3202..fd2911b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -268,7 +268,7 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 	return ret;
 }
 
-long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
+static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 {
 	struct inode *inode = file_inode(file);
 	struct fd real;
