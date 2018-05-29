From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 13/39] ovl: deal with overlay files in ovl_d_real()
Date: Tue, 29 May 2018 16:43:13 +0200
Message-ID: <20180529144339.16538-14-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 704b37311467..211975921a90 100644
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
