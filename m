Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64A9248867;
	Fri, 27 Mar 2026 04:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774584815; cv=none; b=C8FZjcWa7/9hdT/QMsJ9kdFWENr+EnT0YPEAXmGk5gW+8yuhdJR/+28pO8edJ8JtaF/LoddQP47SCxDFrYPu0dVAmGHEFPeY0Q8dxAmhpiDerbLY7mgZJjXqGkhLiKKV0l2v8SNM7CHy/1LLZPAEbJ+u1qvtsVSazk79c6Qeyno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774584815; c=relaxed/simple;
	bh=O1r2TB7AZDhv/ye2uot4lJ8UrQc85iSzpdILU89Cq9o=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=uhN3dQxzZBBo7P7WijDcDpU/iS9EvkApTwDULtlu9X4BLt8HaneiQLtPs2UYD4xgbPnKgx7anGSefcOR7cWUKllwgZkuIC4ORD5hwTcFZRf25hvH6ytOGEEb8bIBIxroH88tm2CLmp1XyVy+6usO+H0lM8ow1ljXiXWE9FsUEjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=iIHUxczi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=MCJY5Ufu; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="iIHUxczi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MCJY5Ufu"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id BF45F7A0169;
	Fri, 27 Mar 2026 00:13:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 27 Mar 2026 00:13:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1774584810; x=1774671210; bh=WyVInZcZr68/eNJ6NMis1vjr9ENyg87XN4z
	U87cAIXw=; b=iIHUxcziG/GkywLtm1/bJzw0DUY8tt4b3TQLybWfs6S+FkiKHWh
	W9cGw9O7v01Dl4UQ9kvXiAxHRNfua/YleuWnpfQuQsaIBXdOlyojDlfxerf7Wu+7
	tECal6FeSfW/Z5LAJTR9On4ZBL5pB4IjmGlkXjqqxPtyLrTzkw5J49u5cxQA8ahW
	Quvva38P3Z6OPakMfy10Vs+dJCJ5ql5XcqDQCSm4jxf6KNg4avTKK3NfHhLj5aDi
	D34yxiT/1kyhxoeVogbtDm3ci0Km/WR9ZkNAPX+xZJo/3e5RmJhr+aWvAxVGIKfY
	zaxjnV4D6RofydqMRhCW24TiJwOb2TaVXVA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1774584810; x=
	1774671210; bh=WyVInZcZr68/eNJ6NMis1vjr9ENyg87XN4zU87cAIXw=; b=M
	CJY5UfuGfBGliGIvIbSfgTi+R+EyT37gVZdbrlsZrKPClwBFLPDfjtVaGaOL2e1J
	zfGzBBj+xhi33mzSoEl0osQmLY221Rzk9o/8Fr9+JVKYBCUiFCjpGXG5jA2BT2YQ
	mSC5fZN7A+ZxiZoANwCAIhGy43mKwW0vba8yMUE1uxyGElww8ivTxWK36AxKdqER
	UZuVejy4hmTFMg0unpBrHLv7W7HtdPtusOWzcD4YQqczsxD8d9BOTuLB/77iDDWK
	zPczgWcNwo4ng+gokkZ57K8oyInXjiYGzqkjdrGB81nTyab8/gO+9jQlr0Ro2svv
	lTUz/DTnt9OadXuzPHpfw==
X-ME-Sender: <xms:6QPGafsB-kzA3OHCSdBvUFQU0uMVqQu7uw8aVez4NojrmiQwpJMjIQ>
    <xme:6QPGaVYPK-9mv_gOBUrX8JnEdQBp9jOrtnAi8Qq2iuRevNDbkx2p8bh4wOp1o9AL7
    8J3gKUER2zn_vJ-jptTH7PJTokI52tpUsOlM8GkPTWN_ya6JA>
X-ME-Received: <xmr:6QPGaXD75L33ZW2L_DG6h-leHMid5qIeugWJTL5BMBBdXv5yMKi9Yj5oZCuk7W_ps8Ov75in3zhmXMPqJuJJY1wTL9x9PkLrgE7dtyrn2Usk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdelvdelucetufdoteggodetrf
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
X-ME-Proxy: <xmx:6QPGad9kR5HiZ78xBJMO0ehBhybmsTHG5ZKHpEg6H5Tf3xc_ua2Lsw>
    <xmx:6QPGaTRJoSgtIOA3f9j-e4zeakPUC3IsKp8bOOUKTPGdoF9JM7ooSA>
    <xmx:6QPGaRXKLEDFxhC9-Io5otAIjRn4qS8e2s1KolEDsMOC__bHrRKpaw>
    <xmx:6QPGadQho4X42sBOmBfSnvittKZuy8qhPM5gezt8G_T-tIzR96GTQQ>
    <xmx:6gPGaQfGw1ali5kZUrVlIs8Kt60XERuaIOjlNWgVWldtYtKQFcKViLFo>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 27 Mar 2026 00:13:27 -0400 (EDT)
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
 <CAOQ4uxgvD3COuoD5r67CfpYSiRFSr0LY5TB-QPcSn-zD9Ht1HQ@mail.gmail.com>
