Received: from fout-b6-smtp.messagingengine.com (fout-b6-smtp.messagingengine.com [202.12.124.149])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D86279DC9;
	Wed, 18 Mar 2026 21:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.149
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773868252; cv=none; b=S4hPjuWZn4sIoyx79O5LaPrZb1JpDOfWcP1TpUyqVG+596826KyEsFMtrV2IqRQjYfNUo/+fAJe35P3VEcCxCF2f2mXWHwx3q/8zf7ruYXiGqU3fBmGxXi3EFfK+rEfQzqsjtli8A3r8cVz2DWXNhLfR07GHJCvuQkQDinIL3OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773868252; c=relaxed/simple;
	bh=J+cGMFv7pNcT+NAanC853cURBp507qR5OxATUCcXKwc=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=kkCVmlzU+9rmLhppc/D3/KURZfEpMhv1qHNIc2fM3YoeE77SUAylulHgQymTfrnLOFd+ER4vgTK+OXwFAQj1F7Zh+HMURKqzOyUQeitp1mPNAe3leiw2hTeMsWq5xrMsoPDTi13gLQCaexBKIWSN7dCBJ/2kyYjYs9+Shovn4fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=ZaaLk60z; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=dEMLsgaf; arc=none smtp.client-ip=202.12.124.149
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="ZaaLk60z";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="dEMLsgaf"
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.stl.internal (Postfix) with ESMTP id 3A1EE1D0010D;
	Wed, 18 Mar 2026 17:10:48 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Wed, 18 Mar 2026 17:10:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1773868247; x=1773954647; bh=WSFi2o3Y9GnmyvEwB/Q9Ty1o7W8p9zIWLum
	oY1klqoA=; b=ZaaLk60zAH09PLfQ0OzqBUM+d/Yis13eg+KqdjJ2eKR0eb3dg84
	A8Vvh0a6Yn0OgnVpbPdswyuOzW8LJSUUF9GTalPAQ1FORAAyoefdgZeVFME+DWaf
	nbVbzxkKg6Ceyk/OyYYHkQ2CsDzKZvUQECdHVRVWcJ+lvlZV7BdIcOv/ugS0rkrT
	94QLJdhMboKurOWPJyZj78I9dvjVJm++nXB7c2pR+HktX4+bXmSN1FLe7PsJWmJp
	K5jNBUBCj9dWNz1zdvJd0SPXOojrvuDRu7BSVpPS8jOs+hK3yFoBxSPWxg49AJfw
	IE8sT+xmrhXRBkTZOXm97nlFX0gwfwAZ+DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1773868247; x=
	1773954647; bh=WSFi2o3Y9GnmyvEwB/Q9Ty1o7W8p9zIWLumoY1klqoA=; b=d
	EMLsgafr/GuO5V7RaObcCQEPvWxBq1SCcA9AKz214wW+vQwERTuRuwqft8zXfhTG
	n0wPmv6I7c6smc0xHFgtEu+t+E2lrdp3BXe0RTSYot7n5PYxd8U9cgZfSpp6orVw
	Yk6eWKmmTpljf0hd4cxPdEOW79rlU/gsc8BNvT0sbVZ2ANxmM9Mftvx6o9MeAqwd
	jRuFfnYIsCum8ab/2N2Qp+oX+4D2Hahu8JgQF2fHuFaow74kw5XLbYfiqhSuch8R
	eDnAGDYeFiZ3KP11RQb8mlotrULZYZoiJ12v1tPff/m+15hl42jJ7ReutXJCFvIf
	fWw2lfWMwB3ihYMbvN2aQ==
X-ME-Sender: <xms:1xS7acp9OJ-EBgP3exSLkevl1pq7trqo2fp8_nrn-DGvIfH1Ya6wMA>
    <xme:1xS7aXnA1bshS-KmaTK2o5fcHTtojDZmuBSzucTJDE5AJ_NQ1mn_ORWfaHRcVGBTT
    gDV61Q8GbES1A5jLOk9M8zXhMI5Y6UvvXZl1ScXP7RYz94R7w>
