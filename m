Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 17/31] ovl: Do not expose metacopy only dentry from d_real()
Date: Thu, 26 Apr 2018 15:09:59 -0400
Message-Id: <20180426191013.13219-18-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Metacopy dentry/inode is internal to overlay and is never exposed
outside of it. Modify d_real() to look for only dentries/inode which
have data and which are not metacopy.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b81ec9d22ac5..4efb7cd76cc1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -100,7 +100,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	if (!d_is_reg(dentry))
 		goto bug;
 
-	real = ovl_dentry_real(dentry);
+	real = ovl_dentry_real_data(dentry);
 	if (inode == d_inode(real))
 		return real;
 
-- 
2.13.6
