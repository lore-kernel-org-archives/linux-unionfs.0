From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.11
Date: Fri, 3 Mar 2017 11:39:03 +0100
Message-ID: <20170303103903.GA30961@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

Because copy up can take a long time, serialized copy ups could be a big
performance bottleneck. This update allows concurrent copy up of regular files
eliminating this potential problem.  There are also minor fixes.

Thanks,
Miklos

---
Amir Goldstein (6):
      ovl: check if upperdir fs supports O_TMPFILE
      ovl: rearrange code in ovl_copy_up_locked()
      ovl: copy up regular file using O_TMPFILE
      ovl: introduce copy up waitqueue
      ovl: concurrent copy up of regular files
      ovl: properly implement sync_filesystem()

Konstantin Khlebnikov (1):
      ovl: drop CAP_SYS_RESOURCE from saved mounter's credentials

---
 fs/overlayfs/copy_up.c   | 91 +++++++++++++++++++++++++++++++++++-------------
 fs/overlayfs/overlayfs.h | 11 ++++++
 fs/overlayfs/ovl_entry.h |  3 ++
 fs/overlayfs/super.c     | 39 +++++++++++++++++++--
 fs/overlayfs/util.c      | 30 ++++++++++++++++
 5 files changed, 147 insertions(+), 27 deletions(-)
