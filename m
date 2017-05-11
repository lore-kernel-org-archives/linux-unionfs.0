From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/4] overlay/017: fix false negatives
Date: Thu, 11 May 2017 09:55:06 +0300
Message-ID: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34972 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdEKGy6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 May 2017 02:54:58 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

With current mainline master branch, overlay/017 may pass on some systems
(e.g. kvm-xfstests) due to a bug in the test, which I already reported.

This series fixes the test back to failing by using the auxiliary program
t_dir_type instead of 'find' whose behavior is system dependent.

I also removed the exception of testing hardlinks, so now the test really
tests what it was meant to test (constant inode number across copy up)
without any discounts for special cases.

Amir.

Amir Goldstein (4):
  src/t_dir_type: support filtering by inode number
  overlay/017: use t_dir_type to find file by d_ino
  overlay/017: test consistent st_ino/d_ino for hardlinks
  overlay: tag tests 016-018 as experimental

 doc/auxiliary-programs.txt |  7 +++++++
 src/t_dir_type.c           | 11 ++++++++---
 tests/overlay/017          |  9 +++++----
 tests/overlay/group        |  6 +++---
 4 files changed, 23 insertions(+), 10 deletions(-)

-- 
2.7.4
