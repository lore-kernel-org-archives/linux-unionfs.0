Return-Path: <cgxu519@mykernel.net>
Date: Thu, 31 Oct 2019 13:33:26 +0800
From: Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
Message-ID: <16e204de70e.cefd69461771.2205150443916624303@mykernel.net>
In-Reply-To: <CAOQ4uxh670WFhwpQyPFTB2nUCSc9n1VmuyPOfdqiBSsq6GxLpQ@mail.gmail.com>
References: <20191030124431.11242-1-cgxu519@mykernel.net> <CAOQ4uxh670WFhwpQyPFTB2nUCSc9n1VmuyPOfdqiBSsq6GxLpQ@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: improving copy-up efficiency for big sparse
 file
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2019-10-30 23:50:13 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Wed, Oct 30, 2019 at 2:45 PM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > Current copy-up is not efficient for big sparse file,
 > > It's not only slow but also wasting more disk space
 > > when the target lower file has huge hole inside.
 > > This patch tries to recognize file hole and skip it
 > > during copy-up.
 > >
 > > In detail, this optimization checks the hole according
 > > to copy-up chunk size so it may not recognize all kind
 > > of holes in the file. However, it is easy to implement
 > > and will be enough for most of the use case.
 > >
 > > Additionally, this optimization relies on lseek(2)
 > > SEEK_DATA implementation, so for some specific
 > > filesystems which do not support this feature
 > > will behave as before on copy-up.
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > ---
 > >
 > > Hi Miklos, Amir
 > >
 > > This is v2 version of hole copy-up improvement which
 > > addressed amir's concerns in previous email.
 > >
 > > Could you have a look at this patch?
 > >
 > > There is a checkpatch warning but that is
 > > false-positive warning, so you can ignore it.
 > >
 > > I've tested the patch with the cases under overlay dir
 > > (include overlay/066) in fstest for xfs/ext4 fstype,
 > > and passed most of the cases except below.
 > >
 > > overlay/045     [not run] fsck.overlay utility required, skipped this =
test
 > > overlay/046     [not run] fsck.overlay utility required, skipped this =
test
 > > overlay/056     [not run] fsck.overlay utility required, skipped this =
test
 >=20
 > Those are not failures.
 > You need to install fsck.overlay from
 > https://github.com/hisilicon/overlayfs-progs
 > for these tests to run.

