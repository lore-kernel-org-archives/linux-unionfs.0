Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E51AC433FE
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Nov 2022 02:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiKVCQA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 21:16:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232442AbiKVCP6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2022 21:15:58 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073B8E2203
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:15:57 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id cw4-20020a056a00450400b00561ec04e77aso8505769pfb.12
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2022 18:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JJiNTZDAcyBcjnZ9p/mphnfF01eV5b88yfC5YuUnZmM=;
        b=cfFs8F08u2LB6NT9MopIhiguqfQ7WXtFPUO7m1nt1MVmOu8TptOmISB0P+7KLmTetQ
         Dx6lCs7ljbXbkaXpWqn/sW+iZOX+CNmO7ANeKRWLmvWd0aGdTYHO92RDZ1f/BrwkmBDP
         esLlCvlF97McdXxQ7QmYwruQ2pTwIQx0q70gHeZE2pWIzYszefNf0R6ekyDZrQ3Bt13l
         YT3P4alOgbtMQFtKHuealnqJv7qBSCbl1waS4ud1ps5m+emFEYQ+c1p9be6XzvR0zo+O
         dLPKt+o3ppBSzUto+aIhc/AtAxi6lFKW2dBnHW+Fj58e8ptadwzho1KMyUrjYFPCbA6U
         jTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JJiNTZDAcyBcjnZ9p/mphnfF01eV5b88yfC5YuUnZmM=;
        b=UxvhK/8eBcVmxmD7GCxGQ0Jxk0isX6J3XNyt0kZczlWUUVHUoymmmvomaP5ZBXfymg
         ofaE6Nr+d0vRIP9BrEKsc+iMR0xyRS1+5WXqhswRhq+iCOFU6CSoCFyxXik6yzGx761+
         466xiIN2sj0ZrTbQYP9GFlGWyx6Z2L/3G/o+zEviH+b9VG10ydhbBj0E28Svmd6yFOuf
         ZozYJCknyq+xgz7dxgNkTVSjPw6hNsy0WDrUQvOANVTklewstDdV1jr+7UJ1skWDfHzK
         dtgJnFw1Z2LLj0mp5we8fBrbZN7Iw5/djlAE6Ie+wGks0RtRzmVVUmrUbhj3qN2qnUqy
         cbkg==
X-Gm-Message-State: ANoB5pm2dKynD91LKF65F/csZUI7smJUZ1/lfVJD8/enBYlYwpS9NccX
        nuL9W4A+PoWT1q0tQjGBgr9uINUNFHw=
X-Google-Smtp-Source: AA0mqf73qIstQw2HWTMqtYCCQgojy0QXuvOTHs6hL/WCgKQAuOC6w/AOOmJG1SLeSt+nZlnhLKI8SHSucd4=
X-Received: from drosen.mtv.corp.google.com ([2620:15c:211:200:8539:aadd:13be:6e82])
 (user=drosen job=sendgmr) by 2002:a65:67c5:0:b0:477:76c0:1d13 with SMTP id
 b5-20020a6567c5000000b0047776c01d13mr3165786pgs.55.1669083356254; Mon, 21 Nov
 2022 18:15:56 -0800 (PST)
Date:   Mon, 21 Nov 2022 18:15:16 -0800
In-Reply-To: <20221122021536.1629178-1-drosen@google.com>
Mime-Version: 1.0
References: <20221122021536.1629178-1-drosen@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221122021536.1629178-2-drosen@google.com>
Subject: [RFC PATCH v2 01/21] fs: Generic function to convert iocb to rw flags
From:   Daniel Rosenberg <drosen@google.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@android.com,
        Alessio Balsini <balsini@google.com>,
        Alessio Balsini <balsini@android.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Alessio Balsini <balsini@google.com>

OverlayFS implements its own function to translate iocb flags into rw
flags, so that they can be passed into another vfs call.
With commit ce71bfea207b4 ("fs: align IOCB_* flags with RWF_* flags")
Jens created a 1:1 matching between the iocb flags and rw flags,
simplifying the conversion.

Reduce the OverlayFS code by making the flag conversion function generic
and reusable.

Signed-off-by: Alessio Balsini <balsini@android.com>
---
 fs/overlayfs/file.c | 23 +++++------------------
 include/linux/fs.h  |  5 +++++
 2 files changed, 10 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index a1a22f58ba18..287ae968852a 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -15,6 +15,8 @@
 #include <linux/fs.h>
 #include "overlayfs.h"
 
+#define OVL_IOCB_MASK (IOCB_DSYNC | IOCB_HIPRI | IOCB_NOWAIT | IOCB_SYNC)
+
 struct ovl_aio_req {
 	struct kiocb iocb;
 	refcount_t ref;
@@ -240,22 +242,6 @@ static void ovl_file_accessed(struct file *file)
 	touch_atime(&file->f_path);
 }
 
-static rwf_t ovl_iocb_to_rwf(int ifl)
-{
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
-}
-
 static inline void ovl_aio_put(struct ovl_aio_req *aio_req)
 {
 	if (refcount_dec_and_test(&aio_req->ref)) {
@@ -315,7 +301,8 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	if (is_sync_kiocb(iocb)) {
 		ret = vfs_iter_read(real.file, iter, &iocb->ki_pos,
-				    ovl_iocb_to_rwf(iocb->ki_flags));
+				    iocb_to_rw_flags(iocb->ki_flags,
+						     OVL_IOCB_MASK));
 	} else {
 		struct ovl_aio_req *aio_req;
 
@@ -379,7 +366,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	if (is_sync_kiocb(iocb)) {
 		file_start_write(real.file);
 		ret = vfs_iter_write(real.file, iter, &iocb->ki_pos,
-				     ovl_iocb_to_rwf(ifl));
+				     iocb_to_rw_flags(ifl, OVL_IOCB_MASK));
 		file_end_write(real.file);
 		/* Update size */
 		ovl_copyattr(inode);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e654435f1651..c913106fdd65 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3434,6 +3434,11 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags)
 	return 0;
 }
 
+static inline rwf_t iocb_to_rw_flags(int ifl, int iocb_mask)
+{
+	return ifl & iocb_mask;
+}
+
 static inline ino_t parent_ino(struct dentry *dentry)
 {
 	ino_t res;
-- 
2.38.1.584.g0f3c55d4c2-goog

