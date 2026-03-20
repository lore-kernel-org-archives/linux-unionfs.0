Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C7A3A0B11
	for <linux-unionfs@vger.kernel.org>; Fri, 20 Mar 2026 14:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774018042; cv=pass; b=HtiRVQQhE6aw7d8VzEXcDVZ1RK/axjgCMqau8WXaoQaFLp4OJ8jen8I/J0Y4RNJ7/QnuVMoLKVk7EvDfW19+7NoRX37tMxL8PJL/VTbDjoyYOS0MoYvyM9zYVSHYz4WB80TprgEsK0vPIatyXIYqok7Dmw/i+WLZe+Tin2Beq6g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774018042; c=relaxed/simple;
	bh=hUXCCzNq+YoSrT1MYXebgJGJ2avs/D6mzf9IXZRcDHg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NPOaj3FVBJR7NK+0WKyVt7SsVYRBMRocOdpznOB6W1Ivusk0YHYkSjyP2eyvz3VeZHhnlZPGoMBQkIlkGy/1xu/AjJz8vQNncl4b/Qi8aio3aC5gTbxRxPib8e7pNbFyTM58YTIQlvEE3CAwvS/9TLWtfwAt95BhS2Ht0Aj8rXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W2vC/Kkr; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W2vC/Kkr"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b936331786dso204928266b.3
        for <linux-unionfs@vger.kernel.org>; Fri, 20 Mar 2026 07:47:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774018039; cv=none;
        d=google.com; s=arc-20240605;
        b=MB7dZ/MlZcTER2sz+rgw4yGSFrCGE+VhXH31HtFV+GZLU6Qu1uEN9JjAIRZD6aGqbZ
         8cI1QU9enXQKjjqFbaVkor+XMLNpNsMTuuUUILBF6DmchMclqM1u7Z5dnfyl9VQgaQXv
         /rHoI/F0Cyh0NgrbKsiico5C3rT+j/VG9jo4mLf5vYhs8H3m7f3Z5gbstm0DJOAoSNZ3
         GMJbh1hyr+Q7OR7gIHIhzrEzmS3G8zmQkr12AhVaoDK6ZuYkhoCI92ktXMB7H1e3KkgL
         PgKJGkibpTWrmfBUwzHY3DIYzvN17vDockbxuQmNL2GVa9RmhnqoBvndFB9suqerktx9
         OiEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vTgQ50O1oiNynzwEGL7y41l8E79C+EzJRmuAl1+fekM=;
        fh=rY0/iFFxxEqbvagUnuYtRFmn3lsYI9QJUKwfGr27gjk=;
        b=audAP/OyWMYkmrS67GB2W5r2Q/Q0M3Tjg2GhWquD2vjIItDgFXCaLrKnADAyI2tlti
         EU4PkDcGYMLWBo+OI+gZNrZm803rfjcTi0WHLezkU2uoS+sFUBw2LRndEdbqYKW0X1j5
         8r53YKIhHDP9Ro/91x8x5o9tXFaMqYCUYPTKSWqAOFDSlQSWvDl1TItsbTtqRaBxjyvh
         Psna25DaTDl7KSiPpBNANsdXIWw0vBs+UAbmTYWazz7Z8gBESxHkeuGiHMiqR7Q0QkBe
         TEU+ZicDkDKXapf/fITbGd9LSRxbnRzw27xU8pZxfVfIIWNlR8Lo88VMick2rqdjHJMu
         1DKw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774018039; x=1774622839; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vTgQ50O1oiNynzwEGL7y41l8E79C+EzJRmuAl1+fekM=;
        b=W2vC/KkrPGk+/a1+HyOHqOYzuqvBmboQfZvbtUBTW1Vl4xS6XO0sZWbVlHlijH61uJ
         N4WIHf/jyr/cA3IurAwPx9qqeZHmeNfVuSJMC7GjGomH1YXIF1MidCAXqd0eVyC2JGQf
         FfqoLJH8UlWNM29n3tr0hXcpW0neCdO0mkeza7Gkr+zY6y/OrMLDiwYUaDx3kyj+0nHA
         XtxE/LFDoW4OGVrE8crOzrVCl63HhHqFLbx1QPQwG48XjXAzaqORIQJOcEPj1Pv8JiDn
         zpSjAYcgqAS00PyYSPRHj3j+0+MEyFLfDfsReSXat6oFrFCrs/16WHabcjtbGA7pTVTr
         AGYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774018039; x=1774622839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vTgQ50O1oiNynzwEGL7y41l8E79C+EzJRmuAl1+fekM=;
        b=O6PNkki9PqlqLvPhC9IRHagJmhfeJDgBMRz9zIcViW8GyHiML7hZkAR8+BudFD+Eqg
         GjXrEPUoT1zajwIsvsksDqP4JqUOMIOhnIJGDyoX96YWQ9tlEIfI0EoKQfJxmt0c9kma
         LvqOqWIit9kJR2fpRByp+lugo7Z3CwC1z2cGeonpIdyb5eFYnkMvMdcL04d0r6ujaAN/
         f8Bf+UtUXURN1TFScUK9fLsJ1o9MDRCWcqjSwJ3lL1g2daXw2wjNK4c8HWyCypKmcR9I
         kUpyl++VRIB2HeXmoD8SWmxxRFw7XPYyOv09LtuG1zEcJMb1S27+wm/13i39eHJW0wDq
         zy9A==
