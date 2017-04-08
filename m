From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 1/2] vfs: ftruncate check IS_APPEND() on real upper inode
Date: Sat,  8 Apr 2017 14:49:06 +0300
Message-ID: <1491652147-19794-2-git-send-email-amir73il@gmail.com>
References: <1491652147-19794-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35749 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751684AbdDHLtC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2017 07:49:02 -0400
Received: by mail-wr0-f194.google.com with SMTP id t20so23280473wra.2
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2017 04:49:02 -0700 (PDT)
In-Reply-To: <1491652147-19794-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

ftruncate an overlayfs inode was checking IS_APPEND() on
overlay inode, but overlay inode does not have the S_APPEND flag.

Check IS_APPEND() on real upper inode instead.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/open.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 949cef2..993a91d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -193,7 +193,8 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 		goto out_putf;
 
 	error = -EPERM;
-	if (IS_APPEND(inode))
+	/* Check IS_APPEND on real upper inode */
+	if (IS_APPEND(file_inode(f.file)))
 		goto out_putf;
 
 	sb_start_write(inode->i_sb);
-- 
2.7.4
