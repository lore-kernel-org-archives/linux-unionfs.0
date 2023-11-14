Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC61C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbjKNPdQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbjKNPdN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:13 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E12911F
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:09 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-40906fc54fdso47405175e9.0
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975988; x=1700580788; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EABgM0PGthLo9c3qNgFDIuspwPfs4M2r4qGK2JQEz90=;
        b=fwTyKNSdoTFxjsqlA5Z/D4V8BKJ+qptxzXaJePlQ9KWvCwazlN8G6lxmcs973wCZpH
         YwZcvp/pgbahmIAsKqR+t6oGKGPYE0cu6iD296DAm4L38Az6A5Xe4JUk3n9T1Z42LOQW
         C+5UvTURKs0qmxVgbmBgYaBAb2I5Yk2IJGmG8T+S8vsW4YxnqiRaT9b2q9VuT7QvrO7e
         ZE1rR61tlaModvRF+n+FqDePvz5lCgB/IP7NizVKNlZ7E+q35XWIdcdU/2NhfoCLfXC4
         LlvM9NaxlQMCLjyzfXhkU5ZR3U82ZMVP/doXbSSUUNjzv70W01vloa/QW5fq/aWDPo69
         zyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975988; x=1700580788;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EABgM0PGthLo9c3qNgFDIuspwPfs4M2r4qGK2JQEz90=;
        b=w/LXPxkIwvgqe+xdIK+g4wbok9zJFr4bYobsD3fxGQIE6j9/JPH2WDA1unbTaB9aSa
         JW3EFftu8VOSHjbaJax2qyf5xlCzzzeOkNrKEPKb6u2dSs/TxOcqr65xNpi7XpKUgIjI
         Ztt7O/ODwlk8k7HX43mTJG3bVIR6ClXORiKPDJcvibpePNa3EAy0EzaII4i1XB8653Zu
         7KPQM0DzkJaVdqnUQA5J77+CFrX7MgXPhIchpn34y4xwqoaPnF6ldUK1xInybV7UeB+G
         X6vAcIPr0I2rbcdkBz22eQ0R1GyDvGa+iXAKvxZYQ64tIysCBhSjuifp9/gptMzPnAlV
         kSDw==
X-Gm-Message-State: AOJu0Ywu4W1zVyMW6s36d9dGrcNSjLBRl8mUfWZ+SzeKyGz7OtLLw6w9
        owYGaXMZ6KoamOA9pumjV3Y=
X-Google-Smtp-Source: AGHT+IHAt9WG6qPtyL5hPkGOXGHDVzkYxpCilu3XYuWyITuTTstuEF4dU+GLddEF+OqL+EhpaIdRWA==
X-Received: by 2002:a05:600c:3151:b0:408:4120:bab7 with SMTP id h17-20020a05600c315100b004084120bab7mr6796592wmo.15.1699975987849;
        Tue, 14 Nov 2023 07:33:07 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:07 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 06/15] remap_range: move permission hooks out of do_clone_file_range()
Date:   Tue, 14 Nov 2023 17:32:45 +0200
Message-Id: <20231114153254.1715969-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In many of the vfs helpers, file permission hook is called before
taking sb_start_write(), making them "start-write-safe".
do_clone_file_range() is an exception to this rule.

do_clone_file_range() has two callers - vfs_clone_file_range() and
overlayfs. Move remap_verify_area() checks from do_clone_file_range()
out to vfs_clone_file_range() to make them "start-write-safe".

Overlayfs already has calls to rw_verify_area() with the same security
permission hooks as remap_verify_area() has.
The rest of the checks in remap_verify_area() are irrelevant for
overlayfs that calls do_clone_file_range() offset 0 and positive length.

This is needed for fanotify "pre content" events.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/remap_range.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/remap_range.c b/fs/remap_range.c
index 87ae4f0dc3aa..42f79cb2b1b1 100644
--- a/fs/remap_range.c
+++ b/fs/remap_range.c
@@ -385,14 +385,6 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (!file_in->f_op->remap_file_range)
 		return -EOPNOTSUPP;
 
-	ret = remap_verify_area(file_in, pos_in, len, false);
-	if (ret)
-		return ret;
-
-	ret = remap_verify_area(file_out, pos_out, len, true);
-	if (ret)
-		return ret;
-
 	ret = file_in->f_op->remap_file_range(file_in, pos_in,
 			file_out, pos_out, len, remap_flags);
 	if (ret < 0)
@@ -410,6 +402,14 @@ loff_t vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 {
 	loff_t ret;
 
+	ret = remap_verify_area(file_in, pos_in, len, false);
+	if (ret)
+		return ret;
+
+	ret = remap_verify_area(file_out, pos_out, len, true);
+	if (ret)
+		return ret;
+
 	file_start_write(file_out);
 	ret = do_clone_file_range(file_in, pos_in, file_out, pos_out, len,
 				  remap_flags);
-- 
2.34.1

