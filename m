Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] Another overlay test for online inconsistency detection
Date: Fri,  4 May 2018 12:41:29 +0300
Message-Id: <1525426891-6121-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Eryu,

Originally, I wrote overlay/049 to test online inconcsistency detection
feature, which I wrote as a sub feature of NFS export, so the initial
version of the test required and eanbled NFS export.

Then, at some point, the test started to pass without NFS export enabled,
which was a by-product of another fix for inotify I did around the same
time. So the test got merged without requiring NFS export, but with said
fix commit on next branch.

On a recent discussion with Vivek, I realized that there was another
"by-product" inconsistency detection introduced by the same fix commit
and not covered by overlay/049.

The variant overlay/059 checks for this case of malformed multiply
referenced origin files. I wrote the test to support upcoming 'metacopy'
feature by Vivek, so it requires and enables redirect_dir, which is
harmless otherwise.

I tested overlay/059 on several old kernels. The results are:
- notrun on kernel < v4.10, before "redirect_dir" feature
- pass on kernels < v4.12, before "origin" was introduced
- fail on kernels < v4.16, before the fix commit
- pass on newer kernels

Amir Goldstein (2):
  overlay/049: update fix commit id
  overlay: test multiple origin references to the same lower file

 tests/overlay/049     |   4 +-
 tests/overlay/059     | 105 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/059.out |   2 +
 tests/overlay/group   |   1 +
 4 files changed, 110 insertions(+), 2 deletions(-)
 create mode 100755 tests/overlay/059
 create mode 100644 tests/overlay/059.out

-- 
2.7.4
