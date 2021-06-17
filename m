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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF523C49EA3
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Jun 2021 15:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 973ED61159
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Jun 2021 15:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233288AbhFQPZB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 11:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233297AbhFQPY7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Jun 2021 11:24:59 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09CBEC0617AE
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Jun 2021 08:22:52 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id f16-20020a05600c1550b02901b00c1be4abso6662234wmg.2
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Jun 2021 08:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gmFrKdmjHc/Xr32FBSknjRP3jroT8XvjVBSyOpt649M=;
        b=i68SKkjp0yPPO8D74IR/7+Q5abqeZHFawXYTfQvIeckDCP+w7xqPyLqzQL8Ixwc+0S
         xGObn+Xtdra6cl9ZPEpWUQDAGTim+7ZE1MWfcNVytt1QCCA7cA8xKkRWNJMCETZfAh3F
         ntGMe9EK0xvCsb6iBShcnwhSkvPCSgred9L63sjvp2gq3FRX0PbxNovzfZjoch2L47BS
         yjr7b076ZZYEui0HjMp35/1ZzXKXqConH3pwrswyCapZ7klTUD/5WaqB6P8O8pLF5aiN
         ONgkycRebbcwJKtB2gaCDHUQLGLh/jjoAFzLSwnSNueJW+U2KgXbJ5JOBhct3J+P69Je
         xjOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gmFrKdmjHc/Xr32FBSknjRP3jroT8XvjVBSyOpt649M=;
        b=kQXRYiA/nr7BBZr8vYciaaKfWK6DAQ/bPuRzruAu1Go/Y3JZEiDGxWBdhPnSaAjwUH
         fwX/jv3/Taq5r231O4FDhJd0WA+qQnXxm1rIBHaxt1ES/CKTygwdmQ37PyuvmxtHiwTu
         oeqsOvIAfa6Xm6uKquP8DTBQ4VYzXoBFbuDo5fPD0IMftQtITdictOasGK3q2TX40yTk
         rVBKbjiZj/A/fq5ZAxWMC2xBQOYXU7IUOlaWW+1upfTVbGI/ux5PFWRf8/CPzLivqTqO
         2VMM1yyhs2Xi3Io8gt6Q96BYmnj5RaIc1s/Ze7ww2z80cnPAE0DL+4isWbymRN+EHdaz
         ao2A==
X-Gm-Message-State: AOAM532NPuI4790tXueXbAPihgnzSXftkBk7p4p52MXxeiPwVBHwMPmE
        zKNMd8hvnlfNXbywQiS5nVo=
X-Google-Smtp-Source: ABdhPJzZE8bYgCi1fT2HUNtWdevRH6zOdZAv4rEo44+sD0y2sSzveXrvJqVEk6h3jo5q7l7/ryWxAw==
X-Received: by 2002:a1c:1d07:: with SMTP id d7mr5809529wmd.42.1623943370559;
        Thu, 17 Jun 2021 08:22:50 -0700 (PDT)
Received: from localhost.localdomain ([141.226.242.176])
        by smtp.gmail.com with ESMTPSA id o7sm5835910wro.76.2021.06.17.08.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 08:22:49 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 3/3] ovl: consistent behavior for immutable/append-only inodes
Date:   Thu, 17 Jun 2021 18:22:41 +0300
Message-Id: <20210617152241.987010-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210617152241.987010-1-amir73il@gmail.com>
References: <20210617152241.987010-1-amir73il@gmail.com>
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
inode, we store them in overlay.xflags xattr on the upper inode and we
we read the flags from xattr on lookup and on fileattr_get().

This gives consistent behavior post copy up regardless of inode eviction
from cache.

When user sets new fileattr flags, we update or remove the overlay.xflags
xattr.

Storing immutable/append-only fileattr flags in an xattr instead of upper
fileattr also solves other non-standard behavior issues - overlayfs can
now copy up children of "ovl-immutable" directories and lower aliases of
"ovl-immutable" hardlinks.

Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Link: https://lore.kernel.org/linux-unionfs/20201226104618.239739-1-cgxu519@mykernel.net/
Link: https://lore.kernel.org/linux-unionfs/20210210190334.1212210-5-amir73il@gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  17 +++-
 fs/overlayfs/inode.c     |  26 +++++-
 fs/overlayfs/overlayfs.h |  28 ++++++-
 fs/overlayfs/util.c      | 171 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 235 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e1d91cdf4c3f..6cc8b5de4121 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -131,7 +131,8 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 	return error;
 }
 
