Return-Path: <SRS0=DgkE=AT=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38AB3C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 13:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 122A620772
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 13:16:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L+YSQBp/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgGHNQ3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 09:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbgGHNQ3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Jul 2020 09:16:29 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0C8C08C5DC
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2020 06:16:29 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 22so3076184wmg.1
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2020 06:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=C+weSM7SmGUDidr6DMCAWtk9egU2z5p5ksX2U0k8Fiw=;
        b=L+YSQBp/YOAlJwVbLHGdRDE2clq78gn36EpXIGUpUXsFTdyEyZimh+BnqZBaQS3Hm6
         P7DEUwr90iL/NL0/RH0yQ/JG7SUsOsn+jUKDJ4CP9SDzr1JXq8vuatPDpOudW+rwLXJC
         q5xGf3xTXqtH8rHqaXtrtPbnddmk0Qb/r+2PWOR+1TuBCOf24ZIG4ntryDXR/X7zZ+pQ
         pXoe799b9M2dnTVs0N42VcLeY1CWIyl+smx1LlgP+GHF80YfqrmsGSqQE8eVot35snoi
         Ud4nFJ7F9pmdhBTZygbaCDGmh1NTmARdI3d9P3piq7unFUKcPDwuYZ1Hy63RMxYlxC7k
         wtNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C+weSM7SmGUDidr6DMCAWtk9egU2z5p5ksX2U0k8Fiw=;
        b=IWRERMCR4HriD+VXnoSa4DRCkGb7QGjxUjsb0dXClizIDsIN4IzFL/UIA8FgEkmspG
         UfNy3Ur3K9OYRnzlrOYG64zyT2LAXXFTPhj6ALixezD3ZSLleTP+gXxDf+xisR0vFkI4
         BwJm/AmjunQjw3VcK9BYUGDREg8tK3jtfYooXDUCo8NNUDhOJPwUHRoaYSHKBbilkEF0
         ym1pboiDmM7LwVv+vwAa8AfUc91eW9FzReudd8zQN8tz74gdga7vKPEpOmbBrMLSA8wp
         njO7AiHN5fk34kBlEU6Wi1+hHAgM5M/GfFWbKy0IXMFY26kPWa52xbPUJNPYlOPY0hOA
         kpfg==
X-Gm-Message-State: AOAM533fhe3MF/JKQyfQ3mqkBpEjnSy3jUiH6cXkE6US0hadh/VJ74og
        l5y6oiBE9R8calA+S9uwq3JVA/SV
X-Google-Smtp-Source: ABdhPJz9FogQubbtFNDjbFKBQig5XDGDR+HvPlmG0a2hbb51kAfNIYW3j9B8hF2qDgAcvLo5fD/OvQ==
X-Received: by 2002:a1c:2183:: with SMTP id h125mr9923393wmh.83.1594214188104;
        Wed, 08 Jul 2020 06:16:28 -0700 (PDT)
Received: from localhost.localdomain ([141.226.183.23])
        by smtp.gmail.com with ESMTPSA id f16sm6006460wmf.17.2020.07.08.06.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 06:16:27 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Fabian <godi.beat@gmx.net>, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix regression with re-formatted lower squashfs
Date:   Wed,  8 Jul 2020 16:16:13 +0300
Message-Id: <20200708131613.30038-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Commit 9df085f3c9a2 ("ovl: relax requirement for non null uuid of lower
fs") relaxed the requirement for non null uuid with single lower layer to
allow enabling index and nfs_export features with single lower squashfs.

Fabian reported a regression in a setup when overlay re-uses an existing
upper layer and re-formats the lower squashfs image.  Because squashfs
has no uuid, the origin xattr in upper layer are decoded from the new
lower layer where they may resolve to a wrong origin file and user may
get an ESTALE or EIO error on lookup.

To avoid the reported regression while still allowing the new features
with single lower squashfs, do not allow decoding origin with lower null
uuid unless user opted-in to one of the new features that require
following the lower inode of non-dir upper (index, xino, metacopy).

Reported-by: Fabian <godi.beat@gmx.net>
Link: https://lore.kernel.org/linux-unionfs/32532923.JtPX5UtSzP@fgdesktop/
Fixes: 9df085f3c9a2 ("ovl: relax requirement for non null uuid...")
Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 15939ab39c1c..06ec3cb977e6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1402,6 +1402,18 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 	if (!ofs->config.nfs_export && !ovl_upper_mnt(ofs))
 		return true;
 
+	/*
+	 * We allow using single lower with null uuid for index and nfs_export
+	 * for example to support those features with single lower squashfs.
+	 * To avoid regressions in setups of overlay with re-formatted lower
+	 * squashfs, do not allow decoding origin with lower null uuid unless
+	 * user opted-in to one of the new features that require following the
+	 * lower inode of non-dir upper.
+	 */
+	if (!ofs->config.index && !ofs->config.metacopy && !ofs->config.xino &&
+	    uuid_is_null(uuid))
+		return false;
+
 	for (i = 0; i < ofs->numfs; i++) {
 		/*
 		 * We use uuid to associate an overlay lower file handle with a
-- 
2.17.1

