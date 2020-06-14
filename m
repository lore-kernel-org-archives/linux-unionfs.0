Return-Path: <SRS0=/kxx=73=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10B46C433E1
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 13:09:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E579E206D7
	for <linux-unionfs@archiver.kernel.org>; Sun, 14 Jun 2020 13:09:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rp9C+vSn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgFNNJt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 14 Jun 2020 09:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgFNNJt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 14 Jun 2020 09:09:49 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE73DC05BD43
        for <linux-unionfs@vger.kernel.org>; Sun, 14 Jun 2020 06:09:48 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y17so14343564wrn.11
        for <linux-unionfs@vger.kernel.org>; Sun, 14 Jun 2020 06:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P53JMy8twlEpPLdOX1t3tSvEfEl4JB8JE7mxEOOKsqc=;
        b=Rp9C+vSnypD4QeCbhTwuQHBovCw8KWPqJzDLbIDirv9QMxqyFUjiscbz6VgOeV4E5r
         8nF7z6EU4n+gouFMbpYjw4CLFjITt5LJJ1BHRmOO9fdYSNr+kXi5NpBOigKKVId7X9nu
         6Wtm+341XZvmu/L0H8fEoCmAZ8FLp0eZC9qAy9UZjbMpwKUBBJgYa8dfjZmdMF8fyFFQ
         ls9sboMKErTR/+uyy11RKgA7/4S66CZ2aRcuoEAKCf7RVlpTd44HSBcS7qYiqAqzs0o6
         eR4d6rS1iX4gghA3SaqN+2KxML2tQ1ke1C/g1RhwB3OXA7tUY2r8YHUVQGttUkhrsxpq
         M1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P53JMy8twlEpPLdOX1t3tSvEfEl4JB8JE7mxEOOKsqc=;
        b=SdaQWwh6yqrarJQYD0F+DubkKNyJxkGur4EW+4lLYFVqW35oob/wreWUU2S32TqiP4
         8LhVs/k6dOkuxiQttJagCqsfPFYRbjik9gHXYFEd30Km0zfvqIiUWvII077IanlSvr/y
         W481RkZfZkQgbADz0GJBWkMoAT076MvR0E7HA5xQFdJGUgcc3SRK0NrczJPH4yDTCU5j
         bk6XUc1e4TRpDc5BWqNkKb0G6S2niW1d8JS7zP37/WVZnpAw7Yj8AVyxddXTkWZkdpP1
         AfTmExciI+edd2tTgWN3/5UzLV7tfhYjwYr2fTiaciyzG29/efCNRmboImb9Rv/6NB+Z
         8pvw==
X-Gm-Message-State: AOAM531Cnz2RZESEqoTbNJF088Wt18g85FGAZftjMTLk2yP0HtwJQtAL
        GGgNCdHUCjP73MebbBJl/oTYj0E9
X-Google-Smtp-Source: ABdhPJyeqvTXNI4jCXVBeQIjA7b/ibe/MLIRZQ6xeCD8JxU/i+V/f+m/ytBVmcB4zQmTzvfNFcWskw==
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr25438153wrs.115.1592140187665;
        Sun, 14 Jun 2020 06:09:47 -0700 (PDT)
Received: from localhost.localdomain ([5.102.204.95])
        by smtp.gmail.com with ESMTPSA id g82sm18458283wmf.1.2020.06.14.06.09.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 06:09:47 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 1/2] ovl: inherit supported ops f_mode flags from final real file
Date:   Sun, 14 Jun 2020 16:09:38 +0300
Message-Id: <20200614130939.7702-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200614130939.7702-1-amir73il@gmail.com>
References: <20200614130939.7702-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Mike Kravetz reported that when hugetlbfs is used as overlayfs upper
layer, writes do not fail, but result in writing to lower layer.

This is surprising because hugeltbfs file does not have write() nor
write_iter() method.

Regardless of the question whether or not this type of filesystem should
be allowed as overlayfs upper layer, overlayfs file should emulate the
supported ops of the underlying files, so at least in the case where
underlying file ops cannot change as result of copy up, the overlayfs
file should inherit the f_mode flags indicating the supported ops of
the underlying file.

Reported-by: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 11 +++++++++++
 fs/overlayfs/file.c      | 11 +++++++++++
 fs/overlayfs/overlayfs.h |  5 +++++
 3 files changed, 27 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 79dd052c7dbf..424f2a170f11 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -953,6 +953,17 @@ static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
 	return true;
 }
 
+/* May need copy up in the future? */
+bool ovl_may_need_copy_up(struct dentry *dentry)
+{
+	int flags = O_RDONLY;
+
+	if (ovl_upper_mnt(OVL_FS(dentry->d_sb)))
+		flags = O_RDWR;
+
+	return ovl_open_need_copy_up(dentry, flags);
+}
+
 int ovl_maybe_copy_up(struct dentry *dentry, int flags)
 {
 	int err = 0;
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 01820e654a21..01dd3ed723df 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -153,6 +153,17 @@ static int ovl_open(struct inode *inode, struct file *file)
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
+	/*
+	 * Overlay file supported ops are a super set of the underlying file
+	 * supported ops and we do not change them when file is copied up.
+	 * But if file cannot be copied up, then there is no need to advertize
+	 * more supported ops than underlying file actually has.
+	 */
+	if (!ovl_may_need_copy_up(file_dentry(file))) {
+		file->f_mode &= ~OVL_UPPER_FMODE_MASK;
+		file->f_mode |= realfile->f_mode & OVL_UPPER_FMODE_MASK;
+	}
+
 	file->private_data = realfile;
 
 	return 0;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b725c7f15ff4..6748c28ff477 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -110,6 +110,10 @@ struct ovl_fh {
 #define OVL_FH_FID_OFFSET	(OVL_FH_WIRE_OFFSET + \
 				 offsetof(struct ovl_fb, fid))
 
+/* f_mode bits expected to be set on an upper file */
+#define OVL_UPPER_FMODE_MASK (FMODE_CAN_READ | FMODE_CAN_WRITE | \
+			      FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE)
+
 static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_rmdir(dir, dentry);
@@ -485,6 +489,7 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_with_data(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_maybe_copy_up(struct dentry *dentry, int flags);
+bool ovl_may_need_copy_up(struct dentry *dentry);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper);
-- 
2.17.1