-static int ovl_copy_xflags(struct path *old, struct path *new)
+static int ovl_copy_xflags(struct inode *inode, struct path *old,
+			   struct path *new)
 {
 	struct fileattr oldfa = { .flags_valid = true };
 	struct fileattr newfa = { .flags_valid = true };
@@ -145,6 +146,18 @@ static int ovl_copy_xflags(struct path *old, struct path *new)
 	if (err)
 		return err;
 
+	/*
+	 * We cannot set immutable and append-only flags on upper inode,
+	 * because we would not be able to link upper inode to upper dir
+	 * not set overlay private xattr on upper inode.
+	 * Store these flags in xflags xattr instead.
+	 */
+	if (oldfa.flags & OVL_XFLAGS_FS_FLAGS_MASK) {
+		err = ovl_set_xflags(inode, new->dentry, &oldfa);
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
-		ovl_copy_xflags(&c->lowerpath, &upperpath);
+		ovl_copy_xflags(inode, &c->lowerpath, &upperpath);
 	}
 
 	/*
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index aec353a2dc80..d66e51b9c347 100644
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
 
+	/* Report immutable/append-only STATX flags */
+	if (ovl_test_flag(OVL_XFLAGS, inode))
+		ovl_fill_xflags(inode, stat, NULL);
+
 	/*
 	 * For non-dir or same fs, we use st_ino of the copy up origin.
 	 * This guaranties constant st_dev/st_ino across copy up.
@@ -556,9 +561,18 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 		ovl_path_real(dentry, &upperpath);
 
 		old_cred = ovl_override_creds(inode->i_sb);
-		err = ovl_real_fileattr(&upperpath, fa, true);
+		/*
+		 * Store immutable/append-only flags in xattr and clear them
+		 * in upper fileattr (in case they were set by older kernel)
+		 * so children of "ovl-immutable" directories lower aliases of
+		 * "ovl-immutable" hardlinks could be copied up.
+		 * Clear xflags xattr when flags are cleared.
+		 */
+		err = ovl_set_xflags(inode, upperpath.dentry, fa);
+		if (!err)
+			err = ovl_real_fileattr(&upperpath, fa, true);
 		revert_creds(old_cred);
-		ovl_copyflags(ovl_inode_real(inode), inode);
+		ovl_merge_xflags(ovl_inode_real(inode), inode);
 	}
 	ovl_drop_write(dentry);
 out:
@@ -576,6 +590,8 @@ int ovl_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 
 	old_cred = ovl_override_creds(inode->i_sb);
 	err = ovl_real_fileattr(&realpath, fa, false);
+	if (!err && ovl_test_flag(OVL_XFLAGS, inode))
+		ovl_fill_xflags(inode, NULL, fa);
 	revert_creds(old_cred);
 
 	return err;
@@ -1128,6 +1144,10 @@ struct inode *ovl_get_inode(struct super_block *sb,
 		}
 	}
 
