Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F90C433FE
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Apr 2022 11:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244770AbiDGLZL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Apr 2022 07:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236014AbiDGLZK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Apr 2022 07:25:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A8130F78
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 04:23:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 39EB661E55
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Apr 2022 11:23:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A05C385A4;
        Thu,  7 Apr 2022 11:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649330590;
        bh=y75S2JiD02rg9n67YR1VjHR9p5RZPN6CJfGcoFdUhXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eGvMFC5l/YeuFMSB7nsxBGLc8C7kWyTVS3rtYIEV8VnJN/+7EuJwMPBHffAbjpj0G
         IWetp7OPNSO+D2QaAgZ215PymK76U45QEMf4P48QAi62HaNRV09nciLSnsZl6FSI7m
         jRC1duXAq7OnQ2G21t0dcY8/cex+GdaUWlsFRF6TQ/+vfu1pQMuAAPQiXGjKIC+hlN
         3RDQ3z6dKTwxrBNs99toHwYe0YUd8OidvlLp9rmc1L0ZfW3XwoefQ9PCcoMkGIXMDj
         xFirJCeYwPFP6/1fssIONt2CJKrKnzFSsrLc+kW6PUEy9PdJ27xMRjEmrxwiXOu4yp
         wumhEwHBzTIWQ==
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
Subject: [PATCH v5 12/19] ovl: handle idmappings for layer fileattrs
Date:   Thu,  7 Apr 2022 13:21:49 +0200
Message-Id: <20220407112157.1775081-13-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220407112157.1775081-1-brauner@kernel.org>
References: <20220407112157.1775081-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1039; h=from:subject; bh=y75S2JiD02rg9n67YR1VjHR9p5RZPN6CJfGcoFdUhXM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMST5nfSp2Fd0oO+2o5e4oODazyaii61emES8vr/UUzfZbKVQ iNWljlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImIxzP84c3ov7TbiqNnppix5KSlHP 5J22/e2GC3wbP6e2nKicYTaxj+ewZ933etJMt13dRIzw1lf6QnLtgncWP99bflnHFcGnFzGQE=
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

/* v4 */
unchanged

/* v5 */
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

