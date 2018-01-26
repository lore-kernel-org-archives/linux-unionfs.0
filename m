From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/4] Assorted overlay test fixes
Date: Fri, 26 Jan 2018 09:59:04 +0200
Message-ID: <1516953548-15679-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Eryu,

These assorted fixes improve test-ability with different overlay
mount option configurtions.

The first 2 patches don't fix any known issue, but they fix correctness
of the tests.

Patch 3 prepares the tests to work correctly with nfs_export=on, which
is now on Miklos' overlayfs-next branch. It shouldn't change behavior for
tests running on kernel without nfs_export.

First 3 patches may have trivial conflicts with Zhangyi's patch ("[5/5]
overlay: correct scratch dirs check").

Patch 4 fixes overlay/017 for the default redirect_dir=off configuration.

I believe there has been a miscommunication between us w.r.t overlay/017.
I guess it always fails in your tests and you thought that was expected.
Actually, since commit 0d84683 ("overlay/017: Remove constant
st_ino/d_ino test for hardlinks") the test was expected to pass with
default upstream configuration, but I missed the redirect_dir requirement
and probably also missed communicating this expectation to you.

When I tested overlay/017 with different configurations I ran into a
strange random failure that only happens with base fs xfs and overlay
mount options index=on,nfs_export=off. I finally tracked it down to an
xfs v4.15 regression and figured out why index=on improves the chances
to hit the bug (because overlay inodes are hashed).

So after patch 4 is applied, overlay/017 is expected to pass on upstream
kernel with default configuration and may may with inodex=on.
xfs bug fix was sent to Darrick.

Thanks,
Amir.

Amir Goldstein (4):
  ovelray: drop explicit use of OVERLAY_MOUNT_OPTIONS
  overlay/036: fix upper/lower dir mismatch
  overlay: consider index dir with whiteouts clean
  overlay/017: require and enable redirect_dir

 tests/overlay/017   | 6 ++++--
 tests/overlay/033   | 8 ++++++--
 tests/overlay/034   | 8 ++++++--
 tests/overlay/036   | 4 ++--
 tests/overlay/041   | 6 ++----
 tests/overlay/043   | 6 ++----
 tests/overlay/044   | 7 ++-----
 tests/overlay/048   | 4 +++-
 tests/overlay/group | 2 +-
 9 files changed, 28 insertions(+), 23 deletions(-)

-- 
2.7.4
