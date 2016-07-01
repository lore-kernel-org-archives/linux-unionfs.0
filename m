From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] locks: use file_inode()
Date: Fri, 1 Jul 2016 09:47:05 -0400
Message-ID: <20160701134705.GA20327@fieldses.org>
References: <1467377767-12845-1-git-send-email-mszeredi@redhat.com>
 <1467378310.7477.3.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:51604 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbcGANtb (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 1 Jul 2016 09:49:31 -0400
Content-Disposition: inline
In-Reply-To: <1467378310.7477.3.camel@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@redhat.com>
Cc: Miklos Szeredi <mszeredi@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, stable@vger.kernel.org

On Fri, Jul 01, 2016 at 09:05:10AM -0400, Jeff Layton wrote:
> On Fri, 2016-07-01 at 14:56 +0200, Miklos Szeredi wrote:
> > (Another one for the f_path debacle.)
> >=20
> > ltp fcntl33 testcase caused an Oops in selinux_file_send_sigiotask.
> >=20
> > The reason is that generic_add_lease() used filp->f_path.dentry->in=
ode
> > while all the others use file_inode().=C2=A0=C2=A0This makes a diff=
erence for files
> > opened on overlayfs since the former will point to the overlay inod=
e the
> > latter to the underlying inode.
> >=20
> > So generic_add_lease() added the lease to the overlay inode and
> > generic_delete_lease() removed it from the underlying inode.=C2=A0=C2=
=A0When the file
> > was released the lease remained on the overlay inode's lock list, r=
esulting
> > in use after free.
> >=20
> > Reported-by: Eryu Guan <eguan@redhat.com>
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > Fixes: 4bacc9c9234c ("overlayfs: Make f_path always point to the ov=
erlay and f_inode to the underlay")
> > Cc: <stable@vger.kernel.org>
> > Cc: Jeff Layton <jlayton@poochiereds.net>
> > Cc: "J. Bruce Fields" <bfields@fieldses.org>
> > ---
> > =C2=A0fs/locks.c | 2 +-
> > =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/fs/locks.c b/fs/locks.c
> > index 7c5f91be9b65..ee1b15f6fc13 100644
> > --- a/fs/locks.c
> > +++ b/fs/locks.c
> > @@ -1628,7 +1628,7 @@ generic_add_lease(struct file *filp, long arg=
, struct file_lock **flp, void **pr
> > =C2=A0{
> > =C2=A0	struct file_lock *fl, *my_fl =3D NULL, *lease;
> > =C2=A0	struct dentry *dentry =3D filp->f_path.dentry;
> > -	struct inode *inode =3D dentry->d_inode;
> > +	struct inode *inode =3D file_inode(filp);
> > =C2=A0	struct file_lock_context *ctx;
> > =C2=A0	bool is_deleg =3D (*flp)->fl_flags & FL_DELEG;
> > =C2=A0	int error;
>=20
> Looks good. Al or Bruce, if either of you have remaining patches this
> cycle then could one of you take this one? Otherwise, I can queue up =
a
> branch with it.
>=20
> Reviewed-by: Jeff Layton <jlayton@redhat.com>

I'll take it and pass it along in a pull request later today, unless
somebody tells me otherwise.

--b.
