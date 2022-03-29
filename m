Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C0B4C433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 10:37:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235242AbiC2KjW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 06:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbiC2KjV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 06:39:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A4FBF950
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 03:37:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F9CD61266
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 10:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE972C340F2;
        Tue, 29 Mar 2022 10:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648550258;
        bh=uJ8KRzqHYL+sGvCmzhjH/IXq/xUZEEcJhSXVs1TYRaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S52egPJYLg7tvjeUqMwdICgOzNlqAFARNqUEtt0ssLPx8S44MN29GLcxHDS9Uu0ee
         1etb2SdlH7Mo63j6OsSeJBP3lBSOF488e2lWx4I7u6TDWmHfd6VDK6ZoneFjTmEYTF
         wiRr80ccLYtGaTCDuHy3mebA79+Bbyp5q0Z1+dcEH2JVT52Ez4USwjLDg459kLdU4a
         lvkvwJjYux17yIvVAJYlqjn6S1S2rdNxJgPwkUfx3RyyDqgq4Ef/FwaYNNoZY6a2Ye
         zboL7K5kiviYVhHwGYDQ4Q/ckINhVwezPlNKrdZxThYx7TvJLqDVzpm3hgkIO8MSOr
         KdvKZjz4ys2aQ==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
Subject: [PATCH 18/18] ovl: support idmapped layers
Date:   Tue, 29 Mar 2022 12:35:25 +0200
Message-Id: <20220329103526.1207086-19-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
References: <20220329103526.1207086-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1095; h=from:subject; bh=uJ8KRzqHYL+sGvCmzhjH/IXq/xUZEEcJhSXVs1TYRaU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQ5PTjI0Bb8jUHguur2l14svL1a3z5O935cnjX1dUHblUUP bvPZd5SyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWwIF6cATOTLR4b/RdPECha/v6V+/2Luo0u5JY 0JP7cfesQhUfo4rOa/7S1hU0aGE++6gvknX5h5VrH6klRW4EQBvYflHHUB2mukvaI9at24AQ==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Now that overlay is able to take a layers idmapping into account allow
overlay mounts to be created on top of idmapped mounts. Since NFS
doesn't support idmapped mounts we don't allow idmapped base layers in
combination with the nfs_export=on mount option.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/overlayfs/super.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9a656a24f7b1..d4cc07f7a2ef 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -874,10 +874,6 @@ static int ovl_mount_dir_noesc(const char *name, struct path *path)
 		pr_err("filesystem on '%s' not supported\n", name);
 		goto out_put;
 	}
-	if (is_idmapped_mnt(path->mnt)) {
-		pr_err("idmapped layers are currently not supported\n");
-		goto out_put;
-	}
 	if (!d_is_dir(path->dentry)) {
 		pr_err("'%s' not a directory\n", name);
 		goto out_put;
-- 
2.32.0

