Received: from neil.brown.name (neil.brown.name [103.29.64.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE4A725BEE5;
	Mon, 18 Aug 2025 21:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.29.64.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755552946; cv=none; b=Bop7Eu8Yxlslwc3UcIFe0PLXNu7CY9Vtk4vvZlN4IMBWe3sgRgAQeOL6tIRfP4NxF8D673aBOQf78RxJUVzJJzhWCxjmEjg05OTwQw0dy6HNCunrsnE6hzlGZKun2nG2o4befeR4fbzTgJ2Fvl3dWSXr6pHvkuEh2vVRdiBqJOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755552946; c=relaxed/simple;
	bh=pHP2UloFNhPWbVA2ptsztxk/LX9+PCs9szDxUpNRu7Y=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=mOIRTEWSEImHJ2z8jIeqGVEkrhPVH+jpsc5yf4bBR1uO4qMAIFjafRouELTggxW7uQ6x7Py+bBbvjEj4M7+7R8cOTp71ZqfSf5sNykJaFqzM8KPvJUKWRCFUYkBEPMsHhrGdC8kVA3T8FWnLytYn+pUJkubVNP4e+ow0qE0ipLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name; spf=pass smtp.mailfrom=neil.brown.name; arc=none smtp.client-ip=103.29.64.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=neil.brown.name
Received: from 196.186.233.220.static.exetel.com.au ([220.233.186.196] helo=home.neil.brown.name)
	by neil.brown.name with esmtp (Exim 4.95)
	(envelope-from <mr@neil.brown.name>)
	id 1uo7Vy-006Fdk-R8;
	Mon, 18 Aug 2025 21:35:40 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neil@brown.name>
To: "Amir Goldstein" <amir73il@gmail.com>
Cc: "syzbot" <syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com>,
 linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
 miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink
In-reply-to:
 <CAOQ4uxhEzxvgpJ=_a++xdGAptsywc4gLmnJXBA7ipFmM+qHR3g@mail.gmail.com>
References:
 <>, <CAOQ4uxhEzxvgpJ=_a++xdGAptsywc4gLmnJXBA7ipFmM+qHR3g@mail.gmail.com>
Date: Tue, 19 Aug 2025 07:35:40 +1000
Message-id: <175555294028.2234665.14790599995742040769@noble.neil.brown.name>

On Mon, 18 Aug 2025, Amir Goldstein wrote:
> On Mon, Aug 18, 2025 at 2:34=E2=80=AFAM NeilBrown <neil@brown.name> wrote:
> >
> > On Mon, 18 Aug 2025, Amir Goldstein wrote:
> > > Neil,
> > >
> > > I will have a look tomorrow.
> > > If you have ideas I am open to hear them.
> > > The repro is mounting overlayfs all over each other in concurrent threa=
ds
> > > and one of the rmdir of "work" dir triggers this assertion
> >
> > My guess is that by dropping and retaking the lock, we open the
> > possibility of a race so that by the time vfs_unlink() is called the
> > dentry has already been unlinked.  In that case it would be unhashed.
> > So after retaking the lock we need to check d_unhashed() as well as
> > ->d_parent.
> >
> > So something like
> > --- a/fs/overlayfs/util.c
> > +++ b/fs/overlayfs/util.c
> > @@ -1552,7 +1552,8 @@ void ovl_copyattr(struct inode *inode)
> >  int ovl_parent_lock(struct dentry *parent, struct dentry *child)
> >  {
> >         inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
> > -       if (!child || child->d_parent =3D=3D parent)
> > +       if (!child ||
> > +           (!d_unhashed(child) && child->d_parent =3D=3D parent))
> >                 return 0;
> >
> >         inode_unlock(parent->d_inode);
> >
> >
> > NeilBrown
> >
>=20
> Nice!
> I pushed this commit to ovl-fixes:
>=20
> commit c56976d86e11afcd6b23633395a7f2e6e920e42d (HEAD -> ovl-fixes)
> Author: Amir Goldstein <amir73il@gmail.com>
> Date:   Mon Aug 18 11:23:55 2025 +0200
>=20
>     ovl: fix possible double unlink
>=20
>     commit 9d23967b18c6 ("ovl: simplify an error path in
>     ovl_copy_up_workdir()") introduced the helper ovl_cleanup_unlocked(),
>     which is later used in several following patches to re-acquire the pare=
nt
>     inode lock and unlink a dentry that was earlier found using lookup.
>     This helper was eventually renamed to ovl_cleanup().
>=20
>     The helper ovl_parent_lock() is used to re-acquire the parent inode loc=
k.
>     After acquiring the parent inode lock, the helper verifies that the
>     dentry has not since been moved to another parent, but it failed to
>     verify that the dentry wasn't unlinked from the parent.
>=20
>     This means that now every call to ovl_cleanup() could potentially
>     race with another thread, unlinking the dentry to be cleaned up
>     underneath overlayfs and trigger a vfs assertion.
>=20
>     Reported-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com
>     Tested-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com
>     Fixes: 9d23967b18c6 ("ovl: simplify an error path in ovl_copy_up_workdi=
r()")
>     Suggested-by: NeilBrown <neil@brown.name>
>     Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>=20
> Neil,
>=20
> Please review my commit message.
> If you want me to assign you ownership please sign off on this commit messa=
ge.

Looks good to me.  No changes needed.

NeilBrown


>=20
> Thanks,
> Amir.
>=20

