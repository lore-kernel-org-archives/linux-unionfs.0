Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04F8FC4167B
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbjKNPdQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233676AbjKNPdO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:14 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C70B93
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:10 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-4083f61322fso44964235e9.1
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975989; x=1700580789; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+iUDFGsO/+8YjOBlEcGZTYITE7ntldQEt+ZaUoKpjOc=;
        b=d4Q7KduJndI6hhENPweHXQq1JKci+S85QF5p+V48VLpgrACYy1KjVvbwUM/57KAAAE
         uBIUbT6j9UH7CVD7qhb4MXI62dJCoI/5yCSLBvxgXwZJHiCvZP762FV7y98scgsFNFA0
         RAwStdofYfJpBmGxJJVzu+ls5u7LiFfUrfbLuo3WccICzdPZBxSCtLE5WNhLNOb5n6l8
         qapetH7MhLyjlfhlZhU+z4kxkZDVwz1IY8h+7rJwH8iofvfffvSakNbU6Q7ZnDWaKTwD
         bJhW4+QqOQ13v5gWrElB2s1MLVicZ/FyMfpAs32YubPRF8nupx5HDvuPXAYhvQz+JV7L
         aM4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975989; x=1700580789;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+iUDFGsO/+8YjOBlEcGZTYITE7ntldQEt+ZaUoKpjOc=;
        b=vFDLpMvTwGVOn70DyOLJ1jc5K+6vlHr0nOqhCW7MxXRdxDSLNxq+N13oT9OD7PBtKV
         Y9hgYqkmGWIxkveuE1t2SaXjEH49il/0pYsrbwP2VgNeQFI9vuTOCEwxCjfTrYokKqwS
         DVi1xA+jJhvIXZFhCo7TsZ9wfz8xHwn7EieZvR4pRq7h+6M+Mp6Uz2fkuMqWU56orjm1
         /JL+7sQrMfNGTBYLspfKPisQt3BX0kbKGnPKOLACPOXe/9XiU2zygJQdbLxV+GmbeKVz
         I6oXBPDipjC9fz2sFY/NGfXg1ead6Z7pPl74ReO3Mtnk8bpURQWyT9v4nDueK1KRav4Q
         pSOQ==
X-Gm-Message-State: AOJu0YyD/Pm13KSN9x4PuGf7aKbJOTxYQ7k80aWUgci9C2bZxyHWFxMI
        vM1T7CbSnQyqNgUV4J+9SHk=
X-Google-Smtp-Source: AGHT+IFh3kqhJ0SHdCaPp1ItY6fkF5o5om2VtKgPnALw9iq+gMtXi2UpXsrq9kvoeK9qsDjShQmIkw==
X-Received: by 2002:a1c:7915:0:b0:408:3bbd:4a82 with SMTP id l21-20020a1c7915000000b004083bbd4a82mr6594810wme.15.1699975988922;
        Tue, 14 Nov 2023 07:33:08 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:08 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 07/15] remap_range: move file_start_write() to after permission hook
Date:   Tue, 14 Nov 2023 17:32:46 +0200
Message-Id: <20231114153254.1715969-8-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In vfs code, file_start_write() is usually called after the permission
hook in rw_verify_area().  vfs_dedupe_file_range_one() is an exception
to this rule.

In vfs_dedupe_file_range_one(), move file_start_write() to after the
the rw_verify_area() checks to make them "start-write-safe".

This is needed for fanotify "pre content" events.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/remap_range.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/remap_range.c b/fs/remap_range.c
index 42f79cb2b1b1..de4b09d0ba1d 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -445,46 +445,40 @@ loff_t vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	WARN_ON_ONCE(remap_flags & ~(REMAP_FILE_DEDUP |
 				     REMAP_FILE_CAN_SHORTEN));
 
-	ret = mnt_want_write_file(dst_file);
-	if (ret)
-		return ret;
-
 	/*
 	 * This is redundant if called from vfs_dedupe_file_range(), but other
 	 * callers need it and it's not performance sesitive...
 	 */
 	ret = remap_verify_area(src_file, src_pos, len, false);
 	if (ret)
-		goto out_drop_write;
+		return ret;
 
 	ret = remap_verify_area(dst_file, dst_pos, len, true);
 	if (ret)
-		goto out_drop_write;
+		return ret;
 
-	ret = -EPERM;
 	if (!allow_file_dedupe(dst_file))
-		goto out_drop_write;
+		return -EPERM;
 
-	ret = -EXDEV;
 	if (file_inode(src_file)->i_sb != file_inode(dst_file)->i_sb)
-		goto out_drop_write;
+		return -EXDEV;
 
-	ret = -EISDIR;
 	if (S_ISDIR(file_inode(dst_file)->i_mode))
-		goto out_drop_write;
+		return -EISDIR;
 
-	ret = -EINVAL;
 	if (!dst_file->f_op->remap_file_range)
-		goto out_drop_write;
+		return -EINVAL;
 
-	if (len == 0) {
-		ret = 0;
-		goto out_drop_write;
-	}
+	if (len == 0)
+		return 0;
+
+	ret = mnt_want_write_file(dst_file);
+	if (ret)
+		return ret;
 
 	ret = dst_file->f_op->remap_file_range(src_file, src_pos, dst_file,
 			dst_pos, len, remap_flags | REMAP_FILE_DEDUP);
-out_drop_write:
+
 	mnt_drop_write_file(dst_file);
 
 	return ret;
-- 
2.34.1

