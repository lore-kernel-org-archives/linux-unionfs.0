Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561D6C47096
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Jun 2021 14:48:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 346CC61408
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Jun 2021 14:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbhFFOtt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 10:49:49 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:46952 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbhFFOts (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 6 Jun 2021 10:49:48 -0400
Received: by mail-wm1-f44.google.com with SMTP id h22-20020a05600c3516b02901a826f84095so3453773wmq.5
        for <linux-unionfs@vger.kernel.org>; Sun, 06 Jun 2021 07:47:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vUdBDWykd/3Q/i3sTAO4UfGh/0f1q7OgdiXr3ALiP7w=;
        b=BHRfhzRhYfk9A9ANURVqC1oecq4sIRdYMBD2wx6w7qPXP0W3JOwV8rrK+AcjSr81NB
         YdGI7d5cXzQUV/ngnaCq3Te/L5eB9QUAdOkaZmVwyjSjiQBOiB8DbbDsTCPfPqsAYlhD
         B9i046uCszyow+idcse4p6dK+rQnosC8kQwnhYx+X9q0u8CN+YTEVKt9xC72d4aUHsB2
         2E9f7OumVKwnZm9fzjbBar3a5z5v/SNtQC8pBvmo0GI7lmrUsUtYDBY25DkYcMYWuU0F
         9gBVtH91jpjlFLk7sbLVPy96U3Kpmoi2SZb6b6r2fz68vF0qjhYEdcMHGc1oO1gGmnaU
         3yow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vUdBDWykd/3Q/i3sTAO4UfGh/0f1q7OgdiXr3ALiP7w=;
        b=GxRCoxSvPKBv4k9pZ+g9bZe00qL/aBtik+VwfeG/dVcGHwyynI2Llmm8PNqsi48f1Y
         ZZVw3Ti2XQUG+XqV6D+8cav9VcBuP967O9+R6QCRymljMDog9H6qC27w/R4iV7qWyDf3
         b3fTGdhZvHJI5WMA9eHyaWpZ9EU4tf4ax/8qlEVUzOElq907K+zdWH8dhxjEdVA33OF2
         EO4I77bLrezt8O5lUP1UCbt+IJWGp8xtvlYIxmUVzfJ2/GaX7sZu0KtWHbKzTuMvtSmJ
         MZnx0LJH2peMvzI0bUxEOdI9udSNUAmgHnJNoYNrXfgsLVAJrBSySOmr9UqsmBWQpUiS
         NuuA==
X-Gm-Message-State: AOAM531I+TwWgX4xqXP7uWTQApTtBF66ytFBo4tMyW+gawkB6MoRPF9e
        H+UmPbGNR+vlTwmwcIuZFVM=
X-Google-Smtp-Source: ABdhPJwZviJ1lbDX3zYpJLEo+QvaECOgeVa5nTeG8RbksNeyNSFQud6TC5KERZLReix1OmQORqnHpQ==
X-Received: by 2002:a7b:c761:: with SMTP id x1mr13049470wmk.118.1622990804634;
        Sun, 06 Jun 2021 07:46:44 -0700 (PDT)
Received: from localhost.localdomain ([185.240.143.244])
        by smtp.gmail.com with ESMTPSA id r18sm13028621wro.62.2021.06.06.07.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 07:46:44 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: consistent behavior for immutable/append-only inodes
Date:   Sun,  6 Jun 2021 17:46:41 +0300
Message-Id: <20210606144641.419138-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When a lower file has immutable/append-only attributes, the behavior of
overlayfs post copy up is inconsistent.

Immediattely after copy up, ovl inode still has the S_IMMUTABLE/S_APPEND
inode flags copied from lower inode, so vfs code still treats the ovl
inode as immutable/append-only.  After ovl inode evict or mount cycle,
the ovl inode does not have these inode flags anymore.

We cannot copy up the immutable and append-only fileattr flags, because
immutable/append-only inodes cannot be linked and because overlayfs will
not be able to set overlay.* xattr on the upper inodes.

Instead, if any of the fileattr flags of interest exist on the lower
inode, we set an xattr overlay.xflags on the upper inode as an indication
to merge the origin inode fileattr flags on lookup.

This gives consistent behavior post copy up regardless of inode eviction
from cache.

When user sets new fileattr flags, we break the connection with the
origin fileattr by removing the overlay.xflags xattr.

Note that having the S_IMMUTABLE/S_APPEND on the ovl inode does not
provide the same level of protection as setting those flags on the real
upper inode, because some filesystem check those flags internally in
addition or instead of the vfs checks (e.g. btrfs_may_delete()), but
that is the way it has always been for overlayfs.

As can be seen in the comment above ovl_check_origin_xflags(), the
"xflags merge" feature is designed to solve other non-standard behavior
issues related to immutable directories and hardlinks in the future, but
this commit does not bother to fix those cases because those are corner
cases that are probably not so important to fix.

A word about the design decision to merge the origin and upper xflags -
Because we do not copy up fileattr and because fileattr_set breaks the
link to origin xflags, the only cases where origin and upper inodes both
have xflags is if upper inode was modified not via overlayfs or if the
system crashed during ovl_fileattr_set() before removing the
overlay.xflags xattr.  In both cases, modifiying the upper inode is not
going to be permitted, so it is better to reflect this in the overlay
inode flags.

Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Link: https://lore.kernel.org/linux-unionfs/20201226104618.239739-1-cgxu519@mykernel.net/
Link: https://lore.kernel.org/linux-unionfs/20210210190334.1212210-5-amir73il@gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

This is the minial and most sane patch I could come up with to fix
xfstest overlay/075 failure.

Note that there is currently a test bug in overlay/075 in upstream
xfstests. I have already posted a fix for the test bug [1].
I also have an improvement to the test to cover the case of breaking
connection to origin xflags on fileattr_set. I will post it later.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/20210605094326.352107-1-amir73il@gmail.com/

 fs/overlayfs/copy_up.c   | 20 ++++++++-
 fs/overlayfs/inode.c     | 91 +++++++++++++++++++++++++++++++---------
 fs/overlayfs/overlayfs.h | 20 ++++++++-
 fs/overlayfs/util.c      | 39 +++++++++++++++++
 4 files changed, 148 insertions(+), 22 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 2846b943e80c..6115773ad56a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -526,9 +526,27 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	 * hard link.
 	 */
 	if (c->origin) {
-		err = ovl_set_origin(ofs, c->dentry, c->lowerpath.dentry, temp);
+		struct dentry *origin = c->lowerpath.dentry;
+
+		err = ovl_set_origin(ofs, c->dentry, origin, temp);
 		if (err)
 			return err;
+		/*
+		 * We cannot copy up immutable and append-only flags, because
+		 * immutable/append-only inodes cannot be linked and cannot set
+		 * xattr on those inodes.  After copy up, ovl inode still has
+		 * those inode flags copied from lower inode, so vfs code still
+		 * treats the ovl inode as immutable/append-only.
+		 * Set this xattr as indication to copy the origin inode flags
+		 * on lookup in order to be consistent with post copy up state.
+		 */
+		if (origin->d_inode->i_flags & OVL_I_FLAGS_MASK) {
+			err = ovl_check_setxattr(c->dentry, temp,
+						 OVL_XATTR_XFLAGS,
+						 NULL, 0, 0);
+			if (err)
+				return err;
+		}
 	}
 
 	if (c->metacopy) {
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5e828a1c98a8..f97cad498faa 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -503,16 +503,14 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
  * Introducing security_inode_fileattr_get/set() hooks would solve this issue
  * properly.
  */
-static int ovl_security_fileattr(struct dentry *dentry, struct fileattr *fa,
-				 bool set)
+static int ovl_security_fileattr(const struct path *realpath,
+				 struct fileattr *fa, bool set)
 {
-	struct path realpath;
 	struct file *file;
 	unsigned int cmd;
 	int err;
 
-	ovl_path_real(dentry, &realpath);
-	file = dentry_open(&realpath, O_RDONLY, current_cred());
+	file = dentry_open(realpath, O_RDONLY, current_cred());
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
@@ -527,11 +525,26 @@ static int ovl_security_fileattr(struct dentry *dentry, struct fileattr *fa,
 	return err;
 }
 
+static int ovl_real_fileattr(const struct path *realpath,
+			     struct fileattr *fa, bool set)
+{
+	int err;
+
+	err = ovl_security_fileattr(realpath, fa, set);
+	if (err)
+		return err;
+
+	if (set)
+		return vfs_fileattr_set(&init_user_ns, realpath->dentry, fa);
+	else
+		return vfs_fileattr_get(realpath->dentry, fa);
+}
+
 int ovl_fileattr_set(struct user_namespace *mnt_userns,
 		     struct dentry *dentry, struct fileattr *fa)
 {
 	struct inode *inode = d_inode(dentry);
-	struct dentry *upperdentry;
+	struct path upperpath;
 	const struct cred *old_cred;
 	int err;
 
@@ -541,12 +554,13 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 
 	err = ovl_copy_up(dentry);
 	if (!err) {
-		upperdentry = ovl_dentry_upper(dentry);
-
+		ovl_path_real(dentry, &upperpath);
 		old_cred = ovl_override_creds(inode->i_sb);
-		err = ovl_security_fileattr(dentry, fa, true);
-		if (!err)
-			err = vfs_fileattr_set(&init_user_ns, upperdentry, fa);
+		err = ovl_real_fileattr(&upperpath, fa, true);
+		if (!err) {
+			/* No merge of origin fileattr flags from now on */
+			ovl_remove_origin_xflags(dentry);
+		}
 		revert_creds(old_cred);
 		ovl_copyflags(ovl_inode_real(inode), inode);
 	}
@@ -555,17 +569,50 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 	return err;
 }
 
+int ovl_merge_origin_xflags(struct dentry *dentry, struct fileattr *fa)
+{
+	struct fileattr realfa = {
+		.flags_valid = fa->flags_valid,
+		.fsx_valid = fa->fsx_valid,
+	};
+	struct path realpath;
+	u32 flags;
+	int err;
+
+	ovl_path_lower(dentry, &realpath);
+	err = ovl_real_fileattr(&realpath, &realfa, false);
+	if (err)
+		return err;
+
+	if (!realfa.flags && !realfa.fsx_xflags) {
+		/* No use to merge zero origin flags */
+		ovl_remove_origin_xflags(dentry);
+		return 0;
+	}
+
+	flags = (fa->flags | realfa.flags) & OVL_FS_FLAGS_MASK;
+	set_mask_bits(&fa->flags, OVL_FS_FLAGS_MASK, flags);
+	flags = (fa->fsx_xflags | realfa.fsx_xflags) & OVL_FS_XFLAGS_MASK;
+	set_mask_bits(&fa->fsx_xflags, OVL_FS_XFLAGS_MASK, flags);
+
+	return 0;
+}
+
 int ovl_fileattr_get(struct dentry *dentry, struct fileattr *fa)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct inode *inode = d_inode(dentry);
-	struct dentry *realdentry = ovl_dentry_real(dentry);
+	struct path realpath;
+	enum ovl_path_type type = ovl_path_real(dentry, &realpath);
 	const struct cred *old_cred;
 	int err;
 
 	old_cred = ovl_override_creds(inode->i_sb);
-	err = ovl_security_fileattr(dentry, fa, false);
-	if (!err)
-		err = vfs_fileattr_get(realdentry, fa);
+	err = ovl_real_fileattr(&realpath, fa, false);
+	if (!err && OVL_TYPE_ORIGIN(type) &&
+	    ovl_check_origin_xflags(ofs, realpath.dentry)) {
+		err = ovl_merge_origin_xflags(dentry, fa);
+	}
 	revert_creds(old_cred);
 
 	return err;
@@ -1037,9 +1084,11 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	struct ovl_fs *ofs = OVL_FS(sb);
 	struct dentry *upperdentry = oip->upperdentry;
 	struct ovl_path *lowerpath = oip->lowerpath;
-	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
+	struct inode *lowerinode = lowerdentry ? d_inode(lowerdentry) : NULL;
+	struct inode *realinode = upperdentry ? d_inode(upperdentry) :
+						lowerinode;
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
 					oip->index);
 	int fsid = bylower ? lowerpath->layer->fsid : 0;
@@ -1047,9 +1096,6 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	unsigned long ino = 0;
 	int err = oip->newinode ? -EEXIST : -ENOMEM;
 
-	if (!realinode)
-		realinode = d_inode(lowerdentry);
-
 	/*
 	 * Copy up origin (lower) may exist for non-indexed upper, but we must
 	 * not use lower as hash key if this is a broken hardlink.
@@ -1118,6 +1164,13 @@ struct inode *ovl_get_inode(struct super_block *sb,
 		}
 	}
 
+	/* Check if need to merge fileattr flags from origin */
+	if (upperdentry && bylower &&
+	    (lowerinode->i_flags & OVL_I_FLAGS_MASK) &&
+	    ovl_check_origin_xflags(ofs, upperdentry)) {
+		ovl_mergeflags(lowerinode, inode);
+	}
+
 	if (inode->i_state & I_NEW)
 		unlock_new_inode(inode);
 out:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 29d71f253db4..aef70bb7a47b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -34,6 +34,7 @@ enum ovl_xattr {
 	OVL_XATTR_NLINK,
 	OVL_XATTR_UPPER,
 	OVL_XATTR_METACOPY,
+	OVL_XATTR_XFLAGS,
 };
 
 enum ovl_inode_flag {
@@ -330,6 +331,8 @@ int ovl_copy_up_start(struct dentry *dentry, int flags);
 void ovl_copy_up_end(struct dentry *dentry);
 bool ovl_already_copied_up(struct dentry *dentry, int flags);
 bool ovl_check_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry);
+bool ovl_check_origin_xflags(struct ovl_fs *ofs, struct dentry *upperdentry);
+void ovl_remove_origin_xflags(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct super_block *sb, struct dentry *dentry,
 			 enum ovl_xattr ox);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
@@ -530,11 +533,24 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 	i_size_write(to, i_size_read(from));
 }
 
+#define OVL_I_FLAGS_MASK (S_SYNC | S_IMMUTABLE | S_APPEND | S_NOATIME)
+#define OVL_FS_FLAGS_MASK (FS_SYNC_FL | FS_IMMUTABLE_FL | \
+			   FS_APPEND_FL | FS_NOATIME_FL)
+#define OVL_FS_XFLAGS_MASK (FS_XFLAG_SYNC | FS_XFLAG_IMMUTABLE | \
+			    FS_XFLAG_APPEND | FS_XFLAG_NOATIME)
+
 static inline void ovl_copyflags(struct inode *from, struct inode *to)
 {
-	unsigned int mask = S_SYNC | S_IMMUTABLE | S_APPEND | S_NOATIME;
+	unsigned int flags = from->i_flags & OVL_I_FLAGS_MASK;
+
+	inode_set_flags(to, flags, OVL_I_FLAGS_MASK);
+}
+
+static inline void ovl_mergeflags(struct inode *from, struct inode *to)
+{
+	unsigned int flags = (from->i_flags | to->i_flags) & OVL_I_FLAGS_MASK;
 
-	inode_set_flags(to, from->i_flags & mask, mask);
+	inode_set_flags(to, flags, OVL_I_FLAGS_MASK);
 }
 
 /* dir.c */
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index b9d03627f364..5c08383d9f9f 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -562,6 +562,43 @@ bool ovl_check_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry)
 	return false;
 }
 
