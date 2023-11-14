Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03105C4167B
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbjKNPdT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbjKNPdT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:19 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFF412F
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:15 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-408382da7f0so47808515e9.0
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975994; x=1700580794; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ko4DuETTQDsrHP5n6WDIpw77gVvQpoHQ8fh/EOMz2cA=;
        b=hmISHzQ3vd3JHAi8TEoU+NBCSBSimVqM2C092sxWas+iNy/aN6tX1nFxid1TsJUsy1
         EqGDX2pZuWxpJx/k5lR/8xssBNMn80JkfVrtsSxU0EdtwpTh84/Q2dJqv4m0m8fHpyIS
         NVLxYCJ8BgzKJCkWVzQXV7y7ipqNVsgYW/EuaaUjLmeOJSfclSefkviZKfnJPkaxEZCU
         6TP1M5d3+MV1wMVgS8+53uAta5aSf5EXCsbhM5R0VXGV7n9s2ehOMFbnLpgK7yyxVGS3
         0r4VrIzrCs3Nqr5vlyU405GNFghhAYJX7Fo8sMmtCX9WgxaCOVfvA6gz7gL7W8U2uQug
         2j4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975994; x=1700580794;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ko4DuETTQDsrHP5n6WDIpw77gVvQpoHQ8fh/EOMz2cA=;
        b=Gb8GSGQ7NZvn1YHnbusac3A332R+J1poXfkuTcrFf+rfmDQidFxbQZq5DpS0WReqE7
         dkl2gC3tZuei+csPid31Ty+XNQKcgBT9WCEe7UllDMVrNPNp90h2o2Y+sdaQeBM+xQ2T
         ch71tRoygJyc18Fxj40WpyHoBMtozsqbbLEkqIZ1KTO6HArd/sKu8bgKBf4WIMCUvg/1
         Qxrlxa9Ur/gvKoohKOyxQ6OOm5wrWhqxvpU46z4Sv4Oe5+q2f0Z35RIl4TqqPAk5Dpb1
         ilnQyOySm4V//zP3O7FkHYzXkHyHhq6VKShI5SPTCM0uu0LaSkyZ7LMcdECvBOwC+q3B
         bl5g==
X-Gm-Message-State: AOJu0Yw9ND9GLhhQSPmlbHQSqPSg2lI+UDNZ2WvgLRsXQkEhFuYkLUpr
        zFHQ3bv/7rBaXkJQ14mcnltF9qDa9/Y=
X-Google-Smtp-Source: AGHT+IHpJ44HMtdoQAbExzCgO+xVShpTfOCkrmZJ8l0TjUavi77/Yi3vGGujNMjNVUvcYd4NU8misg==
X-Received: by 2002:a05:600c:1c15:b0:406:44e6:c00d with SMTP id j21-20020a05600c1c1500b0040644e6c00dmr8347768wms.2.1699975994220;
        Tue, 14 Nov 2023 07:33:14 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:13 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 11/15] fs: move permission hook out of do_iter_read()
Date:   Tue, 14 Nov 2023 17:32:50 +0200
Message-Id: <20231114153254.1715969-12-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

We recently moved fsnotify hook, rw_verify_area() and other checks from
do_iter_write() out to its two callers.

for consistency, do the same thing for do_iter_read() - move the
rw_verify_area() checks and fsnotify hook to the callers vfs_iter_read()
and vfs_readv().

This aligns those vfs helpers with the pattern used in vfs_read() and
vfs_iocb_iter_read() and the vfs write helpers, where all the checks are
in the vfs helpers and the do_* or call_* helpers do the work.

