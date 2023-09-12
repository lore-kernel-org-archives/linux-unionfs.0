Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B37EE3F0B
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbjILRhJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236435AbjILRhJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 13:37:09 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4601110F2
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 10:37:05 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-99bcc0adab4so749331266b.2
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 10:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694540223; x=1695145023; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B1MGBwj0ulVwsYwfgmyVf2rkJTuMjuwA5+D9px5hzeo=;
        b=k86sWMlpqBuJ8aumY+l+INcl895T1ZXtvOX24mqG5C2r7lhW5C4N2lPAYy/H9V8JkI
         /ouwTE/d7kxirbfLFnvMdjj4tqapk496nH7o/JithhM8mD9xQgyQVxUGflBkFRbVFv9o
         dNgOpkh9F2j8u4kMx6fgn5k3a2V4bWHO91KPBp82wDui4lwLf5bbMe4GBnTl2b1iScgB
         FumVNGbRxxVFhka5/DcD05o8W3niU7AM/SWKxyeJI93y40NcFTOA052AD7WwaasaJ11k
         I8xicxTMoxGfD47SM+8CCRl8ImAawfTovQZW8v79UTyX/hh86CZH1mQ7mVPq7IoxJrV1
         bfQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694540223; x=1695145023;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B1MGBwj0ulVwsYwfgmyVf2rkJTuMjuwA5+D9px5hzeo=;
        b=SZPo+XCcTYs5V64/OSaig3VDRtThq9wIzRZrgH4SoOVp0p2NH4BArBbDhHBn2wVYfG
         NdqZjOwjxbL2/Fx0P6lukdNJSpRULvZS3NLIdpo/MsBdcJZN79L3zzO4X1m3JCJ2aNpw
         jYjWGWxRaaTZns9mcoH+BU0DZkuWVp1059uRLqp/yar5kjaMA074mVCBjnF778pyBWXm
         WaLv5KX2fHf/NpHKnE2grDGLaA5jbA7mvgPJrfHP+nuGdPhEy5PUin39/G6mSriqT+rZ
         k3IhTrdoMowUyNcc0FCOSHIJ71w4j21ZhHNNNy9sMJrh/vXGXw5gvS0dypabhYJ/cPwO
         IBSQ==
X-Gm-Message-State: AOJu0YwmZCmiQ39TynRvsqKfb0ibtVlG5P2NliZx3MfLL29ygtEIXLtG
        XKrqfjepzVXpvDfgDqT1YO3Jczan3cc=
X-Google-Smtp-Source: AGHT+IHJgVRIORiM1yQ5UMIklhp4jTfs6aRpUDWzfZoFQUR1BkBdjSnNZPMfr/CEAFMeyIZGxsfu3g==
X-Received: by 2002:a17:907:7718:b0:99b:7297:fbf5 with SMTP id kw24-20020a170907771800b0099b7297fbf5mr11016621ejc.61.1694540223246;
        Tue, 12 Sep 2023 10:37:03 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id s3-20020a170906060300b0099ce188be7fsm7115978ejb.3.2023.09.12.10.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 10:37:02 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH 4/4] ovl: move ovl_file_accessed() to aio completion
Date:   Tue, 12 Sep 2023 20:36:53 +0300
Message-Id: <20230912173653.3317828-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230912173653.3317828-1-amir73il@gmail.com>
References: <20230912173653.3317828-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Refactor the io completion helpers to handlers with clear hierarchy:
- ovl_aio_rw_complete() is called on completion of submitted aio
 `- ovl_aio_cleanup() is called after any aio submission attempt
  `- ovl_rw_complete() is called after any io attempt

Move ovl_copyattr() and ovl_file_accessed() to the common helper
ovl_rw_complete(), so that they are called after aio completion.

Note that moving ovl_file_accessed() changes touch_atime() therein to
be called with mounter credentials in the sync read case.

