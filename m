From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 27/28] ovl: Do not do metacopy only for ioctl modifying file attr
Date: Tue, 29 May 2018 16:46:11 +0200
Message-ID: <20180529144612.16675-28-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

ovl_copy_up() by default will only do metadata only copy up (if enabled).
That means when ovl_real_ioctl() calls ovl_real_file(), it will still get
the lower file (as ovl_real_file() opens data file and not metacopy).  And
that means "chattr +i" will end up modifying lower inode.

There seem to be two ways to solve this.
A. Open metacopy file in ovl_real_ioctl() and do operations on that
B. Force full copy up when FS_IOC_SETFLAGS is called.

I am resorting to option B for now as it feels little safer option.  If
there are performance issues due to this, we can revisit it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 953295774471..31f32fc1004b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -389,7 +389,7 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (ret)
 			return ret;
 
-		ret = ovl_copy_up(file_dentry(file));
+		ret = ovl_copy_up_with_data(file_dentry(file));
 		if (!ret) {
 			ret = ovl_real_ioctl(file, cmd, arg);
 
-- 
2.14.3
