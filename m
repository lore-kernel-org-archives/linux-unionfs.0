Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1557C433F5
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Apr 2022 10:54:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358723AbiDDK4a (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Apr 2022 06:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358719AbiDDK4Z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Apr 2022 06:56:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB43344CD
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 03:54:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 169C6B815A3
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Apr 2022 10:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01F9C340F3;
        Mon,  4 Apr 2022 10:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649069666;
        bh=FNbmrHYnyrFEOCNNWMuCPbBKYMAPzX+KajqRsIo2ANM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tT++W8HId6Y+L4/WyZd/ez1O9lXuZJbrNjWRgIpCQEOVFn8K+w8zfnmqchY7al5VM
         nCpjdUkOdsTPlzOlK4RYkmoI765Ot/TrIOXL5wvRFB+mkpzLEtDAxpzmcVjnA8mjdc
         +LYnWFP/MD39RdgPY8M6pwxZSNkx1GTu6gdpHRbp5Ea/8ow0EVIl2ES+iBHIRDZGj1
         OqziWqfcliNUKBxKbnogZL4U9G/5SGez9SBg+yMqx2KrXO6OrriBJERIjMd3SD2z9O
         GCSsQTfD/PMaACsm11LUk+zef90nayInOil4+xfppfbIMUaYxPuE+hoiXYe2A5DZYv
         1+1vNDtvTaTNg==
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
Subject: [PATCH v4 12/19] ovl: handle idmappings for layer fileattrs
Date:   Mon,  4 Apr 2022 12:51:51 +0200
Message-Id: <20220404105159.1567595-13-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220404105159.1567595-1-brauner@kernel.org>
References: <20220404105159.1567595-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1016; h=from:subject; bh=FNbmrHYnyrFEOCNNWMuCPbBKYMAPzX+KajqRsIo2ANM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSR5nT2qdteWXY1J59zvcLEPvlYmVydovd8hZ6ciGM/dFt9w y6Guo5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCJvNBkZPjorbPuUE/Cb72v0F69dGY Kt3itPfl2Vd+32srCPN11N9zL8T1nd+2jHnhLb4k0yGyI5j7DIR0f+eRMgPavgSbTf8uNHeQE=
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

