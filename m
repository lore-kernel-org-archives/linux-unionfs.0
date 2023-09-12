Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E78E1EE3F09
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbjILRhH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjILRhG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 13:37:06 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951E010E9
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 10:37:02 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9a9d82d73f9so732462566b.3
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 10:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694540221; x=1695145021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CryryFdhSY3jdNMbIZm+VVEBdH7hdIPJ89TlilQ7mWY=;
        b=YzTZwj2GFyuB0Ho4bwFmXmZuKIlhqkLP+c2YUmdLAHGLLTt/crVvv7CDfarZgvTz0N
         iiS+HTT7V0LIIeYDdTmqO1JpPDAs5T/IhIOzAQaFduVqavtD5Z3CTuiz//vb6L/UD7lG
         mqoEDxKCcV3LPPxjiSk8SwlUQuOrAPX4C9IMBFoTxRa7y9hIb42OHRsrGnjJ+8sKXBcu
         TJPy2f8LT81uC5rdpbB4eoMZWJ4af++MxSqqBIJ/1mwefxFZnjFmXJ4pXIGlacsTnKb7
         mUTs/OgqVBXXFmzKrDXrwEhua+kLE7/cVOZck1wfz0tApSAjAxldEiOruO7uAf5XBr4l
         Tlcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694540221; x=1695145021;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CryryFdhSY3jdNMbIZm+VVEBdH7hdIPJ89TlilQ7mWY=;
        b=lrXdt1t6YLARLlR3vnRjMfnx4NrwXDjxJAChM2Ml6t69ELoZ2ULE2Ogveri479KtYf
         DjFiHMIv6plO+oL4unVbOQEB80azVtWeh8fsIImHWIlyJCHLfqH8hA3msk6w9KeA1OaW
         6aGMGmRr5xiYieZtSfl1dZgC7Ty9QpA0lmpdNPWItED71R/aIii4iR6s01NRbZUk0X4p
         K6JBDzgejH8eYjprM+3OELvzGQx2XLtje5G4PfELf2eipYLR/is3pUQyijlH04kbEG25
         eT2+43i4K0hu/dcM/BVIJmdHw0UhQP1uAQys2S6xfBMKXpDwvuI4oNbcJ96hrFZrE2jv
         KUaA==
X-Gm-Message-State: AOJu0YzPJY9oMi/+FQRG/i4K0K/1+JP7qrY7m6RrZTaa4rvU0trbcc0n
        OGWtHGnZYWvm7Qe8u1WRw6ZaoNSMz7M=
X-Google-Smtp-Source: AGHT+IFwtzZkk3XzMAjM2TsuSv0G5c+yLaDO43aO3jyZ6RMEqVr+7pHsWhRbccPpgv1D6px0DuB7qQ==
X-Received: by 2002:a17:907:762f:b0:9a9:d651:68f5 with SMTP id jy15-20020a170907762f00b009a9d65168f5mr16277ejc.3.1694540220703;
        Tue, 12 Sep 2023 10:37:00 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id s3-20020a170906060300b0099ce188be7fsm7115978ejb.3.2023.09.12.10.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 10:37:00 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org,
        Alessio Balsini <balsini@android.com>
Subject: [PATCH 2/4] ovl: use simpler function to convert iocb to rw flags
Date:   Tue, 12 Sep 2023 20:36:51 +0300
Message-Id: <20230912173653.3317828-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230912173653.3317828-1-amir73il@gmail.com>
References: <20230912173653.3317828-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Overlayfs implements its own function to translate iocb flags into rw
flags, so that they can be passed into another vfs call.

With commit ce71bfea207b4 ("fs: align IOCB_* flags with RWF_* flags")
Jens created a 1:1 matching between the iocb flags and rw flags,
simplifying the conversion.

Signed-off-by: Alessio Balsini <balsini@android.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index c6ad84cf9246..98f0dedffc0f 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -262,20 +262,12 @@ static void ovl_file_accessed(struct file *file)
 	touch_atime(&file->f_path);
 }
 
-static rwf_t ovl_iocb_to_rwf(int ifl)
+#define OVL_IOCB_MASK \
+	(IOCB_NOWAIT | IOCB_HIPRI | IOCB_DSYNC | IOCB_SYNC)
+
+static rwf_t iocb_to_rw_flags(int flags)
 {
-	rwf_t flags = 0;
-
-	if (ifl & IOCB_NOWAIT)
-		flags |= RWF_NOWAIT;
-	if (ifl & IOCB_HIPRI)
-		flags |= RWF_HIPRI;
-	if (ifl & IOCB_DSYNC)
-		flags |= RWF_DSYNC;
-	if (ifl & IOCB_SYNC)
-		flags |= RWF_SYNC;
-
-	return flags;
+	return (__force rwf_t)(flags & OVL_IOCB_MASK);
 }
 
 static inline void ovl_aio_put(struct ovl_aio_req *aio_req)
@@ -333,8 +325,9 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	if (is_sync_kiocb(iocb)) {
-		ret = vfs_iter_read(real.file, iter, &iocb->ki_pos,
-				    ovl_iocb_to_rwf(iocb->ki_flags));
+		rwf_t rwf = iocb_to_rw_flags(iocb->ki_flags);
+
+		ret = vfs_iter_read(real.file, iter, &iocb->ki_pos, rwf);
 	} else {
 		struct ovl_aio_req *aio_req;
 
@@ -369,7 +362,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	struct fd real;
 	const struct cred *old_cred;
 	ssize_t ret;
-	int ifl = iocb->ki_flags;
+	int flags = iocb->ki_flags;
 
 	if (!iov_iter_count(iter))
 		return 0;
@@ -391,13 +384,14 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		goto out_fdput;
 
 	if (!ovl_should_sync(OVL_FS(inode->i_sb)))
-		ifl &= ~(IOCB_DSYNC | IOCB_SYNC);
+		flags &= ~(IOCB_DSYNC | IOCB_SYNC);
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	if (is_sync_kiocb(iocb)) {
+		rwf_t rwf = iocb_to_rw_flags(flags);
+
 		file_start_write(real.file);
-		ret = vfs_iter_write(real.file, iter, &iocb->ki_pos,
-				     ovl_iocb_to_rwf(ifl));
+		ret = vfs_iter_write(real.file, iter, &iocb->ki_pos, rwf);
 		file_end_write(real.file);
 		/* Update size */
 		ovl_copyattr(inode);
@@ -412,7 +406,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
 		kiocb_clone(&aio_req->iocb, iocb, get_file(real.file));
-		aio_req->iocb.ki_flags = ifl;
+		aio_req->iocb.ki_flags = flags;
 		aio_req->iocb.ki_complete = ovl_aio_rw_complete;
 		refcount_set(&aio_req->ref, 2);
 		kiocb_start_write(&aio_req->iocb);
-- 
2.34.1

