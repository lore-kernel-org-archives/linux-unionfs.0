Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12CC6C4167D
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbjKNPdK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233660AbjKNPdK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:10 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBAB893
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:06 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id 38308e7fff4ca-2c7420d5a83so72976131fa.0
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975985; x=1700580785; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLHuuySI0a2thaSwrbe14268iMRgl+oSJWzW6vzbqSY=;
        b=iGzQsDqEIPPXNdLqI4yTD2mVh7f+orpYTJ5Zza6wUiiazOTscjrwIbXbSCO7dlHFEK
         MWmf29Ab7cL6gJLQprsna93Rj8CGAJ3dcjNPa7XK1OeayzjJsWw8dXf1wZLH2pl1RTYQ
         m2YDaGSpufsU0s15rPQ2uoCDtAnMacFPSGo1orN8eSVNlSdkz4hX9BG2MKrtyeyh+LIB
         GA4v9NDjnOKNcboUdmmSHUvWi0F8xJTfj7HKBMgXWIQxuk+NdwDL3sdmXcVKTlKOrQpM
         ee9Cpg7ODiHcx7+0ER7qMuAfYpG+l9DFqPX/hGEC6Yt/+fEGRJbViH5F0W26usXLMTfB
         irqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975985; x=1700580785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TLHuuySI0a2thaSwrbe14268iMRgl+oSJWzW6vzbqSY=;
        b=SGGY9tRWp92KSFB5z4NWOp+QXkK4mPLp+2VSk2rK8Uwao23gz7LZYa7kNnmMtf3oKJ
         PpFHxCFvq3Rwtk5Wlmu1rFVYZ+fnm0txeMlvnq+kOKwU83TJOx4ujSMNHNOYMxIUcPOc
         bfW79Q7uQ7ZDdRDDnpNN4GC+6huCT0HNWFk9vvSRyoFCanI14cDHB4Hhx1px6znG8z8N
         mLMrT+t4Y63whoInLEs3Z5kMieeCVpYaCO9rBykyNHLPlu30TnejRvEMy01EPY+ENdMU
         bV5mNOyRfK7K0MU9cCgpA39o7wQhulaeQ+d6H9OreYuHcDonSF4JYnDy1tDm2Jw5qcIe
         cQew==
X-Gm-Message-State: AOJu0Yx8rDVPX3Xdg+NHZBi4OqbrKVgV/te4b0eItaiMmzHBTKZXWk2p
        kEYST68YiZHIRPXyV4ZRrJGBaHSVfxA=
X-Google-Smtp-Source: AGHT+IHbJ8ZsSNkW0qHNhQouHBn8r9hSfoML7ImFre1YIBjgVoZyf7j/xeK2m5ncTmLfMEsfCYHQAA==
X-Received: by 2002:a2e:8244:0:b0:2c5:11e7:6d20 with SMTP id j4-20020a2e8244000000b002c511e76d20mr1844041ljh.35.1699975984853;
        Tue, 14 Nov 2023 07:33:04 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:04 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 04/15] splice: move permission hook out of splice_file_to_pipe()
Date:   Tue, 14 Nov 2023 17:32:43 +0200
Message-Id: <20231114153254.1715969-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

vfs_splice_read() has a permission hook inside rw_verify_area() and
it is called from splice_file_to_pipe(), which is called from
do_splice() and do_sendfile().

do_sendfile() already has a rw_verify_area() check for the entire range.
do_splice() has a rw_verify_check() for the splice to file case, not for
the splice from file case.

Add the rw_verify_area() check for splice from file case in do_splice()
and use a variant of vfs_splice_read() without rw_verify_area() check
in splice_file_to_pipe() to avoid the redundant rw_verify_area() checks.

This is needed for fanotify "pre content" events.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/splice.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/splice.c b/fs/splice.c
index 6fc2c27e9520..d4fdd44c0b32 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1239,7 +1239,7 @@ long splice_file_to_pipe(struct file *in,
 	pipe_lock(opipe);
 	ret = wait_for_space(opipe, flags);
 	if (!ret)
-		ret = vfs_splice_read(in, offset, opipe, len, flags);
+		ret = do_splice_read(in, offset, opipe, len, flags);
 	pipe_unlock(opipe);
 	if (ret > 0)
 		wakeup_pipe_readers(opipe);
@@ -1316,6 +1316,10 @@ long do_splice(struct file *in, loff_t *off_in, struct file *out,
 			offset = in->f_pos;
 		}
 
+		ret = rw_verify_area(READ, in, &offset, len);
+		if (unlikely(ret < 0))
+			return ret;
+
 		if (out->f_flags & O_NONBLOCK)
 			flags |= SPLICE_F_NONBLOCK;
 
-- 
2.34.1

