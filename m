From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 4/5] vfs: add helper lookup_one_len_noperm()
Date: Thu,  1 Jun 2017 12:02:58 +0300
Message-ID: <1496307779-2766-5-git-send-email-amir73il@gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36434 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751195AbdFAJCy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:02:54 -0400
Received: by mail-wm0-f67.google.com with SMTP id k15so9569093wmh.3
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Jun 2017 02:02:53 -0700 (PDT)
In-Reply-To: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org

This is a variant of lookup_one_len() that does not check task
permissions.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/namei.c            | 29 +++++++++++++++++++++++++++++
 include/linux/namei.h |  1 +
 2 files changed, 30 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 263caf0efafe..837da8bfb36f 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2511,6 +2511,35 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 EXPORT_SYMBOL(lookup_one_len);
 
 /**
+ * lookup_one_len_noperm - filesystem helper to lookup single pathname component
+ * @name:	pathname component to lookup
+ * @base:	base directory to lookup from
+ * @len:	maximum length @len should be interpreted to
+ *
+ * Note that this routine is purely a helper for filesystem usage and should
+ * not be called by generic code.
+ *
+ * Unlike lookup_one_len, it does not check the task permissions.
+ *
+ * The caller must hold base->i_mutex.
+ */
+struct dentry *lookup_one_len_noperm(const char *name, struct dentry *base,
+				     int len)
+{
+	struct qstr this;
+	int err;
+
+	WARN_ON_ONCE(!inode_is_locked(base->d_inode));
+
+	err = lookup_one_len_init(&this, base, name, len);
+	if (err)
+		return ERR_PTR(err);
+
+	return __lookup_hash(&this, base, 0);
+}
+EXPORT_SYMBOL(lookup_one_len);
+
+/**
  * lookup_one_len_unlocked - filesystem helper to lookup single pathname component
  * @name:	pathname component to lookup
  * @base:	base directory to lookup from
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 8b4794e83196..afafd38f3680 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -81,6 +81,7 @@ extern struct dentry *kern_path_locked(const char *, struct path *);
 extern int kern_path_mountpoint(int, const char *, struct path *, unsigned int);
 
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
+extern struct dentry *lookup_one_len_noperm(const char *, struct dentry *, int);
 extern struct dentry *lookup_one_len_unlocked(const char *, struct dentry *, int);
 
 extern int follow_down_one(struct path *);
-- 
2.7.4
