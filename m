From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/4] fstests: generic test for NFS handles
Date: Tue, 18 Apr 2017 21:17:20 +0300
Message-ID: <1492539444-25938-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35648 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751456AbdDRSRQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2017 14:17:16 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Trond Myklebust <trondmy@primarydata.com>, Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

Eryu,

I am working on NFS export support for overlayfs [1].
Before testing with NFS client I wanted to test the file handle API,
but apparently xfstests have only tests for the XFS specific ioctl.

So I converted the stale_handle xfs/238 test to a generic test and
added some more test cases to it. 

On the bright side, if I disable the drop_caches in the test, the
test already passes on overlayfs in my test branch, but I still have
some work to do for full NFS export support.

When I am done with that, I will add some more overlay specific
exportfs tests (e.g. export handle from lower and decode after copy up).

In the mean while, running this new test on overlayfs yields:

generic/426 3s ... [not run] overlay does not support NFS export

Tested this on ext4, xfs, btrfs, tmpfs.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-nfs-export

Amir Goldstein (4):
  src/open_by_handle: helper to test open_by_handle_at() syscall
  src/open_by_handle: flexible usage options
  fstests: add helper _require_exportfs
  fstests: add generic test for file handles

 common/rc             |   9 +++
 src/Makefile          |   2 +-
 src/open_by_handle.c  | 212 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/426     |  73 +++++++++++++++++
 tests/generic/426.out |   2 +
 tests/generic/group   |   1 +
 6 files changed, 298 insertions(+), 1 deletion(-)
 create mode 100644 src/open_by_handle.c
 create mode 100755 tests/generic/426
 create mode 100644 tests/generic/426.out

-- 
2.7.4
