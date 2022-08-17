Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB478C25B08
	for <linux-unionfs@archiver.kernel.org>; Wed, 17 Aug 2022 03:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiHQDqm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 16 Aug 2022 23:46:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiHQDqk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 Aug 2022 23:46:40 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519C072B7A
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Aug 2022 20:46:39 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id 202so10953890pgc.8
        for <linux-unionfs@vger.kernel.org>; Tue, 16 Aug 2022 20:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ES4XSV6um0uYgsYcFmKj7KuYCP2ajc5QcgQlnvm8VA4=;
        b=LNDDdT6zVhPPnzuEb9FR7yQ+IIT5NQfFf3mbhp1cCV1hWogez4of+apjE42XruIj/r
         Ud/HxxN0Je5glx+Hyg5WEoQ3PycFC2StiDVpc0F0llcS3p3qq2lDXA6COThvzPYHxctj
         B/Yit3d2G4YeOo2br4R3SjM2jZ/wYR7OCyQoDHt2s3SyK4+JDR8/NGJlrRpPWIRnA0VS
         YuoJS7sQz4fP6pAr+GGMB9oSTo2dpu9/OmIRisujdGjhzgWhcorgo7UqtfwF1SlgzJBm
         lObgAmqLUuvZI2cPYsVNFExlk+lEHI2mf6d0JJRCUj6k+4siJt8MDaO+q8coTJx96KqD
         M94g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ES4XSV6um0uYgsYcFmKj7KuYCP2ajc5QcgQlnvm8VA4=;
        b=XmTKOuB9dIIBcKMLUEspOraCtCTWFoCpWHyXIx6bun42zwla30KYFfh4SZxbk2xdfD
         Jt7jI1q+NAVPVQZ3ABCI7H96uNmhIB/7rKP8e3HvBIEp0CxizOGAmh5czFn0h6WiqLAt
         bdY73joPAykdu9NJEfS/ssi5hBpP6GMOafHnTpBbPQTiT+EKOWkDnZJfIDr8VikSq5jc
         1q2kRelm/t4NoxZXbicNkcrPbSukek9NYWpfw/4VduqVXO5UjdLHPC/aK/b3IXfDd6Ke
         zbAIoxO0WT415f2p69H+BUZQP0GRmlZWQDj77DG8BhPTpxeNzaU6pVVirmbZRno2LRRT
         vvhA==
X-Gm-Message-State: ACgBeo1RJVSHUxIV9MXDhTmbJvyAyDI8hM4j52PNg74VuDhwrXJF4vMi
        YaV3AgB7bT799GeXgVgFe8KENw==
X-Google-Smtp-Source: AA6agR6aRxQIbONcFxrCU95ThiH0UjJgVVAGX9S3Tg4MiWbsz3OtXxNOrzYlfy6gkAkb+X15aN37RQ==
X-Received: by 2002:a65:4205:0:b0:429:b155:4945 with SMTP id c5-20020a654205000000b00429b1554945mr3737562pgq.572.1660707998729;
        Tue, 16 Aug 2022 20:46:38 -0700 (PDT)
Received: from J23WFD767R.bytedance.net ([61.120.150.74])
        by smtp.gmail.com with ESMTPSA id z7-20020a1709027e8700b001725a63746dsm179999pla.186.2022.08.16.20.46.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 16 Aug 2022 20:46:38 -0700 (PDT)
From:   Zhang Tianci <zhangtianci.1997@bytedance.com>
To:     miklos@szeredi.hu
Cc:     Zhang Tianci <zhangtianci.1997@bytedance.com>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Subject: [PATCH] ovl: Do not override fsuid and fsgid in ovl_link()
Date:   Wed, 17 Aug 2022 11:45:59 +0800
Message-Id: <20220817034559.44936-1-zhangtianci.1997@bytedance.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ovl_link() did not create a new inode after commit
51f7e52dc943 ("ovl: share inode for hard link"), so
in ovl_create_or_link() we should not override cred's
fsuid and fsgid when called by ovl_link().

Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
---
 fs/overlayfs/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 6b03457f72bb..568d338032db 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -595,9 +595,9 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 	err = -ENOMEM;
 	override_cred = prepare_creds();
 	if (override_cred) {
-		override_cred->fsuid = inode->i_uid;
-		override_cred->fsgid = inode->i_gid;
 		if (!attr->hardlink) {
+			override_cred->fsuid = inode->i_uid;
+			override_cred->fsgid = inode->i_gid;
 			err = security_dentry_create_files_as(dentry,
 					attr->mode, &dentry->d_name, old_cred,
 					override_cred);
-- 
2.32.1 (Apple Git-133)

