Return-Path: <cgxu519@mykernel.net>
From: Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20191030124431.11242-1-cgxu519@mykernel.net>
Subject: [PATCH v2] ovl: improving copy-up efficiency for big sparse file
Date: Wed, 30 Oct 2019 20:44:31 +0800
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf8
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
List-ID: <linux-unionfs@vger.kernel.org>

Current copy-up is not efficient for big sparse file,
It's not only slow but also wasting more disk space
when the target lower file has huge hole inside.
This patch tries to recognize file hole and skip it
during copy-up.

In detail, this optimization checks the hole according
to copy-up chunk size so it may not recognize all kind
of holes in the file. However, it is easy to implement
and will be enough for most of the use case.

Additionally, this optimization relies on lseek(2)
SEEK_DATA implementation, so for some specific
filesystems which do not support this feature
will behave as before on copy-up.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---

Hi Miklos, Amir

This is v2 version of hole copy-up improvement which
addressed amir's concerns in previous email.

Could you have a look at this patch?

There is a checkpatch warning but that is
false-positive warning, so you can ignore it.

I've tested the patch with the cases under overlay dir
(include overlay/066) in fstest for xfs/ext4 fstype,=20
and passed most of the cases except below.

overlay/045     [not run] fsck.overlay utility required, skipped this test
overlay/046     [not run] fsck.overlay utility required, skipped this test
overlay/056     [not run] fsck.overlay utility required, skipped this test

Above three cases are fsck related cases,
I think they are not important for copy-up.

overlay/061     - output mismatch (see /home/cgxu/git/xfstests-dev/results/=
/overlay/061.out.bad)
    --- tests/overlay/061.out   2019-05-28 09:54:42.320874925 +0800
    +++ /home/cgxu/git/xfstests-dev/results//overlay/061.out.bad        201=
9-10-30 16:11:50.490848367 +0800
    @@ -1,4 +1,4 @@
     QA output created by 061
    -00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaa=
aaaaaa
    +00000000:  54 68 69 73 20 69 73 20 6f 6c 64 20 6e 65 77 73  This.is.ol=
d.news
     After mount cycle:
     00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaa=
aaaaaa
    ...
    (Run 'diff -u /home/cgxu/git/xfstests-dev/tests/overlay/061.out /home/c=
gxu/git/xfstests-dev/results//overlay/061.out.bad'  to see the entire diff)

overlay/061 was failed with/without my patch and test results
were just same. have something already broken for the test?


v1->v2:
- Set file size when the hole is in the end of the file.
- Add a code comment for hole copy-up improvement.
- Check SEEK_DATA support before doing hole skip.
- Back to original copy-up when seek data fails(in error case).

 fs/overlayfs/copy_up.c | 78 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 64 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index b801c6353100..7d8a34c480f4 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -116,13 +116,30 @@ int ovl_copy_xattr(struct dentry *old, struct dentry =
*new)
 =09return error;
 }
