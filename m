From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/5] fstests: more tests for overlay constant inode numbers
Date: Thu, 27 Apr 2017 18:09:30 +0300
Message-ID: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36010 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755713AbdD0PJ3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2017 11:09:29 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Hi Eryu,

This series contains enhancements to overlay/017, which I used to test
my work on overlayfs constant inode numbers. [1]

The original test was a bit naiive, not taking into account renames,
drop caches and mount cycle. All those are added by this series.

My work covers only the inode numbers returned from stat(2) and not
the inode numbers returned in d_ino from readdir(3), so the 'find -inum'
part of this test could still fail with my overlayfs patches.

However, I ran my tests in kvm-xfstests VM, where 'find -inum' called
stat(2) for each entry, so the test did pass.

I will dig deeper into this behavior when I work on fixing d_ino
values in the next part of my work.

Amir.

[1] https://marc.info/?l=linux-unionfs&m=149324252301397&w=2

Amir Goldstein (5):
  overlay/017: silence test output
  overlay/017: use af_unix to create socket test file
  overlay/017: create a helper to record inode number
  overlay/017: verify constant inode number after rename
  overlay/017: test persistent inode numbers after mount cycle

 tests/overlay/017     | 69 +++++++++++++++++++++++++++++++++++++++++++++------
 tests/overlay/017.out |  7 +-----
 2 files changed, 62 insertions(+), 14 deletions(-)

-- 
2.7.4
