Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489E5C83F2D
	for <linux-unionfs@archiver.kernel.org>; Sun,  3 Sep 2023 11:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236584AbjICLQP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 3 Sep 2023 07:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbjICLQO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 3 Sep 2023 07:16:14 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B387B91
        for <linux-unionfs@vger.kernel.org>; Sun,  3 Sep 2023 04:16:11 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4013454fa93so5126725e9.0
        for <linux-unionfs@vger.kernel.org>; Sun, 03 Sep 2023 04:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693739770; x=1694344570; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s1jOC3lAVfW77frHZvY9W0gFzy1Cj1TNNQ+t9mwJjV4=;
        b=KnvlYImBZcgsj18fYMFfVZ775VkV1pCNWRO9WbvE5b4ancNcpe7cVP5vLLXLJy+A+p
         K55cegViFNgGYdJkiVq+cpBI3IJyyoE5DuVJlS9hCLLGrpRtdV8QjjSRVb3VUyV/b8BA
         CyHTe+MTPH4+MXTxLn1fCCryKo9kHr3l2mZO/pr7ohOWad9PrFEkikFX1TPh8zmyK4t+
         wFC001D2sZDyqmrCS6UeOkMtAr7pUHzbkPgP6ygURu922/MQKRk3rTVpmmbjbDd4N5gd
         oEDZcTwNl0hEkS5gP1fppqtQaox11D99t1Mp4/ZMJNlZoeGhLmpzym4VJjY66lrZiMxg
         3LQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693739770; x=1694344570;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s1jOC3lAVfW77frHZvY9W0gFzy1Cj1TNNQ+t9mwJjV4=;
        b=h1zt1D8Z/nlqeqyzuuY5Wqr6BoArGgPmUG0+QC3RX7lTFfI0FkF9Kv3Dqi/pF4h54K
         PLCKYtSizSlAPkb6S32VT6pSNhbSGDPLOHjh1etOPyfJEcXL0u0lQbTNpe9zRFaSwbwb
         +hBnIB1pvGS8LwlH80IiFqzgobpwM9VYOI61LxKGLm6kxj5iS+QXdMeLBrBN7A1Bs3G3
         X54QldauaV0zUJ9N81X/ygRd43K+PlxMSh4ng9+pkQQOx3p7RwtO/urdlvgPwnejOspg
         WLFhLKgG6oYHMlKKenACx8SEtiXw0BB6yoxXUkzn6hl7Rn4f27A26q+JFKT4WKe/MHbZ
         qxVQ==
X-Gm-Message-State: AOJu0Yw9nZsKZEEh6C/5VSkKoU7DWmRMqO4VeNrR8fjx7ItFU1Lgil0k
        D8onMqy8n+vkIKXvVCg2dow=
X-Google-Smtp-Source: AGHT+IFXuAcaNiuAAsJSWq5YgSZbsZR4mpMCtzpd7sbaMzosKLe/qXI48RHNV/c6oP6XKjXZ6nSYqw==
X-Received: by 2002:a05:600c:20d4:b0:3f8:fc2a:c7eb with SMTP id y20-20020a05600c20d400b003f8fc2ac7ebmr4388803wmm.5.1693739769994;
        Sun, 03 Sep 2023 04:16:09 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id 9-20020a05600c228900b003fc080acf68sm13899065wmf.34.2023.09.03.04.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Sep 2023 04:16:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     Cyril Hrubis <chrubis@suse.cz>, Jan Kara <jack@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, ltp@lists.linux.it
Subject: [PATCH 3/3] fanotify13: Test unique overlayfs fsid
Date:   Sun,  3 Sep 2023 14:15:58 +0300
Message-Id: <20230903111558.2603332-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230903111558.2603332-1-amir73il@gmail.com>
References: <20230903111558.2603332-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

With feature uuid=auto, overlayfs gets an fsid which is different than
the base fs fsid.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 testcases/kernel/syscalls/fanotify/fanotify13.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/testcases/kernel/syscalls/fanotify/fanotify13.c b/testcases/kernel/syscalls/fanotify/fanotify13.c
index 5c1d287d7..3bb9eb1df 100644
--- a/testcases/kernel/syscalls/fanotify/fanotify13.c
+++ b/testcases/kernel/syscalls/fanotify/fanotify13.c
@@ -96,6 +96,7 @@ static int fanotify_fd;
 static int filesystem_mark_unsupported;
 static char events_buf[BUF_SIZE];
 static struct event_t event_set[EVENT_MAX];
+static struct fanotify_fid_t base_fs_fid;
 
 static void create_objects(void)
 {
@@ -113,8 +114,19 @@ static void get_object_stats(void)
 {
 	unsigned int i;
 
+	fanotify_save_fid(OVL_BASE_MNTPOINT, &base_fs_fid);
 	for (i = 0; i < ARRAY_SIZE(objects); i++)
 		fanotify_save_fid(objects[i].path, &objects[i].fid);
+
+	/* Variant #2: watching overlayfs - expect fsid != base fs fsid */
+	if (ovl_mounted && tst_variant == 2 &&
+	    memcmp(&objects[0].fid.fsid, &base_fs_fid.fsid,
+		   sizeof(base_fs_fid.fsid)) == 0) {
+		tst_res(TFAIL,
+			"overlayfs fsid is the same as stat.f_fsid that was "
+			"obtained via statfs(2) on the base fs");
+	}
+
 }
 
 static int setup_marks(unsigned int fd, struct test_case_t *tc)
-- 
2.34.1