References: <20260312214330.3885211-1-neilb@ownmail.net>,
 <20260312214330.3885211-17-neilb@ownmail.net>,
 <CAOQ4uxjmcNxsCmDSVgkTns=3BAuQcT3pVvsQzza+u3iqXqrz5g@mail.gmail.com>,
 <177386823998.3934327.10803400222725196190@noble.neil.brown.name>,
 <CAOQ4uxgvD3COuoD5r67CfpYSiRFSr0LY5TB-QPcSn-zD9Ht1HQ@mail.gmail.com>
Date: Fri, 27 Mar 2026 15:13:23 +1100
Message-id: <177458480314.1851489.4686537284269032199@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Sat, 21 Mar 2026, Amir Goldstein wrote:
> On Wed, Mar 18, 2026 at 10:10=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrot=
e:
> >
> > [[ CC list trimmed ]]
> >
> > On Mon, 16 Mar 2026, Amir Goldstein wrote:
> > > On Thu, Mar 12, 2026 at 10:49=E2=80=AFPM NeilBrown <neilb@ownmail.net> =
wrote:
> > > >
> > > > From: NeilBrown <neil@brown.name>
> > > >
> > > > When performing an "impure" readdir, ovl needs to perform a lookup on=
 some
> > > > of the names that it found.
> > > > With proposed locking changes it will not be possible to perform this
> > > > lookup (in particular, not safe to wait for d_alloc_parallel()) while
> > > > holding a lock on the directory.
> > > >
> > > > ovl doesn't really need the lock at this point.
> > >
> > > Not exactly. see below.
> > >
> > > > It has already iterated
> > > > the directory and has cached a list of the contents.  It now needs to
> > > > gather extra information about some contents.  It can do this without
> > > > the lock.
> > > >
> > > > After gathering that info it needs to retake the lock for API
> > > > correctness.  After doing this it must check IS_DEADDIR() again to
> > > > ensure readdir always returns -ENOENT on a removed directory.
> > > >
> > > > Note that while ->iterate_shared is called with a shared lock, ovl us=
es
> > > > WRAP_DIR_ITER() so an exclusive lock is held and so we drop and retake
> > > > that exclusive lock.
> > > >
> > > > As the directory is no longer locked in ovl_cache_update() we need
> > > > dget_parent() to get a reference to the parent.
> > > >
> > > > Signed-off-by: NeilBrown <neil@brown.name>
> > > > ---
> > > >  fs/overlayfs/readdir.c | 19 ++++++++++++-------
> > > >  1 file changed, 12 insertions(+), 7 deletions(-)
> > > >
> > > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > > index 1dcc75b3a90f..d5123b37921c 100644
> > > > --- a/fs/overlayfs/readdir.c
> > > > +++ b/fs/overlayfs/readdir.c
> > > > @@ -568,13 +568,12 @@ static int ovl_cache_update(const struct path *=
path, struct ovl_cache_entry *p,
> > > >                         goto get;
> > > >                 }
> > > >                 if (p->len =3D=3D 2) {
> > > > -                       /* we shall not be moved */
> > > > -                       this =3D dget(dir->d_parent);
> > > > +                       this =3D dget_parent(dir);
> > > >                         goto get;
> > > >                 }
> > > >         }
> > > >         /* This checks also for xwhiteouts */
> > > > -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, =
p->len), dir);
> > > > +       this =3D lookup_one_unlocked(mnt_idmap(path->mnt), &QSTR_LEN(=
p->name, p->len), dir);
> > >
> > > ovl_cache_update() is also called from ovl_iterate_merged() where inode
> > > is locked.
> > >
> > > >         if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> > > >                 /* Mark a stale entry */
> > > >                 p->is_whiteout =3D true;
> > > > @@ -666,11 +665,12 @@ static int ovl_dir_read_impure(const struct pat=
h *path,  struct list_head *list,
> > > >         if (err)
> > > >                 return err;
> > > >
> > > > +       inode_unlock(path->dentry->d_inode);
> > > >         list_for_each_entry_safe(p, n, list, l_node) {
> > > >                 if (!name_is_dot_dotdot(p->name, p->len)) {
> > > >                         err =3D ovl_cache_update(path, p, true);
> > > >                         if (err)
> > > > -                               return err;
> > > > +                               break;
> > > >                 }
> > > >                 if (p->ino =3D=3D p->real_ino) {
> > > >                         list_del(&p->l_node);
> > > > @@ -680,14 +680,19 @@ static int ovl_dir_read_impure(const struct pat=
h *path,  struct list_head *list,
> > > >                         struct rb_node *parent =3D NULL;
> > > >
> > > >                         if (WARN_ON(ovl_cache_entry_find_link(p->name=
, p->len,
> > > > -                                                             &newp, =
&parent)))
> > > > -                               return -EIO;
> > > > +                                                             &newp, =
&parent))) {
> > > > +                               err =3D -EIO;
> > > > +                               break;
> > > > +                       }
> > > >
> > > >                         rb_link_node(&p->node, parent, newp);
> > > >                         rb_insert_color(&p->node, root);
> > > >                 }
> > > >         }
> > > > -       return 0;
> > > > +       inode_lock(path->dentry->d_inode);
> > > > +       if (IS_DEADDIR(path->dentry->d_inode))
> > > > +               err =3D -ENOENT;
> > > > +       return err;
> > > >  }
> > > >
> > > >  static struct ovl_dir_cache *ovl_cache_get_impure(const struct path =
*path)
> > > > --
> > >
> > > You missed the fact that overlayfs uses the dir inode lock
> > > to protect the readdir inode cache, so your patch introduces
> > > a risk for storing a stale readdir cache when dir modify operations
> > > invalidate the readdir cache version while lock is dropped
> > > and also introduces memory leak when cache is stomped
> > > without freeing cache created by a competing thread.
> > > I think something like the untested patch below should fix this.
> >
> > Yes, I did miss that - thanks. I think I missed a few other details too.
> > I no longer think it can be safe to drop the lock without substantial
> > rewrites - and even then maybe not.
> >
> > So I'm considering a different approach.
> > This patch demonstrates what I'm thinking, though it still needs work I
> > think.
>=20
> I like this direction.
>=20
> I always thought that we need to get rid of this vfs lookup
> inside readdir but I thought it would be a lot of work.
>=20
> Your suggestion walks around this in an elegant way.
>=20