+	/* Check if need to merge inode flags from xattr */
+	if (upperdentry)
+		ovl_check_xflags(inode, upperdentry);
+
 	if (inode->i_state & I_NEW)
 		unlock_new_inode(inode);
 out:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1e964e4e45d4..ba3cb1bed3b8 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -34,6 +34,7 @@ enum ovl_xattr {
 	OVL_XATTR_NLINK,
 	OVL_XATTR_UPPER,
 	OVL_XATTR_METACOPY,
+	OVL_XATTR_XFLAGS,
 };
 
 enum ovl_inode_flag {
@@ -45,6 +46,8 @@ enum ovl_inode_flag {
 	OVL_UPPERDATA,
 	/* Inode number will remain constant over copy up. */
 	OVL_CONST_INO,
+	/* Has xflags xattr */
+	OVL_XFLAGS,
 };
 
 enum ovl_entry_flag {
@@ -532,14 +535,24 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 
 /* vfs inode flags copied from real to ovl inode */
 #define OVL_COPY_I_FLAGS_MASK	(S_SYNC | S_NOATIME | S_APPEND | S_IMMUTABLE)
+/* vfs inode flags read from xflags xattr to ovl inode */
+#define OVL_XFLAGS_I_FLAGS_MASK	(S_APPEND | S_IMMUTABLE)
 
 /*
  * fileattr flags copied from lower to upper inode on copy up.
- * We cannot copy immutable/append-only flags, because that would prevevnt
- * linking temp inode to upper dir.
+ * We cannot copy up immutable/append-only flags, because that would prevevnt
+ * linking temp inode to upper dir, so we store them in xattr instead.
  */
 #define OVL_COPY_FS_FLAGS_MASK	(FS_SYNC_FL | FS_NOATIME_FL)
 #define OVL_COPY_FSX_FLAGS_MASK	(FS_XFLAG_SYNC | FS_XFLAG_NOATIME)
+#define OVL_XFLAGS_FS_FLAGS_MASK  (FS_APPEND_FL | FS_IMMUTABLE_FL)
+#define OVL_XFLAGS_FSX_FLAGS_MASK (FS_XFLAG_APPEND | FS_XFLAG_IMMUTABLE)
+
+bool ovl_check_xflags(struct inode *inode, struct dentry *upper);
+int ovl_set_xflags(struct inode *inode, struct dentry *upper,
+		   struct fileattr *fa);
+void ovl_fill_xflags(struct inode *inode, struct kstat *stat,
+		     struct fileattr *fa);
 
 static inline void ovl_copyflags(struct inode *from, struct inode *to)
 {
@@ -548,6 +561,17 @@ static inline void ovl_copyflags(struct inode *from, struct inode *to)
 	inode_set_flags(to, from->i_flags & mask, mask);
 }
 
+/* Merge real inode flags with inode flags read from xflags xattr */
+static inline void ovl_merge_xflags(struct inode *real, struct inode *inode)
+{
+	unsigned int flags = real->i_flags & OVL_COPY_I_FLAGS_MASK;
+
+	if (ovl_test_flag(OVL_XFLAGS, inode))
+		flags |= inode->i_flags & OVL_XFLAGS_I_FLAGS_MASK;
+
+	inode_set_flags(inode, flags, OVL_COPY_I_FLAGS_MASK);
+}
+
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
 int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct inode *dir,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 81b8f135445a..34c1d08f00a0 100644
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
+#define OVL_XATTR_XFLAGS_POSTFIX	"xflags"
 
 #define OVL_XATTR_TAB_ENTRY(x) \
 	[x] = { [false] = OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
@@ -598,6 +600,7 @@ const char *const ovl_xattr_table[][2] = {
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_NLINK),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_UPPER),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
+	OVL_XATTR_TAB_ENTRY(OVL_XATTR_XFLAGS),
 };
 
 int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
@@ -639,6 +642,174 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 	return err;
 }
 
