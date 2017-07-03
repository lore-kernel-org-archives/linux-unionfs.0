From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstest PATCH V3 0/2] overlay/031: add two tests of whiteout check in origin dir
Date: Mon, 3 Jul 2017 18:43:29 +0800
Message-ID: <1499078611-18755-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([45.249.212.188]:9339 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754105AbdGCKjj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 3 Jul 2017 06:39:39 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: eguan@redhat.com, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com

Add two tests of whiteout check in origin dir, cover other
two situations:

1) Lower origined dir have whiteouts;
2) Both upper and lower origined dirs have whiteouts (although
this case is pass now, still add this to cover all three kinds
of situations).

V3:
fix testdir verify origin failure with inodes index feature.

V2:
factor out _create_whiteout() helper,
test whiteout in the middle layer,
fix test failure with inodes index feature.

zhangyi (F) (2):
  overlay/031: factor out _create_whiteout() helper
  overlay/031: add tests of whiteouts in lowerdir and both dirs

 tests/overlay/031 | 84 ++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 64 insertions(+), 20 deletions(-)

-- 
2.5.0
