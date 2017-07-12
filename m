From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] Require overlay index feature for hardlink tests
Date: Wed, 12 Jul 2017 12:43:23 +0300
Message-ID: <1499852605-27759-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34944 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750738AbdGLJnM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jul 2017 05:43:12 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

Per your request, with these changes, the overlay/hardlink tests will
"notrun" on kernels <= v4.12, where they are bound to fail.
The test are expected to run and pass on -next kernel regardless of
the value of kernel config CONFIG_OVERLAY_FS_INDEX.

Amir Goldstein (2):
  fstest: add helper _require_fs_feature
  overlay: enable the index feature for overlay/hardlink tests

 common/rc         | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/018 |  8 +++++---
 tests/overlay/032 |  4 +++-
 tests/overlay/033 |  8 +++++---
 tests/overlay/034 |  9 ++++++---
 5 files changed, 67 insertions(+), 10 deletions(-)

-- 
2.7.4
