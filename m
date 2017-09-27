From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/4] fstests: fixes for config option OVERLAY_MOUNT_OPTIONS
Date: Wed, 27 Sep 2017 10:04:08 +0300
Message-ID: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:45525 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751136AbdI0HDl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Sep 2017 03:03:41 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Eryu,

Since v4.13, overlayfs supports mount option index=on/off per mount
and kernel config option CONFIG_OVERLAY_FS_INDEX that sets the default
system wide value when mount option is not specified.

The behavior of overlayfs may differ for index=on/off, specifically
for hardlinks. It is therefore important to be able to test overlayfs
with both index=on/off.

To that end exists the OVERLAY_MOUNT_OPTIONS config option, only
when I tried to use it I found it was broken in more than one way.
This series fixed the use of OVERLAY_MOUNT_OPTIONS and refactors
some customized overlay mount helpers along the way.

NOTE for users of kvm-xfstests, this test-appliance change is also
required for invoking kvm-xfstests -m index=on/off
https://github.com/tytso/xfstests-bld/pull/4

Amir Goldstein (4):
  overlay: remove stale implementation of _scratch_mount_options
  overlay: use default overlay mount options _overlay_mount_dirs()
  overlay: create helper _overlay_scratch_mount_dirs()
  overlay: fix _overlay_config_override of MOUNT_OPTIONS

 common/config     |  4 ++++
 common/rc         | 36 ++++++++++++++++--------------------
 tests/overlay/005 |  2 +-
 tests/overlay/010 |  3 +--
 tests/overlay/014 |  8 +++-----
 tests/overlay/031 | 11 +++++------
 tests/overlay/035 |  3 +--
 tests/overlay/037 | 14 ++++++--------
 tests/overlay/038 |  3 +--
 9 files changed, 38 insertions(+), 46 deletions(-)

-- 
2.7.4
