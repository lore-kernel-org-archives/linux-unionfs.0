From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/3] xfstests: mount cycle overlay base fs
Date: Fri, 27 Jan 2017 10:56:02 +0200
Message-ID: <1485507365-29012-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Eryu,

The main motivation for this work was to help catch overlayfs bugs
related to leaking objects in underlying (base) fs.
Along the way, it also addresses the config of fake TEST/SCRATCH_DEV
to refer to directories.

I split the patches to 2 main changes:
1) convert old config with config of already mounted test/scratch base fs
   (backward compat with old config is maintained)
2) (optional) configure blockdev of base fs for mount cycling base fs

I tested -g quick with all 3 configuraions:
- old (*_DEV)
- new (only *_BASE_MNT)
- new (*_BASE_MNT and *_BASE_DEV)

v2:
- Test and scratch base dirs each have thier own base fs
- Support mount cycles of base fs for scratch tests

v1:
- Both test and scratch base dirs on a single base fs

Amir Goldstein (3):
  overlay: configure base fs mount point for running tests
  overlay: use SCRATCH_BASE_DIR instead of SCRATCH_DEV
  overlay: mount/unmount base fs before/after running tests

 common/config     | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
 common/rc         | 62 +++++++++++++++++++++++++++++++++++++++++++++++--------
 tests/overlay/001 |  7 +++----
 tests/overlay/002 |  2 +-
 tests/overlay/003 |  5 +++--
 tests/overlay/004 |  7 ++++---
 tests/overlay/005 | 30 +++++++++++++--------------
 tests/overlay/006 |  8 +++----
 tests/overlay/008 |  4 ++--
 tests/overlay/009 |  2 +-
 tests/overlay/010 | 10 ++++-----
 tests/overlay/011 |  4 ++--
 tests/overlay/012 |  4 ++--
 tests/overlay/013 |  4 ++--
 tests/overlay/014 | 19 +++++++++--------
 tests/overlay/015 |  2 +-
 tests/overlay/016 |  2 +-
 tests/overlay/017 |  2 +-
 tests/overlay/018 |  2 +-
 tests/overlay/019 |  2 +-
 tests/overlay/020 |  2 +-
 tests/overlay/021 |  6 +++---
 22 files changed, 171 insertions(+), 71 deletions(-)

-- 
2.7.4
