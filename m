Return-Path: <SRS0=JwOv=5T=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F7AC43331
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 06:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C846B20757
	for <linux-unionfs@archiver.kernel.org>; Fri,  3 Apr 2020 06:45:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="f5Z1dN6B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbgDCGpv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 3 Apr 2020 02:45:51 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21115 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730550AbgDCGpv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Apr 2020 02:45:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1585896305;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=NnzleCkX0exnqPSwzkUYXl2ytiO3LtrIieHREI+aSvc=;
        b=f5Z1dN6B/ehr26hgB9XecHTOTGJbP8rg4wCO3PdW5vhndNjjgFgqLce2f0HN8B4b
        wRCSOVCesB7be5rO+jjY6qxP0GFc3WIIj1YK8tJDYQJu5IoegedmgC9V7Q9uHzCEGm8
        C5HVfjKZxC0Mibe8+AV1oeFca47lMnSf/KwTKXdI=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1585896304241533.8066638403828; Fri, 3 Apr 2020 14:45:04 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org, houtao1@huawei.com,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200403064444.31062-1-cgxu519@mykernel.net>
Subject: [PATCH v2] ovl: sharing inode with different whiteout files
Date:   Fri,  3 Apr 2020 14:44:44 +0800
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
inode and speeding up delete operation.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/dir.c       | 50 ++++++++++++++++++++++++++++++++--------
 fs/overlayfs/overlayfs.h | 11 +++++++--
 fs/overlayfs/ovl_entry.h |  4 ++++
 fs/overlayfs/readdir.c   |  3 ++-
 fs/overlayfs/super.c     | 10 ++++++++
 fs/overlayfs/util.c      |  3 ++-
 6 files changed, 68 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 279009dee366..e48ba7de1bcb 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -62,35 +62,66 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
 }
=20
 /* caller holds i_mutex on workdir */
-static struct dentry *ovl_whiteout(struct dentry *workdir)
+static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry *work=
dir)
 {
 =09int err;
+=09bool same =3D true;
+=09bool again =3D true;
 =09struct dentry *whiteout;
 =09struct inode *wdir =3D workdir->d_inode;
=20
+=09if (ofs->workdir !=3D workdir)
+=09=09same =3D false;
+retry:
 =09whiteout =3D ovl_lookup_temp(workdir);
 =09if (IS_ERR(whiteout))
 =09=09return whiteout;
=20
+=09if (same && ofs->whiteout) {
+=09=09if (ovl_whiteout_linkable(ofs, workdir, ofs->whiteout)) {
+=09=09=09err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
+=09=09=09if (!err)
+=09=09=09=09return whiteout;
+
+=09=09=09if (!again)
+=09=09=09=09goto out;
+=09=09}
+
+=09=09dput(ofs->whiteout);
+=09=09ofs->whiteout =3D NULL;
+=09}
+
 =09err =3D ovl_do_whiteout(wdir, whiteout);
-=09if (err) {
-=09=09dput(whiteout);
-=09=09whiteout =3D ERR_PTR(err);
+=09if (!err) {
+=09=09if (!same || ofs->whiteout_link_max =3D=3D 1)
+=09=09=09return whiteout;
+
+=09=09if (!again) {
+=09=09=09WARN_ON_ONCE(1);
+=09=09=09return whiteout;
+=09=09}
+
+=09=09dget(whiteout);
+=09=09ofs->whiteout =3D whiteout;
+=09=09again =3D false;
+=09=09goto retry;
 =09}
=20
-=09return whiteout;
+out:
+=09dput(whiteout);
+=09return ERR_PTR(err);
 }
=20
 /* Caller must hold i_mutex on both workdir and dir */
-int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
-=09=09=09     struct dentry *dentry)
+int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workdir,
+=09=09=09     struct inode *dir, struct dentry *dentry)
 {
 =09struct inode *wdir =3D workdir->d_inode;
 =09struct dentry *whiteout;
 =09int err;
 =09int flags =3D 0;
=20
-=09whiteout =3D ovl_whiteout(workdir);
+=09whiteout =3D ovl_whiteout(ofs, workdir);
 =09err =3D PTR_ERR(whiteout);
 =09if (IS_ERR(whiteout))
 =09=09return err;
@@ -715,6 +746,7 @@ static bool ovl_matches_upper(struct dentry *dentry, st=
ruct dentry *upper)
 static int ovl_remove_and_whiteout(struct dentry *dentry,
 =09=09=09=09   struct list_head *list)
 {
+=09struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
 =09struct dentry *workdir =3D ovl_workdir(dentry);
 =09struct dentry *upperdir =3D ovl_dentry_upper(dentry->d_parent);
 =09struct dentry *upper;
@@ -748,7 +780,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentr=
y,
 =09=09goto out_dput_upper;
 =09}
=20
-=09err =3D ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), upper);
+=09err =3D ovl_cleanup_and_whiteout(ofs, workdir, d_inode(upperdir), upper=
);
 =09if (err)
 =09=09goto out_d_drop;
