From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 2/8] vfs: export filp_clone_open()
Date: Thu,  1 Dec 2016 11:14:57 +0100
Message-ID: <1480587303-25088-3-git-send-email-mszeredi@redhat.com>
References: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f180.google.com ([209.85.210.180]:33877 "EHLO
        mail-wj0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755998AbcLAKPK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Dec 2016 05:15:10 -0500
Received: by mail-wj0-f180.google.com with SMTP id mp19so200441834wjc.1
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Dec 2016 02:15:09 -0800 (PST)
In-Reply-To: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

Already exported to modules, just needs to move declaration from
"fs/internal.h" to <linux/fs.h>.

This will be used by overlayfs to clone a read-only file that has been
copied up after being opened.  The clone will refer to the copied-up uppper
file instead of the original, lower file.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/internal.h      | 1 -
 include/linux/fs.h | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/internal.h b/fs/internal.h
index f4da3341b4a3..361ba1c12698 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -112,7 +112,6 @@ extern long do_handle_open(int mountdirfd,
 			   struct file_handle __user *ufh, int open_flag);
 extern int open_check_o_direct(struct file *f);
 extern int vfs_open(const struct path *, struct file *, const struct cred *);
-extern struct file *filp_clone_open(struct file *);
 
 /*
  * inode.c
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 87a32f999812..e3bc970214e1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2355,6 +2355,7 @@ extern struct file *filp_open(const char *, int, umode_t);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int, umode_t);
 extern struct file * dentry_open(const struct path *, int, const struct cred *);
+extern struct file *filp_clone_open(struct file *);
 extern int filp_close(struct file *, fl_owner_t id);
 
 extern struct filename *getname_flags(const char __user *, int, int *);
-- 
2.5.5
