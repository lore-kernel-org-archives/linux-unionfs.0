Return-Path: <SRS0=U/uC=5S=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F0C7C43331
	for <linux-unionfs@archiver.kernel.org>; Thu,  2 Apr 2020 08:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6E162080C
	for <linux-unionfs@archiver.kernel.org>; Thu,  2 Apr 2020 08:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="fCH7TMRf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729477AbgDBI6z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 2 Apr 2020 04:58:55 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21155 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387780AbgDBI6z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Apr 2020 04:58:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1585817906;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=Cd5S6RPuRdYH8zdIb945S9g1qSXw6C0BPwTUvYhPQQA=;
        b=fCH7TMRfd/BmC2Qx+ewQYHXFaL6VTd6M0unOo7W0O57bRicaYU9HcAZqCwu0Looh
        9hTHbA10mu/M7ClzwZuKYnDj2CWS4otMNmaWVARtKrepAY7H8h5h3IVoZYyNGKrsDOf
        uBh+TE8KJOYl2+/D/gds2VGi8RSM9iWBll5GZku4=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1585817903613778.1853625546202; Thu, 2 Apr 2020 16:58:23 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200402085808.17695-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: sharing inode with different whiteout files
Date:   Thu,  2 Apr 2020 16:58:08 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Sharing inode with different whiteout files for saving
inode and speeding up delete opration.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---

Hi Miklos, Amir

This is another inode sharing approach for whiteout files compare
to Tao's previous patch. I didn't receive feedback from Tao for
further update and this new approach seems more simple and reliable.
Could you have a look at this patch?=20


 fs/overlayfs/dir.c       | 53 ++++++++++++++++++++++++++++++++++------
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/readdir.c   |  3 ++-
 fs/overlayfs/super.c     |  3 +++
 fs/overlayfs/util.c      |  3 ++-
 6 files changed, 56 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 279009dee366..d5c2e1ada624 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -61,36 +61,74 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
 =09return temp;
 }
=20
+const unsigned int ovl_whiteout_link_max =3D 60000;
+
+static bool ovl_whiteout_linkable(struct dentry *dentry)
+{
+=09unsigned int max;
+
+=09max =3D min_not_zero(dentry->d_sb->s_max_links, ovl_whiteout_link_max);
+=09if (dentry->d_inode->i_nlink >=3D max)
+=09=09return false;
+=09return true;
+}
+
 /* caller holds i_mutex on workdir */
-static struct dentry *ovl_whiteout(struct dentry *workdir)
+static struct dentry *ovl_whiteout(struct dentry *workdir, struct ovl_fs *=
ofs)
 {
 =09int err;
+=09bool again =3D true;
 =09struct dentry *whiteout;
 =09struct inode *wdir =3D workdir->d_inode;
=20
+retry:
 =09whiteout =3D ovl_lookup_temp(workdir);
 =09if (IS_ERR(whiteout))
 =09=09return whiteout;
=20
+
+=09if (ofs->whiteout) {
+=09=09if (ovl_whiteout_linkable(ofs->whiteout)) {
+=09=09=09err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
+=09=09=09if (!err)
+=09=09=09=09return whiteout;
+
+=09=09=09if (!again)
+=09=09=09=09goto out;
+=09=09}
+
+=09=09err =3D ovl_do_unlink(ofs->workdir->d_inode, ofs->whiteout);
+=09=09ofs->whiteout =3D NULL;
+=09=09if (err)
+=09=09=09goto out;
+=09}
+
 =09err =3D ovl_do_whiteout(wdir, whiteout);
-=09if (err) {
-=09=09dput(whiteout);
-=09=09whiteout =3D ERR_PTR(err);
+=09if (!err) {
+=09=09ofs->whiteout =3D whiteout;
+=09=09if (again) {
+=09=09=09again =3D false;
+=09=09=09goto retry;
+=09=09}
+=09=09return ERR_PTR(-EIO);
 =09}
=20
+out:
+=09dput(whiteout);
+=09whiteout =3D ERR_PTR(err);
 =09return whiteout;
 }
=20
 /* Caller must hold i_mutex on both workdir and dir */
 int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
-=09=09=09     struct dentry *dentry)
+=09=09=09     struct dentry *dentry, struct ovl_fs *ofs)
 {
 =09struct inode *wdir =3D workdir->d_inode;
 =09struct dentry *whiteout;
 =09int err;
 =09int flags =3D 0;
=20
-=09whiteout =3D ovl_whiteout(workdir);
+=09whiteout =3D ovl_whiteout(workdir, ofs);
 =09err =3D PTR_ERR(whiteout);
 =09if (IS_ERR(whiteout))
 =09=09return err;
@@ -715,6 +753,7 @@ static bool ovl_matches_upper(struct dentry *dentry, st=
ruct dentry *upper)
 static int ovl_remove_and_whiteout(struct dentry *dentry,
 =09=09=09=09   struct list_head *list)
 {
+=09struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
 =09struct dentry *workdir =3D ovl_workdir(dentry);
 =09struct dentry *upperdir =3D ovl_dentry_upper(dentry->d_parent);
 =09struct dentry *upper;
@@ -748,7 +787,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentr=
y,
 =09=09goto out_dput_upper;
 =09}
=20
-=09err =3D ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), upper);
+=09err =3D ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), upper, ofs=
);
 =09if (err)
 =09=09goto out_d_drop;
