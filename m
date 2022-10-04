Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94C37C433FE
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiJDKew (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiJDKen (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Oct 2022 06:34:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332ACC2D
        for <linux-unionfs@vger.kernel.org>; Tue,  4 Oct 2022 03:34:41 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w18so11914194wro.7
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Oct 2022 03:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/+azcpZw7TmXkfiDz/siKwQknaF6esWxqtt0BxrGIvU=;
        b=Huq2MN5k3NSRhwW8SW7PNzogvoJ2MFEkt3YDJ2+vejcYQazVHQN7H38vbfrewigPiA
         w3FKAkMfzB7Mqz4XvOuFPzaWxSjXbjVmZJNOA235w+aTXoE87ZbyLysuVU7LJSOBVkds
         VO0b5Fxuw9VyQAQR09sAphyOPDs6Nm/oQQ9m0BE9Wq/COr8LTKk78ARozwPwk9U7SaAL
         4U1p5s527zuVJiyWSybU4Xu3uRW3Yn3yrjozQGZQAujAAUOfraIhMK4WQ67MdeIEnOPH
         RIRgZ/EdEWm+KZ94sIVZeAbXI0IusaaIDO30Nj/yYI3iiIZU3VIdfcBod8JWps2EKKww
         JqHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/+azcpZw7TmXkfiDz/siKwQknaF6esWxqtt0BxrGIvU=;
        b=OT3ZhQbzjU6MsKbTB3rHprUCJxsyf93xugvlqvvkUqtLY1oJ1vVNE1PN2pwmsrTpU2
         pi5YFCxHqsb+Qkbu46DBCYJKU2If718C7bp6PoQtArRw0XPVF3B2tLvukJ9xmWdQ12RM
         ZdQIsr2jMiiTokLqImRcwiEioEop4/ZwPN0ihXgGpSt5unHzUD+AV8LD3iiqiK8ftDm7
         Ig/vjker9FXgTUQjHe1QcJvK3EkhwgPPnU80RSJvIEjpP+jAB8Aofq0CLCSaNckUrO2f
         cQiF7mi09ixCvFMH29npstCZM3cB+5YlBj2qw2xQAIiMthbGtF4xgH4jLAdwyfzk4Wlo
         AvvA==
X-Gm-Message-State: ACrzQf0QwnhURNNYrjLrBlu/T4dm59zl10ICv7gYG6u3xSHdyTJairz5
        jC+B06pqeR7nviehfC4N4Nk=
X-Google-Smtp-Source: AMsMyM4gGzCfpuBf+hvZwA3JFVa9wW784Gchhj9jJ5zgXjKtXEYanynV/2NNhlTQLeEdJ8jUv0KhlQ==
X-Received: by 2002:adf:c713:0:b0:22a:3670:b08d with SMTP id k19-20020adfc713000000b0022a3670b08dmr16041593wrg.175.1664879679576;
        Tue, 04 Oct 2022 03:34:39 -0700 (PDT)
Received: from localhost.localdomain ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id b14-20020a05600c4e0e00b003b535ad4a5bsm14691726wmq.9.2022.10.04.03.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 03:34:39 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH 2/2] ovl: use plain list filler in indexdir and workdir cleanup
Date:   Tue,  4 Oct 2022 13:34:33 +0300
Message-Id: <20221004103433.966743-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221004103433.966743-1-amir73il@gmail.com>
References: <20221004103433.966743-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Those two cleanup routines are using the helper ovl_dir_read() with
the merge dir filler, which populates an rb tree, that is never used.

The index dir entry names all have a long (42 bytes) constant prefix,
so it is not surprising that perf top has demostrated high CPU usage
by rb tree population during cleanup of a large index dir:

      - 9.53% ovl_fill_merge
         - 78.41% ovl_cache_entry_find_link.constprop.27
            + 72.11% strncmp

Use the plain list filler that does not populate the unneeded rb tree.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 78f62cc1797b..f11324b46d23 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1071,14 +1071,10 @@ static int ovl_workdir_cleanup_recurse(struct ovl_fs *ofs, struct path *path,
 	int err;
 	struct inode *dir = path->dentry->d_inode;
 	LIST_HEAD(list);
-	struct rb_root root = RB_ROOT;
 	struct ovl_cache_entry *p;
 	struct ovl_readdir_data rdd = {
-		.ctx.actor = ovl_fill_merge,
-		.dentry = NULL,
+		.ctx.actor = ovl_fill_plain,
 		.list = &list,
-		.root = &root,
-		.is_lowest = false,
 	};
 	bool incompat = false;
 
@@ -1159,14 +1155,10 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 	struct inode *dir = indexdir->d_inode;
 	struct path path = { .mnt = ovl_upper_mnt(ofs), .dentry = indexdir };
 	LIST_HEAD(list);
-	struct rb_root root = RB_ROOT;
 	struct ovl_cache_entry *p;
 	struct ovl_readdir_data rdd = {
-		.ctx.actor = ovl_fill_merge,
-		.dentry = NULL,
+		.ctx.actor = ovl_fill_plain,
 		.list = &list,
-		.root = &root,
-		.is_lowest = false,
 	};
 
 	err = ovl_dir_read(&path, &rdd);
-- 
2.25.1

