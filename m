From: Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] locks: use file_inode()
Date: Fri, 01 Jul 2016 09:05:10 -0400
Message-ID: <1467378310.7477.3.camel@redhat.com>
References: <1467377767-12845-1-git-send-email-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1467377767-12845-1-git-send-email-mszeredi@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, stable@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, 2016-07-01 at 14:56 +0200, Miklos Szeredi wrote:
> (Another one for the f_path debacle.)
>=20
> ltp fcntl33 testcase caused an Oops in selinux_file_send_sigiotask.
>=20
> The reason is that generic_add_lease() used filp->f_path.dentry->inod=
e
> while all the others use file_inode().=C2=A0=C2=A0This makes a differ=
ence for files
> opened on overlayfs since the former will point to the overlay inode =
the
> latter to the underlying inode.
>=20
> So generic_add_lease() added the lease to the overlay inode and
> generic_delete_lease() removed it from the underlying inode.=C2=A0=C2=
=A0When the file
> was released the lease remained on the overlay inode's lock list, res=
ulting
> in use after free.
>=20
> Reported-by: Eryu Guan <eguan@redhat.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> Fixes: 4bacc9c9234c ("overlayfs: Make f_path always point to the over=
lay and f_inode to the underlay")
> Cc: <stable@vger.kernel.org>
> Cc: Jeff Layton <jlayton@poochiereds.net>
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> ---
> =C2=A0fs/locks.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/locks.c b/fs/locks.c
> index 7c5f91be9b65..ee1b15f6fc13 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1628,7 +1628,7 @@ generic_add_lease(struct file *filp, long arg, =
struct file_lock **flp, void **pr
> =C2=A0{
> =C2=A0	struct file_lock *fl, *my_fl =3D NULL, *lease;
> =C2=A0	struct dentry *dentry =3D filp->f_path.dentry;
> -	struct inode *inode =3D dentry->d_inode;
> +	struct inode *inode =3D file_inode(filp);
> =C2=A0	struct file_lock_context *ctx;
> =C2=A0	bool is_deleg =3D (*flp)->fl_flags & FL_DELEG;
> =C2=A0	int error;

Looks good. Al or Bruce, if either of you have remaining patches this
cycle then could one of you take this one? Otherwise, I can queue up a
branch with it.

Reviewed-by: Jeff Layton <jlayton@redhat.com>
