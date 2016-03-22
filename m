From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 2/2] ovl: ignore permissions on underlying lookup
Date: Tue, 22 Mar 2016 14:23:02 +0100
Message-ID: <20160322132302.GE11906@tucsk>
References: <20160322132103.GD11906@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160322132103.GD11906@tucsk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Generally permission checking is not necessary when overlayfs looks up =
a
dentry on one of the underlying layers, since search permission on base
directory was already checked in ovl_permission().

More specifically using lookup_one_len() causes a problem when the lowe=
r
directory lacks search permission for a specific user while the upper
directory does have search permission.  Since lookups are cached, this
causes inconsistency in behavior: success depends on who did the first
lookup.

So instead use lookup_hash() which doesn't do the permission check.

Reported-by: Ignacy Gaw=C4=99dzki <ignacy.gawedzki@green-communications=
=2Efr>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -379,7 +379,7 @@ static inline struct dentry *ovl_lookup_
 	struct dentry *dentry;
=20
 	inode_lock(dir->d_inode);
-	dentry =3D lookup_one_len(name->name, dir, name->len);
+	dentry =3D lookup_hash(name, dir, 0);
 	inode_unlock(dir->d_inode);
=20
 	if (IS_ERR(dentry)) {
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
