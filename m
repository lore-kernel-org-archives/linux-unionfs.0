From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v5 0/10] fstests: new way to run overlay tests
Date: Tue, 28 Feb 2017 14:18:27 +0200
Message-ID: <1488284317-3119-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Eryu,

I rebased my branch to your master and made some minor adaptations
to Xiong's new tests. Also reordered the patches:

- patches 1-6 are generic fixes and re-factoring - if you wish,
  you can merge them before the overlay config changes.

- patches 7-10 implement the new overlay config. patches 7 and 10
  include adaptations of Xiong's new tests to new config.

This is the 5th revision of new overlayfs config.
The main motivation of this work is to help catch overlayfs bugs
related to leaking objects in underlying (base) fs.

With this change, all you have to do to run overlay tests if you
already have a local.config setup to test a local file system is:
 ./check -overlay

See README.overlay for some examples of config files to use with -overlay.

The legacy overlayfs configuration, where TEST_DEV is a directory
still works, but it should be deprecated.

Tested ./check -overlay -g quick with both legacy overlay configuration
and the new base fs configuration.

Eryu wished to keep these changes soaking on the list for while,
so for those who can help with testing, you can get pull the branch
for testing from my github tree [1].

Thanks,
Amir.

[1] https://github.com/amir73il/xfstests/tree/ovl_base_fs

v5:
- Rebased to weekly update
- Adapted new overlay tests by Xiong to new config
- Reordered patches "fixes and re-factoring first"

v4:
- Address review comments from Eryu
- Fix sanity checks for already mounted scratch base fs
- Fix handling of SCRATCH_DEV_POOL
- Fix problems when run in kvm-xfstests
- Add README.overlay with example config files
- Remove documentation for overlay config sections

v3:
- Mount cycle base test fs
- Fix bugs in non overlay specific sanity checks
- Run -overlay test with existing config file of base fs
- Run overlay tests per base fs by adding overlay config sections

v2:
- Test and scratch base dirs each have thier own base fs
- Support mount cycles of base fs for scratch tests

v1:
- Both test and scratch base dirs on a single base fs


Amir Goldstein (10):
  fstests: sanity check that test partitions are not mounted elsewhere
  fstests: use _test_mount() consistently
  fstests: canonicalize mount points on every config section
  fstests: fix test and scratch filters for overlapping DEV/MNT paths
  fstests: allow overlay SCRATCH_DEV to be a base fs mount point
  generic/064: access SCRATCH_MNT after _scratch_mount
  overlay: rename OVERLAY_LOWER/UPPER/WORK_DIR
  overlay: configure TEST/SCRATCH vars to base fs
  overlay: mount/unmount base fs before/after running tests
  overlay: use OVL_BASE_SCRATCH_MNT instead of SCRATCH_DEV

 README                |  16 ++--
 README.overlay        |  46 +++++++++++
 check                 |  18 ++---
 common/config         | 160 ++++++++++++++++++++++++++++++++++-----
 common/filter         |  33 +++++++-
 common/rc             | 206 ++++++++++++++++++++++++++++++++++++--------------
 tests/generic/064     |  10 ++-
 tests/overlay/001     |   7 +-
 tests/overlay/002     |   2 +-
 tests/overlay/003     |   5 +-
 tests/overlay/004     |   7 +-
 tests/overlay/005     |  30 ++++----
 tests/overlay/006     |  10 +--
 tests/overlay/008     |   8 +-
 tests/overlay/009     |   2 +-
 tests/overlay/010     |  10 +--
 tests/overlay/011     |   6 +-
 tests/overlay/012     |   4 +-
 tests/overlay/013     |   4 +-
 tests/overlay/014     |  19 ++---
 tests/overlay/015     |   2 +-
 tests/overlay/016     |   2 +-
 tests/overlay/017     |   2 +-
 tests/overlay/018     |   2 +-
 tests/overlay/019     |   2 +-
 tests/overlay/020     |   2 +-
 tests/overlay/021     |   6 +-
 tests/overlay/022     |   2 +-
 tests/overlay/023     |   4 +-
 tests/overlay/023.out |   2 +-
 tests/overlay/024     |   2 +-
 tests/overlay/027     |   2 +-
 tests/overlay/028     |   2 +-
 tests/overlay/029     |   4 +-
 34 files changed, 466 insertions(+), 173 deletions(-)
 create mode 100644 README.overlay

-- 
2.7.4