X-Forwarded-Encrypted: i=1; AJvYcCU28/PtKl+uGzrujS3JdrFp2rMCmxTLWQ1suOxmw/pbGlrCT2yvNbYURmBoQZ/+DhvBRLuo6k1WgWob0PkO@vger.kernel.org
X-Gm-Message-State: AOJu0Yxxx1tVKKKesiQWvG6shUToKH46R7kSz6/q4E/GAqDIngS+lCAC
	A7gzpZPZpCXw3a1gUYnG+ARs8g5u7XAcTLIVCPhxRMt8xoxuh68daztO9t3YVNPZOneLOggwYnR
	uT3rBQ8rFAFkqIJor/Iylk1zyOuuqbaE=
X-Gm-Gg: ATEYQzypWHnkAem/RaX6A0eBM/lD7PTMHd4vQo32C/ceYZAbzF+BrdXlu88p/puCcVk
	PHrfupcbXIiXZcp1eQ3AY80fSoETQI1r6hS5/Gg0XGFJ+6MkQnOkcFwXlGvJoDbfokhyF6LQl+M
	eN2iZ1Hz0R/miyqLIAc1eUa160aR00AXJ5VJiTppdIGJha/gjPRp6MM1+AmG6a1xKBwDVqev0/I
	EjudcpLyy78NlodUKiw3fZaj/UOOj3PUo8UF7jqu2mOHjiHtDIGYIFlxHcDemjs/U8JRkPkWQ9R
	jvKji6f4fTip0WUQmY+oF/uCsPQ9cw5q1uWa0OZd
X-Received: by 2002:a17:907:a807:b0:b97:b2dc:91e2 with SMTP id
 a640c23a62f3a-b982f1e66a0mr240320666b.16.1774018038640; Fri, 20 Mar 2026
 07:47:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260312214330.3885211-1-neilb@ownmail.net> <20260312214330.3885211-17-neilb@ownmail.net>
 <CAOQ4uxjmcNxsCmDSVgkTns=3BAuQcT3pVvsQzza+u3iqXqrz5g@mail.gmail.com> <177386823998.3934327.10803400222725196190@noble.neil.brown.name>
