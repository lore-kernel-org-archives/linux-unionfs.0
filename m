Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191004132030.28353-1-cgxu519@mykernel.net> <16dcef48c44.e916644e10200.8337178254202425670@mykernel.net>
In-Reply-To: <16dcef48c44.e916644e10200.8337178254202425670@mykernel.net>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 15 Oct 2019 17:26:35 +0300
Message-ID: <CAOQ4uxjBNTY4d6VPDRSHy3didY502dVCDnvRfBy_fkRND2UVvw@mail.gmail.com>
Subject: Re: [PATCH] ovl: improving copy-up efficiency for sparse file
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: cgxu519@mykernel.net
Cc: miklos <miklos@szeredi.hu>, linux-unionfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Oct 15, 2019 at 2:38 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2019-10-04 21:20:30 Chenggua=
ng Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
>  > Current copy-up is not efficient for sparse file,
>  > It's not only slow but also wasting more disk space
>  > when the target lower file has huge hole inside.
>  > This patch tries to recognize file hole and skip it
>  > during copy-up.
>  >
>  > In detail, this optimization checks the hole according
>  > to copy-up chunk size so it may not recognize all kind
>  > of holes in the file. However, it is easy to implement
>  > and will be enough for most of the time.

I must say I do not see how aligning to copy-up chunk size
simplifies the change. Why is that more complicated?

if (old_next_data_pos >=3D old_pos) {
      hole_len =3D old_next_data_pos - old_pos;
...

It can still copy hole up to this_len, because there is no
SEEK_HOLE, so you can document that.

>  >
>  > Additionally, this optimization relies on lseek(2)
>  > SEEK_DATA implementation, so for some specific
>  > filesystems which do not support this feature
>  > will behave as before on copy-up.
>  >

I am not sure if we support any lower fs with no f_op->llseek
in that case, copy up will not behave as before - it will return
-ESPIPE and will be a regression.

>  > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
>  > ---
>
> Any better idea or suggestion for this?

This change should be accompanied with proper xfstests examining
all sorts of sparse files.
See overlay/001 and _run_seek_sanity_test for inspiration.

Perhaps you can run all _run_seek_sanity_test tests on
lower fs, then mount overlay. copy up all the sanity test
files and then check something???

Thanks,
Amir.


>
>
>  >  fs/overlayfs/copy_up.c | 15 ++++++++++++++-
>  >  1 file changed, 14 insertions(+), 1 deletion(-)
>  >
>  > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
>  > index b801c6353100..028033c9f021 100644
>  > --- a/fs/overlayfs/copy_up.c
>  > +++ b/fs/overlayfs/copy_up.c
>  > @@ -144,10 +144,11 @@ static int ovl_copy_up_data(struct path *old, st=
ruct path *new, loff_t len)
>  >          goto out;
>  >      /* Couldn't clone, so now we try to copy the data */
>  >
>  > -    /* FIXME: copy up sparse files efficiently */
>  >      while (len) {
>  >          size_t this_len =3D OVL_COPY_UP_CHUNK_SIZE;
>  >          long bytes;
>  > +        loff_t old_next_data_pos;
>  > +        loff_t hole_len;
>  >
>  >          if (len < this_len)
>  >              this_len =3D len;
>  > @@ -157,6 +158,18 @@ static int ovl_copy_up_data(struct path *old, str=
uct path *new, loff_t len)
>  >              break;
>  >          }
>  >
>  > +        old_next_data_pos =3D vfs_llseek(old_file, old_pos, SEEK_DATA=
);
>  > +        if (old_next_data_pos >=3D old_pos + OVL_COPY_UP_CHUNK_SIZE) =
{
>  > +            hole_len =3D (old_next_data_pos - old_pos) /
>  > +                OVL_COPY_UP_CHUNK_SIZE * OVL_COPY_UP_CHUNK_SIZE;
>  > +            old_pos +=3D hole_len;
>  > +            new_pos +=3D hole_len;
>  > +            len -=3D hole_len;
>  > +            continue;
>  > +        } else if (old_next_data_pos =3D=3D -ENXIO) {
>  > +            break;
>  > +        }
>  > +
>  >          bytes =3D do_splice_direct(old_file, &old_pos,
>  >                       new_file, &new_pos,
>  >                       this_len, SPLICE_F_MOVE);
>  > --
