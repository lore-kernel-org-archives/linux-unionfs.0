From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 1/1] OverlayFS: Fix checking permissions during lookup.
Date: Thu, 17 Mar 2016 16:23:01 +0100
Message-ID: <20160317152301.GQ8655@tucsk>
References: <20160224135552.GB8422@zenon.in.qult.net>
 <20160226194143.GB13054@redhat.com>
 <20160228110942.GA19509@zenon.in.qult.net>
 <20160229162546.GA3335@redhat.com>
 <20160229165440.GA28299@zenon.in.qult.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160229165440.GA28299@zenon.in.qult.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Ignacy =?utf-8?B?R2F3xJlkemtp?= <ignacy.gawedzki@green-communications.fr>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, David Howells <dhowells@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Feb 29, 2016 at 05:54:40PM +0100, Ignacy Gaw=C4=99dzki wrote:
> On Mon, Feb 29, 2016 at 11:25:46AM -0500, thus spake Vivek Goyal:
> > I agree that semantics should be more consistent. I don't know that
> > if upper layer should override lower layer checks or not.
> >=20
> > One could also argue that if root did chown, then changes effective=
ly
> > happened in upper layer and anything in upper layer should become
> > visible to unpriviliged user but not the one in lower layer.=20
> >=20
> > I just don't know. I guess those who have more background on this
> > could pitch in and clarify that was is supposed to be the design
> > intention.

I haven't thought about this aspect yet.

[thinking]

We cannot actually respect lower layer search permissions in a merged d=
irectory,
because we cannot selectively allow or deny directory search permission=
s on
individual directory entries (there's simply not enough information in =
the
->permission() call).

The only sane thing to do is to override search permission by the upper=
 layer
permissions.

We can do that with the cap_raise(... CAP_DAC_OVERRIDE) thing, which is=
 what
overlayfs usually does when it needs elevated permissions to do somethi=
ng.

Or we can a special lookup_one_len() type helper.  But we already have =
the
dentry hash in the overlay dentry, so no need to recalculate that (we'v=
e also
made sure that underlying fs doesnt have ->d_hash()).  The sanity check=
s on
'name' are also unnecessary.  And that leaves us with __lookup_hash() w=
here we
can just get rid of the underscores and export to modules.

Attaching folded patch.  Will post split out ones for review.

Thanks,
Miklos


diff --git a/fs/namei.c b/fs/namei.c
index 9c590e0f66e9..80fe2a68f361 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1447,7 +1447,7 @@ static int follow_dotdot(struct nameidata *nd)
  *
  * dir->d_inode->i_mutex must be held
  */
