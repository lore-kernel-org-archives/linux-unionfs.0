From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ovl: fix link error without POSIX ACL
Date: Thu, 14 Jul 2016 11:54:58 +0200
Message-ID: <20160714095512.768359-1-arnd@arndb.de>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.24]:52115 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbcGNJzY (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 14 Jul 2016 05:55:24 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

The latest fix for ACL on overlayfs introduced a link error:

fs/built-in.o: In function `ovl_posix_acl_xattr_set':
file.c:(.text+0x6b320): undefined reference to `posix_acl_from_xattr'

posix_acl_from_xattr doesn't have a 'static inline' implementation when
CONFIG_FS_POSIX_ACL is disabled, and I could not come up with an obvious
way to do it.

This instead avoids the link error by defining two sets of ACL operations
and letting the compiler drop one of the two at compile time depending
on CONFIG_FS_POSIX_ACL. This avoids all references to the ACL code,
also leading to smaller code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: f9bc66ad93b8 ("ovl: fix POSIX ACL setting")
---
 fs/overlayfs/super.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 17f17885a530..9709f32d13d3 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1056,6 +1056,12 @@ static const struct xattr_handler *ovl_xattr_handlers[] = {
 	NULL
 };
 
+static const struct xattr_handler *ovl_xattr_noacl_handlers[] = {
+	&ovl_own_xattr_handler,
+	&ovl_other_xattr_handler,
+	NULL,
+};
+
 static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct path upperpath = { NULL, NULL };
@@ -1268,7 +1274,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
 	sb->s_op = &ovl_super_operations;
-	sb->s_xattr = ovl_xattr_handlers;
+	if (IS_ENABLED(CONFIG_FS_POSIX_ACL))
+		sb->s_xattr = ovl_xattr_handlers;
+	else
+		sb->s_xattr = ovl_xattr_noacl_handlers;
 	sb->s_root = root_dentry;
 	sb->s_fs_info = ufs;
 	sb->s_flags |= MS_POSIXACL;
-- 
2.9.0
