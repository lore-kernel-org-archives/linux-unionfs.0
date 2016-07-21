From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: [RFC PATCH v2 0/3] fix overlayfs locks and leases
Date: Thu, 21 Jul 2016 16:19:33 -0400
Message-ID: <1469132373.2189.5.camel@poochiereds.net>
References: <1469109216-24353-1-git-send-email-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1469109216-24353-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>, "J. Bruce Fields" <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Thu, 2016-07-21 at 15:53 +0200, Miklos Szeredi wrote:
> I've split out the writecount handling and changed it around so that
> underlying layers are consistent and yet leases work correctly on
> overlayfs.
>=20
> Also pushed to the tip of
>=20
> =C2=A0 git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git=
 overlayfs-next
>=20
> Thanks,
> Miklos
> ---
>=20
> Miklos Szeredi (3):
> =C2=A0 locks: fix file locking on overlayfs
> =C2=A0 vfs: make argument of d_real_inode() const
> =C2=A0 vfs: do get_write_access() on upper layer of overlayfs
>=20
> =C2=A0fs/locks.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 53 ++++++++++++++++++++++++++++--------=
-------------
> =C2=A0fs/namespace.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0|=C2=A0=C2=A02 +-
> =C2=A0fs/open.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 17 +++++++++++++---
> =C2=A0fs/overlayfs/super.c=C2=A0=C2=A0=C2=A0=C2=A0|=C2=A0=C2=A02 +-
> =C2=A0include/linux/dcache.h=C2=A0=C2=A0|=C2=A0=C2=A05 +++--
> =C2=A0include/linux/fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0| 16 ++++=
+++++++++--
> =C2=A0include/uapi/linux/fs.h |=C2=A0=C2=A01 +
> =C2=A07 files changed, 64 insertions(+), 32 deletions(-)
>=20

Looks pretty sane overall.

Also, when I mentioned accessing the writable layer in openwrt in the
last set, I forgot that you typically only do reads on it, so the
writecount wouldn't be affected in the case of accessing to do backups.
So, I'm not sure I had a legit objection to the earlier patch, but I
think this looks a little cleaner anyway:

Acked-by: Jeff Layton <jlayton@poochiereds.net>
