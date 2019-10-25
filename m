From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 2/5] ovl: ignore failure to copy up unknown xattrs
Date: Fri, 25 Oct 2019 13:29:14 +0200
Message-ID: <20191025112917.22518-3-mszeredi@redhat.com>
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

This issue came up with NFSv4 as the lower layer, which generates
"system.nfs4_acl" xattrs (even for plain old unix permissions).  Prior to
this patch this prevented copy-up from succeeding.

The overlayfs permission model mandates that permissions are checked
locally for the task and remotely for the mounter(*).  NFS4 ACLs are not
supported by the Linux kernel currently, hence they cannot be enforced
locally.  Which means it is indifferent whether this attribute is copied or
not.

Generalize this to any xattr that is not used in access checking (i.e. it's
not a POSIX ACL and not in the "security." namespace).

Incidentally, best effort copying of xattrs seems to also be the behavior
of "cp -a", which is what overlayfs tries to mimic.

(*) Documentation/filesystems/overlayfs.txt#Permission model

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index b801c6353100..ed6e2d6cf7a1 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -36,6 +36,13 @@ static int ovl_ccup_get(char *buf, const struct kernel_p=
aram *param)
 module_param_call(check_copy_up, ovl_ccup_set, ovl_ccup_get, NULL, 0644);
 MODULE_PARM_DESC(check_copy_up, "Obsolete; does nothing");
=20
+static bool ovl_must_copy_xattr(const char *name)
+{
+=09return !strcmp(name, XATTR_POSIX_ACL_ACCESS) ||
+=09       !strcmp(name, XATTR_POSIX_ACL_DEFAULT) ||
+=09       !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN)=
;
+}
+
 int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 {
 =09ssize_t list_size, size, value_size =3D 0;
@@ -107,8 +114,13 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *=
new)
 =09=09=09continue; /* Discard */
 =09=09}
 =09=09error =3D vfs_setxattr(new, name, value, size, 0);
-=09=09if (error)
-=09=09=09break;
+=09=09if (error) {
+=09=09=09if (error !=3D -EOPNOTSUPP || ovl_must_copy_xattr(name))
+=09=09=09=09break;
+
+=09=09=09/* Ignore failure to copy unknown xattrs */
+=09=09=09error =3D 0;
+=09=09}
 =09}
 =09kfree(value);
 out:
--=20
2.21.0
