From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH v2 2/3] vfs: make argument of d_real_inode() const
Date: Thu, 21 Jul 2016 15:53:35 +0200
Message-ID: <1469109216-24353-3-git-send-email-mszeredi@redhat.com>
References: <1469109216-24353-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1469109216-24353-1-git-send-email-mszeredi@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

d_op->d_real() leaves the dentry alone except if the third argument is
non-zero.  Unfortunately very difficult to explain to the compiler without
a cast.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 include/linux/dcache.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 14df83609c7f..b965751c6b71 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -583,9 +583,10 @@ static inline struct dentry *d_real(struct dentry *dentry,
  * If dentry is on an union/overlay, then return the underlying, real inode.
  * Otherwise return d_inode().
  */
-static inline struct inode *d_real_inode(struct dentry *dentry)
+static inline struct inode *d_real_inode(const struct dentry *dentry)
 {
-	return d_backing_inode(d_real(dentry, NULL, 0));
+	/* This usage of d_real() results in const dentry */
+	return d_backing_inode(d_real((struct dentry *) dentry, NULL, 0));
 }
 
 
-- 
2.5.5

