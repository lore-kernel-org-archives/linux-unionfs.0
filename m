From: Nikolay Borisov <kernel@kyup.com>
Subject: [PATCH] ovl: Add d_select_inode op to ovl_reval_dentry_operations
Date: Mon,  8 Feb 2016 16:52:03 +0200
Message-ID: <1454943123-9652-1-git-send-email-kernel@kyup.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35790 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbcBHOwI (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 8 Feb 2016 09:52:08 -0500
Received: by mail-wm0-f50.google.com with SMTP id c200so19191449wme.0
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Feb 2016 06:52:06 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, operations@siteground.com

Commit daee0af5b522 ("overlayfs: Make f_path always point to the
overlay and f_inode to the underlay") changed the way overlayed dentries
are opened and introduced ovl_d_select_inode so that in cases when an overlayed
file is opened its f_ops are being fetched from the underlying
(in the case of writes the upper directory) layer.

However, by not adding this operation to the ovl_reval_dentry_operations
this essentially disables writes to the upper layer in setups which
use a remote (as per the check in ovl_dentry_remote) lower layers, since
in this case ovl_reval_dentry_operations is going to be used when
dentries are created. This results in code in vfs_open never calling
d_select_inode to get the upper layer inode, which leads to do_dentry_open
using the overlay inode which has empty_fops.

This patch fixes this by adding d_select_inode operation to
ovl_reval_dentry_operations, which allows querying the correct inode
when writing to an overlayed location, using a remote lower dir.

Fixes: daee0af5b522 ("overlayfs: Make f_path always point to the
overlay and f_inode to the underlay")

Signed-off-by: Nikolay Borisov <kernel@kyup.com>
---

This took me quite a while to catch, and so far it survives local
testing. I'm mostly interested in knowing whether it (silently) 
breaks stuff. 

 fs/overlayfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e38ee0fed24a..787e075709fa 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -321,6 +321,7 @@ static const struct dentry_operations ovl_dentry_operations = {
 
 static const struct dentry_operations ovl_reval_dentry_operations = {
 	.d_release = ovl_dentry_release,
+	.d_select_inode = ovl_d_select_inode,
 	.d_revalidate = ovl_dentry_revalidate,
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
 };
-- 
2.5.0
