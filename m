From: Ignacy =?iso-8859-2?Q?Gaw=EAdzki?=
	<ignacy.gawedzki@green-communications.fr>
Subject: [PATCH v2 1/1] OverlayFS: Fix checking permissions during lookup.
Date: Wed, 24 Feb 2016 14:55:52 +0100
Message-ID: <20160224135552.GB8422@zenon.in.qult.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Add alternate lookup_one_len_check function to fs/namei.c which does
what lookup_one_len did until now with a boolean argument telling
whether to check that the base directory is traversable.  Modify
original lookup_one_len function to call the former with true as the
last argument.

In function ovl_lookup_real, file fs/overlayfs/super.c, call
lookup_one_len_check with false as the last argument, so that failure
to traverse the base directory does not return -EACCES.  This should
make lookup resolution work properly in the following setup

  drwxr-xr-x lower/
  drwx------ lower/foo/
  drw-r--r-- lower/boo/bar
  drwxr-xr-x upper/
  drwxr-xr-x upper/foo/

when any user not being the owner of lower/foo is trying to access
foo/bar in the mounted overlay.

Signed-off-by: Ignacy Gaw=EAdzki <ignacy.gawedzki@green-communications.=
fr>
---
 fs/namei.c            | 29 +++++++++++++++++++++++++----
 fs/overlayfs/super.c  |  2 +-
 include/linux/namei.h |  1 +
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index f624d13..f9486da 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2278,6 +2278,25 @@ EXPORT_SYMBOL(vfs_path_lookup);
  */
 struct dentry *lookup_one_len(const char *name, struct dentry *base, i=
nt len)
 {
+	return lookup_one_len_check(name, base, len, true);
+}
+EXPORT_SYMBOL(lookup_one_len);
+
+/**
+ * lookup_one_len_check - filesystem helper to lookup single pathname =
component
+ * @name:	pathname component to lookup
+ * @base:	base directory to lookup from
+ * @len:	maximum length @len should be interpreted to
+ * @check:	whether to check that @base is itself traversable.
+ *
+ * Note that this routine is purely a helper for filesystem usage and =
should
+ * not be called by generic code.
+ *
+ * The caller must hold base->i_mutex.
+ */
+struct dentry *lookup_one_len_check(const char *name, struct dentry *b=
ase,
+				    int len, bool check_base)
+{
 	struct qstr this;
 	unsigned int c;
 	int err;
@@ -2310,13 +2329,15 @@ struct dentry *lookup_one_len(const char *name,=
 struct dentry *base, int len)
 			return ERR_PTR(err);
 	}
=20
-	err =3D inode_permission(base->d_inode, MAY_EXEC);
-	if (err)
-		return ERR_PTR(err);
+	if (check_base) {
+		err =3D inode_permission(base->d_inode, MAY_EXEC);
+		if (err)
+			return ERR_PTR(err);
+	}
=20
 	return __lookup_hash(&this, base, 0);
 }
-EXPORT_SYMBOL(lookup_one_len);
+EXPORT_SYMBOL(lookup_one_len_check);
=20
 /**
  * lookup_one_len_unlocked - filesystem helper to lookup single pathna=
me component
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 8d826bd..965c5dd 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -376,7 +376,7 @@ static inline struct dentry *ovl_lookup_real(struct=
 dentry *dir,
 	struct dentry *dentry;
=20
 	inode_lock(dir->d_inode);
-	dentry =3D lookup_one_len(name->name, dir, name->len);
+	dentry =3D lookup_one_len_check(name->name, dir, name->len, false);
 	inode_unlock(dir->d_inode);
=20
 	if (IS_ERR(dentry)) {
diff --git a/include/linux/namei.h b/include/linux/namei.h
index d0f25d8..0af6775 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -77,6 +77,7 @@ extern struct dentry *kern_path_locked(const char *, =
struct path *);
 extern int kern_path_mountpoint(int, const char *, struct path *, unsi=
gned int);
=20
 extern struct dentry *lookup_one_len(const char *, struct dentry *, in=
t);
+extern struct dentry *lookup_one_len_check(const char *, struct dentry=
 *, int, bool);
 extern struct dentry *lookup_one_len_unlocked(const char *, struct den=
try *, int);
=20
 extern int follow_down_one(struct path *);
--=20
2.5.0
