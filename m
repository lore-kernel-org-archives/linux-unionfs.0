Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75638C4167D
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Nov 2023 15:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbjKNPdR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Nov 2023 10:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbjKNPdO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Nov 2023 10:33:14 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2D89127
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:11 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-4084095722aso47582145e9.1
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Nov 2023 07:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699975990; x=1700580790; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yLj8uITMaHbDVaMNTE6BTJPGFIjLXPD3jxdcRTn/PUQ=;
        b=F0K7NgCSjdhZgSzPzN5Y5dS5Fqizb75i2TE8xJ6wPVAKGW6k0Na5+ClXQnRfhU6Y3j
         9sx2ohTeRYBNKge/JD0YfxuBGA7QqOgchRX4vF72LDfyX93pQWTPsLFHid9fmR7w1HEW
         F8iij3P2/pC7ISwvUVcASv1ruwNaaBUlI3j2pQMvYMOxj5xWVIe53DpqJxYrXNn2t892
         79HxWiBDEhQDnaLED5+WcUkrdx8V7wY3zHNuK48j2ilC3libcvgcvIEsd0PW2ijCdjgg
         Lpop8wBEZFVxtxe9akwxlOpLbHkUeRggsTibGFNqxTGuEQp9KLLnd5Z24C4YZdAIcprZ
         cOQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975990; x=1700580790;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yLj8uITMaHbDVaMNTE6BTJPGFIjLXPD3jxdcRTn/PUQ=;
        b=IIRIKuCt7bk1Lfd8N6VeArVNkCwRBrfkBBUe16ZtttG05pK01XuOWIMiWkKkp56xWM
         50PjnayHofWXBLTQ0vMWg1X/WumcoO+BIYdY/EaXOWDsn2QMsYqDTD6yTh7LmM92s8Uh
         80emDVZKKvi8dgCOqxxV3r+0eJMeYZJyfz8O3TF1pwfJ0wGpibKgESWkANeyio7NTVwZ
         JOM05vlsaqn8TMgEikNvVRdQg1dX/7gbOIv4OTfLoqj0fjuLvCZyzySHQlop46HUhCvd
         aeeLJHXQ+3V2X2w6q9jypT4REdRSeG6sKzAPo+WBi/6n335ra0RbSgBngexXbdIpGo5/
         QrRQ==
X-Gm-Message-State: AOJu0YwWvkcMYXUXUZoi+3AXb87FZ2pm7sAH8tnO/myvMqWTbT9kyAWT
        DMfUs6tgbWv0BrbLJoZVqxA=
X-Google-Smtp-Source: AGHT+IGe2UmBKdphh+sA9xTFEZXVjOWWMokbKCkCqvDIO6e2R6OlB7mS9D+KAgoYmtOyxzMDYPqJnQ==
X-Received: by 2002:a05:600c:1c1b:b0:409:19a0:d26f with SMTP id j27-20020a05600c1c1b00b0040919a0d26fmr7560748wms.23.1699975990215;
        Tue, 14 Nov 2023 07:33:10 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id i10-20020a05600c354a00b004053e9276easm17824505wmq.32.2023.11.14.07.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Nov 2023 07:33:09 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: [PATCH 08/15] btrfs: move file_start_write() to after permission hook
Date:   Tue, 14 Nov 2023 17:32:47 +0200
Message-Id: <20231114153254.1715969-9-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231114153254.1715969-1-amir73il@gmail.com>
References: <20231114153254.1715969-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In vfs code, file_start_write() is usually called after the permission
hook in rw_verify_area().  btrfs_ioctl_encoded_write() in an exception
to this rule.

Move file_start_write() to after the rw_verify_area() check in encoded
write to make the permission hook "start-write-safe".

This is needed for fanotify "pre content" events.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/btrfs/ioctl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 752acff2c734..e691770c25aa 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -4523,29 +4523,29 @@ static int btrfs_ioctl_encoded_write(struct file *file, void __user *argp, bool
 	if (ret < 0)
 		goto out_acct;
 
-	file_start_write(file);
-
 	if (iov_iter_count(&iter) == 0) {
 		ret = 0;
-		goto out_end_write;
+		goto out_iov;
 	}
 	pos = args.offset;
 	ret = rw_verify_area(WRITE, file, &pos, args.len);
 	if (ret < 0)
-		goto out_end_write;
+		goto out_iov;
 
 	init_sync_kiocb(&kiocb, file);
 	ret = kiocb_set_rw_flags(&kiocb, 0);
 	if (ret)
-		goto out_end_write;
+		goto out_iov;
 	kiocb.ki_pos = pos;
 
+	file_start_write(file);
+
 	ret = btrfs_do_write_iter(&kiocb, &iter, &args);
 	if (ret > 0)
 		fsnotify_modify(file);
 
-out_end_write:
 	file_end_write(file);
+out_iov:
 	kfree(iov);
 out_acct:
 	if (ret > 0)
-- 
2.34.1

