Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23EBC38A2D
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Oct 2022 05:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiJ0FbM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Oct 2022 01:31:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJ0FbL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Oct 2022 01:31:11 -0400
Received: from out199-12.us.a.mail.aliyun.com (out199-12.us.a.mail.aliyun.com [47.90.199.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F71D15A8FE;
        Wed, 26 Oct 2022 22:31:09 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0VTA1yNm_1666848664;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VTA1yNm_1666848664)
          by smtp.aliyun-inc.com;
          Thu, 27 Oct 2022 13:31:05 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] ovl: Remove duplicated include in inode.c
Date:   Thu, 27 Oct 2022 13:31:03 +0800
Message-Id: <20221027053103.123173-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

./fs/overlayfs/inode.c: linux/posix_acl.h is included more than once.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2599
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 fs/overlayfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 77a77fd7a77b..d52bcdad4e5b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -14,7 +14,6 @@
 #include <linux/fileattr.h>
 #include <linux/security.h>
 #include <linux/namei.h>
-#include <linux/posix_acl.h>
 #include <linux/posix_acl_xattr.h>
 #include "overlayfs.h"
 
-- 
2.20.1.7.g153144c