In-Reply-To: <177386823998.3934327.10803400222725196190@noble.neil.brown.name>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 20 Mar 2026 15:47:06 +0100
X-Gm-Features: AaiRm50_edNtekIrrv4eSu4Qa5bvNeyUgtpCK3q4qoH_yisc1DeMkbaOnfrPdQ8
Message-ID: <CAOQ4uxgvD3COuoD5r67CfpYSiRFSr0LY5TB-QPcSn-zD9Ht1HQ@mail.gmail.com>
Subject: Re: [PATCH 16/53] ovl: drop dir lock for lookups in impure readdir
To: NeilBrown <neil@brown.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 18, 2026 at 10:10=E2=80=AFPM NeilBrown <neilb@ownmail.net> wrot=
e:
>
> [[ CC list trimmed ]]
>
> On Mon, 16 Mar 2026, Amir Goldstein wrote:
> > On Thu, Mar 12, 2026 at 10:49=E2=80=AFPM NeilBrown <neilb@ownmail.net> =
wrote:
> > >
> > > From: NeilBrown <neil@brown.name>
> > >
> > > When performing an "impure" readdir, ovl needs to perform a lookup on=
 some
> > > of the names that it found.
> > > With proposed locking changes it will not be possible to perform this
> > > lookup (in particular, not safe to wait for d_alloc_parallel()) while
> > > holding a lock on the directory.
> > >
> > > ovl doesn't really need the lock at this point.
> >
> > Not exactly. see below.
> >
> > > It has already iterated
> > > the directory and has cached a list of the contents.  It now needs to
> > > gather extra information about some contents.  It can do this without
> > > the lock.
> > >
> > > After gathering that info it needs to retake the lock for API
> > > correctness.  After doing this it must check IS_DEADDIR() again to
> > > ensure readdir always returns -ENOENT on a removed directory.
> > >
> > > Note that while ->iterate_shared is called with a shared lock, ovl us=
es
> > > WRAP_DIR_ITER() so an exclusive lock is held and so we drop and retak=
e
> > > that exclusive lock.
> > >
> > > As the directory is no longer locked in ovl_cache_update() we need
> > > dget_parent() to get a reference to the parent.
> > >
> > > Signed-off-by: NeilBrown <neil@brown.name>
> > > ---
> > >  fs/overlayfs/readdir.c | 19 ++++++++++++-------
> > >  1 file changed, 12 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> > > index 1dcc75b3a90f..d5123b37921c 100644
> > > --- a/fs/overlayfs/readdir.c
> > > +++ b/fs/overlayfs/readdir.c
> > > @@ -568,13 +568,12 @@ static int ovl_cache_update(const struct path *=
path, struct ovl_cache_entry *p,
> > >                         goto get;
> > >                 }
> > >                 if (p->len =3D=3D 2) {
> > > -                       /* we shall not be moved */
> > > -                       this =3D dget(dir->d_parent);
> > > +                       this =3D dget_parent(dir);
> > >                         goto get;
> > >                 }
> > >         }
> > >         /* This checks also for xwhiteouts */
> > > -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, =
p->len), dir);
> > > +       this =3D lookup_one_unlocked(mnt_idmap(path->mnt), &QSTR_LEN(=
p->name, p->len), dir);
> >
> > ovl_cache_update() is also called from ovl_iterate_merged() where inode
> > is locked.
> >
> > >         if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> > >                 /* Mark a stale entry */
> > >                 p->is_whiteout =3D true;
> > > @@ -666,11 +665,12 @@ static int ovl_dir_read_impure(const struct pat=
h *path,  struct list_head *list,
> > >         if (err)
> > >                 return err;
> > >
> > > +       inode_unlock(path->dentry->d_inode);
> > >         list_for_each_entry_safe(p, n, list, l_node) {
> > >                 if (!name_is_dot_dotdot(p->name, p->len)) {
> > >                         err =3D ovl_cache_update(path, p, true);
> > >                         if (err)
> > > -                               return err;
> > > +                               break;
> > >                 }
> > >                 if (p->ino =3D=3D p->real_ino) {
> > >                         list_del(&p->l_node);
> > > @@ -680,14 +680,19 @@ static int ovl_dir_read_impure(const struct pat=
h *path,  struct list_head *list,
> > >                         struct rb_node *parent =3D NULL;
> > >
> > >                         if (WARN_ON(ovl_cache_entry_find_link(p->name=
, p->len,
> > > -                                                             &newp, =
&parent)))
> > > -                               return -EIO;
> > > +                                                             &newp, =
&parent))) {
> > > +                               err =3D -EIO;
> > > +                               break;
> > > +                       }
> > >
> > >                         rb_link_node(&p->node, parent, newp);
> > >                         rb_insert_color(&p->node, root);
> > >                 }
> > >         }
> > > -       return 0;
> > > +       inode_lock(path->dentry->d_inode);
> > > +       if (IS_DEADDIR(path->dentry->d_inode))
> > > +               err =3D -ENOENT;
> > > +       return err;
> > >  }
> > >
> > >  static struct ovl_dir_cache *ovl_cache_get_impure(const struct path =
*path)
> > > --
> >
> > You missed the fact that overlayfs uses the dir inode lock
> > to protect the readdir inode cache, so your patch introduces
> > a risk for storing a stale readdir cache when dir modify operations
> > invalidate the readdir cache version while lock is dropped
> > and also introduces memory leak when cache is stomped
> > without freeing cache created by a competing thread.
> > I think something like the untested patch below should fix this.
>
> Yes, I did miss that - thanks. I think I missed a few other details too.
> I no longer think it can be safe to drop the lock without substantial
> rewrites - and even then maybe not.
>
> So I'm considering a different approach.
> This patch demonstrates what I'm thinking, though it still needs work I
> think.