This is needed for fanotify "pre content" events.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c | 70 +++++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 26 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index d4891346d42e..5b18e13c2620 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -781,11 +781,22 @@ static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
 }
 
 static ssize_t do_iter_read(struct file *file, struct iov_iter *iter,
-		loff_t *pos, rwf_t flags)
+			    loff_t *pos, rwf_t flags)
+{
+	if (file->f_op->read_iter)
+		return do_iter_readv_writev(file, iter, pos, READ, flags);
+	else
+		return do_loop_readv_writev(file, iter, pos, READ, flags);
+}
+
+ssize_t vfs_iocb_iter_read(struct file *file, struct kiocb *iocb,
+			   struct iov_iter *iter)
 {
 	size_t tot_len;
 	ssize_t ret = 0;
 
+	if (!file->f_op->read_iter)
+		return -EINVAL;
 	if (!(file->f_mode & FMODE_READ))
 		return -EBADF;
 	if (!(file->f_mode & FMODE_CAN_READ))
@@ -794,22 +805,20 @@ static ssize_t do_iter_read(struct file *file, struct iov_iter *iter,
 	tot_len = iov_iter_count(iter);
 	if (!tot_len)
 		goto out;
-	ret = rw_verify_area(READ, file, pos, tot_len);
+	ret = rw_verify_area(READ, file, &iocb->ki_pos, tot_len);
 	if (ret < 0)
 		return ret;
 
-	if (file->f_op->read_iter)
-		ret = do_iter_readv_writev(file, iter, pos, READ, flags);
-	else
-		ret = do_loop_readv_writev(file, iter, pos, READ, flags);
+	ret = call_read_iter(file, iocb, iter);
 out:
 	if (ret >= 0)
 		fsnotify_access(file);
 	return ret;
 }
+EXPORT_SYMBOL(vfs_iocb_iter_read);
 
-ssize_t vfs_iocb_iter_read(struct file *file, struct kiocb *iocb,
-			   struct iov_iter *iter)
+ssize_t vfs_iter_read(struct file *file, struct iov_iter *iter, loff_t *ppos,
+		      rwf_t flags)
 {
 	size_t tot_len;
 	ssize_t ret = 0;
@@ -824,25 +833,16 @@ ssize_t vfs_iocb_iter_read(struct file *file, struct kiocb *iocb,
 	tot_len = iov_iter_count(iter);
 	if (!tot_len)
 		goto out;
-	ret = rw_verify_area(READ, file, &iocb->ki_pos, tot_len);
+	ret = rw_verify_area(READ, file, ppos, tot_len);
 	if (ret < 0)
 		return ret;
 
-	ret = call_read_iter(file, iocb, iter);
+	ret = do_iter_read(file, iter, ppos, flags);
 out:
 	if (ret >= 0)
 		fsnotify_access(file);
 	return ret;
 }
-EXPORT_SYMBOL(vfs_iocb_iter_read);
-
-ssize_t vfs_iter_read(struct file *file, struct iov_iter *iter, loff_t *ppos,
-		rwf_t flags)
-{
-	if (!file->f_op->read_iter)
-		return -EINVAL;
-	return do_iter_read(file, iter, ppos, flags);
-}
 EXPORT_SYMBOL(vfs_iter_read);
 
 static ssize_t do_iter_write(struct file *file, struct iov_iter *iter,
@@ -914,19 +914,37 @@ ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos,
 EXPORT_SYMBOL(vfs_iter_write);
 
 static ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
-		  unsigned long vlen, loff_t *pos, rwf_t flags)
+			 unsigned long vlen, loff_t *pos, rwf_t flags)
 {
 	struct iovec iovstack[UIO_FASTIOV];
 	struct iovec *iov = iovstack;
 	struct iov_iter iter;
-	ssize_t ret;
+	size_t tot_len;
+	ssize_t ret = 0;
 
-	ret = import_iovec(ITER_DEST, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
-	if (ret >= 0) {
-		ret = do_iter_read(file, &iter, pos, flags);
-		kfree(iov);
-	}
+	if (!(file->f_mode & FMODE_READ))
+		return -EBADF;
+	if (!(file->f_mode & FMODE_CAN_READ))
+		return -EINVAL;
+
+	ret = import_iovec(ITER_DEST, vec, vlen, ARRAY_SIZE(iovstack), &iov,
+			   &iter);
+	if (ret < 0)
+		return ret;
 
+	tot_len = iov_iter_count(&iter);
+	if (!tot_len)
+		goto out;
+
+	ret = rw_verify_area(READ, file, pos, tot_len);
+	if (ret < 0)
+		goto out;
+
+	ret = do_iter_read(file, &iter, pos, flags);
+out:
+	if (ret >= 0)
+		fsnotify_access(file);
+	kfree(iov);
 	return ret;
 }
 
-- 
2.34.1

