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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D5BC49361
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Jun 2021 09:26:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78E49610A7
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Jun 2021 09:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233152AbhFSJ2k (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 19 Jun 2021 05:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbhFSJ2k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 19 Jun 2021 05:28:40 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83575C061574
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Jun 2021 02:26:28 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id j2so2989444wrs.12
        for <linux-unionfs@vger.kernel.org>; Sat, 19 Jun 2021 02:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3HuQKSUcsPX5W4pdrFkfflImcsEeETGI6M4nkXbKrk0=;
        b=fA6sfcuvCLINNHiXJrRrQgzH5PHJSwmhzIScznhHZ4SohIPnB/6I66XApmYc6uKpNY
         CcDjWrzv/WeJzMl5tqdNWMrKiKomoKmrw6grquNjZAfIX99aSZitQ2c5qTW1Bw6XFmXe
         53nScehlhFZYYsRctkFDcuEScSNBAUJ8EYQtFTACT3Jd4H2MyPjD8pegZaSAZlWQhMVd
         cfmmRxmgsgpdLm5fBuoGHNgCdgKdPG+Y+bp3/xvEqjBCqKV5g6se0GClM/QO/IdiX6uv
         Ghfa8Lvk4LcuRs/HazLWcNXGBHXM5+WJLd8wgIKWv3AQH0ukuAgouXe3nCuO9ogIQHmn
         PQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3HuQKSUcsPX5W4pdrFkfflImcsEeETGI6M4nkXbKrk0=;
        b=B+T1YfWPISS0RcwqtrzSZnI/zAp0y6rBdRb1LkC5buPhHfGs+z54NtApZXkfbXKF8i
         SOB9ocD7I2Y02YKtKxQKiIxic93g/uP+aDesO8zpfeq58BzxlLKM1JVGqCAtdQVlYhk9
         2O3y7sKFCeJ05BmNSFQwgQtKWIkoZ0CRDqbBCGOanIMrgxl3GywA/eUKvfpZriqteWxj
         D4cJPXSdF2cl3+VVZsL0XVTF+rW+qLVtSKR8roD4mZxgrYX0KMckFG0kNRedpgITLrPr
         AYRgNbUGEFjeycpfgh9LM7K6X04/Dg7f6ho/uEnPy4gIbQQYJ2Gaimj4eODY3piR/BbC
         J68w==
X-Gm-Message-State: AOAM53117zg/rf+0sRygQYamoPwRuVTxFQf84Jar2ngMCw9IOZnbRss6
        xDuNW/KSuu1c5Pxkn9l21p4=
X-Google-Smtp-Source: ABdhPJyt1nxwUyhBt0iIoaDWOQmUxn9nGkxxZA25y5CikG1d0l2YNsg3KhCRSarg8XgPAVcn/JQmcg==
X-Received: by 2002:adf:c18a:: with SMTP id x10mr16860738wre.193.1624094787060;
        Sat, 19 Jun 2021 02:26:27 -0700 (PDT)
Received: from localhost.localdomain ([141.226.245.169])
        by smtp.gmail.com with ESMTPSA id 2sm10904445wrz.87.2021.06.19.02.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Jun 2021 02:26:26 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH v3 4/4] ovl: consistent behavior for immutable/append-only inodes
Date:   Sat, 19 Jun 2021 12:26:19 +0300
Message-Id: <20210619092619.1107608-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210619092619.1107608-1-amir73il@gmail.com>
References: <20210619092619.1107608-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When a lower file has immutable/append-only fileattr flags, the behavior
of overlayfs post copy up is inconsistent.

Immediattely after copy up, ovl inode still has the S_IMMUTABLE/S_APPEND
inode flags copied from lower inode, so vfs code still treats the ovl
inode as immutable/append-only.  After ovl inode evict or mount cycle,
the ovl inode does not have these inode flags anymore.

We cannot copy up the immutable and append-only fileattr flags, because
immutable/append-only inodes cannot be linked and because overlayfs will
not be able to set overlay.* xattr on the upper inodes.

Instead, if any of the fileattr flags of interest exist on the lower
inode, we store them in overlay.protected xattr on the upper inode and we
we read the flags from xattr on lookup and on fileattr_get().

This gives consistent behavior post copy up regardless of inode eviction
from cache.

When user sets new fileattr flags, we update or remove the
overlay.protected xattr.

