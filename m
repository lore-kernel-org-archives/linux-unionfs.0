Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89EE7C433FE
	for <linux-unionfs@archiver.kernel.org>; Tue,  8 Nov 2022 12:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbiKHMAZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 8 Nov 2022 07:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbiKHMAY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 Nov 2022 07:00:24 -0500
X-Greylist: delayed 302 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Nov 2022 04:00:22 PST
Received: from mxct.zte.com.cn (mxct.zte.com.cn [58.251.27.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6BB1E701
        for <linux-unionfs@vger.kernel.org>; Tue,  8 Nov 2022 04:00:22 -0800 (PST)
Received: from mxde.zte.com.cn (unknown [10.35.20.165])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4N663q1TJTz1Ds0
        for <linux-unionfs@vger.kernel.org>; Tue,  8 Nov 2022 19:55:19 +0800 (CST)
Received: from mxus.zte.com.cn (unknown [10.207.168.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxde.zte.com.cn (FangMail) with ESMTPS id 4N663l4Pp1z5TCG4
        for <linux-unionfs@vger.kernel.org>; Tue,  8 Nov 2022 19:55:15 +0800 (CST)
Received: from mxhk.zte.com.cn (unknown [192.168.250.138])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxus.zte.com.cn (FangMail) with ESMTPS id 4N663h4pnZzdmMKn
        for <linux-unionfs@vger.kernel.org>; Tue,  8 Nov 2022 19:55:12 +0800 (CST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4N663Z3M4wz5BNRf;
        Tue,  8 Nov 2022 19:55:06 +0800 (CST)
Received: from szxlzmapp04.zte.com.cn ([10.5.231.166])
        by mse-fl2.zte.com.cn with SMTP id 2A8BswfK040037;
        Tue, 8 Nov 2022 19:54:58 +0800 (+08)
        (envelope-from yang.yang29@zte.com.cn)
Received: from mapi (szxlzmapp03[null])
        by mapi (Zmail) with MAPI id mid14;
        Tue, 8 Nov 2022 19:55:01 +0800 (CST)
Date:   Tue, 8 Nov 2022 19:55:01 +0800 (CST)
X-Zmail-TransId: 2b05636a4395415c08b9
X-Mailer: Zmail v1.0
Message-ID: <202211081955011261898@zte.com.cn>
Mime-Version: 1.0
From:   <yang.yang29@zte.com.cn>
To:     <miklos@szeredi.hu>
Cc:     <linux-unionfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <xu.panda668@gmail.com>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIG92bDogcmVtb3ZlIGR1cGxpY2F0ZWQgaW5jbHVkZWQgbGludXgvcG9zaXhfYWNsLmg=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2A8BswfK040037
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.14.novalocal with ID 636A43A6.000 by FangMail milter!
X-FangMail-Envelope: 1667908519/4N663q1TJTz1Ds0/636A43A6.000/10.35.20.165/[10.35.20.165]/mxde.zte.com.cn/<yang.yang29@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 636A43A6.000/4N663q1TJTz1Ds0
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Xu Panda <xu.panda@zte.com.cn>

The linux/posix_acl.h is included more than once.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Signed-off-by: Yang Yang <yang.yang29@zte.com>
---
 fs/overlayfs/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ee6dfa577c93..d110f8626b69 100644
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
2.15.2
