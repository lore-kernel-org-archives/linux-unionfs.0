From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/5] overlay mount tests
Date: Tue, 11 Jul 2017 22:52:01 +0300
Message-ID: <1499802726-11045-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Eryu,

overlayfs-next brings some changes of mount behavior described at [1].
Some of the changes depend on the new inodes index opt-in feature and
some don't.

The new test overlay/035 checks for overlay mount behaviors, which are
already present in upstream.

The new test overlay/036 checks for new overlay mount behaviors related
to exclusivity of upper and work dirs among overlay mounts. This test
is expected to fail on upstream kernel, but for a good reason, because
the mount configurations that it tests (sharing upper dir among two
overlay mounts) are not wise at all.

The old test overlay/014 is modified to work well with current upstream
kernel as well as with overlayfs-next with inodes index enabled.

I have one more test for the overlay/mount group to test specific behavior
with index=on, but holding it back until Miklos picks up a patch that fixes
one of the mount verifications that is currently broken on overlayfs-next.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commit/9412812ef54861081904f24ddaf176b957b98d40

Amir Goldstein (5):
  overlay/014: remove unneeded require and include
  overlay/014: fix test with inodes index enabled
  overlay: create overlay/mount test group
  overlay: test cases that force read-only mount
  overlay: test mount error cases with exclusive directories

 tests/overlay/014     |  7 ++---
 tests/overlay/035     | 87 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/035.out |  5 +++
 tests/overlay/036     | 82 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/036.out |  3 ++
 tests/overlay/group   |  6 ++--
 6 files changed, 184 insertions(+), 6 deletions(-)
 create mode 100755 tests/overlay/035
 create mode 100644 tests/overlay/035.out
 create mode 100755 tests/overlay/036
 create mode 100644 tests/overlay/036.out

-- 
2.7.4
