From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v2 15/18] fsck.overlay: fix word mistake
Date: Thu, 14 Dec 2017 14:47:44 +0800
Message-ID: <20171214064747.20999-16-yi.zhang@huawei.com>
References: <20171214064747.20999-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:11987 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751502AbdLNGmF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:05 -0500
In-Reply-To: <20171214064747.20999-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 test/local.config | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/local.config b/test/local.config
index 990395f..21b25c2 100644
--- a/test/local.config
+++ b/test/local.config
@@ -10,7 +10,7 @@ export SOURCE_DIR=$PWD/src
 # Overlayfs config
 export LOWER_DIR="lower"
 export UPPER_DIR="upper"
-export WORK_DIR="worker"
+export WORK_DIR="work"
 export MERGE_DIR="merge"
 export LOWER_DIR1="lower1"
-export WORK_DIR1="worker1"
+export WORK_DIR1="work1"
-- 
2.9.5
