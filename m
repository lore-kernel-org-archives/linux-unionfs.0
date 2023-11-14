Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55C3FC41535
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjKNPdR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbjKNPdQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:16 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B24512F
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:13 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-40859dee28cso47671695e9.0
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975991; x=1700580791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQtkuR/iZsmuEMlTPtAT3Yz8z3F19r7J47t6Nq7MaQQ=;
        b=FWT5CX/y68VbFnrm5jILlQS+15z5zksz6QxuAhTUXL62HlSONZeQ4BrNbSR1/Cczu5
         qbY4RTM9GCJLikS/a7NP9SldCSvRqwediBozb30jHmkjpcF2BhNhK+cP+cLmesInIXsM
         ktQAzRqHCV1JJufhNEUjrAwO1bwWBBrkEOWzolqEV1MKJ3JQd4atd4/dFqb9sHeGXG2R
         lXuqMslJeQwRye2NnxQIGgZP7jAIze6t/XBKgL3izZ25NBodC4j0tYGoZbINQxx0to8Q
         cQsVGTw/fWeyUEXtDJO8WiB6kM52B24J5OWsg/d4LsEYG9h7FfbSdjue0JvjkVqRJPmp
         TH1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975991; x=1700580791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kQtkuR/iZsmuEMlTPtAT3Yz8z3F19r7J47t6Nq7MaQQ=;
        b=i1lq0ebH+M/71PYJ2H/+Mp1IFq8AgO1/iKDbczZOSS/24NJEv0+uUXXgROv6LMUl8F
         D0P8INlCO9X2PdXbNGraRnjXkWSFbrVbt2/fTQRv/3tCRbDUtM743K/Isb7QhT/Sbguv
         VzK84tRwV1vHEVrnhmZjM5hl/ImI98XA0OZ14Uh50hab9qm89922IiDwJiJmApI9FzK9
         zBLygFZGy7WnUdTdUIHvjfjY3propEX7mKBwPxImFWOffe/F9KmcEMgWLgx/BSx5WFr4
         DF1uMpoUYx2Efmi/LsPKxbIuBkK+AWVuDnqFluMV3ZMEvo9hu/bHiWWsnrJEhtGWiW0v
         tZxw==
X-Gm-Message-State: AOJu0Yzr8E/POUdDboIFH+npi0AEq4kws9BFWjda4jFCC0DqGI+Z16NK
        AYHc006AU3HZNVO2j/r+LXE=
X-Google-Smtp-Source: AGHT+IGgwkdtnA/tSGAiT4E/L+2DKfU3drcUeBpS/lCdDJJ/ouzQPBucsAgLUEGk9m/NiKHBbkE7pw==
X-Received: by 2002:a05:600c:3ca2:b0:405:3a3d:6f53 with SMTP id bg34-20020a05600c3ca200b004053a3d6f53mr7958973wmb.3.1699975991585;
        Tue, 14 Nov 2023 07:33:11 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:11 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Jan Harkes <jaharkes@cs.cmu.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 09/15] fs: move file_start_write() into vfs_iter_write()
Date:   Tue, 14 Nov 2023 17:32:48 +0200
Message-Id: <20231114153254.1715969-10-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

All the callers of vfs_iter_write() call file_start_write() just before
calling vfs_iter_write() except for target_core_file's fd_do_rw().

Move file_start_write() from the callers into vfs_iter_write().
fd_do_rw() calls vfs_iter_write() with a non-regular file, so
file_start_write() is a no-op.

This is needed for fanotify "pre content" events.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 drivers/block/loop.c |  2 --
 fs/coda/file.c       |  4 +---
 fs/nfsd/vfs.c        |  2 --
 fs/overlayfs/file.c  |  2 --
 fs/read_write.c      | 13 ++++++++++---
 5 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 9f2d412fc560..8a8cd4fc9238 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -245,9 +245,7 @@ static int lo_write_bvec(struct file *file, struct bio_vec *bvec, loff_t *ppos)
 
 	iov_iter_bvec(&i, ITER_SOURCE, bvec, 1, bvec->bv_len);
 
-	file_start_write(file);
 	bw = vfs_iter_write(file, &i, ppos, 0);
-	file_end_write(file);
 
 	if (likely(bw ==  bvec->bv_len))
 		return 0;
diff --git a/fs/coda/file.c b/fs/coda/file.c
index 16acc58311ea..7c84555c8923 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -79,14 +79,12 @@ coda_file_write_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (ret)
 		goto finish_write;
 
-	file_start_write(host_file);
 	inode_lock(coda_inode);
-	ret = vfs_iter_write(cfi->cfi_container, to, &iocb->ki_pos, 0);
+	ret = vfs_iter_write(host_file, to, &iocb->ki_pos, 0);
 	coda_inode->i_size = file_inode(host_file)->i_size;
 	coda_inode->i_blocks = (coda_inode->i_size + 511) >> 9;
 	inode_set_mtime_to_ts(coda_inode, inode_set_ctime_current(coda_inode));
 	inode_unlock(coda_inode);
-	file_end_write(host_file);
 
 finish_write:
 	venus_access_intent(coda_inode->i_sb, coda_i2f(coda_inode),
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 5d704461e3b4..35c9546b3396 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1186,9 +1186,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	since = READ_ONCE(file->f_wb_err);
 	if (verf)
 		nfsd_copy_write_verifier(verf, nn);
-	file_start_write(file);
 	host_err = vfs_iter_write(file, &iter, &pos, flags);
-	file_end_write(file);
 	if (host_err < 0) {
 		commit_reset_write_verifier(nn, rqstp, host_err);
 		goto out_nfserr;
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 131621daeb13..690b173f34fc 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -436,9 +436,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (is_sync_kiocb(iocb)) {
 		rwf_t rwf = iocb_to_rw_flags(ifl);
 
-		file_start_write(real.file);
 		ret = vfs_iter_write(real.file, iter, &iocb->ki_pos, rwf);
-		file_end_write(real.file);
 		/* Update size */
 		ovl_file_modified(file);
 	} else {
diff --git a/fs/read_write.c b/fs/read_write.c
index 590ab228fa98..8cdc6e6a9639 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -846,7 +846,7 @@ ssize_t vfs_iter_read(struct file *file, struct iov_iter *iter, loff_t *ppos,
 EXPORT_SYMBOL(vfs_iter_read);
 
 static ssize_t do_iter_write(struct file *file, struct iov_iter *iter,
-		loff_t *pos, rwf_t flags)
+			     loff_t *pos, rwf_t flags)
 {
 	size_t tot_len;
 	ssize_t ret = 0;
@@ -901,11 +901,18 @@ ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
 EXPORT_SYMBOL(vfs_iocb_iter_write);
 
 ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos,
-		rwf_t flags)
+		       rwf_t flags)
 {
+	int ret;
+
 	if (!file->f_op->write_iter)
 		return -EINVAL;
-	return do_iter_write(file, iter, ppos, flags);
+
+	file_start_write(file);
+	ret = do_iter_write(file, iter, ppos, flags);
+	file_end_write(file);
+
+	return ret;
 }
 EXPORT_SYMBOL(vfs_iter_write);
 
-- 
2.34.1

