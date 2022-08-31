Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A488ECAAD1
	for <linux-unionfs@archiver.kernel.org>; Wed, 31 Aug 2022 08:07:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiHaIHK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 31 Aug 2022 04:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiHaIHJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Aug 2022 04:07:09 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76181F4C;
        Wed, 31 Aug 2022 01:07:07 -0700 (PDT)
Received: from stanislav-HLY-WX9XX.. (unknown [93.175.2.86])
        by mail.ispras.ru (Postfix) with ESMTPSA id C490C40755ED;
        Wed, 31 Aug 2022 08:07:03 +0000 (UTC)
From:   Stanislav Goriainov <goriainov@ispras.ru>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Stanislav Goriainov <goriainov@ispras.ru>,
        Vivek Goyal <vgoyal@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH v2] ovl: Add comment on upperredirect reassignment
Date:   Wed, 31 Aug 2022 11:06:58 +0300
Message-Id: <20220831080658.14878-1-goriainov@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

If memory for uperredirect was allocated with kstrdup()
in upperdir != NULL and d.redirect != NULL path, it may seem
that it can be lost when upperredirect is reassigned later, but
it's not possible.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 0a2d0d3f2f291 ("ovl: Check redirect on index as well")
Signed-off-by: Stanislav Goriainov <goriainov@ispras.ru>
---
 fs/overlayfs/namei.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 69dc577974f8..2a21331e6ccd 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1085,6 +1085,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			.mnt = ovl_upper_mnt(ofs),
 		};
 
+		/* There is no overwrite of upperredirect here as the first
+		 * assignment of upperredirect happens only if
+		 * upperdentry is non-NULL, while here we are only
+		 * if upperdentry is NULL.
+		 */
 		upperredirect = ovl_get_redirect_xattr(ofs, &upperpath, 0);
 		if (IS_ERR(upperredirect)) {
 			err = PTR_ERR(upperredirect);
-- 
2.34.1

