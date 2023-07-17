Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B7B0C001DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 17 Jul 2023 03:11:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbjGQDLQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 16 Jul 2023 23:11:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjGQDLM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Jul 2023 23:11:12 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83F2E4C;
        Sun, 16 Jul 2023 20:11:08 -0700 (PDT)
Received: from kwepemm600013.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4R46TG505lzNmRT;
        Mon, 17 Jul 2023 11:07:46 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600013.china.huawei.com
 (7.193.23.68) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 17 Jul
 2023 11:11:05 +0800
From:   Zhihao Cheng <chengzhihao1@huawei.com>
To:     <amir73il@gmail.com>, <gregkh@linuxfoundation.org>,
        <miklos@szeredi.hu>
CC:     <linux-unionfs@vger.kernel.org>, <stable@vger.kernel.org>,
        <sashal@kernel.org>
Subject: [PATCH 6.1 1/2] ovl: let helper ovl_i_path_real() return the realinode
Date:   Mon, 17 Jul 2023 11:09:03 +0800
Message-ID: <20230717030904.1669754-2-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230717030904.1669754-1-chengzhihao1@huawei.com>
References: <20230717030904.1669754-1-chengzhihao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.67]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600013.china.huawei.com (7.193.23.68)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

[ Upstream commit b2dd05f107b11966e26fe52a313b418364cf497b ]

Let helper ovl_i_path_real() return the realinode to prepare for
checking non-null realinode in RCU walking path.

[msz] Use d_inode_rcu() since we are depending on the consitency
between dentry and inode being non-NULL in an RCU setting.

There are some changes from upstream commit:
1. Context conflicts caused by 73db6a063c785bc ("ovl: port to
   vfs{g,u}id_t and associated helpers") is handled.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Fixes: ffa5723c6d25 ("ovl: store lower path in ovl_inode")
Cc: <stable@vger.kernel.org> # v5.19
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/overlayfs.h | 2 +-
 fs/overlayfs/util.c      | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e74a610a117e..6fb65df09a79 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -367,7 +367,7 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
-void ovl_i_path_real(struct inode *inode, struct path *path);
+struct inode *ovl_i_path_real(struct inode *inode, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_realdata(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 81a57a8d80d9..c9984785999c 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -250,7 +250,7 @@ struct dentry *ovl_i_dentry_upper(struct inode *inode)
 	return ovl_upperdentry_dereference(OVL_I(inode));
 }
 
-void ovl_i_path_real(struct inode *inode, struct path *path)
+struct inode *ovl_i_path_real(struct inode *inode, struct path *path)
 {
 	path->dentry = ovl_i_dentry_upper(inode);
 	if (!path->dentry) {
@@ -259,6 +259,8 @@ void ovl_i_path_real(struct inode *inode, struct path *path)
 	} else {
 		path->mnt = ovl_upper_mnt(OVL_FS(inode->i_sb));
 	}
+
+	return path->dentry ? d_inode_rcu(path->dentry) : NULL;
 }
 
 struct inode *ovl_inode_upper(struct inode *inode)
@@ -1105,8 +1107,7 @@ void ovl_copyattr(struct inode *inode)
 	struct inode *realinode;
 	struct user_namespace *real_mnt_userns;
 
-	ovl_i_path_real(inode, &realpath);
-	realinode = d_inode(realpath.dentry);
+	realinode = ovl_i_path_real(inode, &realpath);
 	real_mnt_userns = mnt_user_ns(realpath.mnt);
 
 	inode->i_uid = i_uid_into_mnt(real_mnt_userns, realinode);
-- 
2.39.2

