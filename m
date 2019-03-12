From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 5.1
Date: Tue, 12 Mar 2019 10:03:09 +0100
Message-ID: <20190312090309.GB30899@veci.piliscsaba.redhat.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.1

Fix copy up of security related xattrs.

Thanks,
Miklos

----------------------------------------------------------------
Vivek Goyal (2):
      ovl: During copy up, first copy up data and then xattrs
      ovl: Do not lose security.capability xattr over metadata file copy-up

---
 fs/overlayfs/copy_up.c   | 59 ++++++++++++++++++++++++++++++++++++------------
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/util.c      | 55 ++++++++++++++++++++++++++++----------------
 3 files changed, 81 insertions(+), 35 deletions(-)