=20
-static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len=
)
+static int ovl_set_size(struct dentry *upperdentry, struct kstat *stat)
+{
+=09struct iattr attr =3D {
+=09=09.ia_valid =3D ATTR_SIZE,
+=09=09.ia_size =3D stat->size,
+=09};
+
+=09return notify_change(upperdentry, &attr, NULL);
+}
+
+static int ovl_copy_up_data(struct path *old, struct path *new,
+=09=09=09    struct kstat *stat)
 {
 =09struct file *old_file;
 =09struct file *new_file;
+=09loff_t len =3D stat->size;
 =09loff_t old_pos =3D 0;
 =09loff_t new_pos =3D 0;
 =09loff_t cloned;
+=09loff_t old_next_data_pos;
+=09loff_t hole_len;
+=09bool seek_support =3D false;
+=09bool skip_hole =3D true;
+=09bool set_size =3D false;
 =09int error =3D 0;
=20
 =09if (len =3D=3D 0)
@@ -144,7 +161,12 @@ static int ovl_copy_up_data(struct path *old, struct p=
ath *new, loff_t len)
 =09=09goto out;
 =09/* Couldn't clone, so now we try to copy the data */
=20
-=09/* FIXME: copy up sparse files efficiently */
+=09/* Check if lower fs supports seek operation */
+=09if (old_file->f_mode & FMODE_LSEEK &&
+=09    old_file->f_op->llseek) {
+=09=09seek_support =3D true;
+=09}
+
 =09while (len) {
 =09=09size_t this_len =3D OVL_COPY_UP_CHUNK_SIZE;
 =09=09long bytes;
@@ -157,6 +179,38 @@ static int ovl_copy_up_data(struct path *old, struct p=
ath *new, loff_t len)
 =09=09=09break;
 =09=09}
=20
+=09=09/*
+=09=09 * Fill zero for hole will cost unnecessary disk space
+=09=09 * and meanwhile slow down the copy-up speed, so we do
+=09=09 * an optimization for hole during copy-up, it relies
+=09=09 * on SEEK_DATA implementation and the hole check is
+=09=09 * aligned to OVL_COPY_UP_CHUNK_SIZE. In other word,
+=09=09 * we do not try to recognize all kind of holes here,
+=09=09 * we just skip big enough hole for simplicity to
+=09=09 * implement. If lower fs does not support SEEK_DATA
+=09=09 * operation, the copy-up will behave as before.
+=09=09 */
+
+=09=09if (seek_support && skip_hole) {
+=09=09=09old_next_data_pos =3D vfs_llseek(old_file,
+=09=09=09=09=09=09old_pos, SEEK_DATA);
+=09=09=09if (old_next_data_pos >=3D old_pos +
+=09=09=09=09=09=09OVL_COPY_UP_CHUNK_SIZE) {
+=09=09=09=09hole_len =3D (old_next_data_pos - old_pos) /
+=09=09=09=09=09=09OVL_COPY_UP_CHUNK_SIZE *
+=09=09=09=09=09=09OVL_COPY_UP_CHUNK_SIZE;
+=09=09=09=09old_pos +=3D hole_len;
+=09=09=09=09new_pos +=3D hole_len;
+=09=09=09=09len -=3D hole_len;
+=09=09=09=09continue;
+=09=09=09} else if (old_next_data_pos =3D=3D -ENXIO) {
+=09=09=09=09set_size =3D true;
+=09=09=09=09break;
+=09=09=09} else if (old_next_data_pos < 0) {
+=09=09=09=09skip_hole =3D false;
+=09=09=09}
+=09=09}
+
 =09=09bytes =3D do_splice_direct(old_file, &old_pos,
 =09=09=09=09=09 new_file, &new_pos,
 =09=09=09=09=09 this_len, SPLICE_F_MOVE);
@@ -168,6 +222,12 @@ static int ovl_copy_up_data(struct path *old, struct p=
ath *new, loff_t len)
=20
 =09=09len -=3D bytes;
 =09}
+
+=09if (!error && set_size) {
+=09=09inode_lock(new->dentry->d_inode);
+=09=09error =3D ovl_set_size(new->dentry, stat);
+=09=09inode_unlock(new->dentry->d_inode);
+=09}
 out:
 =09if (!error)
 =09=09error =3D vfs_fsync(new_file, 0);
@@ -177,16 +237,6 @@ static int ovl_copy_up_data(struct path *old, struct p=
ath *new, loff_t len)
 =09return error;
 }
=20
-static int ovl_set_size(struct dentry *upperdentry, struct kstat *stat)
-{
-=09struct iattr attr =3D {
-=09=09.ia_valid =3D ATTR_SIZE,
-=09=09.ia_size =3D stat->size,
-=09};
-
-=09return notify_change(upperdentry, &attr, NULL);
-}
-
 static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *st=
at)
 {
 =09struct iattr attr =3D {
@@ -453,7 +503,7 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c,=
 struct dentry *temp)
 =09=09upperpath.dentry =3D temp;
=20
 =09=09ovl_path_lowerdata(c->dentry, &datapath);
-=09=09err =3D ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
+=09=09err =3D ovl_copy_up_data(&datapath, &upperpath, &c->stat);
 =09=09if (err)
 =09=09=09return err;
 =09}
@@ -757,7 +807,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_=
up_ctx *c)
 =09=09=09goto out;
 =09}
=20
-=09err =3D ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
+=09err =3D ovl_copy_up_data(&datapath, &upperpath, &c->stat);
 =09if (err)
 =09=09goto out_free;
=20
--=20
2.20.1
