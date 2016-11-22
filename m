From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: show non default redirect_dir mount option
Date: Tue, 22 Nov 2016 11:47:09 +0200
Message-ID: <1479808029-16934-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:34899 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932352AbcKVJrf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Nov 2016 04:47:35 -0500
Received: by mail-wj0-f193.google.com with SMTP id f8so5857844wje.2
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Nov 2016 01:47:34 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When redirect_dir option is turned off or on by mount
option to override the module default param value,
show the value of redirect_dir in /proc/mounts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 2aa2da4..82c54ca 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -228,6 +228,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	}
 	if (ufs->config.default_permissions)
 		seq_puts(m, ",default_permissions");
+	if (ufs->config.redirect_dir != ovl_redirect_dir_default)
+		seq_printf(m, ",redirect_dir=%s",
+			   ufs->config.redirect_dir ? "on" : "off");
 	return 0;
 }
 
-- 
2.7.4
