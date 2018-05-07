From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 10/35] ovl: deal with overlay files in ovl_d_real()
Date: Mon,  7 May 2018 10:37:42 +0200
Message-ID: <20180507083807.28792-11-mszeredi@redhat.com>
References: <20180507083807.28792-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507083807.28792-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e8551c97de51..ad6a5baf226b 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -97,6 +97,10 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	struct dentry *real;
 	int err;
 
+	/* It's an overlay file */
+	if (inode && d_inode(dentry) == inode)
+		return dentry;
+
 	if (flags & D_REAL_UPPER)
 		return ovl_dentry_upper(dentry);
 
-- 
2.14.3
