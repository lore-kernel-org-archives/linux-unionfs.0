Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:51596 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727202AbeHaJ5q (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 31 Aug 2018 05:57:46 -0400
Date: Fri, 31 Aug 2018 13:51:12 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [RFC PATCH miklos-vfs] ovl: ovl_fadvise() can be static
Message-ID: <20180831055112.GA11179@lkp-sb04>
References: <201808311344.jRhJ1LUF%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201808311344.jRhJ1LUF%fengguang.wu@intel.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: kbuild-all@01.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-ID: <linux-unionfs@vger.kernel.org>


Fixes: 53e35e7602b1 ("ovl: add ovl_fadvise()")
Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
---
 file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 89f9e97..aeaefd2 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -331,7 +331,7 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 	return ret;
 }
 
-int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
+static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 {
 	struct fd real;
 	const struct cred *old_cred;
