From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/3] Overlayfs restoring of origin fh
Date: Tue,  7 Nov 2017 23:38:57 +0200
Message-ID: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:43645 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964802AbdKGViR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 16:38:17 -0500
Received: by mail-wr0-f196.google.com with SMTP id 4so589798wrt.0
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 13:38:17 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Miklos,

This series is complementary to the whiteouts expose patches.
Patch 2 restores origin xattr on lookup of merge dir (that was copied up
before v4.12).
Patch 3 sets a 'null' origin fh on dir if we happen to iterate an 'impure'
dir and find a whiteout while looking for copy ups. This is expected to
happen if merge dir was copied up before v4.12, but files inside it were
copied up after v4.12.

This series is currently based on top of non-samefs series and all patches
for v4.15 are piled on my overlayfs-devel branch [1]. Let me know if you
want me to rebase them differently.

I enhanced Zhangyi's xfstest overlay/031, which tests for exposed whiteouts
to cover the 2 cases addressed by this series. The enhanced test is
available on my xfstests branch [2].

Zhangyi,

I would appreciate a review of those patches and the test changes.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/overlayfs-devel
[2] https://github.com/amir73il/xfstests/commits/overlayfs-devel

Amir Goldstein (3):
  ovl: remove unneeded arg from ovl_verify_origin()
  ovl: set origin xattr for merge dir on lookup
  ovl: recover from whiteouts in impure dir iteration

 fs/overlayfs/namei.c     | 63 +++++++++++++++++++++++++++++++++++++++---------
 fs/overlayfs/overlayfs.h |  5 ++--
 fs/overlayfs/readdir.c   | 41 ++++++++++++++++++++++++++++---
 fs/overlayfs/super.c     |  7 +++---
 fs/overlayfs/util.c      | 21 ++++++++++++++++
 5 files changed, 117 insertions(+), 20 deletions(-)

-- 
2.7.4