I like this direction.

I always thought that we need to get rid of this vfs lookup
inside readdir but I thought it would be a lot of work.

Your suggestion walks around this in an elegant way.

>
> Thanks,
> NeilBrown
>
> From: NeilBrown <neil@brown.name>
> Subject: [PATCH] ovl: stop using lookup_one() in iterate_shared() handlin=
g.
>
> lookup_one() is expected to be removed as it does not fit well with
> proposed changes to directory locking.
> Specifically d_alloc_parallel() will be ordered outside of i_rwsem
> and as iterate_shared() is called with i_rwsem held it is not safe
> to call d_alloc_parallel().
>
> We can instead call d_alloc_noblock() and then call the ->lookup, but
> that can fail if there is a lookup attempt concurrent with the
> readdir().
>
> ovl cannot afford for the lookup to fail as that could produce incorrect
> results, and it cannot safely drop i_rwsem temporarily and that could
> introduce races with handling of the directory cache.
>
> Instead we rely on the fact that ovl_iterate() has an exclusive lock on
> the directory, so any concurrent lookup will wait for the ovl_iterate()
> call to complete.  We allocate a separate dentry and if the lookup is
> successful, it is hashed with the result.
>
> When the concurrent lookup gets i_rwsem it mustn't do its own lookup -
> it must use the existing dentry.  This is done using
> try_lookup_noperm().  To manage overheads we keep a counter of the
> number of "Stray dentries" there might be on each directory and only
> check for one when this count is non zero.
>
> If a 'stray dentry' were discarded for any reason before the concurrent
> lookup completed, the count would never reach zero.  That might be a prob=
lem.

Can we deal with the discarded dentries using OVL_E_FLAGS() for
a stray ovl dentry implement the relevant ovl_dentry_operations to decremen=
t
the stray counter?

Thanks,
Amir.

