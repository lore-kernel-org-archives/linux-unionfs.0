From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 00/15] overlayfs constant inode numbers
Date: Mon,  1 May 2017 16:41:51 +0300
Message-ID: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34048 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035208AbdEANl6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:41:58 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

This is v4 series of redirect by file handle and constant inode numbers.
this series fixes constant inode numbers for stat(2) for overlayfs
configuration of all layers on the same fs.

I tried harder to keep this series "as simple as possible", according to
conclusions of our discussion on v3. To this end, I removed that prep
patches of ovl_path_type() and OVL_TYPE_COPYUP(), which I may or may not
need to re-introduced for the next part of the work.

The last patch (verify_lower) is not needed for constant inode numbers,
of course, but is provided here as a demonstration of how redirect_fh can
be extended for the snapshot use case. I did not yet implement decode fh
on failure to verify lower dir. It should not be hard, but I did not want
to stray from "as simple as possible" too much, so I'll defer it to the
second part.

Redirect by file handle is used to lookup of the copy up origin of
non-dir inode. The origin inode reference is then held by overlay dentry
and its inode number used as the overlay object inode number.

Overlayfs configuration of all layers on same fs, also gains:
- Persistent inode numbers for directories
- Consistent st_dev for all overlay objects

Overlayfs configuration of single lower and upper on same fs, also gains:
- With '-o verify_lower', upper dir merged only with verified lower dir

This series is available for testing on [1].

xfstest overlay/017 was added a check for constant and persistent inode
numbers across rename and mount cycle [2].

unionmount-testsuite was instrumented to verify constant inode numbers
after rename/link and mount cycle for the --samefs setup [3].

unionmount-testsuite also sets the new mount option 'verify_lower' on
supported configurations (i.e. ./run --ov=0 --samefs).

I also ran few manual tests of mangling lower dirs to test lower dir
verification failures, but still did not integrate verify_lower with
snapshot to run the full testsuite of lower changes.

Tested the following layer configurations:
 ./run --ov{,=0,=1} {,--samefs}

Where 'samefs' is tmpfs and xfs with sb->s_uuid patch.
When running './run --ov=0 --samefs' with either tmpfs (default) or
with un-patched xfs, the test fails on inode number consistency check
as expected, because copy up origin cannot be followed.

The following test fails inode number consistency check on an origin
lower hardlink, as expected:
 ./run --ov=1 --samefs rename-mass-5

I did not teach unionmount-testsuite to identify the lower hardlink case,
as I intent to fix this problem with the second part of this work.

Amir.

Changes since v3:
- Constant inode numbers only for samefs case
- No constant inode numbers for origin with nlink > 1
- Store lower fs uuid along side fh in overlay.origin (no root fh)
- Verify lower fs uuid is non zero
- Drop ovl_path_type() and OVL_TYPE_COPYUP() patches
- No overlay.redirect for non-dir
- No lookup by name for non-dir origin
- Store non-connectable fh (for non-dir)
- No verify that origin followed by fh is under layer root
- Added 'verify_lower' mount option

[1] https://github.com/amir73il/linux/commits/overlayfs-devel
[2] https://github.com/amir73il/xfstests/commits/overlayfs-devel
[3] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel


Amir Goldstein (15):
  ovl: check if all layers are on the same fs
  ovl: store file handle of lower inode on copy up
  ovl: use an auxiliary var for overlay root entry
  ovl: factor out ovl_lookup_data()
  ovl: store the file type in ovl_lookup_data
  ovl: pass the stack index on ovl_lookup_data
  ovl: lookup copy up origin of non-dir inode
  ovl: lookup non-dir copy up origin by file handle
  ovl: validate lower layer uuid on redirect by fh
  ovl: constant st_ino/st_dev across copy up
  ovl: persistent inode number for directories
  ovl: fix du --one-file-system on overlay mount
  ovl: persistent inode numbers for upper hardlinks
  ovl: update documentation w.r.t. constant inode numbers
  ovl: add support for verify_lower option

 Documentation/filesystems/overlayfs.txt |   9 +-
 fs/overlayfs/copy_up.c                  | 109 +++++++++++
 fs/overlayfs/dir.c                      |  21 ++-
 fs/overlayfs/inode.c                    |  28 ++-
 fs/overlayfs/namei.c                    | 325 ++++++++++++++++++++++++++++----
 fs/overlayfs/overlayfs.h                |  27 +++
 fs/overlayfs/ovl_entry.h                |   6 +
 fs/overlayfs/super.c                    |  60 ++++++
 fs/overlayfs/util.c                     |  49 +++++
 9 files changed, 599 insertions(+), 35 deletions(-)

-- 
2.7.4
