Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2DCC4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbjKNPdJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbjKNPdI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:08 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA25113
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:05 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-4079ed65582so45347505e9.1
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975983; x=1700580783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wPwJl4K8BEEQFhYjexDs/LBFmYBnhVlIJcHUn2gLmag=;
        b=dKn0TrU+UCikPLLLDBMgR4+tyakeyd0jjgHu0AIiibmCp2V8W/7pYilj2NpQ6YL+wt
         i7zt/Hy8uRW9kpg41oWeuffJQ3UB7I/HjVCalFjltVRnlpJv1ufl18TXTwtywbnpbhNI
         R/yUlV6aVbN/Nzdy+z1ZbwDg3+bR+EfKmA3BPX8h75T6NZKpQhTYNamrtI+u0FDRyjnh
         gFsKuiZXFKqAonMyTuHOV5l8+jLJ0pmGtQJUkUa1m+Bvf+51kl+5SoEaJdZuaY5ujgqq
         pvX2J6WjWcKLCKS3zzMuWiw0dWQdIW2wzYJxOkU5y0rYTx29DNkt6AVUTDNyN27/hdws
         N3Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975983; x=1700580783;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wPwJl4K8BEEQFhYjexDs/LBFmYBnhVlIJcHUn2gLmag=;
        b=QbVoZz0ucUl+ZYOlBC1+6ot0byM7ppdy1poYzJiYYf957VoWuisyPdZH3M98yZlYd+
         p5oMKqCAlBVMSvp7TDxoRX0hcnHI7ckmMOsb9v7Bo6OYgoOeXnedH9OCrh7/pdlPZQCm
         F4E5nIPWtzPCwrlVjmQcClExp1y3z8wYFHwW30MdM0VcGDrjESWAg8yFgx8FIo2/UOyR
         veabpXq3M2CXvoGsa03G2Xql+aHCKb21j9k3r5bHX8Hz3Ex753lSefsKOKjjjdjFJJST
         PTQMc0Scy712Vko7VXwunZQ21Xg3XdwFrDbiWuVwZZiBkyL4+qdC87cOzjF1+M10D0zN
         2DBA==
X-Gm-Message-State: AOJu0YymXoq7C4vggcaVmu+5Bcti67YzuL5UNJglwuGahOTK9KZ6DOmt
        4+h/9cfMEGvo8LHKXLATyW8=
X-Google-Smtp-Source: AGHT+IEjp7Eug2HOkqXYqZq4GyaONsAQ6GlaYNG14+5X45yaLGXqEyjKoLTEJOF3a8oMdxrxKXxK9Q==
X-Received: by 2002:a05:600c:3b9f:b0:408:3c8f:afd9 with SMTP id n31-20020a05600c3b9f00b004083c8fafd9mr7527647wms.3.1699975983539;
        Tue, 14 Nov 2023 07:33:03 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:02 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 03/15] splice: move permission hook out of splice_direct_to_actor()
Date:   Tue, 14 Nov 2023 17:32:42 +0200
Message-Id: <20231114153254.1715969-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

vfs_splice_read() has a permission hook inside rw_verify_area() and
it is called from do_splice_direct() -> splice_direct_to_actor().

The callers of do_splice_direct() (e.g. vfs_copy_file_range()) already
call rw_verify_area() for the entire range, but the other caller of
splice_direct_to_actor() (nfsd) does not.

Add the rw_verify_area() checks in nfsd_splice_read() and use a
variant of vfs_splice_read() without rw_verify_area() check in
splice_direct_to_actor() to avoid the redundant rw_verify_area() checks.

This is needed for fanotify "pre content" events.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/nfsd/vfs.c |  5 ++++-
 fs/splice.c   | 58 +++++++++++++++++++++++++++++++--------------------
 2 files changed, 39 insertions(+), 24 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index fbbea7498f02..5d704461e3b4 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1046,7 +1046,10 @@ __be32 nfsd_splice_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	ssize_t host_err;
 
 	trace_nfsd_read_splice(rqstp, fhp, offset, *count);
