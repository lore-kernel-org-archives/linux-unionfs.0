From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] xfstests-bld: improve overlayfs testing
Date: Sun,  6 Nov 2016 12:23:15 +0200
Message-ID: <1478427797-8969-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Ted,

Following are the changes to xfstests-bld I have been using to test overlayfs.

xfstests master branch just got updated with several fixes to overlay/* tests.
One overlayfs bug that was caught by generic/375 was fixed for 4.9-rc4 and one
that was caught by generic/157 is queued on overlayfs-next branch.

With these changes to test-appliance, one can test drive overlayfs clone-up
over xfs with reflink support. Xfs with reflink support was merged to 4.9-rc1
and relevant xfsprogs changes are queued on xfsprogs for-next branch.
Overlayfs clone-up is queued on overlayfs-next branch.

Decided to have a little fun and send this one out to you also via github PR.

Thanks for setting up xfstests-bld.
It has been a great help in bringing up my test env.

Amir.

Amir Goldstein (2):
  test-appliance: add xfs/reflink config
  test-appliance: add support for overlayfs over xfs

 .../test-appliance/files/root/fs/overlay/config    | 44 ++++++++++++++++++----
 .../test-appliance/files/root/fs/xfs/cfg/reflink   |  3 ++
 kvm-xfstests/util/parse_cli                        |  2 +-
 3 files changed, 40 insertions(+), 9 deletions(-)
 create mode 100644 kvm-xfstests/test-appliance/files/root/fs/xfs/cfg/reflink

-- 
2.7.4
