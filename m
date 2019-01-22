Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH v2 0/5] Experiments with overlayfs filemap
Date: Tue, 22 Jan 2019 14:34:52 +0200
Message-Id: <20190122123457.10600-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

This experiment uses very naiive noop aops on overlay inode
for upper data files (i.e. SHARED_UPPER and UPPER).

The patches are available on my github [1] and are based on a bug fix
I posted earlier today ("ovl: fix missing upper fs freeze protection on
copy up for ioctl").

Despite the noop aops, the experiment can demonstrates expected behavior
w.r.t the transition from LOWER -> SHARED_UPPER.

With metacopy=on, file is meta copied up on open O_RDWR and data is
copied up on first data access (not on first write).
This solves the open() latency issue reported by Chengguang, but also
serves as a way to test copy up on page fault.
I havn't written any tests for lazy copy up on mwrite/mread, but I did
test these cases manually.

~50/60 of the overlay xfstests actually pass (those test don't care
about data or about committing writes to storage) and the rest fail on
expected data inconsistencies with no observed crashes nor warnings.

The issue discussed with Vivek on v1 patch of this experiment
(inefficient ovl_iter_read()) becomes moot in v2, because unlike v1,
data is copied up on first read or write of writable file and not on
first write. So there is no LOWER_SHARED state in these patches, but
the generic filemap operations and lazy copy up hooks bring us closer
to an implemention of the LOWER_SHARED -> UPPER_SHARED transition.

Can you please point me in the direction of how to implement proper
aops? Or better yet, send me a demo patch?
I figure we need to call vfs_iter_read/vfs_iter_write of real file
with IOCB_DIRECT for page io? But I am very uncertain about locking
order requirements and whether there is already some infrastructure
that we can use (some splice variant)?

Any other thoughts?

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-lazy-copyup-wip

Amir Goldstein (5):
  ovl: reorder tests in ovl_open_need_copy_up()
  ovl: prepare for generic filemap file operations
  ovl: lazy copy up of data on first data access
  ovl: lazy copy up data on page fault
  ovl: noop aops to test filemap operations and lazy copy up

 fs/overlayfs/copy_up.c   |  14 +--
 fs/overlayfs/file.c      | 238 +++++++++++++++++++++++++++++++++++++--
 fs/overlayfs/inode.c     |   5 -
 fs/overlayfs/overlayfs.h |  11 +-
 fs/overlayfs/util.c      |   4 +-
 mm/fadvise.c             |   4 +-
 6 files changed, 248 insertions(+), 28 deletions(-)

-- 
2.17.1