Storing immutable/append-only fileattr flags in an xattr instead of upper
fileattr also solves other non-standard behavior issues - overlayfs can
now copy up children of "ovl-immutable" directories and lower aliases of
"ovl-immutable" hardlinks.

Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Link: https://lore.kernel.org/linux-unionfs/20201226104618.239739-1-cgxu519@mykernel.net/
Link: https://lore.kernel.org/linux-unionfs/20210210190334.1212210-5-amir73il@gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  17 +++++-
 fs/overlayfs/inode.c     |  42 +++++++++++++-
 fs/overlayfs/overlayfs.h |  28 +++++++++-
 fs/overlayfs/util.c      | 115 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 195 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a06b423ca5d1..fc9ffcf32d0c 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -131,7 +131,8 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 	return error;
 }
 
-static int ovl_copy_fileattr(struct path *old, struct path *new)
+static int ovl_copy_fileattr(struct inode *inode, struct path *old,
+			     struct path *new)
 {
 	struct fileattr oldfa = { .flags_valid = true };
 	struct fileattr newfa = { .flags_valid = true };
@@ -145,6 +146,18 @@ static int ovl_copy_fileattr(struct path *old, struct path *new)
 	if (err)
 		return err;
 
+	/*
+	 * We cannot set immutable and append-only flags on upper inode,
+	 * because we would not be able to link upper inode to upper dir
+	 * not set overlay private xattr on upper inode.
+	 * Store these flags in overlay.protected xattr instead.
+	 */
+	if (oldfa.flags & OVL_PROT_FS_FLAGS_MASK) {
+		err = ovl_set_protected(inode, new->dentry, &oldfa);
+		if (err)
+			return err;
+	}
+
 	BUILD_BUG_ON(OVL_COPY_FS_FLAGS_MASK & ~FS_COMMON_FL);
 	newfa.flags &= ~OVL_COPY_FS_FLAGS_MASK;
 	newfa.flags |= (oldfa.flags & OVL_COPY_FS_FLAGS_MASK);
@@ -550,7 +563,7 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 		 * Copy the fileattr inode flags that are the source of already
 		 * copied i_flags (best effort).
 		 */
-		ovl_copy_fileattr(&c->lowerpath, &upperpath);
+		ovl_copy_fileattr(inode, &c->lowerpath, &upperpath);
 	}
 
 	/*
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index aec353a2dc80..9c621ed17a61 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -162,7 +162,8 @@ int ovl_getattr(struct user_namespace *mnt_userns, const struct path *path,
 	enum ovl_path_type type;
 	struct path realpath;
 	const struct cred *old_cred;
-	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
+	struct inode *inode = d_inode(dentry);
+	bool is_dir = S_ISDIR(inode->i_mode);
 	int fsid = 0;
 	int err;
 	bool metacopy_blocks = false;
@@ -175,6 +176,10 @@ int ovl_getattr(struct user_namespace *mnt_userns, const struct path *path,
 	if (err)
 		goto out;
 
+	/* Report the effective immutable/append-only STATX flags */
+	if (ovl_test_flag(OVL_PROTECTED, inode))
+		generic_fill_statx_attr(inode, stat);
+
 	/*
 	 * For non-dir or same fs, we use st_ino of the copy up origin.
 	 * This guaranties constant st_dev/st_ino across copy up.
@@ -556,15 +561,40 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 		ovl_path_real(dentry, &upperpath);
 
 		old_cred = ovl_override_creds(inode->i_sb);
-		err = ovl_real_fileattr(&upperpath, fa, true);
+		/*
+		 * Store immutable/append-only flags in xattr and clear them
+		 * in upper fileattr (in case they were set by older kernel)
+		 * so children of "ovl-immutable" directories lower aliases of
+		 * "ovl-immutable" hardlinks could be copied up.
+		 * Clear xattr when flags are cleared.
+		 */
+		err = ovl_set_protected(inode, upperpath.dentry, fa);
+		if (!err)
+			err = ovl_real_fileattr(&upperpath, fa, true);
 		revert_creds(old_cred);
-		ovl_copyflags(ovl_inode_real(inode), inode);
+		ovl_merge_prot_flags(ovl_inode_real(inode), inode);
 	}
 	ovl_drop_write(dentry);
 out:
 	return err;
 }
 
+/* Convert inode protection flags to fileattr flags */
+static void ovl_fileattr_prot_flags(struct inode *inode, struct fileattr *fa)
+{
+	BUILD_BUG_ON(OVL_PROT_FS_FLAGS_MASK & ~FS_COMMON_FL);
+	BUILD_BUG_ON(OVL_PROT_FSX_FLAGS_MASK & ~FS_XFLAG_COMMON);
+
+	if (inode->i_flags & S_APPEND) {
+		fa->flags |= FS_APPEND_FL;
+		fa->fsx_xflags |= FS_XFLAG_APPEND;
+	}
+	if (inode->i_flags & S_IMMUTABLE) {
+		fa->flags |= FS_IMMUTABLE_FL;
+		fa->fsx_xflags |= FS_XFLAG_IMMUTABLE;
+	}
+}
+
 int ovl_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
