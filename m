Return-Path: <SRS0=SU5x=77=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E834CC433DF
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:44:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9BDD2070A
	for <linux-unionfs@archiver.kernel.org>; Thu, 18 Jun 2020 15:44:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Olx8VzAz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731878AbgFRPoE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 18 Jun 2020 11:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731704AbgFRPoD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jun 2020 11:44:03 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EF90C06174E
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jun 2020 08:44:02 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q2so4124283wrv.8
        for <linux-unionfs@vger.kernel.org>; Thu, 18 Jun 2020 08:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=IXsB71mA/q+YdPRhrLJQBXiDE+pgA5gNHLHDq11wWiU=;
        b=Olx8VzAz5xj3x3o9RwMQD47/Bv9lNu2d9OAwsqQ+hB6GS/VCdARCT0NP/HgPc56Zh1
         7bbDqRnzqwYvSKXMraBsFhLtQToRBhcUfYYnW/SrhwZCu2LLarChHD9eMzEgYfs8plm+
         PrHjQcLUDb+uQyriwZQ3EUDyyf/yQkhqQQS/G/YvhV4NnSgKA0V/jINV/4GLlW3Upcc3
         mOqIm0pSeze0oxxMa+8ihvFE8aWa7ViBr5d5s7e56kg6W3j8qkeJVjPOJ5Godi3UmKO2
         Dc8I2VdAFH4vKkCKqmRoxw2LRcHEAlU28B4jBpRPYyATA2ZthaGF1MSWIehHoJlTn4Ry
         tgUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=IXsB71mA/q+YdPRhrLJQBXiDE+pgA5gNHLHDq11wWiU=;
        b=aBHAHOV4SVmCWJxcZO7RmLECsRsgEYqv9D5NQ1CqD3dXYgooudHSyJEA2rK706aOM0
         r4gZcenHeyg+uBP2u5JSgqJA3XOpmPdtGoR+g6aA1kuV29NemU5acVY2U27VNKCOVglS
         ghhAccv6iBGmBzxePj19dWgV6TrUeNJeXKiWpoXWd3qOAxazRiXCOztZZFI2RZr+vS1s
         zw6u1QNCgs56IuTlxnByMqnu0yvTKOABmUfcokAU8DrIsYA5CVzqzQQTiE8h981qFSAs
         WjST3TsXZY1mQWK0akmI4ltdhlUvfNAEuzbkaWuR+paW0OEWCvyq5+ev+H2XvhNXrRGx
         6gYg==
X-Gm-Message-State: AOAM532jQ/UkmLCcn2lVsE8JKgPznfVDribCmCy0RWtA12/BYMNhD8Ki
        +5sXEPK75bCl1eOyOvKB3U6ndR7L
X-Google-Smtp-Source: ABdhPJxWbGQX6klDndTSOco4L7dXPoM7P2qFdlhuH5Uo9ImYu3lrJYgGVe1AFetUoN/OaKl4B6jWJw==
X-Received: by 2002:a05:6000:128e:: with SMTP id f14mr5724170wrx.276.1592495040896;
        Thu, 18 Jun 2020 08:44:00 -0700 (PDT)
Received: from localhost.localdomain ([94.230.83.8])
        by smtp.gmail.com with ESMTPSA id y6sm4054212wmy.0.2020.06.18.08.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 08:44:00 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix unneeded call to ovl_change_flags()
Date:   Thu, 18 Jun 2020 18:43:53 +0300
Message-Id: <20200618154353.369-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The check if user has changed the overlay file was wrong, causing unneeded
call to ovl_change_flags() including taking f_lock on every file access.

Fixes: d989903058a8 ("ovl: do not generate duplicate fsnotify events...")
Cc: <stable@vger.kernel.org> # v4.19+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 01820e654a21..0d940e29d62b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -33,13 +33,16 @@ static char ovl_whatisit(struct inode *inode, struct inode *realinode)
 		return 'm';
 }
 
+/* No atime modificaton nor notify on underlying */
+#define OVL_OPEN_FLAGS (O_NOATIME | FMODE_NONOTIFY)
+
 static struct file *ovl_open_realfile(const struct file *file,
 				      struct inode *realinode)
 {
 	struct inode *inode = file_inode(file);
 	struct file *realfile;
 	const struct cred *old_cred;
-	int flags = file->f_flags | O_NOATIME | FMODE_NONOTIFY;
+	int flags = file->f_flags | OVL_OPEN_FLAGS;
 	int acc_mode = ACC_MODE(flags);
 	int err;
 
@@ -72,8 +75,7 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
 	struct inode *inode = file_inode(file);
 	int err;
 
-	/* No atime modificaton on underlying */
-	flags |= O_NOATIME | FMODE_NONOTIFY;
+	flags |= OVL_OPEN_FLAGS;
 
 	/* If some flag changed that cannot be changed then something's amiss */
 	if (WARN_ON((file->f_flags ^ flags) & ~OVL_SETFL_MASK))
@@ -126,7 +128,7 @@ static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
 	}
 
 	/* Did the flags change since open? */
-	if (unlikely((file->f_flags ^ real->file->f_flags) & ~O_NOATIME))
+	if (unlikely((file->f_flags ^ real->file->f_flags) & ~OVL_OPEN_FLAGS))
 		return ovl_change_flags(real->file, file->f_flags);
 
 	return 0;
-- 
2.17.1