+/*
+ * By design, overlay inode fileattr can be in one of three states depending
+ * on the value of xattr overlay.xflags on upper inode:
+ *
+ * 1) No xattr (or no upper) - ovl fileattr are copied from real inode
+ * 2) Empty xattr - ovl fileattr are a merge of fileattr of upper inode and
+ *    some fileattr flags from lower inode
+ * 3) Non-empty xattr - ovl fileattr are a merge of real inode fileattr and
+ *    some fileattr flags read from xattr
+ *
+ * Option 3 is meant to allow setting immutable flag on overlay merged
+ * directories without preventing copy up of children and to allow setting
+ * append-only flag on overlay copied up hardlinks without preventing copy up
+ * of their lower aliases.
+ *
+ * Option 3 is not implemented at this time.
+ */
+bool ovl_check_origin_xflags(struct ovl_fs *ofs, struct dentry *upperdentry)
+{
+	int res;
+
+	res = ovl_do_getxattr(ofs, upperdentry, OVL_XATTR_XFLAGS, NULL, 0);
+	if (res > 0) {
+		pr_warn_ratelimited("incompatible overlay.xflags format (%pd2, len=%d) ignored\n",
+				    upperdentry, res);
+	}
+
+	return res == 0;
+}
+
+void ovl_remove_origin_xflags(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
+
+	ovl_do_removexattr(ofs, ovl_dentry_upper(dentry), OVL_XATTR_XFLAGS);
+}
+
 bool ovl_check_dir_xattr(struct super_block *sb, struct dentry *dentry,
 			 enum ovl_xattr ox)
 {
@@ -585,6 +622,7 @@ bool ovl_check_dir_xattr(struct super_block *sb, struct dentry *dentry,
 #define OVL_XATTR_NLINK_POSTFIX		"nlink"
 #define OVL_XATTR_UPPER_POSTFIX		"upper"
 #define OVL_XATTR_METACOPY_POSTFIX	"metacopy"
+#define OVL_XATTR_XFLAGS_POSTFIX	"xflags"
 
 #define OVL_XATTR_TAB_ENTRY(x) \
 	[x] = { [false] = OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
@@ -598,6 +636,7 @@ const char *const ovl_xattr_table[][2] = {
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_NLINK),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_UPPER),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
+	OVL_XATTR_TAB_ENTRY(OVL_XATTR_XFLAGS),
 };
 
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
-- 
2.31.1

