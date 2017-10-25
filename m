From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 13/13] ovl: Enable metadata only feature
Date: Wed, 25 Oct 2017 15:09:35 -0400
Message-ID: <1508958575-14086-14-git-send-email-vgoyal@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20667 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932356AbdJYTJn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2017 15:09:43 -0400
In-Reply-To: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

All the bits are in patches before this. So it is time to enable the
metadata only copy up feature.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 4876ae4..3ce35e1 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -637,12 +637,13 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	int err;
 	DEFINE_DELAYED_CALL(done);
 	struct path parentpath;
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_copy_up_ctx ctx = {
 		.parent = parent,
 		.dentry = dentry,
 		.workdir = ovl_workdir(dentry),
 		.origin = true,
-		.metacopy = false,
+		.metacopy = ofs->config.metacopy,
 	};
 
 	if (WARN_ON(!ctx.workdir))
-- 
2.5.5
