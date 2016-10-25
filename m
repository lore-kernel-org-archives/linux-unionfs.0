From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 2/3] vfs: export vfs_path_lookup()
Date: Tue, 25 Oct 2016 09:34:46 +0200
Message-ID: <1477380887-21333-3-git-send-email-mszeredi@redhat.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34734 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754711AbcJYHey (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Oct 2016 03:34:54 -0400
Received: by mail-wm0-f49.google.com with SMTP id d128so1161122wmf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Oct 2016 00:34:53 -0700 (PDT)
In-Reply-To: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Exported to modules, but currently residing in fs/internal.h due to commit
197df04c749a ("rename user_path_umountat() to user_path_mountpoint_at()").

Move back to <linux/namei.h> so that overlayfs can make use of it.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/internal.h         | 2 --
 include/linux/namei.h | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index f4da3341b4a3..800319d11291 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -53,8 +53,6 @@ extern void __init chrdev_init(void);
  * namei.c
  */
 extern int user_path_mountpoint_at(int, const char __user *, unsigned int, struct path *);
-extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
-			   const char *, unsigned int, struct path *);
 
 /*
  * namespace.c
diff --git a/include/linux/namei.h b/include/linux/namei.h
index f29abda31e6d..2375bc50a9d3 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -78,6 +78,8 @@ extern struct dentry *user_path_create(int, const char __user *, struct path *,
 extern void done_path_create(struct path *, struct dentry *);
 extern struct dentry *kern_path_locked(const char *, struct path *);
 extern int kern_path_mountpoint(int, const char *, struct path *, unsigned int);
+extern int vfs_path_lookup(struct dentry *, struct vfsmount *,
+			   const char *, unsigned int, struct path *);
 
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
 extern struct dentry *lookup_one_len_unlocked(const char *, struct dentry *, int);
-- 
2.5.5
