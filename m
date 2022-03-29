Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D12C433FE
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 10:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235214AbiC2Ki4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 06:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbiC2Kix (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 06:38:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0760EC12E2
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 03:37:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9590A60ADF
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 10:37:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2368DC340ED;
        Tue, 29 Mar 2022 10:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648550230;
        bh=aCJEyE7xept0ohQd/V0mlPqNgaIhmTR7qbjZGHhX7xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUjTGue+u/4w5q1e2gUQ5pRn1b+dK4nWA/QmWtIeR7lW9HoMUp8hQ+8uSv7yAsANu
         b9rUZ5F49kNpFC1juMT8QPIQ8OQPjTEJ6ZD8xzjyvltXTlEl4f46DAsUizWYE6ZlkU
         JzY5Ec6oYcjhvcn04kZArTyb7vRSY42Fd67bPOJo+T1REN728z9LuvIalg5+QLLpPB
         +yh/WgbgwIj6jk5HQwpJfk+BdOrzmQfTP4dNjl4g4u9u038uX7/SEFwdVc5QLI4rXU
         0hMMGtAvDLgr9qNTVJFOcG1hvU3JW+6Itmz8dJVLGXlDfXjdqLcscUNG0jeWxv3g56
         ydW3Ar//Yk0Sw==
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
Subject: [PATCH 11/18] ovl: handle idmappings for layer fileattrs
Date:   Tue, 29 Mar 2022 12:35:18 +0200
Message-Id: <20220329103526.1207086-12-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
References: <20220329103526.1207086-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=944; h=from:subject; bh=aCJEyE7xept0ohQd/V0mlPqNgaIhmTR7qbjZGHhX7xk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQ5Pdjveth7/p2JT7nL26r5Z/Eslsy83+FVNXt77geG8HwR mfbrHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5q8fI8L+MZ47ovgNNcyYztVru4/ +Slyu3Y8a5ThndDl4t/o0zhBgZlr+SnPkk/IzzczfBigdab6Ki1p7KO+HLdzSVY8PHD+GNXAA=
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