>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/overlayfs/namei.c     | 12 ++++++++++++
>  fs/overlayfs/ovl_entry.h |  1 +
>  fs/overlayfs/readdir.c   | 26 ++++++++++++++++++++++++--
>  fs/overlayfs/super.c     |  1 +
>  4 files changed, 38 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index d8dd4b052984..c3ff57047712 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1399,6 +1399,18 @@ struct dentry *ovl_lookup(struct inode *dir, struc=
t dentry *dentry,
>         if (dentry->d_name.len > ofs->namelen)
>                 return ERR_PTR(-ENAMETOOLONG);
>
> +       if (atomic_read(&OVL_I(dir)->stray_dentries) && d_in_lookup(dentr=
y)) {
> +               /* This dentry might have forced readdir to do the lookup=
 */
> +               struct dentry *alias =3D
> +                       try_lookup_noperm(&QSTR_LEN(dentry->d_name.name,
> +                                                   dentry->d_name.len),
> +                                         dentry->d_parent);
> +               if (alias && !IS_ERR(alias)) {
> +                       atomic_dec(&OVL_I(dir)->stray_dentries);
> +                       return alias;
> +               }
> +       }
> +
>         with_ovl_creds(dentry->d_sb)
>                 err =3D ovl_lookup_layers(&ctx, &d);
>
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 1d4828dbcf7a..0e7751d5dfca 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -172,6 +172,7 @@ struct ovl_inode {
>         struct inode vfs_inode;
>         struct dentry *__upperdentry;
>         struct ovl_entry *oe;
> +       atomic_t stray_dentries; /* directory */
>
>         /* synchronize copy up and more */
>         struct mutex lock;
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 1dcc75b3a90f..add556a0a2b6 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -557,6 +557,7 @@ static int ovl_cache_update(const struct path *path, =
struct ovl_cache_entry *p,
>         enum ovl_path_type type;
>         u64 ino =3D p->real_ino;
>         int xinobits =3D ovl_xino_bits(ofs);
> +       bool did_alloc =3D false;
>         int err =3D 0;
>
>         if (!ovl_same_dev(ofs) && !p->check_xwhiteout)
> @@ -574,8 +575,29 @@ static int ovl_cache_update(const struct path *path,=
 struct ovl_cache_entry *p,
>                 }
>         }
>         /* This checks also for xwhiteouts */
> -       this =3D lookup_one(mnt_idmap(path->mnt), &QSTR_LEN(p->name, p->l=
en), dir);
> -       if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> +       this =3D d_alloc_noblock(dir, &QSTR_LEN(p->name, p->len));
> +       if (this =3D=3D ERR_PTR(-EWOULDBLOCK)) {
> +               /*
> +                * Some other thread is looking up this name and will blo=
ck
> +                * on i_rwsem before they can complete the lookup.
> +                * We will do the lookup and when that lookup gets a turn=
 it
> +                * will return this dentry.
> +                */
> +               this =3D d_alloc_name(dir, p->name);
> +               did_alloc =3D true;
> +       }
> +       if (!IS_ERR(this) && !d_unhashed(this)) {
> +               /* Either we got in-lookup or we made our own unhashed */
> +               struct dentry *alias =3D ovl_lookup(dir->d_inode, this, 0=
);
> +               if (alias) {
> +                       d_lookup_done(this);
> +                       dput(this);
> +                       this =3D alias;
> +               } else if (did_alloc) {
> +                       atomic_inc(&OVL_I(dir->d_inode)->stray_dentries);
> +               }
> +       }
> +       if (IS_ERR(this) || !this->d_inode) {
>                 /* Mark a stale entry */
>                 p->is_whiteout =3D true;
>                 if (IS_ERR(this)) {
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index d4c12feec039..172d3ac7d3e2 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -195,6 +195,7 @@ static struct inode *ovl_alloc_inode(struct super_blo=
ck *sb)
>         oi->__upperdentry =3D NULL;
>         oi->lowerdata_redirect =3D NULL;
>         oi->oe =3D NULL;
> +       atomic_set(&oi->stray_dentries, 0);
>         mutex_init(&oi->lock);
>
>         return &oi->vfs_inode;
> --
> 2.50.0.107.gf914562f5916.dirty
>
