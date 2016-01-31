From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [PATCH] ovl: fix working on distributed fs as lower layer
Date: Sun, 31 Jan 2016 16:22:16 +0300
Message-ID: <145424653619.10827.10119853770850679426.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

This adds missing .d_select_inode into alternative dentry_operations.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Fixes: 7c03b5d45b8e ("ovl: allow distributed fs as lower layer")
Fixes: 4bacc9c9234c ("overlayfs: Make f_path always point to the overlay and f_inode to the underlay")
---
 fs/overlayfs/super.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e6ae59c7119c..1a354840f262 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -343,6 +343,7 @@ static const struct dentry_operations ovl_dentry_operations = {
 
 static const struct dentry_operations ovl_reval_dentry_operations = {
 	.d_release = ovl_dentry_release,
+	.d_select_inode = ovl_d_select_inode,
 	.d_revalidate = ovl_dentry_revalidate,
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
 };
