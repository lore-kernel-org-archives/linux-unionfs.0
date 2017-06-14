From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 21/23] ovl: link up indexed lower hardlink on lookup
Date: Wed, 14 Jun 2017 10:26:40 +0300
Message-ID: <1497425202-16270-22-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33039 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754431AbdFNH1B (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:27:01 -0400
Received: by mail-wr0-f194.google.com with SMTP id v104so36665293wrb.0
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:27:00 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

With inodes index feature, all lower and upper hardlinks point to
the same overlay inode. However, when a lower hardlink is accessed
for read operation, the real inode operated on is not the same inode
as the real inode for read operation on an upper hardlink.

When lookup finds a lower hardlink, which is already indexed by
an earlier upper hardlink copy up, call ovl_copy_up() to link the
indexed upper on top of the lower hardlink and then operate on the
upper real inode to avoid this inconsistency.

Invalidate a lower indexed dentry on dcache lookup, so ovl_lookup()
is called to perform the index link up.

The following test demonstrates the upper/lower hardlinks inconsistency:

$ echo -n a > /lower/foo
$ ln /lower/foo /lower/bar
$ cd /mnt
$ echo -n b >> foo
$ tail foo bar # foo is indexed upper, bar is indexed lower
==> foo <==
ab
==> bar <==
a

$ echo -n c >> bar
$ tail foo bar # both aliases are indexed upper
==> foo <==
abc
==> bar <==
abc

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 11 ++++++++++-
 fs/overlayfs/super.c | 32 +++++++++++++++++++++++++++-----
 2 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 193177883dc7..2f4c02355060 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -654,13 +654,22 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	oe->redirect = upperredirect;
 	oe->__upperdentry = upperdentry;
 	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
-	dput(index);
 	kfree(stack);
 	kfree(d.redirect);
 	dentry->d_fsdata = oe;
 	ovl_update_type(dentry, d.is_dir);
 	d_add(dentry, inode);
 
+	/* Link up indexed lower early for consistent overlay hardlinks */
+	if (OVL_TYPE_INDEX(type) && !upperdentry) {
+		err = ovl_copy_up(dentry);
+		if (err) {
+			pr_warn_ratelimited("overlayfs: failed link up to index (%pd2, index=%pd2, err=%i)\n",
+					    dentry, index, err);
+		}
+	}
+	dput(index);
+
 	return NULL;
 
 out_free_oe:
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0f36a09df34c..82b036ee9e52 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -117,6 +117,33 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	return dentry;
 }
 
+static int ovl_dentry_indexed_revalidate(struct dentry *dentry,
+					 unsigned int flags)
+{
+	enum ovl_path_type type = ovl_path_type(dentry);
+	bool is_upper;
+
+	if (d_is_dir(dentry) || d_is_negative(dentry))
+		return 1;
+
+	/*
+	 * Invalidate lower hardlink after it has been indexed by copy up
+	 * of another lower alias. ovl_lookup will trigger copy up of this
+	 * path and link the upper path to the upper index inode.
+	 */
+	ovl_inode_real(d_inode(dentry), &is_upper);
+	if (is_upper && !OVL_TYPE_UPPER(type))
+		return 0;
+
+	return 1;
+}
+
+static const struct dentry_operations ovl_dentry_operations = {
+	.d_release = ovl_dentry_release,
+	.d_real = ovl_d_real,
+	.d_revalidate = ovl_dentry_indexed_revalidate,
+};
+
 static int ovl_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -158,11 +185,6 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
 	return ret;
 }
 
-static const struct dentry_operations ovl_dentry_operations = {
-	.d_release = ovl_dentry_release,
-	.d_real = ovl_d_real,
-};
-
 static const struct dentry_operations ovl_reval_dentry_operations = {
 	.d_release = ovl_dentry_release,
 	.d_real = ovl_d_real,
-- 
2.7.4