X-ME-Received: <xmr:1xS7aVfZ--PswtpxT1t5h140-WyPg95qRHAcK82aCkdoBL2Q5BTl6LBuekmeCeqtLyFGFujwYZIImwXP9lw5sk3YsslARpkApWCCtF4EsVVb>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdehudejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtqhertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epleejtdefgeeukeeiteduveehudevfeffvedutefgteduhfegvdfgtdeigeeuudejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohepkedpmhhouggvpehsmhhtphho
    uhhtpdhrtghpthhtohepvhhirhhoseiivghnihhvrdhlihhnuhigrdhorhhgrdhukhdprh
    gtphhtthhopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hgpdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpthhtoh
    epthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphht
    thhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopegrmhhirhejfe
    hilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:1xS7aTpqVTf_SLuBu-d8saI_QyG7R01DqZjfNjmemQuMDub6AspYrw>
    <xmx:1xS7afNSTU__-zgcRaXk4-fMZ7PEpOlJTeQVOw-knFIq0tK25x5JCw>
    <xmx:1xS7aWiKQuaI4a8eQZ75t3IXTa-cYrReWz62Sqoj9se0blXe_-dzZA>
    <xmx:1xS7aSuXNA7QmI9f1tloMR3gDrnRaw2AUhD4Sc0Zxx_UoE5f8Z3WFw>
    <xmx:1xS7aUGbuBAZZgn7SpR9wk64qUAerXjmOHXv99ZCqXP-yS16sxMUXYll>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Mar 2026 17:10:44 -0400 (EDT)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Amir Goldstein" <amir73il@gmail.com>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Christian Brauner" <brauner@kernel.org>,
 "Miklos Szeredi" <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/53] ovl: drop dir lock for lookups in impure readdir
In-reply-to:
 <CAOQ4uxjmcNxsCmDSVgkTns=3BAuQcT3pVvsQzza+u3iqXqrz5g@mail.gmail.com>
References: <20260312214330.3885211-1-neilb@ownmail.net>,
 <20260312214330.3885211-17-neilb@ownmail.net>,
 <CAOQ4uxjmcNxsCmDSVgkTns=3BAuQcT3pVvsQzza+u3iqXqrz5g@mail.gmail.com>
Date: Thu, 19 Mar 2026 08:10:39 +1100
Message-id: <177386823998.3934327.10803400222725196190@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

[[ CC list trimmed ]]

