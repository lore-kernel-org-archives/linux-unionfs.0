Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C38CFC433DB
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 Jan 2021 04:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 984B020643
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 Jan 2021 04:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbhA0E4a (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 26 Jan 2021 23:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729179AbhAZRCk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 26 Jan 2021 12:02:40 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0499EC061A31
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Jan 2021 08:51:06 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id g3so23922069ejb.6
        for <linux-unionfs@vger.kernel.org>; Tue, 26 Jan 2021 08:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x/DIGNyIeGl8jWOE+/SxbFz8fKdWCEt9o+idA7gyYAs=;
        b=laBHie+xb764Ub/3eAOaJZSVMoR3F2s9bn7cv0XoLkIIN6VFYkvujio1YQQk+7Y76i
         erUfRS0bL4+i9VC3y5axVZ8vqH1w7zM5rrqhJtfMm0mMjsjUOoGVemLmMo8rCnyzEWZ6
         6MKEZi0GfMrL6V59BJ9Y5Oj6TCLym7M2+A9o9MD+mTT8LejlF6AoQ+kR2SxO1uVLFnCn
         KBc6fIUcgOk6mUJ36QgxZ7QWIp7mCZWKEvH4WE4KgLGXSDSWymz4V8/LMPX1Bp/vSOBA
         S+orQusEwEmVVg4SiYvH+pYNrup2um0Qrj53TrzT7ntYfKbAjekNa3vLAZqrLhsIlTIc
         bHMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x/DIGNyIeGl8jWOE+/SxbFz8fKdWCEt9o+idA7gyYAs=;
        b=UOiQuX6l8hu8VqEMX29laFDuzger8NrlHCXZi9ILZS7Bci7sY+kWuJPXlr9jaISM1R
         mB047aXZHxTRwczyNF7v5CkgUQioQbCYOfKE1rlLPLp2rcaLgChuqECGiDzghlqyeSKq
         FC2CHkj7cBBNBGJmwehQcM6tAeew05eHCKiXObgnM+MbjW5TmxfF7Wixh8aI3NHKQLft
         jN1RAGrY2M5q0RHBOEh/YWKF8DYYY6lCE+QqGOFqdDjhsto8lw8I3UmBCs4B51HTLO4Z
         XkQqKcTrfKOwQFeGQFyGpTLRDl1blo0mbF4HC6W9dHlcQsuKRgIhxhOhO3ict5slVaEp
         OLoA==
X-Gm-Message-State: AOAM5315+oPRzW2lnHfN0p5K1g2Zzt+0piNqdOouQj23M+84QUsHALyc
        7gVP0YFwwsH+k6qMONCFGUdDiqi1R+c=
X-Google-Smtp-Source: ABdhPJyaOiA5l75NnQqVegbIAaRzNhZ7w/LNcoqTCQXvA3z9wWUzrWjlBtk+kKkdTPkD56Jc9ofbCg==
X-Received: by 2002:a17:906:b2d5:: with SMTP id cf21mr4060645ejb.387.1611679865751;
        Tue, 26 Jan 2021 08:51:05 -0800 (PST)
Received: from localhost.localdomain ([31.210.181.203])
        by smtp.gmail.com with ESMTPSA id j5sm13128320edl.42.2021.01.26.08.51.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 08:51:04 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix fd leak in ovl_flush()
Date:   Tue, 26 Jan 2021 18:51:02 +0200
Message-Id: <20210126165102.1017787-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

This patch is against overlayfs-next which currently fails xfstests.

Thanks,
Amir.

 fs/overlayfs/file.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 2ff818d5c2c9..6fa9ac682beb 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -693,12 +693,17 @@ static int ovl_flush(struct file *file, fl_owner_t id)
 	int err;
 
 	err = ovl_real_fdget(file, &real);
-	if (!err && real.file->f_op->flush) {
+	if (err)
+		return err;
+
+	if (real.file->f_op->flush) {
 		old_cred = ovl_override_creds(file_inode(file)->i_sb);
 		err = real.file->f_op->flush(real.file, id);
 		revert_creds(old_cred);
 	}
 
+	fdput(real);
+
 	return err;
 }
 
-- 
2.25.1

