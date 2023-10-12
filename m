Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B766CDB47E
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 15:37:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379172AbjJLPhK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 11:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379065AbjJLPhJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 11:37:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13BD7B8
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 08:37:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E4FC433C8;
        Thu, 12 Oct 2023 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697125027;
        bh=VdKe3s1fGXG9JaYxeHT3MfM7VreN1ibOkkvZF094eg0=;
        h=From:To:Cc:Subject:Date:From;
        b=L66ZYl9K4SliubBttrabVP+2l8AeXhpK3+MNII0O+zCrKJBjapP6LQeep7LRTCq2H
         k0SUDRjAypvgxRe2lPbUQxYMROncsderZ++yr3A3IgmThY1Zg9w33ww3KIHvYA47Ax
         Ewj3rVxdIp5oIaU/s0OwmS4QSZI4No1Qji1SJniI9+/M+fTAzsjz7k9L90YVtHavmy
         h6tL8svAYD42lVf5Yzh6IpeNyoRSleAvjYuyr1vunsSuBXFbQ8L3CvSAUDitas3Shy
         Io0ksqQ7Ab/zMkuG9pTpJF0H8LGJP/pAf61Np5a+FoxGBF1T9ggezbEsFhpn4aDWFF
         YEVeOGDhJBqWQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Max Kellermann <max.kellermann@ionos.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: rely on SB_I_NOUMASK
Date:   Thu, 12 Oct 2023 17:36:57 +0200
Message-Id: <20231012-einband-uferpromenade-80541a047a1f@brauner>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1784; i=brauner@kernel.org; h=from:subject:message-id; bh=VdKe3s1fGXG9JaYxeHT3MfM7VreN1ibOkkvZF094eg0=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaRqCAUuTNV+dajxUfL3a/1x7krrEvOkNf/bmqceCufpz1Z1 VYrqKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMhFM0aGIznJzVv1q81NJx6yVl8w3T XpuKXMKf9E1k36KsmKjttrGBnOWm6RSGOJutnh+8fUVrMoZLVm0tqfE8zsv6XkPb26lIcZAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In commit f61b9bb3f838 ("fs: add a new SB_I_NOUMASK flag") we added a
new SB_I_NOUMASK flag that is used by filesystems like NFS to indicate
that umask stripping is never supposed to be done in the vfs independent
of whether or not POSIX ACLs are supported.

Overlayfs falls into the same category as it raises SB_POSIXACL
unconditionally to defer umask application to the upper filesystem.

Now that we have SB_I_NOUMASK use that and make SB_POSIXACL properly
conditional on whether or not the kernel does have support for it. This
will enable use to turn IS_POSIXACL() into nop on kernels that don't
have POSIX ACL support avoding bugs from missed umask stripping.

Signed-off-by: Christian Brauner <brauner@kernel.org>
---
Hey Amir & Miklos,

This depends on the aforementioned patch in vfs.misc. So if you're fine
with this change I'd take this through vfs.misc.

Christian
---
 fs/overlayfs/super.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9f43f0d303ad..361189b676b0 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1489,8 +1489,16 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_xattr = ofs->config.userxattr ? ovl_user_xattr_handlers :
 		ovl_trusted_xattr_handlers;
 	sb->s_fs_info = ofs;
+#ifdef CONFIG_FS_POSIX_ACL
 	sb->s_flags |= SB_POSIXACL;
+#endif
 	sb->s_iflags |= SB_I_SKIP_SYNC | SB_I_IMA_UNVERIFIABLE_SIGNATURE;
+	/*
+	 * Ensure that umask handling is done by the filesystems used
+	 * for the the upper layer instead of overlayfs as that would
+	 * lead to unexpected results.
+	 */
+	sb->s_iflags |= SB_I_NOUMASK;
 
 	err = -ENOMEM;
 	root_dentry = ovl_get_root(sb, ctx->upper.dentry, oe);
-- 
2.34.1