On Mon, 16 Mar 2026, Amir Goldstein wrote:
> On Thu, Mar 12, 2026 at 10:49=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrot=
e:
> >
> > From: NeilBrown <neil@brown.name>
> >
> > When performing an "impure" readdir, ovl needs to perform a lookup on some
> > of the names that it found.
> > With proposed locking changes it will not be possible to perform this
> > lookup (in particular, not safe to wait for d_alloc_parallel()) while
> > holding a lock on the directory.
> >
> > ovl doesn't really need the lock at this point.
>=20
> Not exactly. see below.
>=20
> > It has already iterated
> > the directory and has cached a list of the contents.  It now needs to
> > gather extra information about some contents.  It can do this without
> > the lock.
> >
> > After gathering that info it needs to retake the lock for API
> > correctness.  After doing this it must check IS_DEADDIR() again to
> > ensure readdir always returns -ENOENT on a removed directory.
> >
> > Note that while ->iterate_shared is called with a shared lock, ovl uses
> > WRAP_DIR_ITER() so an exclusive lock is held and so we drop and retake
> > that exclusive lock.
> >
> > As the directory is no longer locked in ovl_cache_update() we need
> > dget_parent() to get a reference to the parent.
> >
> > Signed-off-by: NeilBrown <neil@brown.name>
> > ---
> >  fs/overlayfs/readdir.c | 19 ++++++++++++-------
> >  1 file changed, 12 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > index 1dcc75b3a90f..d5123b37921c 100644
> > --- a/fs/overlayfs/readdir.c
> > +++ b/fs/overlayfs/readdir.c
> > @@ -568,13 +568,12 @@ static int ovl_cache_update(const struct path *path=
, struct ovl_cache_entry *p,
> >                         goto get;
> >                 }
> >                 if (p->len =3D=3D 2) {
> > -                       /* we shall not be moved */
> > -                       this =3D dget(dir->d_parent);
> > +                       this =3D dget_parent(dir);
> >                         goto get;
> >                 }
> >         }
> >         /* This checks also for xwhiteouts */
> > -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->l=
en), dir);
> > +       this =3D lookup_one_unlocked(mnt_idmap(path->mnt), &QSTR_LEN(p->n=
ame, p->len), dir);
>=20
> ovl_cache_update() is also called from ovl_iterate_merged() where inode
> is locked.
>=20
> >         if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> >                 /* Mark a stale entry */
> >                 p->is_whiteout =3D true;
> > @@ -666,11 +665,12 @@ static int ovl_dir_read_impure(const struct path *p=
ath,  struct list_head *list,
> >         if (err)
> >                 return err;
> >
> > +       inode_unlock(path->dentry->d_inode);
> >         list_for_each_entry_safe(p, n, list, l_node) {
> >                 if (!name_is_dot_dotdot(p->name, p->len)) {
> >                         err =3D ovl_cache_update(path, p, true);
> >                         if (err)
> > -                               return err;
> > +                               break;
> >                 }
> >                 if (p->ino =3D=3D p->real_ino) {
> >                         list_del(&p->l_node);
> > @@ -680,14 +680,19 @@ static int ovl_dir_read_impure(const struct path *p=
ath,  struct list_head *list,
> >                         struct rb_node *parent =3D NULL;
> >
> >                         if (WARN_ON(ovl_cache_entry_find_link(p->name, p-=
>len,
> > -                                                             &newp, &par=
ent)))
> > -                               return -EIO;
> > +                                                             &newp, &par=
ent))) {
> > +                               err =3D -EIO;
> > +                               break;
> > +                       }
> >
> >                         rb_link_node(&p->node, parent, newp);
> >                         rb_insert_color(&p->node, root);
> >                 }
> >         }
> > -       return 0;
> > +       inode_lock(path->dentry->d_inode);
> > +       if (IS_DEADDIR(path->dentry->d_inode))
> > +               err =3D -ENOENT;
> > +       return err;
> >  }
> >
> >  static struct ovl_dir_cache *ovl_cache_get_impure(const struct path *pat=
h)
> > --
>=20
> You missed the fact that overlayfs uses the dir inode lock
> to protect the readdir inode cache, so your patch introduces
> a risk for storing a stale readdir cache when dir modify operations
> invalidate the readdir cache version while lock is dropped
> and also introduces memory leak when cache is stomped
> without freeing cache created by a competing thread.
> I think something like the untested patch below should fix this.

Yes, I did miss that - thanks. I think I missed a few other details too.
I no longer think it can be safe to drop the lock without substantial
rewrites - and even then maybe not.

So I'm considering a different approach.
This patch demonstrates what I'm thinking, though it still needs work I
think.

Thanks,
NeilBrown

From: NeilBrown <neil@brown.name>
Subject: [PATCH] ovl: stop using lookup_one() in iterate_shared() handling.

lookup_one() is expected to be removed as it does not fit well with
proposed changes to directory locking.
Specifically d_alloc_parallel() will be ordered outside of i_rwsem
and as iterate_shared() is called with i_rwsem held it is not safe
to call d_alloc_parallel().

We can instead call d_alloc_noblock() and then call the ->lookup, but
that can fail if there is a lookup attempt concurrent with the
readdir().

ovl cannot afford for the lookup to fail as that could produce incorrect
results, and it cannot safely drop i_rwsem temporarily and that could
introduce races with handling of the directory cache.

Instead we rely on the fact that ovl_iterate() has an exclusive lock on
the directory, so any concurrent lookup will wait for the ovl_iterate()
call to complete.  We allocate a separate dentry and if the lookup is
successful, it is hashed with the result.

When the concurrent lookup gets i_rwsem it mustn't do its own lookup -
it must use the existing dentry.  This is done using
try_lookup_noperm().  To manage overheads we keep a counter of the
number of "Stray dentries" there might be on each directory and only
check for one when this count is non zero.

