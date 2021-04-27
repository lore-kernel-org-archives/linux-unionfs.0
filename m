Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9E4C43460
	for <linux-unionfs@archiver.kernel.org>; Tue, 27 Apr 2021 10:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86B59611ED
	for <linux-unionfs@archiver.kernel.org>; Tue, 27 Apr 2021 10:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238518AbhD0K3n (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 27 Apr 2021 06:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238415AbhD0K3R (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 27 Apr 2021 06:29:17 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E12C06175F
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Apr 2021 03:28:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id k14so8985668wrv.5
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Apr 2021 03:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eza+AuZNSGYLkNaYcp7rzAAg9QUKS/lEjBbDnMFW6ps=;
        b=EXVrAGdPusNFmEkphN2+MEBMInlqLm4hDtx4DnZV9tBVzdscMZunHMnUnTBOBNEZ6S
         Mi2EsXiV1FzcwT3vK+4SlUX5J+JbweWJ8yV9PlXPXR0h6d3ns54ZXKZU9S74B6zUaYEe
         OpUwBCmsXOpdZ5XO/RkWPv5QZj2GqgSXh3TXHzgDVA9cA4+TTgEQLaM7+NwDx3kg9cvo
         4W8083vu2hIwFkpvo9QHsXg0H/qk0drYtVCRUBDsWMD56qyzwQ+cv1AmhWJF4pGO8x1Y
         Bkyag7rJ39f5VqCnw0X8spOmQYyN2O7jdDK1Op9PIVYtxBSAJSYpTCbZ9oHwTiY5e6Em
         4J/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eza+AuZNSGYLkNaYcp7rzAAg9QUKS/lEjBbDnMFW6ps=;
        b=mbKPee0f32TL0rbxeRDkYX7WdJzS8PwHKUUL7OMF1bgKW/oRysgz4GDqSflNd2Rbgv
         /x8q4OKhnuYDXItbEumcnCLH3O+ew1dwqJ6xdQ8wte+ANqGuvPfZltR9N/MkFAeoIflh
         hc+DI66AD2LtFQ48S5hfjGLe66ZpHVUv/icNzUbSDmSgYFGPEbxcbxxvOJrJWnLDZYPH
         IReUedaVTaPZw6OZU6enCWiTuGtZeDNQaQvjtksLAkH2WNXYQrd3hnj35LD2EjStgby0
         HKM/VVxJCl7mUaqi7iSZ0ttOfSA6wq6ITGMRjbwzpHYRkHGRh4MU4aOaVzsWQfaAW6Om
         TaDA==
X-Gm-Message-State: AOAM533AzPgWatybrRXCr24ECWshGv7cdlZ+E/gFlBdoJmiABoXGfFpv
        cA/4KMSscsywt9CJ63jsqXM=
X-Google-Smtp-Source: ABdhPJzIG/vS9NNl7Tvby/uGHdWQC5Ss2hm1j5PcD+r8f8zyxhpLNQ99w5tnx3Tih/4flN7XM4Xd5A==
X-Received: by 2002:a05:6000:1843:: with SMTP id c3mr29407962wri.361.1619519311234;
        Tue, 27 Apr 2021 03:28:31 -0700 (PDT)
Received: from localhost.localdomain ([82.114.44.37])
        by smtp.gmail.com with ESMTPSA id l21sm2376046wme.10.2021.04.27.03.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 03:28:30 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Byron <ouyangxuan10@163.com>, Kevin Locke <kevin@kevinlocke.name>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: relax lookup error on mismatch origin ftype
Date:   Tue, 27 Apr 2021 13:28:26 +0300
Message-Id: <20210427102826.1189410-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

We get occasional reports of lookup errors due to mismatched
origin ftype from users that re-format a lower squashfs image.

Commit 13c6ad0f45fd ("ovl: document lower modification caveats")
tries to discourage the practice of re-formating lower layers and
describes the expected behavior as undefined.

Commit b0e0f69731cd ("ovl: restrict lower null uuid for "xino=auto"")
limits the configurations in which origin file handles are followed.

In addition to these measures, change the behavior in case of detecting
a mismatch origin ftype in lookup to issue a warning, not follow origin,
but not fail the lookup operation either.

That should make overall more users happy without any big consequences.

Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxgPq9E9xxwU2CDyHy-_yCZZeymg+3n+-6AqkGGE1YtwvQ@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

I am getting tired of dealing with lower squashfs related reports.
How about this?

It passes the xfstests quick tests and no, I do not have a reproducer
for origin mismatch, so will wait for Byron to test the patch.

Thanks,
Amir.

 fs/overlayfs/namei.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 71e264e2f16b..850c0a37f1f0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -392,7 +392,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 			    upperdentry, d_inode(upperdentry)->i_mode & S_IFMT,
 			    d_inode(origin)->i_mode & S_IFMT);
 	dput(origin);
-	return -EIO;
+	return -EINVAL;
 }
 
 static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
@@ -408,7 +408,7 @@ static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
 	kfree(fh);
 
 	if (err) {
-		if (err == -ESTALE)
+		if (err == -ESTALE || err == -EINVAL)
 			return 0;
 		return err;
 	}
-- 
2.25.1

