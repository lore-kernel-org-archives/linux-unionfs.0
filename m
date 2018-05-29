From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 16/28] ovl: Do not expose metacopy only dentry from d_real()
Date: Tue, 29 May 2018 16:46:00 +0200
Message-ID: <20180529144612.16675-17-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Metacopy dentry/inode is internal to overlay and is never exposed outside
of it.  Exception is metacopy upper file used for fsync().  Modify d_real()
to look for dentries/inode which have data, but also allow matching upper
inode without data for the fsync case.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/super.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e0326a686f45..6687d547ec6b 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -101,10 +101,13 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	}
 
 	real = ovl_dentry_upper(dentry);
-	if (real && (!inode || inode == d_inode(real)))
+	if (real && (inode == d_inode(real)))
 		return real;
 
-	real = ovl_dentry_lower(dentry);
+	if (real && !inode && ovl_has_upperdata(d_inode(dentry)))
+		return real;
+
+	real = ovl_dentry_lowerdata(dentry);
 	if (!real)
 		goto bug;
 
-- 
2.14.3
