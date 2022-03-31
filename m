Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED1FC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Mar 2022 11:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbiCaL00 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Mar 2022 07:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235138AbiCaL0Y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Mar 2022 07:26:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966276257
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 04:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4949AB820C4
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Mar 2022 11:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 285E9C340EE;
        Thu, 31 Mar 2022 11:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648725875;
        bh=xsdHOl3QQXc2cLsK8wZlpMPkOxEP5FoFlYjI54IZoxc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rdjGDn5nCXjTdFvwvX95aTBMgV1RTU3IrqGaY/7a4Hqfyj4zsE4bkydC6gm4DiBx1
         qFXv7RigAaPbw8S5eEoyKcW9DzhWhjhxdbX8Wfzlmr+9Ttf1M9HNsGKoiqs+Rvhopl
         OwrHmlgPrOiisxJLoERvnKWB4nB4Pd3Kop61HIcqqNnsmSSxZadBsDrz3OhYl8QY2m
         rogZEk4qZ54OaXR0jLmgOYuSinnVFYGXHStZa5v5Aeor/oVCGigrIvtpKF8nLepmNp
         T4N40blos/8NIXKr6Ruf+CRTJZuVYZ8jp0qiO0ZxChWn6IJXC+ua3sG5/N7xoMW19a
         8zMXCg0o6WQzw==
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
Subject: [PATCH v3 12/19] ovl: handle idmappings for layer fileattrs
Date:   Thu, 31 Mar 2022 13:23:10 +0200
Message-Id: <20220331112318.1377494-13-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220331112318.1377494-1-brauner@kernel.org>
References: <20220331112318.1377494-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=993; h=from:subject; bh=xsdHOl3QQXc2cLsK8wZlpMPkOxEP5FoFlYjI54IZoxc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS59ktpbPm1ldPy7QuvbxI3D/LVPnxYcaqWe5rjogvXYqoW fVn3rqOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAid7oZGb7Jpyx44hPpouxr+pvB2t zHpH5m5r10vbBUppB3JQLHKhn+l8j3PRLarv9sy4fvi0XcLglHLit1VpY2sS9cYnuYP+87JwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Take the upper mount's idmapping into account when setting fileattrs on
the upper layer. This is needed to support idmapped base layers with
overlay.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
/* v2 */
unchanged

/* v3 */
unchanged
---
 fs/overlayfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 763dada2ae68..f18b02b9dd53 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -537,7 +537,7 @@ int ovl_real_fileattr_set(struct path *realpath, struct fileattr *fa)
 	if (err)
 		return err;
 
-	return vfs_fileattr_set(&init_user_ns, realpath->dentry, fa);
+	return vfs_fileattr_set(mnt_user_ns(realpath->mnt), realpath->dentry, fa);
 }
 
 int ovl_fileattr_set(struct user_namespace *mnt_userns,
-- 
2.32.0