It does not seem to matter with which credentials touch_atime() is called.
If it did matter, we would have needed to override to mounter credentials
in ovl_update_time() which calls touch_atime() on upper dentry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index ffebffa710b5..05ec614f7054 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -278,29 +278,43 @@ static inline void ovl_aio_put(struct ovl_aio_req *aio_req)
 	}
 }
 
-static void ovl_aio_cleanup_handler(struct ovl_aio_req *aio_req)
+/* Completion for submitted/failed sync/async rw io */
+static void ovl_rw_complete(struct kiocb *orig_iocb)
+{
+	struct file *file = orig_iocb->ki_filp;
+
+	if (orig_iocb->ki_flags & IOCB_WRITE) {
+		/* Update size/mtime */
+		ovl_copyattr(file_inode(file));
+	} else {
+		/* Update atime */
+		ovl_file_accessed(file);
+	}
+}
+
+/* Completion for submitted/failed async rw io */
+static void ovl_aio_cleanup(struct ovl_aio_req *aio_req)
 {
 	struct kiocb *iocb = &aio_req->iocb;
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
-	if (iocb->ki_flags & IOCB_WRITE) {
-		struct inode *inode = file_inode(orig_iocb->ki_filp);
-
+	if (iocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(iocb);
-		ovl_copyattr(inode);
-	}
 
 	orig_iocb->ki_pos = iocb->ki_pos;
+	ovl_rw_complete(orig_iocb);
+
 	ovl_aio_put(aio_req);
 }
 
+/* Completion for submitted async rw io */
 static void ovl_aio_rw_complete(struct kiocb *iocb, long res)
 {
 	struct ovl_aio_req *aio_req = container_of(iocb,
 						   struct ovl_aio_req, iocb);
 	struct kiocb *orig_iocb = aio_req->orig_iocb;
 
-	ovl_aio_cleanup_handler(aio_req);
+	ovl_aio_cleanup(aio_req);
 	orig_iocb->ki_complete(orig_iocb, res);
 }
 
@@ -328,6 +342,7 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		rwf_t rwf = iocb_to_rw_flags(iocb->ki_flags);
 
 		ret = vfs_iter_read(real.file, iter, &iocb->ki_pos, rwf);
+		ovl_rw_complete(iocb);
 	} else {
 		struct ovl_aio_req *aio_req;
 
@@ -344,11 +359,10 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		ret = vfs_iocb_iter_read(real.file, &aio_req->iocb, iter);
 		ovl_aio_put(aio_req);
 		if (ret != -EIOCBQUEUED)
-			ovl_aio_cleanup_handler(aio_req);
+			ovl_aio_cleanup(aio_req);
 	}
 out:
 	revert_creds(old_cred);
-	ovl_file_accessed(file);
 out_fdput:
 	fdput(real);
 
@@ -386,15 +400,14 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (!ovl_should_sync(OVL_FS(inode->i_sb)))
 		flags &= ~(IOCB_DSYNC | IOCB_SYNC);
 
-	old_cred = ovl_override_creds(file_inode(file)->i_sb);
+	old_cred = ovl_override_creds(inode->i_sb);
 	if (is_sync_kiocb(iocb)) {
 		rwf_t rwf = iocb_to_rw_flags(flags);
 
 		file_start_write(real.file);
 		ret = vfs_iter_write(real.file, iter, &iocb->ki_pos, rwf);
 		file_end_write(real.file);
-		/* Update size */
-		ovl_copyattr(inode);
+		ovl_rw_complete(iocb);
 	} else {
 		struct ovl_aio_req *aio_req;
 
@@ -413,7 +426,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
 		ovl_aio_put(aio_req);
 		if (ret != -EIOCBQUEUED)
-			ovl_aio_cleanup_handler(aio_req);
+			ovl_aio_cleanup(aio_req);
 	}
 out:
 	revert_creds(old_cred);
-- 
2.34.1

