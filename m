From: hujianyang <hujianyang@huawei.com>
Subject: [PATCH 2/3] ovl: check lowerdir amount for non-upper mount
Date: Thu, 15 Jan 2015 13:19:21 +0800
Message-ID: <54B74DD9.2020607@huawei.com>
References: <54B74D70.3000205@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <54B74D70.3000205@huawei.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Seunghun Lee <waydi1@gmail.com>, Fabian Sturm <fabian.sturm@aduu.de>
List-Id: linux-unionfs@vger.kernel.org

Recently multi-lower layer mount support allow upperdir and workdir
to be omitted, then cause overlayfs can be mount with only one
lowerdir directory. This action make no sense and have potential risk.

This patch check the total number of lower directories to prevent
mounting overlayfs with only one directory.

Also, an error message is added to indicate lower directories exceed
*OVL_MAX_STACK* limit.

Signed-off-by: hujianyang <hujianyang@huawei.com>
---
 fs/overlayfs/super.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ab3c8cb..edbb3eb 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -870,8 +870,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)

 	err = -EINVAL;
 	stacklen = ovl_split_lowerdirs(lowertmp);
-	if (stacklen > OVL_MAX_STACK)
+	if (stacklen > OVL_MAX_STACK) {
+		pr_err("overlayfs: too many lower directries, limit is %d\n",
+		       OVL_MAX_STACK);
 		goto out_free_lowertmp;
+	} else if (!ufs->config.upperdir && stacklen == 1) {
+		pr_err("overlayfs: at least 2 lowerdir are needed while upperdir nonexistent\n");
+		goto out_free_lowertmp;
+	}

 	stack = kcalloc(stacklen, sizeof(struct path), GFP_KERNEL);
 	if (!stack)
-- 
1.6.0.2