=20
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e6f3670146ed..cc7bcc3fb916 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -225,6 +225,13 @@ static inline bool ovl_open_flags_need_copy_up(int fla=
gs)
 =09return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
 }
=20
+static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs,
+=09=09=09=09=09 struct dentry *workdir,
+=09=09=09=09=09 struct dentry *dentry)
+{
+=09return dentry->d_inode->i_nlink < ofs->whiteout_link_max;
+}
+
 /* util.c */
 int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
@@ -455,8 +462,8 @@ static inline void ovl_copyflags(struct inode *from, st=
ruct inode *to)
=20
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
-int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
-=09=09=09     struct dentry *dentry);
+int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workdir,
+=09=09=09     struct inode *dir, struct dentry *dentry);
 struct ovl_cattr {
 =09dev_t rdev;
 =09umode_t mode;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 5762d802fe01..de5f230b6e6b 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -77,6 +77,10 @@ struct ovl_fs {
 =09int xino_mode;
 =09/* For allocation of non-persistent inode numbers */
 =09atomic_long_t last_ino;
+=09/* Whiteout dentry cache */
+=09struct dentry *whiteout;
+=09/* Whiteout max link count */
+=09unsigned int whiteout_link_max;
 };
=20
 static inline struct ovl_fs *OVL_FS(struct super_block *sb)
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index e452ff7d583d..1e921115e6aa 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1146,7 +1146,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 =09=09=09 * Whiteout orphan index to block future open by
 =09=09=09 * handle after overlay nlink dropped to zero.
 =09=09=09 */
-=09=09=09err =3D ovl_cleanup_and_whiteout(indexdir, dir, index);
+=09=09=09err =3D ovl_cleanup_and_whiteout(ofs, indexdir, dir,
+=09=09=09=09=09=09       index);
 =09=09} else {
 =09=09=09/* Cleanup orphan index entries */
 =09=09=09err =3D ovl_cleanup(dir, index);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 732ad5495c92..340c4c05c410 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -26,6 +26,10 @@ struct ovl_dir_cache;
=20
 #define OVL_MAX_STACK 500
=20
+static unsigned int ovl_whiteout_link_max_def =3D 60000;
+module_param_named(whiteout_link_max, ovl_whiteout_link_max_def, uint, 064=
4);
+MODULE_PARM_DESC(whiteout_link_max, "Maximum count of whiteout file link")=
;
+
 static bool ovl_redirect_dir_def =3D IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT=
_DIR);
 module_param_named(redirect_dir, ovl_redirect_dir_def, bool, 0644);
 MODULE_PARM_DESC(redirect_dir,
@@ -219,6 +223,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 =09iput(ofs->upperdir_trap);
 =09dput(ofs->indexdir);
 =09dput(ofs->workdir);
+=09dput(ofs->whiteout);
 =09if (ofs->workdir_locked)
 =09=09ovl_inuse_unlock(ofs->workbasedir);
 =09dput(ofs->workbasedir);
@@ -1762,6 +1767,11 @@ static int ovl_fill_super(struct super_block *sb, vo=
id *data, int silent)
=20
 =09=09if (!ofs->workdir)
 =09=09=09sb->s_flags |=3D SB_RDONLY;
+=09=09else
+=09=09=09ofs->whiteout_link_max =3D min_not_zero(
+=09=09=09=09=09ofs->workdir->d_sb->s_max_links,
+=09=09=09=09=09ovl_whiteout_link_max_def ?
+=09=09=09=09=09ovl_whiteout_link_max_def : 1);
=20
 =09=09sb->s_stack_depth =3D ofs->upper_mnt->mnt_sb->s_stack_depth;
 =09=09sb->s_time_gran =3D ofs->upper_mnt->mnt_sb->s_time_gran;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 36b60788ee47..18df65ee81a8 100644
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
+=09=09err =3D ovl_cleanup_and_whiteout(ofs, indexdir, dir, index);
 =09} else {
 =09=09/* Cleanup orphan index entries */
 =09=09err =3D ovl_cleanup(dir, index);
--=20
2.20.1


