Return-Path: <cgxu519@mykernel.net>
Date: Tue, 15 Oct 2019 18:26:36 +0800
From: Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
Message-ID: <16dcef48c44.e916644e10200.8337178254202425670@mykernel.net>
In-Reply-To: <20191004132030.28353-1-cgxu519@mykernel.net>
References: <20191004132030.28353-1-cgxu519@mykernel.net>
Subject: =?UTF-8?Q?=E5=9B=9E=E5=A4=8D:[PATCH]_ovl:_improving_copy?=
 =?UTF-8?Q?-up_efficiency_for_sparse_file?=
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: miklos <miklos@szeredi.hu>, linux-unionfs <linux-unionfs@vger.kernel.org>
Cc: Chengguang Xu <cgxu519@mykernel.net>
List-ID: <linux-unionfs@vger.kernel.org>

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2019-10-04 21:20:30 Chengguang=
 Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
 > Current copy-up is not efficient for sparse file,
 > It's not only slow but also wasting more disk space
 > when the target lower file has huge hole inside.
 > This patch tries to recognize file hole and skip it
 > during copy-up.
 >=20
 > In detail, this optimization checks the hole according
 > to copy-up chunk size so it may not recognize all kind
 > of holes in the file. However, it is easy to implement
 > and will be enough for most of the time.
 >=20
 > Additionally, this optimization relies on lseek(2)
 > SEEK_DATA implementation, so for some specific
 > filesystems which do not support this feature
 > will behave as before on copy-up.
 >=20
 > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > ---

Any better idea or suggestion for this?


Thanks,
Chengguang


 >  fs/overlayfs/copy_up.c | 15 ++++++++++++++-
 >  1 file changed, 14 insertions(+), 1 deletion(-)
 >=20
 > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
 > index b801c6353100..028033c9f021 100644
 > --- a/fs/overlayfs/copy_up.c
 > +++ b/fs/overlayfs/copy_up.c
 > @@ -144,10 +144,11 @@ static int ovl_copy_up_data(struct path *old, stru=
ct path *new, loff_t len)
 >          goto out;
 >      /* Couldn't clone, so now we try to copy the data */
 > =20
 > -    /* FIXME: copy up sparse files efficiently */
 >      while (len) {
 >          size_t this_len =3D OVL_COPY_UP_CHUNK_SIZE;
 >          long bytes;
 > +        loff_t old_next_data_pos;
 > +        loff_t hole_len;
 > =20
 >          if (len < this_len)
 >              this_len =3D len;
 > @@ -157,6 +158,18 @@ static int ovl_copy_up_data(struct path *old, struc=
t path *new, loff_t len)
 >              break;
 >          }
 > =20
 > +        old_next_data_pos =3D vfs_llseek(old_file, old_pos, SEEK_DATA);
 > +        if (old_next_data_pos >=3D old_pos + OVL_COPY_UP_CHUNK_SIZE) {
 > +            hole_len =3D (old_next_data_pos - old_pos) /
 > +                OVL_COPY_UP_CHUNK_SIZE * OVL_COPY_UP_CHUNK_SIZE;
 > +            old_pos +=3D hole_len;
 > +            new_pos +=3D hole_len;
 > +            len -=3D hole_len;
 > +            continue;
 > +        } else if (old_next_data_pos =3D=3D -ENXIO) {
 > +            break;
 > +        }
 > +
 >          bytes =3D do_splice_direct(old_file, &old_pos,
 >                       new_file, &new_pos,
 >                       this_len, SPLICE_F_MOVE);
 > --=20
 > 2.21.0
 >=20
 >=20
 >