@@ -576,6 +606,8 @@ int ovl_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 
 	old_cred = ovl_override_creds(inode->i_sb);
 	err = ovl_real_fileattr(&realpath, fa, false);
+	if (!err && ovl_test_flag(OVL_PROTECTED, inode))
+		ovl_fileattr_prot_flags(inode, fa);
 	revert_creds(old_cred);
 
 	return err;
@@ -1128,6 +1160,10 @@ struct inode *ovl_get_inode(struct super_block *sb,
 		}
 	}
 
+	/* Check for immutable/append-only inode flags in xattr */
+	if (upperdentry)
+		ovl_check_protected(inode, upperdentry);
+
 	if (inode->i_state & I_NEW)
 		unlock_new_inode(inode);
 out:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1e964e4e45d4..840b6e1a71ea 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -34,6 +34,7 @@ enum ovl_xattr {
 	OVL_XATTR_NLINK,
 	OVL_XATTR_UPPER,
 	OVL_XATTR_METACOPY,
+	OVL_XATTR_PROTECTED,
 };
 
 enum ovl_inode_flag {
@@ -45,6 +46,8 @@ enum ovl_inode_flag {
 	OVL_UPPERDATA,
 	/* Inode number will remain constant over copy up. */
 	OVL_CONST_INO,
+	/* Has overlay.protected xattr */
+	OVL_PROTECTED,
 };
 
 enum ovl_entry_flag {
@@ -532,14 +535,22 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 
 /* vfs inode flags copied from real to ovl inode */
 #define OVL_COPY_I_FLAGS_MASK	(S_SYNC | S_NOATIME | S_APPEND | S_IMMUTABLE)
+/* vfs inode flags read from overlay.protected xattr to ovl inode */
+#define OVL_PROT_I_FLAGS_MASK	(S_APPEND | S_IMMUTABLE)
 
 /*
  * fileattr flags copied from lower to upper inode on copy up.
- * We cannot copy immutable/append-only flags, because that would prevevnt
- * linking temp inode to upper dir.
+ * We cannot copy up immutable/append-only flags, because that would prevevnt
+ * linking temp inode to upper dir, so we store them in xattr instead.
  */
 #define OVL_COPY_FS_FLAGS_MASK	(FS_SYNC_FL | FS_NOATIME_FL)
 #define OVL_COPY_FSX_FLAGS_MASK	(FS_XFLAG_SYNC | FS_XFLAG_NOATIME)
+#define OVL_PROT_FS_FLAGS_MASK  (FS_APPEND_FL | FS_IMMUTABLE_FL)
+#define OVL_PROT_FSX_FLAGS_MASK (FS_XFLAG_APPEND | FS_XFLAG_IMMUTABLE)
+
+bool ovl_check_protected(struct inode *inode, struct dentry *upper);
+int ovl_set_protected(struct inode *inode, struct dentry *upper,
+		      struct fileattr *fa);
 
 static inline void ovl_copyflags(struct inode *from, struct inode *to)
 {
@@ -548,6 +559,19 @@ static inline void ovl_copyflags(struct inode *from, struct inode *to)
 	inode_set_flags(to, from->i_flags & mask, mask);
 }
 
+/* Merge real inode flags with inode flags read from overlay.protected xattr */
+static inline void ovl_merge_prot_flags(struct inode *real, struct inode *inode)
+{
+	unsigned int flags = real->i_flags & OVL_COPY_I_FLAGS_MASK;
+
+	BUILD_BUG_ON(OVL_PROT_I_FLAGS_MASK & ~OVL_COPY_I_FLAGS_MASK);
+
+	if (ovl_test_flag(OVL_PROTECTED, inode))
+		flags |= inode->i_flags & OVL_PROT_I_FLAGS_MASK;
+
+	inode_set_flags(inode, flags, OVL_COPY_I_FLAGS_MASK);
+}
+
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
 int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct inode *dir,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 81b8f135445a..202377ca2ee9 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -10,6 +10,7 @@
 #include <linux/cred.h>
 #include <linux/xattr.h>
 #include <linux/exportfs.h>
+#include <linux/fileattr.h>
 #include <linux/uuid.h>
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
@@ -585,6 +586,7 @@ bool ovl_check_dir_xattr(struct super_block *sb, struct dentry *dentry,
 #define OVL_XATTR_NLINK_POSTFIX		"nlink"
 #define OVL_XATTR_UPPER_POSTFIX		"upper"
 #define OVL_XATTR_METACOPY_POSTFIX	"metacopy"
+#define OVL_XATTR_PROTECTED_POSTFIX	"protected"
 
 #define OVL_XATTR_TAB_ENTRY(x) \
 	[x] = { [false] = OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
@@ -598,6 +600,7 @@ const char *const ovl_xattr_table[][2] = {
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_NLINK),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_UPPER),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
+	OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTECTED),
 };
 
 int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
@@ -639,6 +642,118 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 	return err;
 }
 
