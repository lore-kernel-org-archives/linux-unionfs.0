Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C17BC19F2D
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Aug 2022 02:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbiHECDa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 22:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiHECD3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Aug 2022 22:03:29 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B306432449
        for <linux-unionfs@vger.kernel.org>; Thu,  4 Aug 2022 19:03:28 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LzTMY01dszlVxC;
        Fri,  5 Aug 2022 10:00:41 +0800 (CST)
Received: from dggpemm500016.china.huawei.com (7.185.36.25) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 5 Aug 2022 10:03:26 +0800
Received: from huawei.com (10.67.175.41) by dggpemm500016.china.huawei.com
 (7.185.36.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 5 Aug
 2022 10:03:25 +0800
From:   Yipeng Zou <zouyipeng@huawei.com>
To:     <miklos@szeredi.hu>, <xuyang2018.jy@fujitsu.com>,
        <linux-unionfs@vger.kernel.org>
CC:     <zouyipeng@huawei.com>
Subject: [-next] ovl: clean up compile error without CONFIG_FS_POSIX_ACL
Date:   Fri, 5 Aug 2022 10:00:28 +0800
Message-ID: <20220805020028.69342-1-zouyipeng@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.175.41]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500016.china.huawei.com (7.185.36.25)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

fs/overlayfs/inode.c:462:13: error: ‘ovl_idmap_posix_acl’ defined but
not used [-Werror=unused-function]
 static void ovl_idmap_posix_acl(struct user_namespace *mnt_userns,
              ^~~~~~~~~~~~~~~~~~~
      cc1: all warnings being treated as errors
      make[2]: *** [fs/overlayfs/inode.o] Error 1
      make[2]: *** Waiting for unfinished jobs....
      make[1]: *** [fs/overlayfs] Error 2
      make: *** [fs] Error 2
      make: *** Waiting for unfinished jobs....

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: ded536561a36 ("ovl: improve ovl_get_acl() if POSIX ACL support is
off")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
---
 fs/overlayfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 623e48dad606..b45fea69fff3 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -454,6 +454,7 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 	return res;
 }
 
+#ifdef CONFIG_FS_POSIX_ACL
 /*
  * Apply the idmapping of the layer to POSIX ACLs. The caller must pass a clone
  * of the POSIX ACLs retrieved from the lower layer to this function to not
@@ -491,7 +492,6 @@ static void ovl_idmap_posix_acl(struct user_namespace *mnt_userns,
  *
  * This is obviously only relevant when idmapped layers are used.
  */
-#ifdef CONFIG_FS_POSIX_ACL
 struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu)
 {
 	struct inode *realinode = ovl_inode_real(inode);
-- 
2.17.1

