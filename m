Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09446C433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 30 Mar 2022 10:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245327AbiC3K1H (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 06:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244839AbiC3K1E (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Mar 2022 06:27:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B062A25E327
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 03:25:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4593C61485
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 10:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD402C340F2;
        Wed, 30 Mar 2022 10:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648635918;
        bh=TlqXaLV2tO3GGHLcLOr9shbbhchAuEfnbRPH5bknL34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6OWh7G2R+RGhlG63Dg+kzjVPO6qCuPAaw7C0D6ZQbl/QetnmQKkF3CL0v6wAIyWm
         NlaPthvzvtkk9k8mDlIhVHhVoY/HqRNF8xL4NebQB0Y2a9RcJi2OHCE4bmJ2lrggfD
         /3v+eQ5nPebA5m+Xsm/IZ4KT6+rhqE07wPYy4/+Aa49T/aKCHuk8ixAn/CRo73Zs7A
         8JB6pWUgNSdAnsYECK1nOr+FhMaFZBvlsXgtQBuREtN09GhbfGv8Z9AmsK7SJjqznA
         r1V7WSsDM3fF1QBQRjvEoVOMaTZ3mGF3t8E1TyWhbDiHo+iE2bvuKobzwyWa5XLJXz
         8uENUGt5csRCg==
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
Subject: [PATCH v2 05/19] ovl: add ovl_upper_idmap() wrapper
Date:   Wed, 30 Mar 2022 12:23:53 +0200
Message-Id: <20220330102409.1290850-6-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220330102409.1290850-1-brauner@kernel.org>
References: <20220330102409.1290850-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1279; h=from:subject; bh=TlqXaLV2tO3GGHLcLOr9shbbhchAuEfnbRPH5bknL34=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSS56O9Z/0Vc8I5IkU+ElPff/WuD5+/y/8qxo3Cvsf4xblZm id3dHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMRL2NkWHvooaCOiPWHzyET8vQ7mZ jeJfTNmNd4KeDCJq6kwKo7pxn+6UqnL2ix9xBeJLp1Tec3sZnCQo9u3JgVxW91Odvr/NYJXAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Add a tiny wrapper to retrieve the upper mount's idmapping. Have it
return the initial idmapping until we have prepared and converted all
places to take the relevant idmapping into account. Then we can switch
on idmapped layer support by having ovl_upper_idmap() return the upper
mount's idmapping.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
/* v2 */
- Miklos Szeredi <mszeredi@redhat.com>:
  - Add separate patch for ovl_upper_idmap() and have it return the
    initial idmapping until we turn idmapped layer support on later.
---
 fs/overlayfs/ovl_entry.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 63efee554f69..22ce60426de2 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -90,6 +90,11 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
 	return ofs->layers[0].mnt;
 }
 
+static inline struct user_namespace *ovl_upper_idmap(struct ovl_fs *ofs)
+{
+       return &init_user_ns;
+}
+
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 {
 	return (struct ovl_fs *)sb->s_fs_info;
-- 
2.32.0

