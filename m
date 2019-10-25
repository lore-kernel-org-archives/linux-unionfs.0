From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 0/5] allow unprivileged overlay mounts
Date: Fri, 25 Oct 2019 13:29:12 +0200
Message-ID: <20191025112917.22518-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Eric,

Can you please have a look at this patchset?

The most interesting one is the last oneliner adding FS_USERNS_MOUNT;
whether I'm correct in stating that this isn't going to introduce any
holes, or not...

Thanks,
Miklos

---
Miklos Szeredi (5):
  ovl: document permission model
  ovl: ignore failure to copy up unknown xattrs
  vfs: allow unprivileged whiteout creation
  ovl: user xattr
  ovl: unprivieged mounts

 Documentation/filesystems/overlayfs.txt | 44 +++++++++++++
 fs/char_dev.c                           |  3 +
 fs/namei.c                              | 17 ++---
 fs/overlayfs/copy_up.c                  | 34 +++++++---
 fs/overlayfs/dir.c                      |  2 +-
 fs/overlayfs/export.c                   |  2 +-
 fs/overlayfs/inode.c                    | 39 ++++++------
 fs/overlayfs/namei.c                    | 56 +++++++++--------
 fs/overlayfs/overlayfs.h                | 81 +++++++++++++++---------
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/readdir.c                  |  5 +-
 fs/overlayfs/super.c                    | 53 +++++++++++-----
 fs/overlayfs/util.c                     | 82 +++++++++++++++++++++----
 include/linux/device_cgroup.h           |  3 +
 14 files changed, 298 insertions(+), 124 deletions(-)

--=20
2.21.0
