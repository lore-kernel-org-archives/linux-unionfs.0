Return-Path: <SRS0=lkgI=6G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E9DC55186
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 10:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1412C2073A
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 10:30:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="WHb7xFlO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbgDVKaZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 06:30:25 -0400
Received: from [163.53.93.247] ([163.53.93.247]:21143 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1730646AbgDVK2z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Apr 2020 06:28:55 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1587551277; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=c749bAmQiTVfQhwDn8R2Bxoyz2iFXp6cd64hG8qg8yZB5wxkzGJpj9/Iz3UV2chemD13A5P0JRWc0CAym4vMY6Ym5CmGZxMpTRcszmKojk1oZHdtPp9yisxHSmAmaZFbTnwAyzabWC+vvm4xNjgBCi0V2ivRSMkSspLGpjNvNyM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1587551277; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=rrJn0AZ+jBYOftVeKvvdHi+6rcHGdZscqQHM68S2uHg=; 
        b=P5x5lJTDxYyppVHTOq57cS3Yk8jHcqLxM/WbZZwkbhYZCRBfxiCElIq+9wDQCvuilK0JW7YbFcLfg4kDMDJr6A0VLwiS/egApTWxYgUuJ+JxJWMoEIuBXaoD9wZIjBXJ+RBWS0KPY7Btu29KJEmen0u3XQ9ScyIOhGWG5HervE8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1587551277;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=rrJn0AZ+jBYOftVeKvvdHi+6rcHGdZscqQHM68S2uHg=;
        b=WHb7xFlOCpOvxnYYNDVyZaL2IGFilF53zkwzPtE0Penab4rDsVdPKdo1LAsXVRX0
        yp2H2neuqY4FEXgbquYDETfWvHI/bJIynFDHbB0jbh+QF14pKhZOZfOl0KcDo3UCVgi
        gWfcRfKO/kmhamRhMBtC76fz3g864W82QCJNHwq4=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1587551275329770.035788962666; Wed, 22 Apr 2020 18:27:55 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200422102740.6670-1-cgxu519@mykernel.net>
Subject: [PATCH v4] ovl: whiteout inode sharing
Date:   Wed, 22 Apr 2020 18:27:40 +0800
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
inode and speeding up deleting operation.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
v1->v2:
- Address Amir's comments in v1.

v2->v3:
- Address Amir's comments in v2.
- Rebase on Amir's "Overlayfs use index dir as work dir" patch set.
- Keep at most one whiteout tmpfile in work dir.

v3->v4:
- Disable the feature after link failure.
- Add mount option(whiteout link max) for overlayfs instance.

 fs/overlayfs/dir.c       | 47 ++++++++++++++++++++++++++++++++++------
 fs/overlayfs/overlayfs.h | 10 +++++++--
 fs/overlayfs/ovl_entry.h |  5 +++++
 fs/overlayfs/readdir.c   |  3 ++-
 fs/overlayfs/super.c     | 24 ++++++++++++++++++++
 fs/overlayfs/util.c      |  3 ++-
 6 files changed, 81 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 279009dee366..8b7d8854f31f 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -62,35 +62,67 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
 }
=20
 /* caller holds i_mutex on workdir */
-static struct dentry *ovl_whiteout(struct dentry *workdir)
+static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry *work=
dir)
 {
 =09int err;
+=09bool retried =3D false;
+=09bool should_link =3D (ofs->whiteout_link_max > 1);
 =09struct dentry *whiteout;
 =09struct inode *wdir =3D workdir->d_inode;
=20
+retry:
 =09whiteout =3D ovl_lookup_temp(workdir);
 =09if (IS_ERR(whiteout))
 =09=09return whiteout;
=20
+=09err =3D 0;
+=09if (should_link) {
+=09=09if (ovl_whiteout_linkable(ofs)) {
+=09=09=09err =3D ovl_do_link(ofs->whiteout, wdir, whiteout);
+=09=09=09if (!err)
+=09=09=09=09return whiteout;
+=09=09} else if (ofs->whiteout) {
+=09=09=09dput(whiteout);
+=09=09=09whiteout =3D ofs->whiteout;
+=09=09=09ofs->whiteout =3D NULL;
+=09=09=09return whiteout;
+=09=09}
+
+=09=09if (err) {
+=09=09=09pr_warn("Failed to link whiteout - disabling whiteout inode shari=
ng(nlink=3D%u, err=3D%i)\n",
+=09=09=09=09ofs->whiteout->d_inode->i_nlink, err);
+=09=09=09ofs->whiteout_link_max =3D 0;
+=09=09=09should_link =3D false;
+=09=09=09ovl_cleanup(wdir, ofs->whiteout);
+=09=09=09dput(ofs->whiteout);
+=09=09=09ofs->whiteout =3D NULL;
+=09=09}
+=09}
+
 =09err =3D ovl_do_whiteout(wdir, whiteout);
 =09if (err) {
 =09=09dput(whiteout);
-=09=09whiteout =3D ERR_PTR(err);
+=09=09return ERR_PTR(err);
 =09}
=20
-=09return whiteout;
+=09if (!should_link || retried)
+=09=09return whiteout;
+
+=09ofs->whiteout =3D whiteout;
+=09retried =3D true;
+=09goto retry;
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
@@ -715,6 +747,7 @@ static bool ovl_matches_upper(struct dentry *dentry, st=
ruct dentry *upper)
 static int ovl_remove_and_whiteout(struct dentry *dentry,
 =09=09=09=09   struct list_head *list)
 {
+=09struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
 =09struct dentry *workdir =3D ovl_workdir(dentry);
 =09struct dentry *upperdir =3D ovl_dentry_upper(dentry->d_parent);
 =09struct dentry *upper;
@@ -748,7 +781,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentr=
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
index e00b1ff6dea9..3b127c997a6d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -225,6 +225,12 @@ static inline bool ovl_open_flags_need_copy_up(int fla=
gs)
 =09return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
 }
=20
+static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs)
+{
+=09return (ofs->whiteout &&
+=09=09ofs->whiteout->d_inode->i_nlink < ofs->whiteout_link_max);
+}
+
 /* util.c */
 int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
