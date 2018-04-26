Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753498AbeDZTKm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 30/31] ovl: Do not do metacopy only for ioctl modifying file attr
Date: Thu, 26 Apr 2018 15:10:12 -0400
Message-Id: <20180426191013.13219-31-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

ovl_copy_up() by default will only do metadata only copy up (if enabled).
That means when ovl_real_ioctl() calls ovl_real_file(), it will still
get the lower file (as ovl_real_file() opens data file and not metacopy).
And that means "chattr +i" will end up modifying lower inode.

There seem to be two ways to solve this.
A. Open metacopy file in ovl_real_ioctl() and do operations on that
B. Force full copy up when FS_IOC_SETFLAGS is called.

I am resorting to option B for now as it feels little safer option. If
there are performance issues due to this, we can revisit it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index d61c8355b892..9a9efaac71f4 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -397,7 +397,7 @@ long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (ret)
 			return ret;
 
-		ret = ovl_copy_up(file_dentry(file));
+		ret = ovl_copy_up_flags(file_dentry(file), O_WRONLY);
 		if (!ret) {
 			ret = ovl_real_ioctl(file, cmd, arg);
 
-- 
2.13.6

