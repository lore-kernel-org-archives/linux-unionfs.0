Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD214C4708B
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 17:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97A97610A0
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 17:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhE0Rrl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 May 2021 13:47:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhE0Rrk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 May 2021 13:47:40 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FDB0C061761
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 10:46:06 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id j14so714271wrq.5
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 10:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P4yWGhwwrTXCVH2tcnBa2DjJ8I2U2QUuDgwrQ0w53Mw=;
        b=SAkebh0fypOt9B+bnT6pGdzGqGnWg4TiVgs7Sco8JgiJR0xRatuEQdhX5oGX3/hhY4
         q0F6oMwUQGXBlX2H0OxUJLJWJN+g0B4ir7uCHhhDFESqmaQ0c/v8nckag1JObv0TmY7X
         nL8WgBAH8V7xsqWvf8/brZiKyDCB0jEk+IUwJwZiNVWU+HKZyldmyPTb0csEpDngP0sn
         gAwLsR+ijRsJKXhXuRKiPJoq+gy+LFAfYh6aIn4xxWl7/Fzsh0/djSUFDjM6FeJuEw+6
         zsOWuILR1ZkboA17QpDcKQeJYxbHiV4MIG8ia8nwRZ8oqE84nv2iqeu1YmwMlWdshQDO
         3HPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P4yWGhwwrTXCVH2tcnBa2DjJ8I2U2QUuDgwrQ0w53Mw=;
        b=UifoFmQRlvAhSneVQ8nLLDGuYzKr7DBjHJSjJLim+b5zn0vW4XkLRA87pGrIjPwgS1
         WFkRdB/MeYlokIUknJ+0cT2uiyCZ7u7zJTJS3ljOEUolokKL0MBnwlTPJ3rOq416MkLx
         6Ll17IZbCmlFg+1UfHbPNhZu+Ddp0p1rYEyXZ/3xR2hinL307HXgZ+GaGKbDgU2cl3Te
         C54dEwjatwn47CJa2wEGgOuRi4WmzvShoq75cnrtXpXwrlDC+94UoXNVuccQ3DwO/rbo
         owYEiWAaNvOnuX/ce6zqPj65w28XEXSJGgIn9BAF+vK5g/ba67vadtPUhlVkcU+adQwn
         YKaA==
X-Gm-Message-State: AOAM532fSx2XLwEZ4ZoLPOZgcIcPpC842M368o6rRmsrNM49qOlRaKmw
        HfZmbpQBJWkYt+vKwK2ZMCdW5uRQL2V2hc7yLE0=
X-Google-Smtp-Source: ABdhPJzAeHp+nkGhO49pkPAiXEQcbzCjtk3VEaC7gAVVgCFBtTS5NI+5evT8GQaMSvG317S9Dpeuww==
X-Received: by 2002:a5d:6803:: with SMTP id w3mr4636717wru.285.1622137565077;
        Thu, 27 May 2021 10:46:05 -0700 (PDT)
Received: from uvv-2004-vm.localdomain (dslb-002-205-242-053.002.205.pools.vodafone-ip.de. [2.205.242.53])
        by smtp.gmail.com with ESMTPSA id f7sm4999837wrg.34.2021.05.27.10.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 10:46:04 -0700 (PDT)
From:   Vyacheslav Yurkov <uvv.mail@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org,
        Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Subject: [PATCH v3 3/3] ovl: do not set overlay.opaque for new directories
Date:   Thu, 27 May 2021 19:45:47 +0200
Message-Id: <20210527174547.109269-3-uvv.mail@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527174547.109269-1-uvv.mail@gmail.com>
References: <20210527174547.109269-1-uvv.mail@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>

Enable optimizations only if user opted-in for any of extended features.
If optimization is enabled, it breaks existing use case when a lower layer
directory appears after directory was created on a merged layer. If
overlay.opaque is applied, new files on lower layer are not visible.

Consider the following scenario:
- /lower and /upper are mounted to /merged
- directory /merged/new-dir is created with a file test1
- overlay is unmounted
- directory /lower/new-dir is created with a file test2
- overlay is mounted again

If opaque is applied by default, file test2 is not going to be visible
without explicitly clearing the overlay.opaque attribute

Signed-off-by: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
---
 fs/overlayfs/dir.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 93efe7048a77..03a22954fe61 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -320,6 +320,7 @@ static bool ovl_type_origin(struct dentry *dentry)
 static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 			    struct ovl_cattr *attr)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
 	struct inode *udir = upperdir->d_inode;
 	struct dentry *newdentry;
@@ -338,7 +339,8 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(newdentry))
 		goto out_unlock;
 
-	if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry)) {
+	if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry) &&
+	    !ovl_allow_offline_changes(ofs)) {
 		/* Setting opaque here is just an optimization, allow to fail */
 		ovl_set_opaque(dentry, newdentry);
 	}
-- 
2.25.1

