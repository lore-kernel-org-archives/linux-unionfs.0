Return-Path: <SRS0=94B3=75=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7027C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue, 16 Jun 2020 04:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 903A7206DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 16 Jun 2020 04:46:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TmGPjEeQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgFPEq6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 16 Jun 2020 00:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgFPEq5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 Jun 2020 00:46:57 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA19C05BD43;
        Mon, 15 Jun 2020 21:46:56 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x22so8921308pfn.3;
        Mon, 15 Jun 2020 21:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gdcznPwXSPEx/HPzlO737tmp5HWnzdWQfrFQbb2WQrE=;
        b=TmGPjEeQEK8OlP+IhxvuorrgBcx/nT4tEIRaWNNOoPUdzClokNJjqfcY2P/CbwbAmV
         EWa6Sl4uPfzj9cT2EC5pTo6ftRJCs8cM4PbpgV4xhuyksDh1i38KGe0hpJTI5ml+eozi
         FnUj0auXzF4z+W1ZMOrQQW5j6OWfoqjdwW9yqcx1U+EzRPT3WynSB3cB8H+Qths+mGXY
         6teOIzmvUbZ7UgPopDRNrZn4uYyzk8s9Fj66tkJ1+bnV0yS7rlT7XvOghcpHUI0KGDvw
         +rIqujybHWmNZk3TECQpBt2BeknLsDEuQvfKkOIyvd0/S4DanIUYLaSBzPMbQVPJ0gk1
         Y4lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gdcznPwXSPEx/HPzlO737tmp5HWnzdWQfrFQbb2WQrE=;
        b=qeWtDqoJCNQVQOggV6qGMWN77AU4AVcJ3ADkyRnXVxe0VasvUMcVboVHoia+ZRA56Q
         MK1z/FHkmOSkluSVvNjf+oGKJArW0szTl/+1EB4S8J063ruSBXroxq/MrGxbUQYaSBaQ
         qs0fMCa88YO1elXr8LF2UVKkyV+kQ7jA4esgwX39rfGQY5vm4eGm8wtJqmbUiet+nxB9
         OjnWU36mpwNOn02Dj0SvzYYcR0pHE1Raqdd8m6kzsVjUVqOa4Sw6HFX6tTZFMeHS8Jb3
         rzUGBjCY6rVUGV0ul/ag+l6spmGa/94qxn8fUhhy7avza7LpX/izKL0nVo34sQS/bV9R
         LrEg==
X-Gm-Message-State: AOAM532YpfFhLoY43ZIwO9WmaUHG5/eJ92YKeIcHbj3MVGgAGUxYHfbi
        Ui+D8iFmcQZePBZ/F4jfsRUg+FJn
X-Google-Smtp-Source: ABdhPJy1bxACh1qEidxIOmibj9dy+gaDFb4RY6RzvOki3sSU4MsmJhtAcwFjyk2bC9JS4fctLVbTBw==
X-Received: by 2002:a63:d652:: with SMTP id d18mr765120pgj.164.1592282815973;
        Mon, 15 Jun 2020 21:46:55 -0700 (PDT)
Received: from her0gyu-virtual-machine.localdomain ([1.221.137.163])
        by smtp.gmail.com with ESMTPSA id z140sm16084374pfc.135.2020.06.15.21.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 21:46:55 -0700 (PDT)
From:   youngjun <her0gyugyu@gmail.com>
To:     amir73il@gmail.com
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, youngjun <her0gyugyu@gmail.com>
Subject: [PATCH] ovl: inode reference leak in ovl_is_inuse true case.
Date:   Tue, 16 Jun 2020 13:46:47 +0900
Message-Id: <20200616044647.19071-1-her0gyugyu@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200615155645.32939-1-her0gyugyu@gmail.com>
References: <20200615155645.32939-1-her0gyugyu@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When "ovl_is_inuse" true case, trap inode reference not put.
plus adding the comment explaining sequence of
ovl_is_inuse after ovl_setup_trap.

Signed-off-by: youngjun <her0gyugyu@gmail.com>
---
 fs/overlayfs/super.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 91476bc422f9..0396793dadb8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1029,6 +1029,12 @@ static const struct xattr_handler *ovl_xattr_handlers[] = {
 	NULL
 };
 
+/*
+ * Check if lower root conflicts with this overlay layers before checking
+ * if it is in-use as upperdir/workdir of "another" mount, because we do
+ * not bother to check in ovl_is_inuse() if the upperdir/workdir is in fact
+ * in-use by our upperdir/workdir.
+ */
 static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
 			  struct inode **ptrap, const char *name)
 {
@@ -1499,8 +1505,10 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 
 		if (ovl_is_inuse(stack[i].dentry)) {
 			err = ovl_report_in_use(ofs, "lowerdir");
-			if (err)
+			if (err) {
+				iput(trap);
 				goto out;
+			}
 		}
 
 		mnt = clone_private_mount(&stack[i]);
-- 
2.17.1

Thank you for comment Amir. I modified patch as you said.