=20
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e6f3670146ed..6212feef36c5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -456,7 +456,7 @@ static inline void ovl_copyflags(struct inode *from, st=
ruct inode *to)
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
 int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
-=09=09=09     struct dentry *dentry);
+=09=09=09     struct dentry *dentry, struct ovl_fs *ofs);
 struct ovl_cattr {
 =09dev_t rdev;
 =09umode_t mode;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 5762d802fe01..408aa6c7a3bd 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -77,6 +77,8 @@ struct ovl_fs {
 =09int xino_mode;
 =09/* For allocation of non-persistent inode numbers */
 =09atomic_long_t last_ino;
+=09/* Whiteout dentry cache */
+=09struct dentry *whiteout;
 };
=20
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index e452ff7d583d..0c8c7ff4fc9e 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1146,7 +1146,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 =09=09=09 * Whiteout orphan index to block future open by
 =09=09=09 * handle after overlay nlink dropped to zero.
 =09=09=09 */
-=09=09=09err =3D ovl_cleanup_and_whiteout(indexdir, dir, index);
+=09=09=09err =3D ovl_cleanup_and_whiteout(indexdir, dir, index,
+=09=09=09=09=09=09       ofs);
 =09=09} else {
 =09=09=09/* Cleanup orphan index entries */
 =09=09=09err =3D ovl_cleanup(dir, index);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 732ad5495c92..fae9729ff018 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -240,6 +240,9 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 =09kfree(ofs->config.redirect_mode);
 =09if (ofs->creator_cred)
 =09=09put_cred(ofs->creator_cred);
+=09if (ofs->whiteout)
+=09=09ovl_do_unlink(ofs->workdir->d_inode,
+=09=09=09   ofs->whiteout);
 =09kfree(ofs);
 }
=20
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 36b60788ee47..d05c4028f179 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -669,6 +669,7 @@ bool ovl_need_index(struct dentry *dentry)
 /* Caller must hold OVL_I(inode)->lock */
 static void ovl_cleanup_index(struct dentry *dentry)
 {
+=09struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
 =09struct dentry *indexdir =3D ovl_indexdir(dentry->d_sb);
 =09struct inode *dir =3D indexdir->d_inode;
 =09struct dentry *lowerdentry =3D ovl_dentry_lower(dentry);
@@ -707,7 +708,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 =09=09index =3D NULL;
 =09} else if (ovl_index_all(dentry->d_sb)) {
 =09=09/* Whiteout orphan index to block future open by handle */
-=09=09err =3D ovl_cleanup_and_whiteout(indexdir, dir, index);
+=09=09err =3D ovl_cleanup_and_whiteout(indexdir, dir, index, ofs);
 =09} else {
 =09=09/* Cleanup orphan index entries */
 =09=09err =3D ovl_cleanup(dir, index);
--=20
2.20.1


