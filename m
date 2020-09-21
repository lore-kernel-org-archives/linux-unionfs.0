Return-Path: <SRS0=ehig=C6=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84A0C43464
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Sep 2020 07:50:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3BBB20809
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Sep 2020 07:50:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgIUHuG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Sep 2020 03:50:06 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:13599 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726211AbgIUHuD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Sep 2020 03:50:03 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 03:49:53 EDT
X-IronPort-AV: E=Sophos;i="5.77,286,1596470400"; 
   d="scan'208";a="99456458"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 21 Sep 2020 15:39:58 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id C4B0248990EC;
        Mon, 21 Sep 2020 15:39:54 +0800 (CST)
Received: from G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 21 Sep 2020 15:39:55 +0800
Received: from Fedora-31.g08.fujitsu.local (10.167.220.31) by
 G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 21 Sep 2020 15:39:51 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <linux-unionfs@vger.kernel.org>
CC:     <miklos@szeredi.hu>, <amir73il@gmail.com>,
        <darrick.wong@oracle.com>, <hch@infradead.org>,
        <fstests@vger.kernel.org>, Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH] ovl: Support FS_IOC_[SG]ETFLAGS and FS_IOC_FS[SG]ETXATTR ioctls on directories
Date:   Mon, 21 Sep 2020 15:21:27 +0800
Message-ID: <20200921072127.373125-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: C4B0248990EC.AAE95
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Factor out ovl_ioctl() and ovl_compat_ioctl() and take use of them for
directories.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 fs/overlayfs/file.c      | 5 ++---
 fs/overlayfs/overlayfs.h | 2 ++
 fs/overlayfs/readdir.c   | 2 ++
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 0d940e29d62b..94ad7f9c9c76 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -640,7 +640,7 @@ static long ovl_ioctl_set_fsxflags(struct file *file, unsigned int cmd,
 				   ovl_fsxflags_to_iflags(fa.fsx_xflags));
 }
 
-static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 
@@ -665,8 +665,7 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-static long ovl_compat_ioctl(struct file *file, unsigned int cmd,
-			     unsigned long arg)
+long ovl_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case FS_IOC32_GETFLAGS:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 29bc1ec699e7..bfb499314dcc 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -301,6 +301,8 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct dentry *dentry, int padding);
 ssize_t ovl_getxattr(struct dentry *dentry, char *name, char **value,
 		     size_t padding);
+long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+long ovl_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 6918b98faeb6..cde909b6fe7d 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -945,6 +945,8 @@ const struct file_operations ovl_dir_operations = {
 	.llseek		= ovl_dir_llseek,
 	.fsync		= ovl_dir_fsync,
 	.release	= ovl_dir_release,
+	.unlocked_ioctl = ovl_ioctl,
+	.compat_ioctl   = ovl_compat_ioctl,
 };
 
 int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
-- 
2.25.1



