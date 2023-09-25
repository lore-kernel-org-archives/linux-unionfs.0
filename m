Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E142CE7A89
	for <linux-unionfs@archiver.kernel.org>; Mon, 25 Sep 2023 04:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjIYEvV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 00:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjIYEvV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2023 00:51:21 -0400
Received: from mail.nfschina.com (unknown [42.101.60.195])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id BD11EC2;
        Sun, 24 Sep 2023 21:51:14 -0700 (PDT)
Received: from localhost.localdomain (unknown [180.167.10.98])
        by mail.nfschina.com (Maildata Gateway V2.8.8) with ESMTPA id 62A466047A8C6;
        Mon, 25 Sep 2023 12:51:12 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From:   Su Hui <suhui@nfschina.com>
To:     miklos@szeredi.hu, amir73il@gmail.com
Cc:     Su Hui <suhui@nfschina.com>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] ovl: avoid possible NULL dereference
Date:   Mon, 25 Sep 2023 12:51:00 +0800
Message-Id: <20230925045059.92883-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

smatch warn:
fs/overlayfs/copy_up.c:450 ovl_set_origin() warn:
variable dereferenced before check 'fh' (see line 449)

If 'fh' is NULL, passing NULL instead of 'fh->buf'.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 fs/overlayfs/copy_up.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d1761ec5866a..086f9176b4d4 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -446,7 +446,7 @@ int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
 	/*
 	 * Do not fail when upper doesn't support xattrs.
 	 */
-	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh->buf,
+	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh ? fh->buf : NULL,
 				 fh ? fh->fb.len : 0, 0);
 	kfree(fh);
 
-- 
2.30.2

