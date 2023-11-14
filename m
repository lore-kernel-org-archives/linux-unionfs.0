Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8901EC072A2
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233678AbjKNPdT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbjKNPdS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:18 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA16793
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:14 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-4083f61322fso44964775e9.1
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975993; x=1700580793; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iTeM1dBsqSMrj7dJ0Y7ppqb+rwjsKONfTRk0U9DB+v8=;
        b=iE50zYivMhmkgyuw3Q20x3oLv+eHedCphfBR9VNOOj5zRFtZOwQWxycEpnrYKMVQbz
         //tbywbPolclSi1SPHrbzJJabynG+CcEBjyGhmh6NtHFqt15eE+X0pnWbxN4sjB81OIu
         tVyhOiv9ylfeTc6XCBWApYT2p2NL+2hgA8htMykAxRp7ynxwmr84ZDhCL0fPE7T6vY2A
         Y9No04Bp0OitzHglYAptgyVHJxAVd8YIkMalvcuONPik2QWBcOkI6GMfD/Ucp3zcirb6
         dlsShknJz+jjE/+zAiVZ6Du5rz5wWLM+zYLobR88iemqpCXlkTDu25mjHrhkRcRyQkKP
         P6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975993; x=1700580793;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iTeM1dBsqSMrj7dJ0Y7ppqb+rwjsKONfTRk0U9DB+v8=;
        b=BsUbzTtFIE6tw71eEjBqQZPt9r3HTyqbGDLFPS7YKeUEnhMr6kToCHaHybTeFNwJUW
         48XHTFIOmMf0HFHxYIxmoabFrb0PdEtgZrxfTJ7X8AbIWDSvgEpNkxjCXr0NMGbWgPtV
         AcmdCHpx0UJ3cntXPj40u47/Njlimk8iNgBHHhtMwh+S9mziEVWgfTqCc1+VjmwmFtKw
         GKCqW/NO8hghVuJO+E30/YGy0hHG1hB8CGP5Wj6lGNFYeoMi9FpJhrdpcg2lJzXoZn5G
         /4050rvr6Kexmw9cA6CK5AQTB/8z87eiT+5J5bRsM0cQ66ThVLV0Mu4GTbPAMo/ZVQgi
         X/tA==
X-Gm-Message-State: AOJu0Yx/rnvJjR5F40gtOlqEdRdK8ZKgmFuzbBrWcZdCN9oczvErfLdT
        kjL23vbKyLMkIIlOshLz73s=
X-Google-Smtp-Source: AGHT+IGmVy7NRUhi42hrv8qJabpyLF8paXwjwXSvAJuZdJSeVHDgu+vFBvj2IOQbjKCYzXobOy4I3Q==
X-Received: by 2002:a05:600c:470a:b0:404:f9c1:d5d7 with SMTP id v10-20020a05600c470a00b00404f9c1d5d7mr7500023wmo.25.1699975993123;
        Tue, 14 Nov 2023 07:33:13 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:12 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 10/15] fs: move permission hook out of do_iter_write()
Date:   Tue, 14 Nov 2023 17:32:49 +0200
Message-Id: <20231114153254.1715969-11-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In many of the vfs helpers, the rw_verity_area() checks are called before
taking sb_start_write(), making them "start-write-safe".
do_iter_write() is an exception to this rule.

do_iter_write() has two callers - vfs_iter_write() and vfs_writev().
Move rw_verify_area() and other checks from do_iter_write() out to
its callers to make them "start-write-safe".

Move also the fsnotify_modify() hook to align with similar pattern
used in vfs_write() and other vfs helpers.

This is needed for fanotify "pre content" events.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c | 76 ++++++++++++++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 30 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 8cdc6e6a9639..d4891346d42e 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -848,28 +848,10 @@ EXPORT_SYMBOL(vfs_iter_read);
 static ssize_t do_iter_write(struct file *file, struct iov_iter *iter,
 			     loff_t *pos, rwf_t flags)
 {
-	size_t tot_len;
-	ssize_t ret = 0;
-
-	if (!(file->f_mode & FMODE_WRITE))
-		return -EBADF;
-	if (!(file->f_mode & FMODE_CAN_WRITE))
-		return -EINVAL;
-
-	tot_len = iov_iter_count(iter);
-	if (!tot_len)
-		return 0;
-	ret = rw_verify_area(WRITE, file, pos, tot_len);
-	if (ret < 0)
-		return ret;
-
 	if (file->f_op->write_iter)
-		ret = do_iter_readv_writev(file, iter, pos, WRITE, flags);
+		return do_iter_readv_writev(file, iter, pos, WRITE, flags);
 	else
-		ret = do_loop_readv_writev(file, iter, pos, WRITE, flags);
-	if (ret > 0)
-		fsnotify_modify(file);
-	return ret;
+		return do_loop_readv_writev(file, iter, pos, WRITE, flags);
 }
 
 ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
@@ -903,13 +885,28 @@ EXPORT_SYMBOL(vfs_iocb_iter_write);
 ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos,
 		       rwf_t flags)
 {
-	int ret;
+	size_t tot_len;
+	ssize_t ret;
 
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+	if (!(file->f_mode & FMODE_CAN_WRITE))
+		return -EINVAL;
 	if (!file->f_op->write_iter)
 		return -EINVAL;
 
+	tot_len = iov_iter_count(iter);
+	if (!tot_len)
+		return 0;
+
+	ret = rw_verify_area(WRITE, file, ppos, tot_len);
+	if (ret < 0)
+		return ret;
+
 	file_start_write(file);
 	ret = do_iter_write(file, iter, ppos, flags);
+	if (ret > 0)
+		fsnotify_modify(file);
 	file_end_write(file);
 
 	return ret;
@@ -934,20 +931,39 @@ static ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 }
 
 static ssize_t vfs_writev(struct file *file, const struct iovec __user *vec,
-		   unsigned long vlen, loff_t *pos, rwf_t flags)
+			  unsigned long vlen, loff_t *pos, rwf_t flags)
 {
 	struct iovec iovstack[UIO_FASTIOV];
 	struct iovec *iov = iovstack;
 	struct iov_iter iter;
-	ssize_t ret;
+	size_t tot_len;
+	ssize_t ret = 0;
 
-	ret = import_iovec(ITER_SOURCE, vec, vlen, ARRAY_SIZE(iovstack), &iov, &iter);
-	if (ret >= 0) {
-		file_start_write(file);
-		ret = do_iter_write(file, &iter, pos, flags);
-		file_end_write(file);
-		kfree(iov);
-	}
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+	if (!(file->f_mode & FMODE_CAN_WRITE))
+		return -EINVAL;
+
+	ret = import_iovec(ITER_SOURCE, vec, vlen, ARRAY_SIZE(iovstack), &iov,
+			   &iter);
+	if (ret < 0)
+		return ret;
+
+	tot_len = iov_iter_count(&iter);
+	if (!tot_len)
+		goto out;
+
+	ret = rw_verify_area(WRITE, file, pos, tot_len);
+	if (ret < 0)
+		goto out;
+
+	file_start_write(file);
+	ret = do_iter_write(file, &iter, pos, flags);
+	if (ret > 0)
+		fsnotify_modify(file);
+	file_end_write(file);
+out:
+	kfree(iov);
 	return ret;
 }
 
-- 
2.34.1

