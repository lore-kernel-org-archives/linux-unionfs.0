Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC369C7EE2E
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jun 2023 05:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbjFLFge (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 01:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234025AbjFLFgc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jun 2023 01:36:32 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64B0127
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Jun 2023 22:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Iqb8yqv42Jpk9dF5nG2xmCjIa7S0ggClh5tb3+YGBGI=; b=qIqkyI+C7NtRzFcpPQzJIWzT29
        6pFWxIpg6pyQ2fwpca0fkfzcTwrPbh7uLNnt/e3Zap9fKfxewcTuTq0qsirxtS3wdYtZCgTBol1bw
        DJGga0oZX1eqWYf/u5iVK678LNMzR+TkNGlWmVK0W10V39IS/jjydo9oEBUWtlL6jfcM9JZIikk+O
        p4W1iduWIWgsTP7Rxsn3Ak7u1oPQns8yl/diwyLHqcMz2t7pMi3Iu4ZRWaP4C0Lgzdle3EdWPBiQ+
        +6AnFCnPTUnRm6qB8IdARxlJxuawu9a2RYO/vkWPRn4t9M/hOq8FrdPulT2NPDqwnCz8bWnNy30I3
        c31so4PA==;
Received: from 2a02-8389-2341-5b80-8c8c-28f8-1274-e038.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:8c8c:28f8:1274:e038] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1q8aEA-002fDI-2h;
        Mon, 12 Jun 2023 05:36:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH] overlayfs: set FMODE_CAN_ODIRECT instead of a dummy direct_IO method
Date:   Mon, 12 Jun 2023 07:36:28 +0200
Message-Id: <20230612053628.585624-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Since commit a2ad63daa88b ("VFS: add FMODE_CAN_ODIRECT file flag") file
systems can just set the FMODE_CAN_ODIRECT flag at open time instead of
wiring up a dummy direct_IO method to indicate support for direct I/O.

Remove .direct_IO and thus the entire address space operations for
overlayfs and set FMODE_CAN_ODIRECT in ovl_open instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/overlayfs/file.c  | 1 +
 fs/overlayfs/inode.c | 6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 7c04f033aadd75..4c9bc79ae1d452 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -156,6 +156,7 @@ static int ovl_open(struct inode *inode, struct file *file)
 
 	/* No longer need these flags, so don't pass them on to underlying fs */
 	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
+	file->f_mode |= FMODE_CAN_ODIRECT;
 
 	ovl_path_realdata(dentry, &realpath);
 	realfile = ovl_open_realfile(file, &realpath);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 541cf3717fc2b1..efaa8e41579210 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -886,11 +886,6 @@ static const struct inode_operations ovl_special_inode_operations = {
 	.update_time	= ovl_update_time,
 };
 
-static const struct address_space_operations ovl_aops = {
-	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
-	.direct_IO		= noop_direct_IO,
-};
-
 /*
  * It is possible to stack overlayfs instance on top of another
  * overlayfs instance as lower layer. We need to annotate the
@@ -1032,7 +1027,6 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
 	case S_IFREG:
 		inode->i_op = &ovl_file_inode_operations;
 		inode->i_fop = &ovl_file_operations;
-		inode->i_mapping->a_ops = &ovl_aops;
 		break;
 
 	case S_IFDIR:
-- 
2.39.2

