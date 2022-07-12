Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D069C43334
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Jul 2022 15:25:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiGLPZN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Jul 2022 11:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232986AbiGLPY5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Jul 2022 11:24:57 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 48ED15C9EE;
        Tue, 12 Jul 2022 08:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=G+z5b
        nYslAb/L5CvdEE281XrI0AtqzAgEbcezhR5z/g=; b=of5oPnfq0ElM4u3Gp0z1i
        H6x9dcdaHbpeBh69qyBYQnJumYC0pdTof2nv3tDiWNCBJI1Ds78hDK1D3AuCWwGF
        g8HTkld/63jjyU8LfwTJoKBk+FBMvPH37FIw2dWOHj67/lPR3/D+x2SS3tPRTbGy
        fjcETL9HHU3Fir0f7JuGiQ=
Received: from localhost.localdomain (unknown [123.58.221.99])
        by smtp1 (Coremail) with SMTP id GdxpCgDnQqXpkc1iayuaNw--.2084S2;
        Tue, 12 Jul 2022 23:23:24 +0800 (CST)
From:   williamsukatube@163.com
To:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     miklos@szeredi.hu, William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
Subject: [PATCH -next] ovl: clean up comparsions to NULL
Date:   Tue, 12 Jul 2022 23:23:18 +0800
Message-Id: <20220712152318.2649819-1-williamsukatube@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: GdxpCgDnQqXpkc1iayuaNw--.2084S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF4rKry3ur1xWFy3KFyUZFb_yoW8CFWUpF
        WxCa4rt34rX347ZF1SyF4q9Fy5X395GF47J348uwsFv395Ww4rAryjy3WjqF9rAFWrurWa
        vanYgry5Ja1kZF7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07b1GYLUUUUU=
X-Originating-IP: [123.58.221.99]
X-CM-SenderInfo: xzlozx5dpv3yxdwxuvi6rwjhhfrp/xtbB0Aw8g2EsrUTQrwAAs4
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: William Dean <williamsukatube@gmail.com>

Clean up comparsions to NULL, simplify as follows:
if (x == NULL) -> if (!x)

Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@gmail.com>
---
 fs/overlayfs/readdir.c | 6 +++---
 fs/overlayfs/super.c   | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 78f62cc1797b..953ff22d825c 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -182,7 +182,7 @@ static int ovl_cache_entry_add_rb(struct ovl_readdir_data *rdd,
 		return 0;
 
 	p = ovl_cache_entry_new(rdd, name, len, ino, d_type);
-	if (p == NULL) {
+	if (!p) {
 		rdd->err = -ENOMEM;
 		return -ENOMEM;
 	}
@@ -205,7 +205,7 @@ static int ovl_fill_lowest(struct ovl_readdir_data *rdd,
 		list_move_tail(&p->l_node, &rdd->middle);
 	} else {
 		p = ovl_cache_entry_new(rdd, name, namelen, ino, d_type);
-		if (p == NULL)
+		if (!p)
 			rdd->err = -ENOMEM;
 		else
 			list_add_tail(&p->l_node, &rdd->middle);
@@ -538,7 +538,7 @@ static int ovl_fill_plain(struct dir_context *ctx, const char *name,
 
 	rdd->count++;
 	p = ovl_cache_entry_new(rdd, name, namelen, ino, d_type);
-	if (p == NULL) {
+	if (!p) {
 		rdd->err = -ENOMEM;
 		return -ENOMEM;
 	}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e0a2e0468ee7..a474cb8040b2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -468,7 +468,7 @@ static char *ovl_next_opt(char **s)
 	char *sbegin = *s;
 	char *p;
 
-	if (sbegin == NULL)
+	if (!sbegin)
 		return NULL;
 
 	for (p = sbegin; *p; p++) {
@@ -2186,7 +2186,7 @@ static int __init ovl_init(void)
 					     (SLAB_RECLAIM_ACCOUNT|
 					      SLAB_MEM_SPREAD|SLAB_ACCOUNT),
 					     ovl_inode_init_once);
-	if (ovl_inode_cachep == NULL)
+	if (!ovl_inode_cachep)
 		return -ENOMEM;
 
 	err = ovl_aio_request_cache_init();
-- 
2.25.1

