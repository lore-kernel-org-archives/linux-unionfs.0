Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:31210 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752406AbeDLQNj (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Apr 2018 12:13:39 -0400
Date: Fri, 13 Apr 2018 00:13:09 +0800
From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH miklos-vfs] ovl: ovl_ioctl() can be static
Message-ID: <20180412161309.GA68367@lkp-sb-ep06>
References: <201804130058.N6wp9opo%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201804130058.N6wp9opo%fengguang.wu@intel.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: kbuild-all@01.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>


Fixes: f8395fc9f072 ("ovl: readd lsattr/chattr support")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 24674cf..a8e8a1d 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -312,7 +312,7 @@ static long ovl_real_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
-long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