-	host_err = splice_direct_to_actor(file, &sd, nfsd_direct_splice_actor);
+	host_err = rw_verify_area(READ, file, &offset, *count);
+	if (!host_err)
+		host_err = splice_direct_to_actor(file, &sd,
+						  nfsd_direct_splice_actor);
 	return nfsd_finish_read(rqstp, fhp, file, offset, count, eof, host_err);
 }
 
diff --git a/fs/splice.c b/fs/splice.c
index 6e917db6f49a..6fc2c27e9520 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -944,27 +944,15 @@ static void do_splice_eof(struct splice_desc *sd)
 		sd->splice_eof(sd);
 }
 
-/**
- * vfs_splice_read - Read data from a file and splice it into a pipe
- * @in:		File to splice from
- * @ppos:	Input file offset
- * @pipe:	Pipe to splice to
- * @len:	Number of bytes to splice
- * @flags:	Splice modifier flags (SPLICE_F_*)
- *
- * Splice the requested amount of data from the input file to the pipe.  This
- * is synchronous as the caller must hold the pipe lock across the entire
- * operation.
- *
- * If successful, it returns the amount of data spliced, 0 if it hit the EOF or
- * a hole and a negative error code otherwise.
+/*
+ * Callers already called rw_verify_area() on the entire range.
+ * No need to call it for sub ranges.
  */
-long vfs_splice_read(struct file *in, loff_t *ppos,
-		     struct pipe_inode_info *pipe, size_t len,
-		     unsigned int flags)
+static long do_splice_read(struct file *in, loff_t *ppos,
+			   struct pipe_inode_info *pipe, size_t len,
+			   unsigned int flags)
 {
 	unsigned int p_space;
-	int ret;
 
 	if (unlikely(!(in->f_mode & FMODE_READ)))
 		return -EBADF;
@@ -975,10 +963,6 @@ long vfs_splice_read(struct file *in, loff_t *ppos,
 	p_space = pipe->max_usage - pipe_occupancy(pipe->head, pipe->tail);
 	len = min_t(size_t, len, p_space << PAGE_SHIFT);
 
-	ret = rw_verify_area(READ, in, ppos, len);
-	if (unlikely(ret < 0))
-		return ret;
-
 	if (unlikely(len > MAX_RW_COUNT))
 		len = MAX_RW_COUNT;
 
@@ -992,6 +976,34 @@ long vfs_splice_read(struct file *in, loff_t *ppos,
 		return copy_splice_read(in, ppos, pipe, len, flags);
 	return in->f_op->splice_read(in, ppos, pipe, len, flags);
 }
+
+/**
+ * vfs_splice_read - Read data from a file and splice it into a pipe
+ * @in:		File to splice from
+ * @ppos:	Input file offset
+ * @pipe:	Pipe to splice to
+ * @len:	Number of bytes to splice
+ * @flags:	Splice modifier flags (SPLICE_F_*)
+ *
+ * Splice the requested amount of data from the input file to the pipe.  This
+ * is synchronous as the caller must hold the pipe lock across the entire
+ * operation.
+ *
+ * If successful, it returns the amount of data spliced, 0 if it hit the EOF or
+ * a hole and a negative error code otherwise.
+ */
+long vfs_splice_read(struct file *in, loff_t *ppos,
+		     struct pipe_inode_info *pipe, size_t len,
+		     unsigned int flags)
+{
+	int ret;
+
+	ret = rw_verify_area(READ, in, ppos, len);
+	if (unlikely(ret < 0))
+		return ret;
+
+	return do_splice_read(in, ppos, pipe, len, flags);
+}
 EXPORT_SYMBOL_GPL(vfs_splice_read);
 
 /**
@@ -1066,7 +1078,7 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
 		size_t read_len;
 		loff_t pos = sd->pos, prev_pos = pos;
 
-		ret = vfs_splice_read(in, &pos, pipe, len, flags);
+		ret = do_splice_read(in, &pos, pipe, len, flags);
 		if (unlikely(ret <= 0))
 			goto read_failure;
 
-- 
2.34.1

