Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86655C64E7B
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Nov 2020 03:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE0520757
	for <linux-unionfs@archiver.kernel.org>; Mon, 30 Nov 2020 03:01:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=sargun.me header.i=@sargun.me header.b="RGz1qIxS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726260AbgK3DBd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 29 Nov 2020 22:01:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbgK3DBd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 29 Nov 2020 22:01:33 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955E7C0613D2
        for <linux-unionfs@vger.kernel.org>; Sun, 29 Nov 2020 19:00:47 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id u2so5664425pls.10
        for <linux-unionfs@vger.kernel.org>; Sun, 29 Nov 2020 19:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sargun.me; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OgfC1dHk0OMu7PasvRzn5zPxdots61Yzs3kDI+H1neE=;
        b=RGz1qIxSqf9AckWZOlg8m6CNJtYtvsm2kqdn4r/NXG0e2ukzoW7ApRob/LNKVAWYE7
         fknw+sZcchNwytKhZTIHnNaQ0g37o6ExsB+qNQT+yLsZW3qTPiD6YSsavKOhc3rhU7XZ
         TS4llcZWnfqP4nNnWkPdDDi0JsUc77XYy/e8w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OgfC1dHk0OMu7PasvRzn5zPxdots61Yzs3kDI+H1neE=;
        b=F9aDawAF6cCR/dQ9efFR3nPf5PLzmh4qXt3CPui4VrYY42gHXrnSOr2Z6JEAMso1rz
         X+jv9jeCVvHyVFzzHUk18ngiFY3Wz6WAbSLwV68EK04qRiJeay+NJK2cKgxHx8Nu+FhQ
         GNwnzhIsx8o4TqyOrDg5m5mMVw9laD88XCsfmmezu14StZsmRuxPtODnfOlgtilxCbHC
         lY42Yd6LWFYfqnBt4/Gi0gfqGpMMW2W/rqNVQzrpmai+JepZMImXdWX9q0LWJMUPGgzV
         p0RPhvGNqp6S2k2oH1CswevI2Wt0nlA8bMhhNPQw7IeaAvSPQ13Z7mR3CranaFXxY/BQ
         RUbQ==
X-Gm-Message-State: AOAM531hi0+OG9ayIL2blMQmIywrq1KjiuvSCPU0j1IilPlxFb4nJkej
        pgFVPc/EqAX66nXwqfmlc+vdNQ==
X-Google-Smtp-Source: ABdhPJwStcytkvfmvSbg8gDNmJ/bTZcADr6Z1PeBWmpvWR5tpX4bwrfs42fnetwyY6onbticfV3Ukw==
X-Received: by 2002:a17:902:ba8b:b029:d7:e6da:cd21 with SMTP id k11-20020a170902ba8bb02900d7e6dacd21mr16621058pls.38.1606705246731;
        Sun, 29 Nov 2020 19:00:46 -0800 (PST)
Received: from ubuntu.netflix.com (203.20.25.136.in-addr.arpa. [136.25.20.203])
        by smtp.gmail.com with ESMTPSA id z17sm19651803pjn.46.2020.11.29.19.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 19:00:46 -0800 (PST)
From:   Sargun Dhillon <sargun@sargun.me>
Cc:     Sargun Dhillon <sargun@sargun.me>, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay: Plumb through flush method
Date:   Sun, 29 Nov 2020 19:00:39 -0800
Message-Id: <20201130030039.596801-1-sargun@sargun.me>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Filesystems can implement their own flush method that release
resources, or manipulate caches. Currently if one of these
filesystems is used with overlayfs, the flush method is not called.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Cc: linux-fsdevel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index efccb7c1f9bc..802259f33c28 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -787,6 +787,16 @@ static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
 			    remap_flags, op);
 }
 
+static int ovl_flush(struct file *file, fl_owner_t id)
+{
+	struct file *realfile = file->private_data;
+
+	if (realfile->f_op->flush)
+		return realfile->f_op->flush(realfile, id);
+
+	return 0;
+}
+
 const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 	.release	= ovl_release,
@@ -798,6 +808,7 @@ const struct file_operations ovl_file_operations = {
 	.fallocate	= ovl_fallocate,
 	.fadvise	= ovl_fadvise,
 	.unlocked_ioctl	= ovl_ioctl,
+	.flush		= ovl_flush,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl	= ovl_compat_ioctl,
 #endif
-- 
2.25.1

