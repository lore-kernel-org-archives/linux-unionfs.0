Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184D9C433F5
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Feb 2022 03:01:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244059AbiBKDA7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 10 Feb 2022 22:00:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234830AbiBKDA7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Feb 2022 22:00:59 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E6055A2
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Feb 2022 19:00:58 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=hongnan.li@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0V46pH9w_1644548455;
Received: from localhost(mailfrom:hongnan.li@linux.alibaba.com fp:SMTPD_---0V46pH9w_1644548455)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 11 Feb 2022 11:00:56 +0800
From:   Hongnan Li <hongnan.li@linux.alibaba.com>
To:     linux-unionfs@vger.kernel.org
Cc:     miklos@szeredi.hu
Subject: [PATCH] fs/overlayfs: fix comments mentioning i_mutex
Date:   Fri, 11 Feb 2022 11:00:55 +0800
Message-Id: <20220211030055.95334-1-hongnan.li@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: hongnanli <hongnan.li@linux.alibaba.com>

inode->i_mutex has been replaced with inode->i_rwsem long ago. Fix
comments still mentioning i_mutex.

Signed-off-by: hongnanli <hongnan.li@linux.alibaba.com>
---
 fs/overlayfs/copy_up.c | 4 ++--
 fs/overlayfs/dir.c     | 4 ++--
 fs/overlayfs/inode.c   | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index b193d08a3dc3..8f7d7f05e5fb 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -432,7 +432,7 @@ static int ovl_set_upper_fh(struct ovl_fs *ofs, struct dentry *upper,
 /*
  * Create and install index entry.
  *
- * Caller must hold i_mutex on indexdir.
+ * Caller must hold i_rwsem on indexdir.
  */
 static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 			    struct dentry *upper)
@@ -762,7 +762,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
  *
  * All renames start with copy up of source if necessary.  The actual
  * rename will only proceed once the copy up was successful.  Copy up uses
- * upper parent i_mutex for exclusion.  Since rename can change d_parent it
+ * upper parent i_rwsem for exclusion.  Since rename can change d_parent it
  * is possible that the copy up will lock the old parent.  At that point
  * the file will have already been copied up anyway.
  */
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f18490813170..c96dfbf5c9e0 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -61,7 +61,7 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
 	return temp;
 }
 
-/* caller holds i_mutex on workdir */
+/* caller holds i_rwsem on workdir */
 static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 {
 	int err;
@@ -105,7 +105,7 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 	return whiteout;
 }
 
-/* Caller must hold i_mutex on both workdir and dir */
+/* Caller must hold i_rwsem on both workdir and dir */
 int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct inode *dir,
 			     struct dentry *dentry)
 {
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1f36158c7dbe..25c6d2c9a9bd 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -670,7 +670,7 @@ static const struct address_space_operations ovl_aops = {
 /*
  * It is possible to stack overlayfs instance on top of another
  * overlayfs instance as lower layer. We need to annotate the
- * stackable i_mutex locks according to stack level of the super
+ * stackable i_rwsem locks according to stack level of the super
  * block instance. An overlayfs instance can never be in stack
  * depth 0 (there is always a real fs below it).  An overlayfs
  * inode lock will use the lockdep annotation ovl_i_mutex_key[depth].
-- 
2.19.1.6.gb485710b