I'll do.

 >=20
 > >
 > > Above three cases are fsck related cases,
 > > I think they are not important for copy-up.
 > >
 > > overlay/061     - output mismatch (see /home/cgxu/git/xfstests-dev/res=
ults//overlay/061.out.bad)
 > >     --- tests/overlay/061.out   2019-05-28 09:54:42.320874925 +0800
 > >     +++ /home/cgxu/git/xfstests-dev/results//overlay/061.out.bad      =
  2019-10-30 16:11:50.490848367 +0800
 > >     @@ -1,4 +1,4 @@
 > >      QA output created by 061
 > >     -00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaa=
aaaaaaaaaaa
 > >     +00000000:  54 68 69 73 20 69 73 20 6f 6c 64 20 6e 65 77 73  This.=
is.old.news
 > >      After mount cycle:
 > >      00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaa=
aaaaaaaaaaa
 > >     ...
 > >     (Run 'diff -u /home/cgxu/git/xfstests-dev/tests/overlay/061.out /h=
ome/cgxu/git/xfstests-dev/results//overlay/061.out.bad'  to see the entire =
diff)
 > >
 > > overlay/061 was failed with/without my patch and test results
 > > were just same. have something already broken for the test?
 >=20
 > Yes, overlayfs does not comply with this "posix"' test.
 > This is why it was removed from the auto and quick groups.

So I'm curious what is the purpose for the test?

 >=20
 > >
 > >
 > > v1->v2:
 > > - Set file size when the hole is in the end of the file.
 > > - Add a code comment for hole copy-up improvement.
 > > - Check SEEK_DATA support before doing hole skip.
 > > - Back to original copy-up when seek data fails(in error case).
 > >
 > >  fs/overlayfs/copy_up.c | 78 ++++++++++++++++++++++++++++++++++-------=
-
 > >  1 file changed, 64 insertions(+), 14 deletions(-)
 > >
 > > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
 > > index b801c6353100..7d8a34c480f4 100644
 > > --- a/fs/overlayfs/copy_up.c
 > > +++ b/fs/overlayfs/copy_up.c
 > > @@ -116,13 +116,30 @@ int ovl_copy_xattr(struct dentry *old, struct de=
ntry *new)
 > >         return error;
 > >  }
 > >
 > > -static int ovl_copy_up_data(struct path *old, struct path *new, loff_=
t len)
 > > +static int ovl_set_size(struct dentry *upperdentry, struct kstat *sta=
t)
 > > +{
 > > +       struct iattr attr =3D {
 > > +               .ia_valid =3D ATTR_SIZE,
 > > +               .ia_size =3D stat->size,
 > > +       };
 > > +
 > > +       return notify_change(upperdentry, &attr, NULL);
 > > +}
 > > +
 > > +static int ovl_copy_up_data(struct path *old, struct path *new,
 > > +                           struct kstat *stat)
 > >  {
 > >         struct file *old_file;
 > >         struct file *new_file;
 > > +       loff_t len =3D stat->size;
 > >         loff_t old_pos =3D 0;
 > >         loff_t new_pos =3D 0;
 > >         loff_t cloned;
 > > +       loff_t old_next_data_pos;
 > > +       loff_t hole_len;
 > > +       bool seek_support =3D false;
 > > +       bool skip_hole =3D true;
 > > +       bool set_size =3D false;
 > >         int error =3D 0;
 > >
 > >         if (len =3D=3D 0)
 > > @@ -144,7 +161,12 @@ static int ovl_copy_up_data(struct path *old, str=
uct path *new, loff_t len)
 > >                 goto out;
 > >         /* Couldn't clone, so now we try to copy the data */
 > >
 > > -       /* FIXME: copy up sparse files efficiently */
 > > +       /* Check if lower fs supports seek operation */
 > > +       if (old_file->f_mode & FMODE_LSEEK &&
 > > +           old_file->f_op->llseek) {
 > > +               seek_support =3D true;
 > > +       }
 > > +
 > >         while (len) {
 > >                 size_t this_len =3D OVL_COPY_UP_CHUNK_SIZE;
 > >                 long bytes;
 > > @@ -157,6 +179,38 @@ static int ovl_copy_up_data(struct path *old, str=
uct path *new, loff_t len)
 > >                         break;
 > >                 }
 > >
 > > +               /*
 > > +                * Fill zero for hole will cost unnecessary disk space
 > > +                * and meanwhile slow down the copy-up speed, so we do
 > > +                * an optimization for hole during copy-up, it relies
 > > +                * on SEEK_DATA implementation and the hole check is
 > > +                * aligned to OVL_COPY_UP_CHUNK_SIZE. In other word,
 > > +                * we do not try to recognize all kind of holes here,
 > > +                * we just skip big enough hole for simplicity to
 > > +                * implement. If lower fs does not support SEEK_DATA
 > > +                * operation, the copy-up will behave as before.
 > > +                */
 > > +
 > > +               if (seek_support && skip_hole) {
 > > +                       old_next_data_pos =3D vfs_llseek(old_file,
 > > +                                               old_pos, SEEK_DATA);
 > > +                       if (old_next_data_pos >=3D old_pos +
 > > +                                               OVL_COPY_UP_CHUNK_SIZE=
) {
 > > +                               hole_len =3D (old_next_data_pos - old_=
pos) /
 > > +                                               OVL_COPY_UP_CHUNK_SIZE=
 *
 > > +                                               OVL_COPY_UP_CHUNK_SIZE=
;
 >=20
 > Use round_down() helper

I'll change the logic of hole detection a bit, so that it could work
more effectively for big continuous hole.


 >=20
 > > +                               old_pos +=3D hole_len;
 > > +                               new_pos +=3D hole_len;
 > > +                               len -=3D hole_len;
 > > +                               continue;
 > > +                       } else if (old_next_data_pos =3D=3D -ENXIO) {
 > > +                               set_size =3D true;
 > > +                               break;
 > > +                       } else if (old_next_data_pos < 0) {
 > > +                               skip_hole =3D false;
 >=20
 > Why do you need to use 2 booleans?
 > You can initialize skip_hole =3D true only in case of lower
 > has seek support.
 >=20
 > >
 > > +                       }
 > > +               }
 > > +
 > >                 bytes =3D do_splice_direct(old_file, &old_pos,
 > >                                          new_file, &new_pos,
 > >                                          this_len, SPLICE_F_MOVE);
 > > @@ -168,6 +222,12 @@ static int ovl_copy_up_data(struct path *old, str=
uct path *new, loff_t len)
 > >
 > >                 len -=3D bytes;
 > >         }
 > > +
 > > +       if (!error && set_size) {
 > > +               inode_lock(new->dentry->d_inode);
 > > +               error =3D ovl_set_size(new->dentry, stat);
 > > +               inode_unlock(new->dentry->d_inode);
 > > +       }
 >=20
 > I see no reason to repeat this code here.
 > Two options:
 > 1. always set_size at the end of ovl_copy_up_inode()
 >     what's the harm in that?

I think at least it's not suitable for directory.


 > 2. set boolean c->set_size here and check it at the end
 >     of ovl_copy_up_inode() instead of checking c->metacopy
 >=20

I don't understand why 'c->set_size' can replace 'c->metacopy',

Thanks,
Chengguang.
