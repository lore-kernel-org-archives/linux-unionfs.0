Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DD8C433DB
	for <linux-unionfs@archiver.kernel.org>; Sat, 26 Dec 2020 10:47:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7C742084D
	for <linux-unionfs@archiver.kernel.org>; Sat, 26 Dec 2020 10:47:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgLZKrm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 26 Dec 2020 05:47:42 -0500
Received: from sender2-pp-o92.zoho.com.cn ([163.53.93.251]:25392 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbgLZKrm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 26 Dec 2020 05:47:42 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1608979609; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=Q3E1/HQR+tSuSNY4wQs+RoQggCu8erGonSnVSaLpZ4anZDuDi5/OqmphRMvkpJXehBEESANs5C9yMJTw7VvJvCGRvdQXx6fOWBJfHM96xSRj8w9sH7gjiBBbTUsclY/7HEvJT8cr9gr7W8kHCTqxN4MSFOZA9M9g//8mIqrc4U8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1608979609; h=Cc:Date:From:Message-ID:Subject:To; 
        bh=SKxFvP/LMusx+kvRflAKLCrq2uNgVqAC6qqBL1XBA0o=; 
        b=dxtuCsmTJhE+YyHhNKfMkCDnbYyLMgk6rVaArHMoL2eZKDsV7l5CvTlm7VXLx3EtCuELWOLd5lkEA1HHby+U9Ctj2RVrFtTKXHQbNHRUDq3wIjCPnYoXuzY93Yx6Eo9daV3MxMJewpfF4cS4Fqe51bM5oDtcLop8lA9xGaLsZIo=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1608979609;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Subject:Date:Message-Id;
        bh=SKxFvP/LMusx+kvRflAKLCrq2uNgVqAC6qqBL1XBA0o=;
        b=AGaouQK2tXMXu295n/0RO/EwBn1pfaBrMyTrQw5kTbxbepez7u1nXa+Bb03txy2a
        8y6q+ZCvQljNfKxMXjtADcdy4oTo9wp2Dyu1S/YMq+HCBGyhmTUkK59lI6S5eVq5q7I
        8zATH75OEDe+4D10C+Thex/tBFmQVaoB0F7lWTOw=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1608979607479611.034899342346; Sat, 26 Dec 2020 18:46:47 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Subject: [RFC PATCH] ovl: keep some file attrubutions after copy-up
Date:   Sat, 26 Dec 2020 18:46:18 +0800
Message-Id: <20201226104618.239739-1-cgxu519@mykernel.net>
X-Mailer: git-send-email 2.18.4
X-ZohoCNMailClient: External
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Currently after copy-up, upper file will lose most of file
attributions except copy-up triggered by setting fsflags.
Because ioctl operation of underlying file systems does not
expect calling from kernel component, it seems hard to
copy fsflags during copy-up.

Overlayfs keeps limited attributions(append-only, etc) in it's
inode flags after successfully updating attributions. so ater
copy-up, lsattr(1) does not show correct result but overlayfs
can still prohibit ramdom write for those files which originally
have append-only attribution. However, recently I found this
protection can be easily broken in below operations.

1, Set append attribution to lower file.
2, Mount overlayfs.
3, Trigger copy-up by data append.
4, Set noatime attributtion to the file.
5, The file is random writable.

This patch tries to keep some file attributions after copy-up
so that overlayfs keeps compatible behavior with local filesystem
as much as possible.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/file.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index efccb7c1f9bc..e0eb055d00a6 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -655,12 +655,24 @@ static long ovl_ioctl_set_fsxflags(struct file *file, unsigned int cmd,
 
 long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	unsigned int imask = S_SYNC | S_APPEND | S_NOATIME;
+	unsigned int fsmask = FS_SYNC_FL | FS_APPEND_FL | FS_NOATIME_FL;
+	unsigned int flags, ovl_fsflags;
 	long ret;
 
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
 	case FS_IOC_FSGETXATTR:
 		ret = ovl_real_ioctl(file, cmd, arg);
+		if (!ret) {
+			if (get_user(flags, (int __user *) arg))
+				return -EFAULT;
+
+			ovl_fsflags = ovl_iflags_to_fsflags(file_inode(file)->i_flags & imask);
+			if ((flags & fsmask) != ovl_fsflags)
+				flags |= ovl_fsflags;
+			ret = put_user(flags, (int __user *)arg);
+		}
 		break;
 
 	case FS_IOC_SETFLAGS:
-- 
2.18.4

