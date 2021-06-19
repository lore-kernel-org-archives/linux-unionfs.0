Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E388CC49361
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Jun 2021 09:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA31B610A7
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Jun 2021 09:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbhFSJ2h (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 19 Jun 2021 05:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFSJ2h (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 19 Jun 2021 05:28:37 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E207FC061756
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Jun 2021 02:26:24 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id o3so13562515wri.8
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Jun 2021 02:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P2MeVQUTmzjV7T33p8gxWNbwIG6ihISzESSYNTTgWNs=;
        b=NYrZBhHVgC7uSFmFpOSAYof11TCL7GuGsBd+ihsJYoGNEFb1PFN9bUsUCeujvJGWEE
         Htf/Z5v3z4WYSv8QYUIp+U+mCrZeva3OoLRcQqPZgH3hMQUOyPCu1NCg1CaIagwVqv+N
         XSSe91kwF+3EBLrWl8ag/zKPnx0E3BQ2J1S3SGgC5U4nsIKXSU4jJKJ4p0ykXCqKrGx2
         uJ6Qdzvh78n0KN3PJTNNRXZx+KbvycBjcuN6zMf95z0ljy5aZEL0W0KQiklHsbdt+iRS
         6VAovUfHPMW5at0ZJ1GzrKqPssix42oWjolHFPYUn0fZMhSUNWyN6YZFKeQw68aywu8J
         2HhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P2MeVQUTmzjV7T33p8gxWNbwIG6ihISzESSYNTTgWNs=;
        b=t0l9BSgM/wGFYeFhSNMrFFyUtRXMBzeRKg8Cs0dIBzop3s60e4q+3AlZ6TRfYC7/nk
         UB5jVA0sxAiGpscU13XlIHG0U+uWsj2wqKNrKS//cMMySipWsS25qEOZag1tTkV3sdnE
         cQbcU7iHRl55Q+cdmPEtfZr0XzRBXOQWbuWsMXqp/+jq9GS0KXRfSEvwRZM02k1FTQQm
         GjMSHWGJcprIxbi8CAV7G7BwkrSCOH1/tsGJrGg5Mp3tzv+7huS4ol48MyHTxHhU+Dev
         xovJZYiDCeOvp9hf4pfL2NwpXGoCFjyaKboTmEn0G6ZREyDYPwpiydEQidRrUb9tgZs4
         MizQ==
X-Gm-Message-State: AOAM530fyYTcWkL8eRfTgEfIdEZSBSEW4GhMyWMPeAyR0GviEvIGlXyt
        qoS/T5+FPszOTzpBnZCW0c4=
X-Google-Smtp-Source: ABdhPJwyKc9IzU38GpSslr+eptoxSXh82pjU9E3KrRyQQEyHBtjMAh3nCECbglxyV9saJZGNLLsctw==
X-Received: by 2002:a5d:6acc:: with SMTP id u12mr16846672wrw.414.1624094783487;
        Sat, 19 Jun 2021 02:26:23 -0700 (PDT)
Received: from localhost.localdomain ([141.226.245.169])
        by smtp.gmail.com with ESMTPSA id 2sm10904445wrz.87.2021.06.19.02.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 02:26:22 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH v3 1/4] fs: add generic helper for filling statx attribute flags
Date:   Sat, 19 Jun 2021 12:26:16 +0300
Message-Id: <20210619092619.1107608-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619092619.1107608-1-amir73il@gmail.com>
References: <20210619092619.1107608-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The immutable and append-only properties on an inode are published on
the inode's i_flags and enforced by the VFS.

Create a helper to fill the corresponding STATX_ATTR_ flags in the kstat
structure from the inode's i_flags.

Only orange was converted to use this helper.
Other filesystems could use it in the future.

Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/orangefs/inode.c  |  7 +------
 fs/stat.c            | 18 ++++++++++++++++++
 include/linux/fs.h   |  1 +
 include/linux/stat.h |  4 ++++
 4 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 6bf35a0d61f3..4092009716a3 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -883,12 +883,7 @@ int orangefs_getattr(struct user_namespace *mnt_userns, const struct path *path,
 		if (!(request_mask & STATX_SIZE))
 			stat->result_mask &= ~STATX_SIZE;
 
-		stat->attributes_mask = STATX_ATTR_IMMUTABLE |
-		    STATX_ATTR_APPEND;
-		if (inode->i_flags & S_IMMUTABLE)
-			stat->attributes |= STATX_ATTR_IMMUTABLE;
-		if (inode->i_flags & S_APPEND)
-			stat->attributes |= STATX_ATTR_APPEND;
+		generic_fill_statx_attr(inode, stat);
 	}
 	return ret;
 }
diff --git a/fs/stat.c b/fs/stat.c
index 1fa38bdec1a6..314269150b5b 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -59,6 +59,24 @@ void generic_fillattr(struct user_namespace *mnt_userns, struct inode *inode,
 }
 EXPORT_SYMBOL(generic_fillattr);
 
+/**
+ * generic_fill_statx_attr - Fill in the statx attributes from the inode flags
+ * @inode:	Inode to use as the source
+ * @stat:	Where to fill in the attribute flags
+ *
+ * Fill in the STATX_ATTR_ flags in the kstat structure for properties of the
+ * inode that are published on i_flags and enforced by the VFS.
+ */
+void generic_fill_statx_attr(struct inode *inode, struct kstat *stat)
+{
+	if (inode->i_flags & S_IMMUTABLE)
+		stat->attributes |= STATX_ATTR_IMMUTABLE;
+	if (inode->i_flags & S_APPEND)
+		stat->attributes |= STATX_ATTR_APPEND;
+	stat->attributes_mask |= KSTAT_ATTR_VFS_FLAGS;
+}
+EXPORT_SYMBOL(generic_fill_statx_attr);
+
 /**
  * vfs_getattr_nosec - getattr without security checks
  * @path: file to get attributes from
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c3c88fdb9b2a..647664316013 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3353,6 +3353,7 @@ extern int page_symlink(struct inode *inode, const char *symname, int len);
 extern const struct inode_operations page_symlink_inode_operations;
 extern void kfree_link(void *);
 void generic_fillattr(struct user_namespace *, struct inode *, struct kstat *);
+void generic_fill_statx_attr(struct inode *inode, struct kstat *stat);
 extern int vfs_getattr_nosec(const struct path *, struct kstat *, u32, unsigned int);
 extern int vfs_getattr(const struct path *, struct kstat *, u32, unsigned int);
 void __inode_add_bytes(struct inode *inode, loff_t bytes);
diff --git a/include/linux/stat.h b/include/linux/stat.h
index fff27e603814..7df06931f25d 100644
--- a/include/linux/stat.h
+++ b/include/linux/stat.h
@@ -34,6 +34,10 @@ struct kstat {
 	 STATX_ATTR_ENCRYPTED |				\
 	 STATX_ATTR_VERITY				\
 	 )/* Attrs corresponding to FS_*_FL flags */
+#define KSTAT_ATTR_VFS_FLAGS				\
+	(STATX_ATTR_IMMUTABLE |				\
+	 STATX_ATTR_APPEND				\
+	 ) /* Attrs corresponding to S_* flags that are enforced by the VFS */
 	u64		ino;
 	dev_t		dev;
 	dev_t		rdev;
-- 
2.32.0

