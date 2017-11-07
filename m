From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 1/9] ovl: move include of ovl_entry.h into overlayfs.h
Date: Tue,  7 Nov 2017 18:58:01 +0200
Message-ID: <1510073889-11657-2-git-send-email-amir73il@gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:49449 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753192AbdKGQ5d (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:57:33 -0500
Received: by mail-wm0-f67.google.com with SMTP id b189so5101616wmd.4
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 08:57:32 -0800 (PST)
In-Reply-To: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

Most overlayfs c files already explicitly include ovl_entry.h
to use overlay entry struct definitions and upcoming changes
are going to require even more c files to include this header.

All overlayfs c files include overlayfs.h and overlayfs.h itself
refers to some structs defined in ovl_entry.h, so it seems more
logic to include ovl_entry.h from overlayfs.h than from c files.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 1 -
 fs/overlayfs/inode.c     | 1 -
 fs/overlayfs/namei.c     | 1 -
 fs/overlayfs/overlayfs.h | 1 +
 fs/overlayfs/super.c     | 1 -
 fs/overlayfs/util.c      | 1 -
 6 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index c441f9387a1b..9311d183b532 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -22,7 +22,6 @@
 #include <linux/ratelimit.h>
 #include <linux/exportfs.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 2949448d0c7d..b772e5a2a730 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -14,7 +14,6 @@
 #include <linux/posix_acl.h>
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a12dc10bf726..505a4b8902fc 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -15,7 +15,6 @@
 #include <linux/mount.h>
 #include <linux/exportfs.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 struct ovl_lookup_data {
 	struct qstr name;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d53157ccf0d7..1cf3bdd193a4 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/uuid.h>
+#include "ovl_entry.h"
 
 enum ovl_path_type {
 	__OVL_PATH_UPPER	= (1 << 0),
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f5738e96a052..8702803ba328 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -18,7 +18,6 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Overlay filesystem");
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 51ca8bd16009..9158d17bb320 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -17,7 +17,6 @@
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 int ovl_want_write(struct dentry *dentry)
 {
-- 
2.7.4
