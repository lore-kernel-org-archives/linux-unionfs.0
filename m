From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/6] fstests: more tests for overlay constant inode numbers
Date: Fri, 28 Apr 2017 11:24:42 +0300
Message-ID: <1493367888-26550-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34905 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033622AbdD1IYk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 04:24:40 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Hi Eryu,

This series contains enhancements to overlay/017, which I used to test
my work on overlayfs constant inode numbers. [1]

The original test was a bit naiive, not taking into account renames,
drop caches and mount cycle. All those are added by this series.
Since the original test does not pass on stable kernel nor will
it pass with the changes by this series, these changes should cause
no regressions to testers.

My work covers only the inode numbers returned from stat(2) and not
the inode numbers returned in d_ino from readdir(3), so the 'find -inum'
part of this test could still fail with my overlayfs patches.

However, I ran my tests in kvm-xfstests VM, where 'find -inum' called
stat(2) for each entry, so the test did pass.

I will dig deeper into this behavior when I work on fixing d_ino
values in the next part of my work.

Changes since v1:
- Re-factor check_inode_numbers
- Move -maxdepth option position
- Fix somme comments
- Blurb more in commit messages

Amir.

[1] https://marc.info/?l=linux-unionfs&m=149324252301397&w=2


Amir Goldstein (6):
  overlay/017: silence test output
  overlay/017: fix some comments
  overlay/017: use af_unix to create socket test file
  overlay/017: create helpers to record and check inode numbers
  overlay/017: verify constant inode number after rename
  overlay/017: test persistent inode numbers after mount cycle

 tests/overlay/017     | 86 +++++++++++++++++++++++++++++++++++++++++----------
 tests/overlay/017.out |  7 +----
 2 files changed, 70 insertions(+), 23 deletions(-)

-- 
2.7.4
