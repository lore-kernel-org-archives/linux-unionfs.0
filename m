Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCE21ECAAA1
	for <linux-unionfs@archiver.kernel.org>; Fri,  9 Sep 2022 09:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiIIJIR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 9 Sep 2022 05:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiIIJIN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 9 Sep 2022 05:08:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73B995727F
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Sep 2022 02:08:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0815161F4B
        for <linux-unionfs@vger.kernel.org>; Fri,  9 Sep 2022 09:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD961C433C1;
        Fri,  9 Sep 2022 09:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662714491;
        bh=0a3pbge29fF90Ee/MxPWEV27CllE5J5Tl3LSgHPAC7s=;
        h=From:To:Cc:Subject:Date:From;
        b=T8X+7L19IrblmsjduyDPPHNnoIwxWz/re5qjVV3lR9Qux157kzVojDusnspV/0/iV
         a8WLWCH2e4ZZ9LKc93CZeojH81HxuukIC+31s9ShHqpC62LhU3MT5XBAM7PE2x3X5l
         brxAliGfs7tchJMuCgilXL9Egi67o9jRtZEP+1NYO5T/CczXmqBhmdeUYCE/JoQ+a9
         fMDTIT3wNFbf8jHSV/1RJyVAkDiGjramFcBPQaV8e53lm7w9O37UszEfih4u3Rd4gP
         cId1JnXAl6VDWkQZZtmCMlpNEVNTL+vRdHEs0N86vZrAjDK60JywvTuum/lsQ/FAGm
         Tw1ZIf41GBg6g==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Seth Forshee <sforshee@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: port to vfs{g,u}id_t and associated helpers
Date:   Fri,  9 Sep 2022 11:07:47 +0200
Message-Id: <20220909090747.930375-1-brauner@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1707; i=brauner@kernel.org; h=from:subject; bh=0a3pbge29fF90Ee/MxPWEV27CllE5J5Tl3LSgHPAC7s=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSRLMwWJNN8Ju3hFjfHnDJ1zipPdmf3WBN9xSaywv7VUs+Cl 4NPajlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIns6mZkWJXxeNrkGzfkYk7qsdeXG1 vZ3vFLmB1rGDw1xTywbP99YUaGjfOWliYsKZm2/1YyU6H3wQTufTst5s9J51aXLZ22K9KUFwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

A while ago we introduced a dedicated vfs{g,u}id_t type in commit
1e5267cd0895 ("mnt_idmapping: add vfs{g,u}id_t"). We already switched
over a good part of the VFS. Ultimately we will remove all legacy
idmapped mount helpers that operate only on k{g,u}id_t in favor of the
new type safe helpers that operate on vfs{g,u}id_t.

Cc: Seth Forshee (Digital Ocean) <sforshee@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/overlayfs/util.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 87f811c089e4..40ea42c5100a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1104,13 +1104,18 @@ void ovl_copyattr(struct inode *inode)
 	struct path realpath;
 	struct inode *realinode;
 	struct user_namespace *real_mnt_userns;
+	vfsuid_t vfsuid;
+	vfsgid_t vfsgid;
 
 	ovl_i_path_real(inode, &realpath);
 	realinode = d_inode(realpath.dentry);
 	real_mnt_userns = mnt_user_ns(realpath.mnt);
 
-	inode->i_uid = i_uid_into_mnt(real_mnt_userns, realinode);
-	inode->i_gid = i_gid_into_mnt(real_mnt_userns, realinode);
+	vfsuid = i_uid_into_vfsuid(real_mnt_userns, realinode);
+	vfsgid = i_gid_into_vfsgid(real_mnt_userns, realinode);
+
+	inode->i_uid = vfsuid_into_kuid(vfsuid);
+	inode->i_gid = vfsgid_into_kgid(vfsgid);
 	inode->i_mode = realinode->i_mode;
 	inode->i_atime = realinode->i_atime;
 	inode->i_mtime = realinode->i_mtime;

base-commit: 7e18e42e4b280c85b76967a9106a13ca61c16179
-- 
2.34.1

