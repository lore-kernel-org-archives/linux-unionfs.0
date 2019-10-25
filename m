From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 5/5] ovl: unprivieged mounts
Date: Fri, 25 Oct 2019 13:29:17 +0200
Message-ID: <20191025112917.22518-6-mszeredi@redhat.com>
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

Enable unprivileged user namespace mounts of overlayfs.  Overlayfs's
permission model (*) ensures that the mounter itself cannot gain additional
privileges by the act of creating an overlayfs mount.

This feature request is coming from the "rootless" container crowd.

(*) Documentation/filesystems/overlayfs.txt#Permission model

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d122c07f2a43..c7f21a049c6b 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1739,6 +1739,7 @@ static struct dentry *ovl_mount(struct file_system_ty=
pe *fs_type, int flags,
 static struct file_system_type ovl_fs_type =3D {
 =09.owner=09=09=3D THIS_MODULE,
 =09.name=09=09=3D "overlay",
+=09.fs_flags=09=3D FS_USERNS_MOUNT,
 =09.mount=09=09=3D ovl_mount,
 =09.kill_sb=09=3D kill_anon_super,
 };
--=20
2.21.0
