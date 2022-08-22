Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 286FFC28D13
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Aug 2022 11:53:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbiHVLxa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 07:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbiHVLxM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Aug 2022 07:53:12 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B570B33A15;
        Mon, 22 Aug 2022 04:53:09 -0700 (PDT)
Received: from stanislav-HLY-WX9XX.. (unknown [46.172.13.71])
        by mail.ispras.ru (Postfix) with ESMTPSA id 12A9640D4004;
        Mon, 22 Aug 2022 11:53:01 +0000 (UTC)
From:   Stanislav Goriainov <goriainov@ispras.ru>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Stanislav Goriainov <goriainov@ispras.ru>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] ovl: Fix potential memory leak
Date:   Mon, 22 Aug 2022 14:52:57 +0300
Message-Id: <20220822115257.7457-1-goriainov@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ovl: Fix potential memory leak in ovl_lookup()

If memory for uperredirect was allocated with kstrdup()
in upperdir != NULL and d.redirect != NULL path,
it may be lost when upperredirect is reassigned later.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Stanislav Goriainov <goriainov@ispras.ru>
---
 fs/overlayfs/namei.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 69dc577974f8..226c69812379 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1085,6 +1085,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			.mnt = ovl_upper_mnt(ofs),
 		};
 
+		kfree(upperredirect);
 		upperredirect = ovl_get_redirect_xattr(ofs, &upperpath, 0);
 		if (IS_ERR(upperredirect)) {
 			err = PTR_ERR(upperredirect);
-- 
2.34.1

