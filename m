From: Linzhe Lee <slayercat.subscription@gmail.com>
Subject: [PATCH] New module param allow_userns for allow unprivileged to mount
 under userns.
Date: Tue, 5 Jan 2016 14:58:59 +0800
Message-ID: <CAK_yBkOge-Sb64WHuu_wXn+jSHsCAp6LpK_cyw3LsO+cKbWTOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yk0-f170.google.com ([209.85.160.170]:35107 "EHLO
	mail-yk0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbcAEG7A (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 5 Jan 2016 01:59:00 -0500
Received: by mail-yk0-f170.google.com with SMTP id x67so272417377ykd.2
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Jan 2016 22:59:00 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

From: =?UTF-8?q?=E6=9D=8E=E6=9E=97=E5=93=B2?= <lilinzhe@ijinshan.com>
Date: Wed, 6 Jan 2016 15:03:58 +0800
Subject: [PATCH] New module param allow_userns for allow unprivileged to mount
 under userns.

Signed-off-by: Li LinZhe <lilinzhe@ijinshan.com>
---
 fs/overlayfs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e38ee0f..35c79af 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1102,8 +1102,13 @@ static struct file_system_type ovl_fs_type = {
 };
 MODULE_ALIAS_FS("overlay");

+static bool ovl_userns;
+MODULE_PARM_DESC(allow_userns, "allow unprivileged to mount under userns");
+module_param_named(allow_userns, ovl_userns, bool, S_IRUGO);
+
 static int __init ovl_init(void)
 {
+    ovl_fs_type.fs_flags |= ovl_userns ? FS_USERNS_MOUNT : 0;
        return register_filesystem(&ovl_fs_type);
 }