If a 'stray dentry' were discarded for any reason before the concurrent
lookup completed, the count would never reach zero.  That might be a problem.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/overlayfs/namei.c     | 12 ++++++++++++
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/readdir.c   | 26 ++++++++++++++++++++++++--
 fs/overlayfs/super.c     |  1 +
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index d8dd4b052984..c3ff57047712 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1399,6 +1399,18 @@ struct dentry *ovl_lookup(struct inode *dir, struct de=
ntry *dentry,
 	if (dentry->d_name.len > ofs->namelen)
 		return ERR_PTR(-ENAMETOOLONG);
=20
+	if (atomic_read(&OVL_I(dir)->stray_dentries) && d_in_lookup(dentry)) {
+		/* This dentry might have forced readdir to do the lookup */
+		struct dentry *alias =3D
+			try_lookup_noperm(&QSTR_LEN(dentry->d_name.name,
+						    dentry->d_name.len),
+					  dentry->d_parent);
+		if (alias && !IS_ERR(alias)) {
+			atomic_dec(&OVL_I(dir)->stray_dentries);
+			return alias;
+		}
+	}
+
 	with_ovl_creds(dentry->d_sb)
 		err =3D ovl_lookup_layers(&ctx, &d);
=20
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 1d4828dbcf7a..0e7751d5dfca 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -172,6 +172,7 @@ struct ovl_inode {
 	struct inode vfs_inode;
 	struct dentry *__upperdentry;
 	struct ovl_entry *oe;
+	atomic_t stray_dentries; /* directory */
=20
 	/* synchronize copy up and more */
 	struct mutex lock;
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 1dcc75b3a90f..add556a0a2b6 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -557,6 +557,7 @@ static int ovl_cache_update(const struct path *path, stru=
ct ovl_cache_entry *p,
 	enum ovl_path_type type;
 	u64 ino =3D p->real_ino;
 	int xinobits =3D ovl_xino_bits(ofs);
+	bool did_alloc =3D false;
 	int err =3D 0;
=20
 	if (!ovl_same_dev(ofs) && !p->check_xwhiteout)
@@ -574,8 +575,29 @@ static int ovl_cache_update(const struct path *path, str=
uct ovl_cache_entry *p,
 		}
 	}
 	/* This checks also for xwhiteouts */
-	this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->len), dir);
-	if (IS_ERR_OR_NULL(this) || !this->d_inode) {
+	this =3D d_alloc_noblock(dir, &QSTR_LEN(p->name, p->len));
+	if (this =3D=3D ERR_PTR(-EWOULDBLOCK)) {
+		/*
+		 * Some other thread is looking up this name and will block
+		 * on i_rwsem before they can complete the lookup.
+		 * We will do the lookup and when that lookup gets a turn it
+		 * will return this dentry.
+		 */
+		this =3D d_alloc_name(dir, p->name);
+		did_alloc =3D true;
+	}
+	if (!IS_ERR(this) && !d_unhashed(this)) {
+		/* Either we got in-lookup or we made our own unhashed */
+		struct dentry *alias =3D ovl_lookup(dir->d_inode, this, 0);
+		if (alias) {
+			d_lookup_done(this);
+			dput(this);
+			this =3D alias;
+		} else if (did_alloc) {
+			atomic_inc(&OVL_I(dir->d_inode)->stray_dentries);
+		}
+	}
+	if (IS_ERR(this) || !this->d_inode) {
 		/* Mark a stale entry */
 		p->is_whiteout =3D true;
 		if (IS_ERR(this)) {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d4c12feec039..172d3ac7d3e2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -195,6 +195,7 @@ static struct inode *ovl_alloc_inode(struct super_block *=
sb)
 	oi->__upperdentry =3D NULL;
 	oi->lowerdata_redirect =3D NULL;
 	oi->oe =3D NULL;
+	atomic_set(&oi->stray_dentries, 0);
 	mutex_init(&oi->lock);
=20
 	return &oi->vfs_inode;
--=20
2.50.0.107.gf914562f5916.dirty

