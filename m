Return-Path: <SRS0=Pu7X=DG=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80845C4727F
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Sep 2020 07:47:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 525912076B
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Sep 2020 07:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727521AbgI2Hrj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Sep 2020 03:47:39 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16796 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725535AbgI2Hri (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Sep 2020 03:47:38 -0400
X-IronPort-AV: E=Sophos;i="5.77,317,1596470400"; 
   d="scan'208";a="99706516"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 29 Sep 2020 15:47:32 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id C06AF48990F6;
        Tue, 29 Sep 2020 15:47:28 +0800 (CST)
Received: from G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Tue, 29 Sep 2020 15:47:25 +0800
Received: from Fedora-31.g08.fujitsu.local (10.167.220.31) by
 G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Tue, 29 Sep 2020 15:47:25 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <linux-unionfs@vger.kernel.org>
CC:     <miklos@szeredi.hu>, <amir73il@gmail.com>, <hch@infradead.org>,
        <darrick.wong@oracle.com>, <fstests@vger.kernel.org>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH v2 2/2] ovl: use generic vfs_ioc_setflags_prepare() helper
Date:   Tue, 29 Sep 2020 15:28:48 +0800
Message-ID: <20200929072848.853877-2-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929072848.853877-1-yangx.jy@cn.fujitsu.com>
References: <20200929072848.853877-1-yangx.jy@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: C06AF48990F6.ABAE1
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Canonalize to ioctl FS_* flags instead of inode S_* flags.

Note that we do not call the helper vfs_ioc_fssetxattr_check()
for FS_IOC_FSSETXATTR ioctl. The reason is that underlying filesystem
will perform all the checks. We only need to perform the capability
check before overriding credentials.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
Reviewed-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---

V1->v2:
1) Rebase on top of the following branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-nex

 fs/overlayfs/file.c | 62 ++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 90b9aaebdf57..7f82c9fc9d9a 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -559,12 +559,28 @@ static long ovl_real_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
+static unsigned int ovl_iflags_to_fsflags(unsigned int iflags)
+{
+	unsigned int flags = 0;
+
+	if (iflags & S_SYNC)
+		flags |= FS_SYNC_FL;
+	if (iflags & S_APPEND)
+		flags |= FS_APPEND_FL;
+	if (iflags & S_IMMUTABLE)
+		flags |= FS_IMMUTABLE_FL;
+	if (iflags & S_NOATIME)
+		flags |= FS_NOATIME_FL;
+
+	return flags;
+}
+
 static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
-				unsigned long arg, unsigned int iflags)
+				unsigned long arg, unsigned int flags)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
-	unsigned int old_iflags;
+	unsigned int oldflags;
 
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
@@ -576,10 +592,9 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
 	inode_lock(inode);
 
 	/* Check the capability before cred override */
-	ret = -EPERM;
-	old_iflags = READ_ONCE(inode->i_flags);
-	if (((iflags ^ old_iflags) & (S_APPEND | S_IMMUTABLE)) &&
-	    !capable(CAP_LINUX_IMMUTABLE))
+	oldflags = ovl_iflags_to_fsflags(READ_ONCE(inode->i_flags));
+	ret = vfs_ioc_setflags_prepare(inode, oldflags, flags);
+	if (ret)
 		goto unlock;
 
 	ret = ovl_maybe_copy_up(file_dentry(file), O_WRONLY);
@@ -598,22 +613,6 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
 
 }
 
-static unsigned int ovl_fsflags_to_iflags(unsigned int flags)
-{
-	unsigned int iflags = 0;
-
-	if (flags & FS_SYNC_FL)
-		iflags |= S_SYNC;
-	if (flags & FS_APPEND_FL)
-		iflags |= S_APPEND;
-	if (flags & FS_IMMUTABLE_FL)
-		iflags |= S_IMMUTABLE;
-	if (flags & FS_NOATIME_FL)
-		iflags |= S_NOATIME;
-
-	return iflags;
-}
-
 static long ovl_ioctl_set_fsflags(struct file *file, unsigned int cmd,
 				  unsigned long arg)
 {
@@ -622,24 +621,23 @@ static long ovl_ioctl_set_fsflags(struct file *file, unsigned int cmd,
 	if (get_user(flags, (int __user *) arg))
 		return -EFAULT;
 
-	return ovl_ioctl_set_flags(file, cmd, arg,
-				   ovl_fsflags_to_iflags(flags));
+	return ovl_ioctl_set_flags(file, cmd, arg, flags);
 }
 
-static unsigned int ovl_fsxflags_to_iflags(unsigned int xflags)
+static unsigned int ovl_fsxflags_to_fsflags(unsigned int xflags)
 {
-	unsigned int iflags = 0;
+	unsigned int flags = 0;
 
 	if (xflags & FS_XFLAG_SYNC)
-		iflags |= S_SYNC;
+		flags |= FS_SYNC_FL;
 	if (xflags & FS_XFLAG_APPEND)
-		iflags |= S_APPEND;
+		flags |= FS_APPEND_FL;
 	if (xflags & FS_XFLAG_IMMUTABLE)
-		iflags |= S_IMMUTABLE;
+		flags |= FS_IMMUTABLE_FL;
 	if (xflags & FS_XFLAG_NOATIME)
-		iflags |= S_NOATIME;
+		flags |= FS_NOATIME_FL;
 
-	return iflags;
+	return flags;
 }
 
 static long ovl_ioctl_set_fsxflags(struct file *file, unsigned int cmd,
@@ -652,7 +650,7 @@ static long ovl_ioctl_set_fsxflags(struct file *file, unsigned int cmd,
 		return -EFAULT;
 
 	return ovl_ioctl_set_flags(file, cmd, arg,
-				   ovl_fsxflags_to_iflags(fa.fsx_xflags));
+				   ovl_fsxflags_to_fsflags(fa.fsx_xflags));
 }
 
 long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-- 
2.25.1



