From: hujianyang <hujianyang@huawei.com>
Subject: [PATCH] ovl: Fix kernel panic while mounting overlayfs
Date: Tue, 6 Jan 2015 12:52:13 +0800
Message-ID: <54AB69FD.6060501@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

The function ovl_fill_super() in recently multi-layer support
version will incorrectly return 0 at error handling path and
then cause kernel panic.

This failure can be reproduced by mounting a overlayfs with
upperdir and workdir in different mounts.

And also, If the memory allocation of *lower_mnt* fail, this
function may return an zero either.

This patch fix this problem by setting *err* to proper error
number before jumping to error handling path.

Signed-off-by: hujianyang <hujianyang@huawei.com>
---
 fs/overlayfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 84f3144..d50e3ed 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -836,6 +836,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (err)
 			goto out_put_upperpath;

+		err = -EINVAL;
 		if (upperpath.mnt != workpath.mnt) {
 			pr_err("overlayfs: workdir and upperdir must reside under the same mount\n");
 			goto out_put_workpath;
@@ -894,6 +895,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}

+	err = -ENOMEM;
 	ufs->lower_mnt = kcalloc(numlower, sizeof(struct vfsmount *), GFP_KERNEL);
 	if (ufs->lower_mnt == NULL)
 		goto out_put_workdir;
-- 
1.6.0.2

