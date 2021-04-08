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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D44AC433ED
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 11:30:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B7D86102A
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 11:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbhDHLaf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 07:30:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbhDHLaf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Apr 2021 07:30:35 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F924C061760
        for <linux-unionfs@vger.kernel.org>; Thu,  8 Apr 2021 04:30:24 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id 12so1748134wrz.7
        for <linux-unionfs@vger.kernel.org>; Thu, 08 Apr 2021 04:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFTUjh2aehDaAkrdM0H2NirNZ1y+j2RcZvNJEUwSq64=;
        b=MlIqNiRNlZfTZKFNMGxQ8EbvpMTMriBmOEylZF+iXzSLWfT39wCFuEYqZhVzltWGg4
         ro9XQw+JEodDiXtf74f7zwAcdlN4ODg0Mq1T95esGOzf/DdwSyM0WgG2QXNzguuUCncH
         MYQx91Cm53vuqz2WN+5b20v75eLwKbOBTyVmzT2q54n82YV79SHPiEy6GdVdQ/oL7jU5
         z9A8E8UN0437MrbSkQMgqCgLWnCD68TdNUTOvDEufo9d68cznW+y4rj8PEvznuXO4Rmz
         j5i3p5Gld8ACHzrRv1ZbptjfXHww278ZNrezjBpNr1TnzmjZas81jOLroCmfvBz4Xo2Y
         jeNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GFTUjh2aehDaAkrdM0H2NirNZ1y+j2RcZvNJEUwSq64=;
        b=IELMBNqx/u5NTzxuKXfyE9XGN2EYjnuk+QtiXiIUz/Yd5ZhWxA/AvhHNJEdHfV+6wK
         ialcBl5zMcpfHOVnHsn9Sfx4RUKTc2ZryTCZxjE+3jzO4/07C0fJIeph276D1HAX/k/m
         pV6t4apDfB1P08fOc74Dhzn3nbg95F8rTdwbJzEoRbnjevJuiEFfgN3v5Ae8ohQ5hsav
         zvl5dNbYoWFh5xHFDuswhUzTj0WW8xL4hrLUa6mWLK1NVbt3dYtdiM4cZhskAS7rzYA9
         /H726o5D1ibGf4Pom7B2m0LuuzpM7S5xd9jrS/kSH6vPX8e7oW9BzxN2ftBG4MgsrSZC
         CyhA==
X-Gm-Message-State: AOAM5332YypiHPMkA4r6FH4tjYRnJhaaWVvbix9z6vPAiB2dhQN8XtXU
        Vx3TfdSewY4VQuu53KpqOt4=
X-Google-Smtp-Source: ABdhPJwiY54HH+owobLKVJt74SQz8M4EXhT1XQX6qyJpGoXEH7DCkF4p0XZLT87POIcENaOc5rxPVg==
X-Received: by 2002:adf:fb87:: with SMTP id a7mr10734600wrr.58.1617881423168;
        Thu, 08 Apr 2021 04:30:23 -0700 (PDT)
Received: from localhost.localdomain ([141.226.241.101])
        by smtp.gmail.com with ESMTPSA id a11sm7304547wrv.21.2021.04.08.04.30.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 04:30:22 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: check that upperdir path is not on a read-only mount
Date:   Thu,  8 Apr 2021 14:30:20 +0300
Message-Id: <20210408113020.1708212-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

So far we only checked that sb is not read-only.

Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fdd72f1a9c5e..8d8366350093 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1185,8 +1185,8 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 	if (err)
 		goto out;
 
-	/* Upper fs should not be r/o */
-	if (sb_rdonly(upperpath->mnt->mnt_sb)) {
+	/* Upperdir path should not be r/o */
+	if (__mnt_is_readonly(upperpath->mnt)) {
 		pr_err("upper fs is r/o, try multi-lower layers mount\n");
 		err = -EINVAL;
 		goto out;
-- 
2.30.0

