From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 05/10] ovl: suppress file handle support warnings on read-only mount
Date: Tue, 11 Jul 2017 15:58:38 +0300
Message-ID: <1499777923-29410-6-git-send-email-amir73il@gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35304 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755606AbdGKM6l (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 08:58:41 -0400
Received: by mail-wr0-f193.google.com with SMTP id z45so32273162wrb.2
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2017 05:58:40 -0700 (PDT)
In-Reply-To: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

An overlay mount with no upper layer (a.k.a ovl_force_readonly)
does not need an index, because there is no copy up, so there is
no reason to spew warnings about lower layer file handle support
for index=on.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c88493b01d8d..6381e71b0d5d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -922,6 +922,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	} else if (!ufs->config.upperdir && stacklen == 1) {
 		pr_err("overlayfs: at least 2 lowerdir are needed while upperdir nonexistent\n");
 		goto out_free_lowertmp;
+	} else if (!ufs->config.upperdir || !ufs->config.workdir) {
+		/* Read-only mount - skip file handle support checks */
+		ufs->config.index = false;
 	}
 
 	err = -ENOMEM;
-- 
2.7.4