+
+/*
+ * Overlayfs stores immutable/append-only attributes in overlay.xflags xattr.
+ * If upper inode does have those fileattr flags set (i.e. from old kernel),
+ * overlayfs does not clear them on fileattr_get(), but it will clear them on
+ * fileattr_set().
+ */
+#define OVL_XFLAG(c, x) \
+	{ c, S_ ## x, FS_ ## x ## _FL, FS_XFLAG_ ## x, STATX_ATTR_ ## x }
+
+struct ovl_xflag {
+	char code;
+	u32 i_flag;
+	u32 fs_flag;
+	u32 fsx_flag;
+	u64 statx_attr;
+} const ovl_xflags[] = {
+	OVL_XFLAG('a', APPEND),
+	OVL_XFLAG('i', IMMUTABLE),
+};
+
+#define OVL_XFLAGS_NUM ARRAY_SIZE(ovl_xflags)
+#define OVL_XFLAGS_MAX 32 /* Reserved for future xflags */
+
+static const struct ovl_xflag *ovl_xflag(char code)
+{
+	const struct ovl_xflag *xflag = ovl_xflags;
+	int i;
+
+	for (i = 0; i < OVL_XFLAGS_NUM; i++, xflag++) {
+		if (xflag->code == code)
+			return xflag;
+	}
+
+	return NULL;
+}
+
+static int ovl_xflags_to_buf(struct inode *inode, char *buf, int len,
+			     const struct fileattr *fa)
+{
+	const struct ovl_xflag *xflag = ovl_xflags;
+	u32 iflags = 0;
+	int i, n = 0;
+
+	for (i = 0; i < OVL_XFLAGS_NUM; i++, xflag++) {
+		if (fa->flags & xflag->fs_flag) {
+			buf[n++] = xflag->code;
+			iflags |= xflag->i_flag;
+		}
+	}
+
+	inode_set_flags(inode, iflags, OVL_XFLAGS_I_FLAGS_MASK);
+
+	return n;
+}
+
+static bool ovl_xflags_from_buf(struct inode *inode, const char *buf, int len)
+{
+	const struct ovl_xflag *xflag = ovl_xflags;
+	u32 iflags = inode->i_flags & OVL_XFLAGS_I_FLAGS_MASK;
+	int n;
+
+	/*
+	 * We cannot clear flags that are set on real inode.
+	 * We can only set flags that are not set in inode.
+	 */
+	for (n = 0; n < len && buf[n]; n++) {
+		xflag = ovl_xflag(buf[n]);
+		if (!xflag)
+			break;
+
+		iflags |= xflag->i_flag;
+	}
+
+	inode_set_flags(inode, iflags, OVL_XFLAGS_I_FLAGS_MASK);
+
+	return buf[n] == 0;
+}
+
+/* Initialize inode flags from xflags xattr and upper inode flags */
+bool ovl_check_xflags(struct inode *inode, struct dentry *upper)
+{
+	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
+	char buf[OVL_XFLAGS_MAX+1];
+	int res;
+
+	res = ovl_do_getxattr(ofs, upper, OVL_XATTR_XFLAGS, buf,
+			      OVL_XFLAGS_MAX);
+	if (res < 0)
+		return false;
+
+	buf[res] = 0;
+	if (res == 0 || !ovl_xflags_from_buf(inode, buf, res)) {
+		pr_warn_ratelimited("incompatible overlay.xflags format (%pd2, len=%d)\n",
+				    upper, res);
+	}
+
+	ovl_set_flag(OVL_XFLAGS, inode);
+	ovl_merge_xflags(d_inode(upper), inode);
+
+	return true;
+}
+
+/* Set inode flags and xflags xattr from fileattr */
+int ovl_set_xflags(struct inode *inode, struct dentry *upper,
+		   struct fileattr *fa)
+{
+	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
+	char buf[OVL_XFLAGS_NUM];
+	int len, err = 0;
+
+	BUILD_BUG_ON(OVL_XFLAGS_NUM >= OVL_XFLAGS_MAX);
+	len = ovl_xflags_to_buf(inode, buf, OVL_XFLAGS_NUM, fa);
+
+	/*
+	 * Do not fail when upper doesn't support xattrs, but also do not
+	 * mask out the xattr xflags from real fileattr to continue
+	 * supporting fileattr_set() on fs without xattr support.
+	 * Remove xattr if it exist and all flags are cleared.
+	 */
+	if (len) {
+		err = ovl_check_setxattr(ofs, upper, OVL_XATTR_XFLAGS,
+					 buf, len, 0);
+	} else if (ovl_test_flag(OVL_XFLAGS, inode)) {
+		err = ovl_do_removexattr(ofs, upper, OVL_XATTR_XFLAGS);
+	}
+	if (err || ofs->noxattr)
+		return err;
+
+	/* Mask out the fileattr flags that should not be set in upper inode */
+	fa->flags &= ~OVL_XFLAGS_FS_FLAGS_MASK;
+	fa->fsx_xflags &= ~OVL_XFLAGS_FSX_FLAGS_MASK;
+
+	if (len)
+		ovl_set_flag(OVL_XFLAGS, inode);
+	else
+		ovl_clear_flag(OVL_XFLAGS, inode);
+
+	return 0;
+}
+
+/* Convert inode flags to visible fileattr/statx flags */
+void ovl_fill_xflags(struct inode *inode, struct kstat *stat,
+		     struct fileattr *fa)
+{
+	const struct ovl_xflag *xflag = ovl_xflags;
+	int i;
+
+	BUILD_BUG_ON(OVL_XFLAGS_FS_FLAGS_MASK & ~FS_COMMON_FL);
+	BUILD_BUG_ON(OVL_XFLAGS_FSX_FLAGS_MASK & ~FS_XFLAG_COMMON);
+
+	for (i = 0; i < OVL_XFLAGS_NUM; i++, xflag++) {
+		if (stat)
+			stat->attributes_mask |= xflag->statx_attr;
+
+		if (!(inode->i_flags & xflag->i_flag))
+			continue;
+
+		if (stat)
+			stat->attributes |= xflag->statx_attr;
+
+		if (fa) {
+			fa->flags |= xflag->fs_flag;
+			fa->fsx_xflags |= xflag->fsx_flag;
+		}
+	}
+}
+
 /**
  * Caller must hold a reference to inode to prevent it from being freed while
  * it is marked inuse.
-- 
2.32.0

