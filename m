Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C808FECAAA1
	for <linux-unionfs@archiver.kernel.org>; Mon,  5 Sep 2022 05:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbiIEFsD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 5 Sep 2022 01:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiIEFsD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Sep 2022 01:48:03 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 462332497E;
        Sun,  4 Sep 2022 22:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=W7qfu
        W2COxzqII9yQck1Az5gD2nwiCAVhdk+aSL11rs=; b=McxAL2/qNWlqsJDrkS6W+
        UBA5L6kc7VrlUG/SWdZbq3WWY8xYW1H4TFl2GkLTKkN7A3scAe2iYb7F4Z4xKqGO
        r0trMCr3207fF34k1mTN9nyPwDOYAp0TTQZC1fKpPHpuL+ipEWSbMrZGQsc+v5+P
        /5o+NeBiC7xBtK+Ng2DGdw=
Received: from localhost.localdomain (unknown [116.128.244.169])
        by smtp5 (Coremail) with SMTP id HdxpCgCXeSCGjRVjWMK3Zw--.29957S2;
        Mon, 05 Sep 2022 13:47:50 +0800 (CST)
From:   Jiangshan Yi <13667453960@163.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiangshan Yi <yijiangshan@kylinos.cn>,
        k2ci <kernel-bot@kylinos.cn>
Subject: [PATCH] fs/overlayfs/export.c: fix spelling typo in comment
Date:   Mon,  5 Sep 2022 13:47:36 +0800
Message-Id: <20220905054736.1816872-1-13667453960@163.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HdxpCgCXeSCGjRVjWMK3Zw--.29957S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrury7Jr47ZFy5GFWxWr1Dtrb_yoWfGrcEkw
        12gw40grW5J3WSyr47CrW5tF4Sga1FkrWUJrn3trZ8ua1qqw47Jas8tr1Sqr1DCry8tFyD
        uwn8Jry0kw4rCjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU15l1JUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: bprtllyxuvjmiwq6il2tof0z/1tbiyAZz+1p7HmkcOQAAs1
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Jiangshan Yi <yijiangshan@kylinos.cn>

Fix spelling typo in comment.

Reported-by: k2ci <kernel-bot@kylinos.cn>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
---
 fs/overlayfs/export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index e065a5b9a442..bced83bd9ffa 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -339,7 +339,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	return dentry;
 }
 
-/* Get the upper or lower dentry in stach whose on layer @idx */
+/* Get the upper or lower dentry in stack whose on layer @idx */
 static struct dentry *ovl_dentry_real_at(struct dentry *dentry, int idx)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-- 
2.27.0


No virus found
		Checked by Hillstone Network AntiVirus

