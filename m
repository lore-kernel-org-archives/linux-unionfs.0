From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 08/35] ovl: deal with overlay files in ovl_d_real()
Date: Thu, 12 Apr 2018 17:07:59 +0200
Message-ID: <20180412150826.20988-9-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
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
