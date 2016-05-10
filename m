From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL (resend) ] overlayfs fixes for 4.6-rc7
Date: Tue, 10 May 2016 10:34:23 +0200
Message-ID: <CAJfpegta1PoH55tf=4TXb=EZjmOqhxuQam+1Q4sS_=sB3i_dEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Hi Al,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

This fixes two issues with overlayfs.

Thanks,
Miklos

---
Miklos Szeredi (3):
      vfs: rename: check backing inode being equal
      vfs: export lookup_hash() to modules
      ovl: ignore permissions on underlying lookup

---
 fs/namei.c            | 48 ++++++++++++++++++++++++++++++++++++++----------
 fs/overlayfs/super.c  |  2 +-
 include/linux/namei.h |  2 ++
 3 files changed, 41 insertions(+), 11 deletions(-)
