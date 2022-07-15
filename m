Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90615C43334
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 Jul 2022 10:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbiGOKIU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 15 Jul 2022 06:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbiGOKH4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Jul 2022 06:07:56 -0400
Received: from mail3.bemta32.messagelabs.com (mail3.bemta32.messagelabs.com [195.245.230.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BFB882F9B
        for <linux-unionfs@vger.kernel.org>; Fri, 15 Jul 2022 03:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1657879584; i=@fujitsu.com;
        bh=Fs2Eg5berxPTVL+nkbEys+VtSO89eTwuXIXiAuLmcy0=;
        h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=SrEoZ2vmTHdwySIwLrIEY+nSKsOVAIqMOtAOsu8x231N4mtty0YQjX4rEhBvoOzYt
         1X4Oa4v4OGDBVZEJQlz1SODdauDwvAE24S9FuLHRI2MFX0bZ+N5kpcpiZc5mkg5VFh
         R9r9vbifoXiiY8kAoWv2sn7u+gE2+E4UNLQkr3wX/trg8NaBh5YTiheb6LJH3WYanP
         GHaIhWKQD5/Lip8hXjuxG+/Fcu/kGRtqkMdH+knMy2JcwWWQN+W1bkyDPYBG3dSQLH
         QSdIAi7tPsuCVs5P2hxdyi4RPoMCYEyebqO5uzrKVPYgmE62X81MB65ZYGs66QxTMD
         grWqlskf5mYSg==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRWlGSWpSXmKPExsViZ8ORpCtvczH
  J4M5/S4vXhz8xWrRdX8No8Wz3RmYHZo9NqzrZPFZMu8jk8XmTXABzFGtmXlJ+RQJrxsx339kL
  ergr9hy/w9bAeI6zi5GLQ0hgI6NE18z5TBDOYiaJyT+usEI4exglTqyaydzFyMnBJqAp8axzA
  ZgtIqAssWPyLzCbWcBL4vmvT6wgtrCAvsT/vhtgNouAqsSKDVNYQGxeAQ+JrpbdjCC2hICCxJ
  SH75kh4oISJ2c+YYGYIyFx8MULZogaRYlLHd+g6iskXh++BBVXk7h6bhPzBEb+WUjaZyFpX8D
  ItIrRKqkoMz2jJDcxM0fX0MBA19DQVNdA18jQVC+xSjdRL7VUtzy1uETXUC+xvFgvtbhYr7gy
  NzknRS8vtWQTIzB4U4oZru9gnNj3U+8QoyQHk5Io7yqDi0lCfEn5KZUZicUZ8UWlOanFhxhlO
  DiUJHjXWwLlBItS01Mr0jJzgJEEk5bg4FES4d1tBZTmLS5IzC3OTIdInWJUlBLnvQySEABJZJ
  TmwbXBovcSo6yUMC8jAwODEE9BalFuZgmq/CtGcQ5GJWHeIyBTeDLzSuCmvwJazAS0+KHvBZD
  FJYkIKakGphgfRknu21PcfOo9l2b4ON02Xu5zeePqZes/+4av4St8cOVY5cbVT6ubWeYLHM2P
  meP/PvJCkdeu4G+Pkq2WP787Oajkd1LW4vfPyjJOPbevvuJ86/LH6TeZHnxkqwrULX6Q7LWix
  mdGPkP8txmOb29bVF5VmMraqaEVfrx14+7bWud1MoJPBvu4b/xcp+8hKiQUvlF1mtKNyQ6T9i
  3xdmM/sbiZZwpDSMP7/EtztjeZX5hTd4D5/IfcBRPvV3So7Wxe9fNryZ5TvC3nn1eXhufrZAf
  Xn/5yf/WeQP9v+861Kl0Ikmz8vzAl5rhSSNWV5Sm3mLdrrbwXzTGfe5l4gx9r3D7HrXM/F66Q
  PHJ/7yQlluKMREMt5qLiRACzuLY0WQMAAA==
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-2.tower-585.messagelabs.com!1657879583!75649!1
X-Originating-IP: [62.60.8.98]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 3126 invoked from network); 15 Jul 2022 10:06:23 -0000
Received: from unknown (HELO n03ukasimr03.n03.fujitsu.local) (62.60.8.98)
  by server-2.tower-585.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 15 Jul 2022 10:06:23 -0000
Received: from n03ukasimr03.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTP id 89FBA1AB;
        Fri, 15 Jul 2022 11:06:23 +0100 (BST)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr03.n03.fujitsu.local (Postfix) with ESMTPS id 7EBD27C;
        Fri, 15 Jul 2022 11:06:23 +0100 (BST)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Fri, 15 Jul 2022 11:06:21 +0100
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <linux-unionfs@vger.kernel.org>
CC:     <miklos@szeredi.hu>, <brauner@kernel.org>,
        <xuyang2018.jy@fujitsu.com>
Subject: [PATCH] overlayfs: improve ovl_get_acl
Date:   Fri, 15 Jul 2022 19:06:47 +0800
Message-ID: <1657883207-2159-1-git-send-email-xuyang2018.jy@fujitsu.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.220.84]
X-ClientProxiedBy: G08CNEXCHPEKD08.g08.fujitsu.local (10.167.33.83) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Provide a proper stub for the !CONFIG_FS_POSIX_ACL case.

Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
---
 fs/overlayfs/inode.c     | 2 +-
 fs/overlayfs/overlayfs.h | 6 ++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 492eddeb481f..ba2dde24c1f7 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -460,7 +460,7 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu)
 	const struct cred *old_cred;
 	struct posix_acl *acl;
 
-	if (!IS_ENABLED(CONFIG_FS_POSIX_ACL) || !IS_POSIXACL(realinode))
+	if (!IS_POSIXACL(realinode))
 		return NULL;
 
 	if (rcu)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 4f34b7e02eee..3d8de16a76e9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -599,7 +599,13 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 		  void *value, size_t size);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
+
+#ifdef CONFIG_FS_POSIX_ACL
 struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu);
+#else
+#define ovl_get_acl	NULL
+#endif
+
 int ovl_update_time(struct inode *inode, struct timespec64 *ts, int flags);
 bool ovl_is_private_xattr(struct super_block *sb, const char *name);
 
-- 
2.23.0