Thanks :-)


> >
> > Thanks,
> > NeilBrown
> >
> > From: NeilBrown <neil@brown.name>
> > Subject: [PATCH] ovl: stop using lookup_one() in iterate_shared() handlin=
g.
> >
> > lookup_one() is expected to be removed as it does not fit well with
> > proposed changes to directory locking.
> > Specifically d_alloc_parallel() will be ordered outside of i_rwsem
> > and as iterate_shared() is called with i_rwsem held it is not safe
> > to call d_alloc_parallel().
> >
> > We can instead call d_alloc_noblock() and then call the ->lookup, but
> > that can fail if there is a lookup attempt concurrent with the
> > readdir().
> >
> > ovl cannot afford for the lookup to fail as that could produce incorrect
> > results, and it cannot safely drop i_rwsem temporarily and that could
> > introduce races with handling of the directory cache.
> >
> > Instead we rely on the fact that ovl_iterate() has an exclusive lock on
> > the directory, so any concurrent lookup will wait for the ovl_iterate()
> > call to complete.  We allocate a separate dentry and if the lookup is
> > successful, it is hashed with the result.
> >
> > When the concurrent lookup gets i_rwsem it mustn't do its own lookup -
> > it must use the existing dentry.  This is done using
> > try_lookup_noperm().  To manage overheads we keep a counter of the
> > number of "Stray dentries" there might be on each directory and only
> > check for one when this count is non zero.
> >
> > If a 'stray dentry' were discarded for any reason before the concurrent
> > lookup completed, the count would never reach zero.  That might be a prob=
lem.
>=20
> Can we deal with the discarded dentries using OVL_E_FLAGS() for
> a stray ovl dentry implement the relevant ovl_dentry_operations to decrement
> the stray counter?

Maybe ... though I'd really rather get rid of the stray counter.
We could drop it completely and always do the try_lookup_noperm() in
ovl_lookup(), but that might have a performance cost.
I'd really like to be able to mark the in-lookup dentry which caused
d_alloc_noblock() to fail so that when the lookup on that dentry happens
we can know to do the try_lookup_noperm().  That avoids both the counter
and the cost.

I had previously suggested a d_alloc_locked() which could return an
in-lookup dentry providing the filesystem provided some interlock so the
caller of d_alloc_locked() and ->lookup wouldn't both instantiate the
dentry.  Al wasn't keen on that.  Maybe I could try again.  I'd like to
get some review from him on the current patches first though...

Thanks,
NeilBrown
