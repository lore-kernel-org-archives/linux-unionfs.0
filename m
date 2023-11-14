Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77944C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233683AbjKNPdV (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbjKNPdU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:20 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F4AED
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:17 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-40806e4106dso34122455e9.1
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975995; x=1700580795; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkFHZx+vlTxfUH8YeTgoGB/M3KXXCxOMDvqz9lQaF+E=;
        b=nISsILOYzHLvRYViv/H4v3DGMVsxAKBddi0dFmit7ROvbBBprSTSBNbC7V2rixGt52
         LHisRmQbn4tQ0gORZ5MJ0pPBLW8NCQDHaXApHQZ558toO0+SyPFfxX1u9SS/+Ddna7hS
         ssfEY5IHBcPoLTGeUgVx5e5dStP2jSuFmrOvnJFOvWJHTqJxjqPiYkjn8+m5SuG0yaaC
         956b14oU+AiJR/Z+UUoE3Gt5KG4B0oMoQi8T4NmrVxqhis5D6sfnqOeMxEgXxF+zlhWh
         3eie4hrQNf2WP4RKg50cQXDsxRlenCuTuKfK1g2Hgw4vGzbsh67yjCbeMAF28QLdfCq4
         tjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975995; x=1700580795;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkFHZx+vlTxfUH8YeTgoGB/M3KXXCxOMDvqz9lQaF+E=;
        b=KV0b8ov0DIPY2lKrk6CZ9io0sE/mimcliI0v5w0OC24HhAh/tbgKrgmf4j1OXFCzFT
         20uIOaEHmCyJ7YhDmglFa65kOrMs8+f87r/LKdYQXIHklKXIWxYg/G58vvVrfyaKmgTW
         bdZeo9xNZ41F4ZREwiGOaNSM7QAZ1jTvx0mu34iBW5D1qIoUgQnLTJgPMuhpPTneGYDh
         8JSoiyYR8bPg+3NGDsofissDHLso88jlGpRzCMB9rWc3IR5ulc7WNg9rmh5x5N9f5aHE
         pzJpHE3GUnn1nm0SdK+E3bEEgdjeCt1rIBD7gIFsy0z25HAU1A9GxImip5iLGGZjDu4C
         EpDw==
X-Gm-Message-State: AOJu0YwdxcREbZD9MImCw04rSpp0u/6NTTlDvoKd5MAyJb+Oz6Gv0Zm+
        NbIZbvtsMYc05hkdipH2wnk=
X-Google-Smtp-Source: AGHT+IGxZ0aXMXxMrWdnSXwOPS4DSV/E8GKLBgMh/llJD3nxH+NwSpijGZTFXwTiOzmRGFSyrXVrWQ==
X-Received: by 2002:a05:600c:a12:b0:405:3ab3:e640 with SMTP id z18-20020a05600c0a1200b004053ab3e640mr2424151wmp.20.1699975995246;
        Tue, 14 Nov 2023 07:33:15 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:14 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Jan Kara <jack@suse.cz>
Subject: [PATCH 12/15] fs: move kiocb_start_write() into vfs_iocb_iter_write()
Date:   Tue, 14 Nov 2023 17:32:51 +0200
Message-Id: <20231114153254.1715969-13-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In vfs code, sb_start_write() is usually called after the permission hook
in rw_verify_area().  vfs_iocb_iter_write() is an exception to this rule,
where kiocb_start_write() is called by its callers.

Move kiocb_start_write() from the callers into vfs_iocb_iter_write()
after the rw_verify_area() checks, to make them "start-write-safe".

This is needed for fanotify "pre content" events.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/cachefiles/io.c  | 2 --
 fs/overlayfs/file.c | 1 -
 fs/read_write.c     | 2 ++
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/cachefiles/io.c b/fs/cachefiles/io.c
index 009d23cd435b..3d3667807636 100644
--- a/fs/cachefiles/io.c
+++ b/fs/cachefiles/io.c
@@ -319,8 +319,6 @@ int __cachefiles_write(struct cachefiles_object *object,
 		ki->iocb.ki_complete = cachefiles_write_complete;
 	atomic_long_add(ki->b_writing, &cache->b_writing);
 
-	kiocb_start_write(&ki->iocb);
-
 	get_file(ki->iocb.ki_filp);
 	cachefiles_grab_object(object, cachefiles_obj_get_ioreq);
 
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 690b173f34fc..2adf3a5641cd 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -456,7 +456,6 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		aio_req->iocb.ki_flags = ifl;
 		aio_req->iocb.ki_complete = ovl_aio_queue_completion;
 		refcount_set(&aio_req->ref, 2);
-		kiocb_start_write(&aio_req->iocb);
 		ret = vfs_iocb_iter_write(real.file, &aio_req->iocb, iter);
 		ovl_aio_put(aio_req);
 		if (ret != -EIOCBQUEUED)
diff --git a/fs/read_write.c b/fs/read_write.c
index 5b18e13c2620..8d381929701c 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -854,6 +854,7 @@ static ssize_t do_iter_write(struct file *file, struct iov_iter *iter,
 		return do_loop_readv_writev(file, iter, pos, WRITE, flags);
 }
 
+/* Caller is responsible for calling kiocb_end_write() on completion */
 ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
 			    struct iov_iter *iter)
 {
@@ -874,6 +875,7 @@ ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
 	if (ret < 0)
 		return ret;
 
+	kiocb_start_write(iocb);
 	ret = call_write_iter(file, iocb, iter);
 	if (ret > 0)
 		fsnotify_modify(file);
-- 
2.34.1

