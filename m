Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86FDC04A68
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jul 2022 01:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiG1Bsw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 21:48:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiG1Bsv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Jul 2022 21:48:51 -0400
Received: from mail1.bemta32.messagelabs.com (mail1.bemta32.messagelabs.com [195.245.230.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23022564F7
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 18:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1658972928; i=@fujitsu.com;
        bh=C3n1xiSbSsvSq9M5rpBPCaD2RbJQY0jXFMYUS8FbTUg=;
        h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=teT8zpdA8Dx+kwpNLRSASX5MinCKwao2tM/0MzEpZ4l5vhYDLVqkc0XxFJDNGACHh
         ESOe651PTyPM9rbjqUBnpKcsMCWzxDC1R/50JSuENN7ma5N3iJowJo8KJ9hAS43O+e
         MFNEym6plB00QbgtPI9njz3Pp/Y8ZZD+sa85xiS9Vcn5E2YszGV54gtDByM3A9Xrg2
         BjeV6pisma5OiAfBX2BYh5V2EG2Ttfur+GTjh3TkynEnUr7iavxBefdaK+uFZGxLQk
         0oE6yhlMKoIaL6XzcPzuFbyjbExWYhrU/i25nm/rTBZncA5E2UJFbz9crnN8yQBPvY
         69mkkjqdtFBpA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRWlGSWpSXmKPExsViZ8MxSff/q4d
  JBsceGVi8PvyJ0aLt+hpGi2e7NzI7MHtsWtXJ5rFi2kUmj8+b5AKYo1gz85LyKxJYM17eX8tU
  0MxXMf/0VKYGxlaeLkYuDiGBLYwS3XvPskM4y5kkLrRPhXL2MEr83H6QsYuRk4NNQFPiWecCZ
  hBbREBc4vTH86wgNrNAvMStbXvA4sICRhJH7iwHi7MIqEp8vbENKM7BwSvgIbFkTQFIWEJAQW
  LKw/dg5bwCghInZz5hgRgjIXHwxQtmiBpFiUsd3xgh7AqJ14cvQcXVJK6e28Q8gZF/FpL2WUj
  aFzAyrWK0TCrKTM8oyU3MzNE1NDDQNTQ01TXWtTDTS6zSTdRLLdUtTy0u0TXUSywv1kstLtYr
  rsxNzknRy0st2cQIDNyUYuawHYx/en/qHWKU5GBSEuWdufBhkhBfUn5KZUZicUZ8UWlOavEhR
  hkODiUJ3sIXQDnBotT01Iq0zBxgFMGkJTh4lER4Zz8DSvMWFyTmFmemQ6ROMSpKifPa3wdKCI
  AkMkrz4NpgkXuJUVZKmJeRgYFBiKcgtSg3swRV/hWjOAejkjDvBpDxPJl5JXDTXwEtZgJavEX
  hAcjikkSElFQDU1JwbVlUpE1PRcL9/7pLl3P9nLZAwW1dUdvSu4zukxvn9PxiNi5M+LSOXaBK
  ip/7d6GB5L8kPtEv6+KW+3+at+T1lDC+ngWKZsVRjjOMAhu2xtcc0X2+8bb06dSvbzT5E/Qr9
  60NWW/CxLz3jlSJo0Zd4renjtt/5N9OtenO9mfTKxLUqv0eIbP265ld5y9W5HZ/Uv7876l37I
  lVlocUI6T6F9stf39Royle963gml0VZxWz+Pqzfui0P1NXNiiTifp0Tf6j5if2GFW1oN3fsk1
  kEzPONsg4Ml5qd924f0NB+7vrdbu9/vWIFtdeit/zMO32+1zL458ylm+IbP1dOMU0jlVrwWI5
  Tt1VHPpKLMUZiYZazEXFiQB4IPklVwMAAA==
X-Env-Sender: xuyang2018.jy@fujitsu.com
X-Msg-Ref: server-4.tower-587.messagelabs.com!1658972927!56236!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 9454 invoked from network); 28 Jul 2022 01:48:47 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
  by server-4.tower-587.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 28 Jul 2022 01:48:47 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id 68436100077;
        Thu, 28 Jul 2022 02:48:47 +0100 (BST)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id 5B3B7100078;
        Thu, 28 Jul 2022 02:48:47 +0100 (BST)
Received: from localhost.localdomain (10.167.220.84) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Thu, 28 Jul 2022 02:48:45 +0100
From:   Yang Xu <xuyang2018.jy@fujitsu.com>
To:     <miklos@szeredi.hu>
CC:     <linux-unionfs@vger.kernel.org>, <brauner@kernel.org>,
        Yang Xu <xuyang2018.jy@fujitsu.com>
Subject: [PATCH v2] overlayfs: improve ovl_get_acl
Date:   Thu, 28 Jul 2022 10:49:24 +0800
Message-ID: <1658976564-2163-1-git-send-email-xuyang2018.jy@fujitsu.com>
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
 fs/overlayfs/inode.c     | 4 +++-
 fs/overlayfs/overlayfs.h | 6 ++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 492eddeb481f..beef5e2ff563 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -454,13 +454,14 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 	return res;
 }
 
+#ifdef CONFIG_FS_POSIX_ACL
 struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu)
 {
 	struct inode *realinode = ovl_inode_real(inode);
 	const struct cred *old_cred;
 	struct posix_acl *acl;
 
-	if (!IS_ENABLED(CONFIG_FS_POSIX_ACL) || !IS_POSIXACL(realinode))
+	if (!IS_POSIXACL(realinode))
 		return NULL;
 
 	if (rcu)
@@ -472,6 +473,7 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu)
 
 	return acl;
 }
+#endif
 
 int ovl_update_time(struct inode *inode, struct timespec64 *ts, int flags)
 {
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
2.27.0

