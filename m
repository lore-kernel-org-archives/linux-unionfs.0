From: weiyj_lk@163.com
Subject: [PATCH -next] ovl: remove duplicated include from super.c
Date: Wed,  6 Jul 2016 12:27:15 +0000
Message-ID: <1467808035-32411-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from m12-17.163.com ([220.181.12.17]:57201 "EHLO m12-17.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbcGFM1t (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 6 Jul 2016 08:27:49 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, linux-unionfs@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove duplicated include.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/overlayfs/super.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e1f5203..f931490 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -16,7 +16,6 @@
 #include <linux/slab.h>
 #include <linux/parser.h>
 #include <linux/module.h>
-#include <linux/pagemap.h>
 #include <linux/sched.h>
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
