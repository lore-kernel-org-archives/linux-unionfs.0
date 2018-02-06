From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/4] Overlayfs file handle decode optimization
Date: Tue,  6 Feb 2018 14:21:35 +0200
Message-ID: <1517919700-29182-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:38579 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752947AbeBFMUo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Feb 2018 07:20:44 -0500
Received: by mail-wr0-f193.google.com with SMTP id t94so1697308wrc.5
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Feb 2018 04:20:43 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

This patch set completes the known 'debt' for the NFS export work
and is available with the rest if the 'debt' and fixes on my github [1].

Patch 2 is a cosmetic re-factoring of dcache name hash functions.
I tried hard to make sure there is no-change to existing users. Please
double check me on that.

To verify optimization, I ran all the overlay/exportfs tests, which are
now upstream. I added prints to real fs decode functions to verify they
are not called when decoding a lower dir file handle of a deleted dir.

To verify the hash function, I added prints inside iget5_locked() to
check when an inode is added to an empty hash list and then I ran some
tests to populate cache with a few 1000 upper or lower inodes.

When populated with pure upper inodes, the hash values were far less
random (pointer values) and out of 2000 inodes there were 1-5 hash
collisions depending on the test run.

When populated with pure lower inodes, the hash values seemed more
random and out of 2000 inodes there were 3-4 hash collisions depending
on the test run. So for a quick test that seem to indicate that the
file handle hash function is at least better than the real inode hash.
The real lower file handles were xfs file handles all with the same uuid,
with sequential 64-bit inode numbers and zero generation (xfs inodes on
a newly formatted fs).

I guess it is possible to improve the efficiency of the hash function
by xoring the 16 bytes of uuid to a single long value and feeding it
as salt to full_name_long_hash() instead of computing a hash on the uuid
which is already random.

Performance benchmarks/regression testing is high on my TODO list, but
still did not get there.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-nfs-export

Amir Goldstein (4):
  ovl: disambiguate ovl_encode_fh()
  fs/namei.c: factor out helper full_name_long_hash()
  ovl: hash inodes by lower file handle for NFS export
  ovl: lookup in inode cache when decoding lower file handle

 fs/namei.c                 | 41 +++++++++++++++++-------
 fs/overlayfs/copy_up.c     |  6 ++--
 fs/overlayfs/export.c      | 51 +++++++++++++----------------
 fs/overlayfs/inode.c       | 80 +++++++++++++++++++++++++++++++++++++++++++---
 fs/overlayfs/namei.c       | 12 +++----
 fs/overlayfs/overlayfs.h   | 13 ++++++--
 fs/overlayfs/super.c       |  2 ++
 include/linux/hash.h       | 10 +++++-
 include/linux/stringhash.h |  6 +++-
 9 files changed, 163 insertions(+), 58 deletions(-)

-- 
2.7.4
