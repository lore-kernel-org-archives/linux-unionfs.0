From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 3/5] vfs: allow unprivileged whiteout creation
Date: Fri, 25 Oct 2019 13:29:15 +0200
Message-ID: <20191025112917.22518-4-mszeredi@redhat.com>
References: <20191025112917.22518-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191025112917.22518-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Whiteouts are special, but unlike real device nodes they should not require
privileges to create.

The 0 char device number should already be reserved, but make this explicit
in cdev_add() to be on the safe side.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/char_dev.c                 |  3 +++
 fs/namei.c                    | 17 ++++-------------
 include/linux/device_cgroup.h |  3 +++
 3 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 00dfe17871ac..8bf66f40e5e0 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -483,6 +483,9 @@ int cdev_add(struct cdev *p, dev_t dev, unsigned count)
 =09p->dev =3D dev;
 =09p->count =3D count;
=20
+=09if (WARN_ON(dev =3D=3D WHITEOUT_DEV))
+=09=09return -EBUSY;
+
 =09error =3D kobj_map(cdev_map, dev, count, NULL,
 =09=09=09 exact_match, exact_lock, p);
 =09if (error)
diff --git a/fs/namei.c b/fs/namei.c
index 671c3c1a3425..05ca98595b62 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3687,12 +3687,14 @@ EXPORT_SYMBOL(user_path_create);
=20
 int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_=
t dev)
 {
+=09bool is_whiteout =3D S_ISCHR(mode) && dev =3D=3D WHITEOUT_DEV;
 =09int error =3D may_create(dir, dentry);
=20
 =09if (error)
 =09=09return error;
=20
-=09if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD))
+=09if ((S_ISCHR(mode) || S_ISBLK(mode)) && !capable(CAP_MKNOD) &&
+=09    !is_whiteout)
 =09=09return -EPERM;
=20
 =09if (!dir->i_op->mknod)
@@ -4527,9 +4529,6 @@ static int do_renameat2(int olddfd, const char __user=
 *oldname, int newdfd,
 =09    (flags & RENAME_EXCHANGE))
 =09=09return -EINVAL;
=20
-=09if ((flags & RENAME_WHITEOUT) && !capable(CAP_MKNOD))
-=09=09return -EPERM;
-
 =09if (flags & RENAME_EXCHANGE)
 =09=09target_flags =3D 0;
=20
@@ -4667,15 +4666,7 @@ SYSCALL_DEFINE2(rename, const char __user *, oldname=
, const char __user *, newna
=20
 int vfs_whiteout(struct inode *dir, struct dentry *dentry)
 {
-=09int error =3D may_create(dir, dentry);
-=09if (error)
-=09=09return error;
-
-=09if (!dir->i_op->mknod)
-=09=09return -EPERM;
-
-=09return dir->i_op->mknod(dir, dentry,
-=09=09=09=09S_IFCHR | WHITEOUT_MODE, WHITEOUT_DEV);
+=09return vfs_mknod(dir, dentry, S_IFCHR | WHITEOUT_MODE, WHITEOUT_DEV);
 }
 EXPORT_SYMBOL(vfs_whiteout);
=20
diff --git a/include/linux/device_cgroup.h b/include/linux/device_cgroup.h
index 8557efe096dc..fc989487c273 100644
--- a/include/linux/device_cgroup.h
+++ b/include/linux/device_cgroup.h
@@ -62,6 +62,9 @@ static inline int devcgroup_inode_mknod(int mode, dev_t d=
ev)
 =09if (!S_ISBLK(mode) && !S_ISCHR(mode))
 =09=09return 0;
=20
+=09if (S_ISCHR(mode) && dev =3D=3D WHITEOUT_DEV)
+=09=09return 0;
+
 =09if (S_ISBLK(mode))
 =09=09type =3D DEVCG_DEV_BLOCK;
 =09else
--=20
2.21.0
