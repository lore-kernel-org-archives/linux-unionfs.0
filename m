Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD88C433F5
	for <linux-unionfs@archiver.kernel.org>; Wed, 30 Mar 2022 10:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242937AbiC3K2T (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245363AbiC3K2R (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Mar 2022 06:28:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32726260C4D
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 03:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C6F6E61488
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 10:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C7AC340EC;
        Wed, 30 Mar 2022 10:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648635992;
        bh=BiyoSanAlxlhOtl91kLiqfqBOJ35yEF59ejJOB0/jPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=btejt+PtJCjkzA4rrdz/FgIDdKO/ye9ErwFm6+xLyH8WU9RoRGd/URrLb9U/4eByA
         +2Qne0Uy2cv3DQCe+1Ltpa0RIjKLGNNQYOvsL9ysO9yfNcXuis+kEQEQVgyk3ZSUhb
         j+V+rC4ubjiukkKEsjnxGfVj7iuyz6cXlK32NkirUDPya3xsOa9+4SJuI4Z6bmzs2i
         jpImLYJTMhofz17IoN/rWyS+VdKTKUYs5sdiARKKr6NNoxkIhK+O+ywfZcTzMBOaye
         We07hiHxiZej1Zg2npfV+xSv2WDjJfrXVjJNpKXgAVCP8zY2old3oUQlFtckElYfa9
         +WhrSuf9HQElw==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
Subject: [PATCH v2 19/19] ovl: support idmapped layers
Date:   Wed, 30 Mar 2022 12:24:07 +0200
Message-Id: <20220330102409.1290850-20-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330102409.1290850-1-brauner@kernel.org>
References: <20220330102409.1290850-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1524; h=from:subject; bh=BiyoSanAlxlhOtl91kLiqfqBOJ35yEF59ejJOB0/jPY=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS56B90ZJoX/M/Y5+5rp/brb8M4I2su/glO0tpoZ7TurKLE PQmtjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIncrGRkaGa54/vNOFq+Y9mNb+v55l hc8GMP1DKwSpXZpSR1kn/SFob/RWlX5SvUHHbeubblhu3TvdJ2HZz7bk0yFkngDM2WYmfiAgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Now that overlay is able to take a layers idmapping into account allow
overlay mounts to be created on top of idmapped mounts.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
/* v2 */
unchanged
---
 fs/overlayfs/ovl_entry.h | 2 +-
 fs/overlayfs/super.c     | 4 ----
 2 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 79b612cfbe52..898b002a5c6f 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -92,7 +92,7 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
 
 static inline struct user_namespace *ovl_upper_idmap(struct ovl_fs *ofs)
 {
-       return &init_user_ns;
+	return mnt_user_ns(ovl_upper_mnt(ofs));
 }
 
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
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