+
+/*
+ * Initialize inode flags from overlay.protected xattr and upper inode flags.
+ * If upper inode has those fileattr flags set (i.e. from old kernel), we do not
+ * clear them on ovl_get_inode(), but we will clear them on next fileattr_set().
+ */
+static bool ovl_prot_flags_from_buf(struct inode *inode, const char *buf,
+				    int len)
+{
+	u32 iflags = inode->i_flags & OVL_PROT_I_FLAGS_MASK;
+	int n;
+
+	/*
+	 * We cannot clear flags that are set on real inode.
+	 * We can only set flags that are not set in inode.
+	 */
+	for (n = 0; n < len && buf[n]; n++) {
+		if (buf[n] == 'a')
+			iflags |= S_APPEND;
+		else if (buf[n] == 'i')
+			iflags |= S_IMMUTABLE;
+		else
+			break;
+	}
+
+	inode_set_flags(inode, iflags, OVL_PROT_I_FLAGS_MASK);
+
+	return buf[n] == 0;
+}
+
+#define OVL_PROTECTED_MAX 32 /* Reserved for future flags */
+
+bool ovl_check_protected(struct inode *inode, struct dentry *upper)
+{
+	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
+	char buf[OVL_PROTECTED_MAX+1];
+	int res;
+
+	res = ovl_do_getxattr(ofs, upper, OVL_XATTR_PROTECTED, buf,
+			      OVL_PROTECTED_MAX);
+	if (res < 0)
+		return false;
+
+	buf[res] = 0;
+	if (res == 0 || !ovl_prot_flags_from_buf(inode, buf, res)) {
+		pr_warn_ratelimited("incompatible overlay.protected format (%pd2, len=%d)\n",
+				    upper, res);
+	}
+
+	ovl_set_flag(OVL_PROTECTED, inode);
+	ovl_merge_prot_flags(d_inode(upper), inode);
+
+	return true;
+}
+
+/* Set inode flags and overlay.protected xattr from fileattr */
+static int ovl_prot_flags_to_buf(struct inode *inode, char *buf,
+				 const struct fileattr *fa)
+{
+	u32 iflags = 0;
+	int n = 0;
+
+	if (fa->flags & FS_APPEND_FL) {
+		buf[n++] = 'a';
+		iflags |= S_APPEND;
+	}
+	if (fa->flags & FS_IMMUTABLE_FL) {
+		buf[n++] = 'i';
+		iflags |= S_IMMUTABLE;
+	}
+
+	inode_set_flags(inode, iflags, OVL_PROT_I_FLAGS_MASK);
+
+	return n;
+}
+
+int ovl_set_protected(struct inode *inode, struct dentry *upper,
+		      struct fileattr *fa)
+{
+	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
+	char buf[OVL_PROTECTED_MAX];
+	int len, err = 0;
+
+	BUILD_BUG_ON(HWEIGHT32(OVL_PROT_FS_FLAGS_MASK) > OVL_PROTECTED_MAX);
+	len = ovl_prot_flags_to_buf(inode, buf, fa);
+
+	/*
+	 * Do not allow to set protection flags when upper doesn't support
+	 * xattrs, because we do not set those fileattr flags on upper inode.
+	 * Remove xattr if it exist and all protection flags are cleared.
+	 */
+	if (len) {
+		err = ovl_check_setxattr(ofs, upper, OVL_XATTR_PROTECTED,
+					 buf, len, -EPERM);
+	} else if (ovl_test_flag(OVL_PROTECTED, inode)) {
+		err = ovl_do_removexattr(ofs, upper, OVL_XATTR_PROTECTED);
+	}
+	if (err)
+		return err;
+
+	/* Mask out the fileattr flags that should not be set in upper inode */
+	fa->flags &= ~OVL_PROT_FS_FLAGS_MASK;
+	fa->fsx_xflags &= ~OVL_PROT_FSX_FLAGS_MASK;
+
+	if (len)
+		ovl_set_flag(OVL_PROTECTED, inode);
+	else
+		ovl_clear_flag(OVL_PROTECTED, inode);
+
+	return 0;
+}
+
 /**
  * Caller must hold a reference to inode to prevent it from being freed while
  * it is marked inuse.
-- 
2.32.0