@@ -455,8 +461,8 @@ static inline void ovl_copyflags(struct inode *from, st=
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
index 5762d802fe01..c805c35e0594 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -17,6 +17,7 @@ struct ovl_config {
 =09bool nfs_export;
 =09int xino;
 =09bool metacopy;
+=09unsigned int whiteout_link_max;
 };
=20
 struct ovl_sb {
@@ -77,6 +78,10 @@ struct ovl_fs {
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
index 20f5310d3ee4..bf22fb7792c1 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1154,7 +1154,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
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
index f57aa348dcd6..6bccab4d5596 100644
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
@@ -358,6 +363,10 @@ static int ovl_show_options(struct seq_file *m, struct=
 dentry *dentry)
 =09if (ofs->config.metacopy !=3D ovl_metacopy_def)
 =09=09seq_printf(m, ",metacopy=3D%s",
 =09=09=09   ofs->config.metacopy ? "on" : "off");
+=09if (ofs->config.whiteout_link_max !=3D ovl_whiteout_link_max_def)
+=09=09seq_printf(m, ",whiteout_link_max=3D%u",
+=09=09=09   ofs->config.whiteout_link_max);
+
 =09return 0;
 }
=20
@@ -398,6 +407,7 @@ enum {
 =09OPT_XINO_AUTO,
 =09OPT_METACOPY_ON,
 =09OPT_METACOPY_OFF,
+=09OPT_WHITEOUT_LINK_MAX,
 =09OPT_ERR,
 };
=20
@@ -416,6 +426,7 @@ static const match_table_t ovl_tokens =3D {
 =09{OPT_XINO_AUTO,=09=09=09"xino=3Dauto"},
 =09{OPT_METACOPY_ON,=09=09"metacopy=3Don"},
 =09{OPT_METACOPY_OFF,=09=09"metacopy=3Doff"},
+=09{OPT_WHITEOUT_LINK_MAX,=09=09"whiteout_link_max=3D%u"},
 =09{OPT_ERR,=09=09=09NULL}
 };
=20
@@ -469,6 +480,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *=
config)
 {
 =09char *p;
 =09int err;
+=09int link_max;
 =09bool metacopy_opt =3D false, redirect_opt =3D false;
 =09bool nfs_export_opt =3D false, index_opt =3D false;
=20
@@ -560,6 +572,13 @@ static int ovl_parse_opt(char *opt, struct ovl_config =
*config)
 =09=09=09metacopy_opt =3D true;
 =09=09=09break;
=20
+=09=09case OPT_WHITEOUT_LINK_MAX:
+=09=09=09if (match_int(&args[0], &link_max))
+=09=09=09=09return -EINVAL;
+=09=09=09if (link_max < ovl_whiteout_link_max_def)
+=09=09=09=09config->whiteout_link_max =3D link_max;
+=09=09=09break;
+
 =09=09default:
 =09=09=09pr_err("unrecognized mount option \"%s\" or missing value\n",
 =09=09=09=09=09p);
@@ -1269,6 +1288,10 @@ static int ovl_make_workdir(struct super_block *sb, =
struct ovl_fs *ofs,
 =09=09pr_warn("NFS export requires \"index=3Don\", falling back to nfs_exp=
ort=3Doff.\n");
 =09=09ofs->config.nfs_export =3D false;
 =09}
+
+=09ofs->whiteout_link_max =3D min_not_zero(
+=09=09ofs->workdir->d_sb->s_max_links,
+=09=09ofs->config.whiteout_link_max ?: 1);
 out:
 =09mnt_drop_write(mnt);
 =09return err;
@@ -1768,6 +1791,7 @@ static int ovl_fill_super(struct super_block *sb, voi=
d *data, int silent)
 =09ofs->config.nfs_export =3D ovl_nfs_export_def;
 =09ofs->config.xino =3D ovl_xino_def();
 =09ofs->config.metacopy =3D ovl_metacopy_def;
+=09ofs->config.whiteout_link_max =3D ovl_whiteout_link_max_def;
 =09err =3D ovl_parse_opt((char *) data, &ofs->config);
 =09if (err)
 =09=09goto out_err;
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


