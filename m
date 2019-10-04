Return-Path: <cgxu519@mykernel.net>
From: Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20191004132030.28353-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: improving copy-up efficiency for sparse file
Date: Fri,  4 Oct 2019 21:20:30 +0800
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf8
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
List-ID: <linux-unionfs@vger.kernel.org>

Current copy-up is not efficient for sparse file,
It's not only slow but also wasting more disk space
when the target lower file has huge hole inside.
This patch tries to recognize file hole and skip it
during copy-up.

In detail, this optimization checks the hole according
to copy-up chunk size so it may not recognize all kind
of holes in the file. However, it is easy to implement
and will be enough for most of the time.

Additionally, this optimization relies on lseek(2)
SEEK_DATA implementation, so for some specific
filesystems which do not support this feature
will behave as before on copy-up.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/copy_up.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index b801c6353100..028033c9f021 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -144,10 +144,11 @@ static int ovl_copy_up_data(struct path *old, struct =
path *new, loff_t len)
 =09=09goto out;
 =09/* Couldn't clone, so now we try to copy the data */
=20
-=09/* FIXME: copy up sparse files efficiently */
 =09while (len) {
 =09=09size_t this_len =3D OVL_COPY_UP_CHUNK_SIZE;
 =09=09long bytes;
+=09=09loff_t old_next_data_pos;
+=09=09loff_t hole_len;
=20
 =09=09if (len < this_len)
 =09=09=09this_len =3D len;
@@ -157,6 +158,18 @@ static int ovl_copy_up_data(struct path *old, struct p=
ath *new, loff_t len)
 =09=09=09break;
 =09=09}
=20
+=09=09old_next_data_pos =3D vfs_llseek(old_file, old_pos, SEEK_DATA);
+=09=09if (old_next_data_pos >=3D old_pos + OVL_COPY_UP_CHUNK_SIZE) {
+=09=09=09hole_len =3D (old_next_data_pos - old_pos) /
+=09=09=09=09OVL_COPY_UP_CHUNK_SIZE * OVL_COPY_UP_CHUNK_SIZE;
+=09=09=09old_pos +=3D hole_len;
+=09=09=09new_pos +=3D hole_len;
+=09=09=09len -=3D hole_len;
+=09=09=09continue;
+=09=09} else if (old_next_data_pos =3D=3D -ENXIO) {
+=09=09=09break;
+=09=09}
+
 =09=09bytes =3D do_splice_direct(old_file, &old_pos,
 =09=09=09=09=09 new_file, &new_pos,
 =09=09=09=09=09 this_len, SPLICE_F_MOVE);
--=20
2.21.0
