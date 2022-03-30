Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80A89C433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 30 Mar 2022 10:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244096AbiC3K1p (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242937AbiC3K1p (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Mar 2022 06:27:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5D625FD6F
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 03:26:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B4A5B81BE4
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 10:25:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF7BC340EC;
        Wed, 30 Mar 2022 10:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648635957;
        bh=9X1MQgr2Jt51zQGDU3SHJuFtMdDuYl8ZtYK1kuCBzvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qYakIrEGGP7jiOuGHUD8GsgciHD2EXd1ipanhx6khQPJXqFBYVt5unlLeWBUweNye
         jsyXZyUwYXg/I06TdDG4MK79+13mt+xWikArdYbPs7IJwLZg+5DAJ/bTlfaEI8YCOY
         WAzjr+5wj9bdXjPiinxV7hzwSejob0KPimwe/kfoKCntBCzaA6dHl0RJWZGvCJKrwq
         3FjoCGuxpS04uGwsjblv6F4frLNmpH5DZj+U7UVoqUoiKB6T536joNCJZXTKh9PVFy
         Dy86PpZEpu65e6Arns0haxNGGkbitlAx9XgFewtnSKi949HANrzY6OquhTdsjPexC1
         nE+nXV5xVv6gA==
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
Subject: [PATCH v2 12/19] ovl: handle idmappings for layer fileattrs
Date:   Wed, 30 Mar 2022 12:24:00 +0200
Message-Id: <20220330102409.1290850-13-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330102409.1290850-1-brauner@kernel.org>
References: <20220330102409.1290850-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=970; h=from:subject; bh=9X1MQgr2Jt51zQGDU3SHJuFtMdDuYl8ZtYK1kuCBzvw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS56O+P0d5vVryosfxH+p/ULG3TadkP9zwN2Oq68U/KHaHy Pc96O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACay2ovhn6L1A7UN7UsPXwj7eW7/I7 6W62xmuqtEVStmn37LvGX6pOmMDBNaPBtn5h4sTlSdFOixQeQ517UDP9kbLRQV36+Qnv90NhsA
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