-static struct dentry *lookup_dcache(struct qstr *name, struct dentry *=
dir,
+static struct dentry *lookup_dcache(const struct qstr *name, struct de=
ntry *dir,
 				    unsigned int flags, bool *need_lookup)
 {
 	struct dentry *dentry;
@@ -1506,8 +1506,8 @@ static struct dentry *lookup_real(struct inode *d=
ir, struct dentry *dentry,
 	return dentry;
 }
=20
-static struct dentry *__lookup_hash(struct qstr *name,
-		struct dentry *base, unsigned int flags)
+struct dentry *lookup_hash(const struct qstr *name,
+			   struct dentry *base, unsigned int flags)
 {
 	bool need_lookup;
 	struct dentry *dentry;
@@ -1518,6 +1518,7 @@ static struct dentry *__lookup_hash(struct qstr *=
name,
=20
 	return lookup_real(base->d_inode, dentry, flags);
 }
+EXPORT_SYMBOL(lookup_hash);
=20
 /*
  *  It's more convoluted than I'd like it to be, but... it's still fai=
rly
@@ -1630,7 +1631,7 @@ static int lookup_slow(struct nameidata *nd, stru=
ct path *path)
 	BUG_ON(nd->inode !=3D parent->d_inode);
=20
 	inode_lock(parent->d_inode);
-	dentry =3D __lookup_hash(&nd->last, parent, nd->flags);
+	dentry =3D lookup_hash(&nd->last, parent, nd->flags);
 	inode_unlock(parent->d_inode);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
@@ -2235,7 +2236,7 @@ struct dentry *kern_path_locked(const char *name,=
 struct path *path)
 		return ERR_PTR(-EINVAL);
 	}
 	inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
-	d =3D __lookup_hash(&last, path->dentry, 0);
+	d =3D lookup_hash(&last, path->dentry, 0);
 	if (IS_ERR(d)) {
 		inode_unlock(path->dentry->d_inode);
 		path_put(path);
@@ -2319,7 +2320,7 @@ struct dentry *lookup_one_len(const char *name, s=
truct dentry *base, int len)
 	if (err)
 		return ERR_PTR(err);
=20
-	return __lookup_hash(&this, base, 0);
+	return lookup_hash(&this, base, 0);
 }
 EXPORT_SYMBOL(lookup_one_len);
=20
@@ -2386,7 +2387,7 @@ struct dentry *lookup_one_len_unlocked(const char=
 *name,
 		return ret;
=20
 	inode_lock(base->d_inode);
-	ret =3D  __lookup_hash(&this, base, 0);
+	ret =3D  lookup_hash(&this, base, 0);
 	inode_unlock(base->d_inode);
 	return ret;
 }
@@ -3498,7 +3499,7 @@ static struct dentry *filename_create(int dfd, st=
ruct filename *name,
 	 */
 	lookup_flags |=3D LOOKUP_CREATE | LOOKUP_EXCL;
 	inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
-	dentry =3D __lookup_hash(&last, path->dentry, lookup_flags);
+	dentry =3D lookup_hash(&last, path->dentry, lookup_flags);
 	if (IS_ERR(dentry))
 		goto unlock;
=20
@@ -3803,7 +3804,7 @@ retry:
 		goto exit1;
=20
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
-	dentry =3D __lookup_hash(&last, path.dentry, lookup_flags);
+	dentry =3D lookup_hash(&last, path.dentry, lookup_flags);
 	error =3D PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
@@ -3925,7 +3926,7 @@ retry:
 		goto exit1;
 retry_deleg:
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
-	dentry =3D __lookup_hash(&last, path.dentry, lookup_flags);
+	dentry =3D lookup_hash(&last, path.dentry, lookup_flags);
 	error =3D PTR_ERR(dentry);
 	if (!IS_ERR(dentry)) {
 		/* Why not before? Because we want correct error value */
@@ -4443,7 +4444,7 @@ retry:
 retry_deleg:
 	trap =3D lock_rename(new_path.dentry, old_path.dentry);
=20
-	old_dentry =3D __lookup_hash(&old_last, old_path.dentry, lookup_flags=
);
+	old_dentry =3D lookup_hash(&old_last, old_path.dentry, lookup_flags);
 	error =3D PTR_ERR(old_dentry);
 	if (IS_ERR(old_dentry))
 		goto exit3;
@@ -4451,7 +4452,7 @@ retry_deleg:
 	error =3D -ENOENT;
 	if (d_is_negative(old_dentry))
 		goto exit4;
-	new_dentry =3D __lookup_hash(&new_last, new_path.dentry, lookup_flags=
 | target_flags);
+	new_dentry =3D lookup_hash(&new_last, new_path.dentry, lookup_flags |=
 target_flags);
 	error =3D PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto exit4;
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d894e7cd9a86..0cf45a0e904e 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -220,8 +220,7 @@ static int ovl_copy_up_locked(struct dentry *workdi=
r, struct dentry *upperdir,
 	if (IS_ERR(newdentry))
 		goto out;
=20
-	upper =3D lookup_one_len(dentry->d_name.name, upperdir,
-			       dentry->d_name.len);
+	upper =3D lookup_hash(&dentry->d_name, upperdir, 0);
 	err =3D PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto out1;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 52f6de5d40a9..888b5fe29fdf 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -168,8 +168,7 @@ static int ovl_create_upper(struct dentry *dentry, =
struct inode *inode,
 	int err;
=20
 	inode_lock_nested(udir, I_MUTEX_PARENT);
-	newdentry =3D lookup_one_len(dentry->d_name.name, upperdir,
-				   dentry->d_name.len);
+	newdentry =3D lookup_hash(&dentry->d_name, upperdir, 0);
 	err =3D PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
 		goto out_unlock;
@@ -337,8 +336,7 @@ static int ovl_create_over_whiteout(struct dentry *=
dentry, struct inode *inode,
 	if (IS_ERR(newdentry))
 		goto out_unlock;
=20
-	upper =3D lookup_one_len(dentry->d_name.name, upperdir,
-			       dentry->d_name.len);
+	upper =3D lookup_hash(&dentry->d_name, upperdir, 0);
 	err =3D PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto out_dput;
@@ -547,8 +545,7 @@ static int ovl_remove_and_whiteout(struct dentry *d=
entry, bool is_dir)
=20
 	upper =3D ovl_dentry_upper(dentry);
 	if (!upper) {
-		upper =3D lookup_one_len(dentry->d_name.name, upperdir,
-				       dentry->d_name.len);
+		upper =3D lookup_hash(&dentry->d_name, upperdir, 0);
 		err =3D PTR_ERR(upper);
 		if (IS_ERR(upper))
 			goto kill_whiteout;
@@ -851,8 +848,7 @@ static int ovl_rename2(struct inode *olddir, struct=
 dentry *old,
 		}
 	} else {
 		new_create =3D true;
-		newdentry =3D lookup_one_len(new->d_name.name, new_upperdir,
-					   new->d_name.len);
+		newdentry =3D lookup_hash(&new->d_name, new_upperdir, 0);
 		err =3D PTR_ERR(newdentry);
 		if (IS_ERR(newdentry))
 			goto out_unlock;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 619ad4b016d2..c16eeb3e5021 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -379,7 +379,7 @@ static inline struct dentry *ovl_lookup_real(struct=
 dentry *dir,
 	struct dentry *dentry;
=20
 	inode_lock(dir->d_inode);
-	dentry =3D lookup_one_len(name->name, dir, name->len);
+	dentry =3D lookup_hash(name, dir, 0);
 	inode_unlock(dir->d_inode);
=20
 	if (IS_ERR(dentry)) {
diff --git a/include/linux/namei.h b/include/linux/namei.h
index d0f25d81b46a..22cc2cece000 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -78,6 +78,8 @@ extern int kern_path_mountpoint(int, const char *, st=
ruct path *, unsigned int);
=20
 extern struct dentry *lookup_one_len(const char *, struct dentry *, in=
t);
 extern struct dentry *lookup_one_len_unlocked(const char *, struct den=
try *, int);
+struct qstr;
+extern struct dentry *lookup_hash(const struct qstr *, struct dentry *=
, unsigned int);
=20
 extern int follow_down_one(struct path *);
 extern int follow_down(struct path *);
