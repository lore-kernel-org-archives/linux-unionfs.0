Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E165EC2D0E4
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Nov 2020 09:21:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 954C5206D9
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Nov 2020 09:21:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="BvVHKFHm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728114AbgK0JVP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 27 Nov 2020 04:21:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgK0JVO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Nov 2020 04:21:14 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAF2CC0613D4
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Nov 2020 01:21:14 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id v21so2389212plo.12
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Nov 2020 01:21:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=okmQhfPLGgBjgjZXbAm+aIoWMwXVsIOZ9BcK51UFRVI=;
        b=BvVHKFHm+5yavD2kii5ezOno5mhVTxOxRqvPhwq2ZnepF4QcmilndtgKa4E4XKjivE
         QKdejxSbJlfZ/cy5wfV7pZTIzrVmELPefTzuRmRzPrquEAGqCyBYaDRE9+vLPHnPRa5h
         SCjMvFlBWRuy4HEG7ld/MUhxYm0Ai0wz7nBok=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=okmQhfPLGgBjgjZXbAm+aIoWMwXVsIOZ9BcK51UFRVI=;
        b=pfkRIq2idcKtpv68IBZ3Bc4ZLXiSHx0Vx8tMk8tJ3jJ9onLfH096+Gyy6bS0U10SUW
         WjnZcZyr6bF8W9IuOAiMd0yuYJUr0lqIYD9MPX893Z9LSQMFQqE1jOWSaxWeFswHn9KX
         GmmU0BjDHvl9h88We5k7DzZZ2wCeDLjG3tjf1JrIlQso+3Vc8G5S6ZpeUm9kT2mBRP58
         xrADQVtaNVic2RvBzNRO8oMn9KGDDiYf8gELQ7Rk/RZ5CAcJeRVahH5bqOZdz3yvbTrm
         MPWNK7gJxNFbUxESHhJ8MuowxJvTcK94WVCfqMUmgMusF5HxR6kqLZx8Qg3opek+skKo
         AlsA==
X-Gm-Message-State: AOAM533HMk6dq00N8aK4wUdLZ8GxEeiD3FjkgYDkFNzuk6N+78SIFBSv
        i5NwYaMioHoq8wZsv75AoayzSgjtbX+Bag==
X-Google-Smtp-Source: ABdhPJxQVST1I6ABrDukfZAWfDWDJtHcCtYIHhwxiksn57cMXHQkRbzCSL6dkDHbM45XS3PnXYrN7A==
X-Received: by 2002:a17:902:8f82:b029:da:23e0:17d7 with SMTP id z2-20020a1709028f82b02900da23e017d7mr6225058plo.37.1606468873951;
        Fri, 27 Nov 2020 01:21:13 -0800 (PST)
Received: from ubuntu.netflix.com (203.20.25.136.in-addr.arpa. [136.25.20.203])
        by smtp.gmail.com with ESMTPSA id t9sm9938944pjq.46.2020.11.27.01.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 01:21:13 -0800 (PST)
From:   Sargun Dhillon <sargun@sargun.me>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     Sargun Dhillon <sargun@sargun.me>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH v2 4/4] overlay: Add rudimentary checking of writeback errseq on volatile remount
Date:   Fri, 27 Nov 2020 01:20:58 -0800
Message-Id: <20201127092058.15117-5-sargun@sargun.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201127092058.15117-1-sargun@sargun.me>
References: <20201127092058.15117-1-sargun@sargun.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Volatile remounts validate the following at the moment:
 * Has the module been reloaded / the system rebooted
 * Has the workdir been remounted

This adds a new check for errors detected via the superblock's
errseq_t. At mount time, the errseq_t is snapshotted to disk,
and upon remount it's re-verified. This allows for kernel-level
detection of errors without forcing userspace to perform a
sync and allows for the hidden detection of writeback errors.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/overlayfs.h | 1 +
 fs/overlayfs/readdir.c   | 6 ++++++
 fs/overlayfs/super.c     | 1 +
 3 files changed, 8 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index de694ee99d7c..e8a711953b64 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -85,6 +85,7 @@ struct ovl_volatile_info {
 	 */
 	uuid_t		ovl_boot_id;	/* Must stay first member */
 	u64		s_instance_id;
+	errseq_t	errseq;	/* Implemented as a u32 */
 } __packed;
 
 /*
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 7b66fbb20261..5795b28bb4cf 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1117,6 +1117,12 @@ static int ovl_verify_volatile_info(struct ovl_fs *ofs,
 		return -EINVAL;
 	}
 
+	err = errseq_check(&volatiledir->d_sb->s_wb_err, info.errseq);
+	if (err) {
+		pr_debug("Workdir filesystem reports errors: %d\n", err);
+		return -EINVAL;
+	}
+
 	return 1;
 }
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a8ee3ba4ebbd..2e473f8c75dd 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1248,6 +1248,7 @@ static int ovl_set_volatile_info(struct ovl_fs *ofs, struct dentry *volatiledir)
 	int err;
 	struct ovl_volatile_info info = {
 		.s_instance_id = volatiledir->d_sb->s_instance_id,
+		.errseq = errseq_sample(&volatiledir->d_sb->s_wb_err),
 	};
 
 	uuid_copy(&info.ovl_boot_id, &ovl_boot_id);
-- 
2.25.1

