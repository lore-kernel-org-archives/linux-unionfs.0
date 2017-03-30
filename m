From: Ralph Sennhauser <ralph.sennhauser@gmail.com>
Subject: Re: [REGRESSION 4.11] Commit d8514d8edb5b ("ovl: copy up regular
 file using O_TMPFILE") breaks ubifs
Date: Thu, 30 Mar 2017 09:28:31 +0200
Message-ID: <20170330092831.6c88f362@gmail.com>
References: <pt0j2tw5gavgsksyh1yovnel.1490857017978@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36746 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932651AbdC3H2g (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Mar 2017 03:28:36 -0400
In-Reply-To: <pt0j2tw5gavgsksyh1yovnel.1490857017978@email.android.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org, regressions@leemhuis.info, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, David Oberhollenzer <goliath@sigma-star.at>

Hi Richard,

On Thu, 30 Mar 2017 08:56:57 +0200
Richard Weinberger <richard@nod.at> wrote:

>    =20
> Ralph,
> Please apply this
> fix:http://lists.infradead.org/pipermail/linux-mtd/2017-March/072613.html
>=20

No longer able to observe an issue with this one on top. The two
patches seem all that was needed to get things back to a working state.

Do you want me to test anything else than linux-next?

Thanks
Ralph

>=20
> Von meinem Samsung Ger=C3=A4t gesendet.
>=20
> -------- Urspr=C3=BCngliche Nachricht --------
> Von: Ralph Sennhauser <ralph.sennhauser@gmail.com>=20
> Datum: 30.03.17  07:53  (GMT+01:00)=20
> An: Richard Weinberger <richard@nod.at>=20
> Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi
> <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-kernel
> <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
> regressions@leemhuis.info, Artem Bityutskiy <dedekind1@gmail.com>,
> Adrian Hunter <adrian.hunter@intel.com>, David Oberhollenzer
> <goliath@sigma-star.at> Betreff: Re: [REGRESSION 4.11] Commit
> d8514d8edb5b ("ovl: copy up regular=0D&nbsp; file using O_TMPFILE") break=
s ubifs=20
>=20
> Hi Richard,
>=20
> On Thu, 30 Mar 2017 00:15:31 +0200
> Richard Weinberger <richard@nod.at> wrote:
>=20
> > Ralph,
> >=20
> > Am 29.03.2017 um 23:26 schrieb Ralph Sennhauser: =20
> > >> # create and link a tmpfile - then remove it
> > >> sudo rm -rf foo; sudo xfs_io -T -c "flink foo" . ; ls -l foo;
> > >> sudo rm foo=C2=A0  =20
> > >=20
> > > next-20170328, obviously without your patch:
> > >=20
> > >=C2=A0=C2=A0 # xfs_io -T -c "flink foo" .
> > >=C2=A0=C2=A0 .: Not supported=C2=A0  =20
> >=20
> > -T tells xfs_io to create a tmpfile but you have it disabled in
> > UBIFS. =20
>=20
> Bash history says I booted the other partition than I flashed (uname
> just happened to match), the downside of the dual boot layout. :)
>=20
> =C2=A0 # rm -rf foo
> =C2=A0 # xfs_io -T -c "flink foo" .
> =C2=A0 # ls -l foo
> =C2=A0 -rw-------=C2=A0=C2=A0=C2=A0 1 root=C2=A0=C2=A0=C2=A0=C2=A0 root=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0 =
Mar 30 02:00 foo
> =C2=A0 # rm foo
> =C2=A0 [=C2=A0 305.001436] UBIFS error (ubi0:0 pid 2493): ubifs_add_orpha=
n:
> orphaned twice
>=20
> However, unlike with the overlay setup the filesystem can be mounted
> just fine without imediatly visible side effects.
>=20
> >=20
> > Anyway, can you please test the attached patch?
> > Amir was right, UBIFS misses a corner case in ubifs_link(). ;-\
> >=20
> > I think I understand also why we never noticed this in xfstests,
> > UBIFS prints only a non-fatal error while umounting the filesystem
> > in this case. But will test tomorrow in more detail, need some
> > sleep now.
> >=20
> > diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
> > index 30825d882aa9..95e348a2da29 100644
> > --- a/fs/ubifs/dir.c
> > +++ b/fs/ubifs/dir.c
> > @@ -748,6 +748,9 @@ static int ubifs_link(struct dentry *old_dentry,
> > struct inode *dir, goto out_fname;
> >=20
> >=C2=A0 	lock_2_inodes(dir, inode);
> > +	if (inode->i_nlink =3D=3D 0)
> > +		ubifs_delete_orphan(c, inode->i_ino);
> > +
> >=C2=A0 	inc_nlink(inode);
> >=C2=A0 	ihold(inode);
> >=C2=A0 	inode->i_ctime =3D ubifs_current_time(inode);
> >=20
> > Thanks,
> > //richard =20
>=20
> With this patch I'm no longer able to reproduce _this_ issue, however,
> rename no longer works either:
>=20
> =C2=A0 # mv /etc/config/wireless /etc/config/wireless.back
> =C2=A0 mv: can't rename '/etc/config/wireless': Invalid argument
> =C2=A0 # ls /etc/config/wireless
> =C2=A0 /etc/config/wireless
> =C2=A0 # rm /etc/config/wireless
> =C2=A0 # ls /etc/config/wireless
> =C2=A0 ls: /etc/config/wireless: No such file or directory
>=20
>=20
> Thanks
> Ralph
