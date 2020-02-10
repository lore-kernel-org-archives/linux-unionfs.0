Return-Path: <SRS0=hil1=36=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888C8C35254
	for <linux-unionfs@archiver.kernel.org>; Mon, 10 Feb 2020 03:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50DBA2082E
	for <linux-unionfs@archiver.kernel.org>; Mon, 10 Feb 2020 03:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="IHEy5wrU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727143AbgBJD0S (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 9 Feb 2020 22:26:18 -0500
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21148 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726944AbgBJD0S (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 9 Feb 2020 22:26:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1581304267;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=RFjAvesANhCWwtrS826K6N8aAmm1PMTDw25pvVSvriU=;
        b=IHEy5wrUv3jIidv4MUYkiX3A2Y/QPmyvyns/NStZIGw9lfqRHcdYSnPgsiTuWkxg
        dmPPZXoRnofOypmSLtjTkArKMYK/6hAZJxpsqtKb+c+ssOe7FRPCAkOBo3OxliH1pBx
        nAdkRhUhWBWCbwzNs5Q0nUEyQwPxIKnuF0z2g0YE=
Received: from localhost.localdomain.localdomain (113.88.132.74 [113.88.132.74]) by mx.zoho.com.cn
        with SMTPS id 158130426522984.46339085344403; Mon, 10 Feb 2020 11:11:05 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200210031047.61211-1-cgxu519@mykernel.net>
Subject: [RFC PATCH] ovl: copy-up on MAP_SHARED
Date:   Mon, 10 Feb 2020 11:10:47 +0800
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When a read-only file is mapped shared, copy up the file before
actually doing the map so that we can keep data consistency in
O_RDONLY/O_WRONLY combination of shared mapping.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/Kconfig     | 21 ++++++++++++++++
 fs/overlayfs/file.c      | 54 ++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  6 +++++
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 22 ++++++++++++++++
 5 files changed, 104 insertions(+)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 444e2da4f60e..e9ce3010d5c7 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -123,3 +123,24 @@ config OVERLAY_FS_METACOPY
 =09  that doesn't support this feature will have unexpected results.
=20
 =09  If unsure, say N.
+
+config OVERLAY_FS_COPY_UP_SHARED
+=09bool "Overlayfs: copy up when mapping a file shared"
+=09default n
+=09depends on OVERLAY_FS
+=09help
+=09  If this option is enabled then on mapping a file with MAP_SHARED
+=09  overlayfs copies up the file in anticipation of it being modified (ju=
st
+=09  like we copy up the file on O_WRONLY and O_RDWR in anticipation of
+=09  modification).  This does not interfere with shared library loading, =
as
+=09  that uses MAP_PRIVATE.  But there might be use cases out there where
+=09  this impacts performance and disk usage.
+
+=09  This just selects the default, the feature can also be enabled or
+=09  disabled in the running kernel or individually on each overlay mount.
+
+=09  To get maximally standard compliant behavior, enable this option.
+
+=09  To get a maximally backward compatible kernel, disable this option.
+
+=09  If unsure, say N.
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index a5317216de73..69d4636d79ad 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -12,6 +12,7 @@
 #include <linux/splice.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
+#include <linux/mman.h>
 #include "overlayfs.h"
=20
 struct ovl_aio_req {
@@ -429,12 +430,65 @@ static int ovl_fsync(struct file *file, loff_t start,=
 loff_t end, int datasync)
 =09return ret;
 }
=20
+struct ovl_copy_up_work {
+=09struct work_struct work;
+=09struct dentry *dentry;
+=09unsigned long flags;
+=09int err;
+};
+
+enum ovl_copy_up_work_flag {
+=09OVL_COPY_UP_PENDING,
+};
+
+static void ovl_copy_up_work_fn(struct work_struct *work)
+{
+=09struct ovl_copy_up_work *ovl_cuw;
+
+=09ovl_cuw =3D container_of(work, struct ovl_copy_up_work, work);
+=09ovl_cuw->err =3D ovl_copy_up(ovl_cuw->dentry);
+
+=09clear_bit(OVL_COPY_UP_PENDING, &ovl_cuw->flags);
+=09wake_up_bit(&ovl_cuw->flags, OVL_COPY_UP_PENDING);
+}
+
 static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
 =09struct file *realfile =3D file->private_data;
 =09const struct cred *old_cred;
+=09struct inode *inode =3D file->f_inode;
+=09struct ovl_copy_up_work ovl_cuw;
+=09DEFINE_WAIT_BIT(wait, &ovl_cuw.flags, OVL_COPY_UP_PENDING);
+=09wait_queue_head_t *wqh;
 =09int ret;
=20
+=09if (vma->vm_flags & MAP_SHARED &&
+=09=09=09ovl_copy_up_shared(file_inode(file)->i_sb)) {
+=09=09ovl_cuw.err =3D 0;
+=09=09ovl_cuw.flags =3D 0;
+=09=09ovl_cuw.dentry =3D file_dentry(file);
+=09=09set_bit(OVL_COPY_UP_PENDING, &ovl_cuw.flags);
+
+=09=09wqh =3D bit_waitqueue(&ovl_cuw.flags, OVL_COPY_UP_PENDING);
+=09=09prepare_to_wait(wqh, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
+
+=09=09INIT_WORK(&ovl_cuw.work, ovl_copy_up_work_fn);
+=09=09schedule_work(&ovl_cuw.work);
+
+=09=09schedule();
+=09=09finish_wait(wqh, &wait.wq_entry);
+
+=09=09if (ovl_cuw.err)
+=09=09=09return ovl_cuw.err;
+
+=09=09realfile =3D ovl_open_realfile(file, ovl_inode_realdata(inode));
+=09=09if (IS_ERR(realfile))
+=09=09=09return PTR_ERR(realfile);
+
+=09=09ovl_release(inode, file);
+=09=09file->private_data =3D realfile;
+=09}
+
 =09if (!realfile->f_op->mmap)
 =09=09return -ENODEV;
=20
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 3623d28aa4fa..28853c18d59c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -328,6 +328,12 @@ static inline void ovl_inode_unlock(struct inode *inod=
e)
 =09mutex_unlock(&OVL_I(inode)->lock);
 }
=20
+static inline bool ovl_copy_up_shared(struct super_block *sb)
+{
+=09struct ovl_fs *ofs =3D sb->s_fs_info;
+
+=09return !(sb->s_flags & SB_RDONLY) && ofs->config.copy_up_shared;
+}
=20
 /* namei.c */
 int ovl_check_fb_len(struct ovl_fb *fb, int fb_len);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 89015ea822e7..6007cafd2ac7 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -17,6 +17,7 @@ struct ovl_config {
 =09bool nfs_export;
 =09int xino;
 =09bool metacopy;
+=09bool copy_up_shared;
 };
=20
 struct ovl_sb {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 319fe0d355b0..35ed1aef3266 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -53,6 +53,12 @@ module_param_named(xino_auto, ovl_xino_auto_def, bool, 0=
644);
 MODULE_PARM_DESC(xino_auto,
 =09=09 "Auto enable xino feature");
=20
+static bool ovl_copy_up_shared_def =3D
+=09IS_ENABLED(CONFIG_OVERLAY_FS_COPY_UP_SHARED);
+module_param_named(copy_up_shared, ovl_copy_up_shared_def, bool, 0644);
+MODULE_PARM_DESC(copy_up_shared,
+=09=09 "Copy up when mapping a file shared");
+
 static void ovl_entry_stack_free(struct ovl_entry *oe)
 {
 =09unsigned int i;
@@ -363,6 +369,9 @@ static int ovl_show_options(struct seq_file *m, struct =
dentry *dentry)
 =09if (ofs->config.metacopy !=3D ovl_metacopy_def)
 =09=09seq_printf(m, ",metacopy=3D%s",
 =09=09=09   ofs->config.metacopy ? "on" : "off");
+=09if (ofs->config.copy_up_shared !=3D ovl_copy_up_shared_def)
+=09=09seq_printf(m, ",copy_up_shared=3D%s",
+=09=09=09=09ofs->config.copy_up_shared ? "on" : "off");
 =09return 0;
 }
=20
@@ -403,6 +412,8 @@ enum {
 =09OPT_XINO_AUTO,
 =09OPT_METACOPY_ON,
 =09OPT_METACOPY_OFF,
+=09OPT_COPY_UP_SHARED_ON,
+=09OPT_COPY_UP_SHARED_OFF,
 =09OPT_ERR,
 };
=20
@@ -421,6 +432,8 @@ static const match_table_t ovl_tokens =3D {
 =09{OPT_XINO_AUTO,=09=09=09"xino=3Dauto"},
 =09{OPT_METACOPY_ON,=09=09"metacopy=3Don"},
 =09{OPT_METACOPY_OFF,=09=09"metacopy=3Doff"},
+=09{OPT_COPY_UP_SHARED_ON,=09=09"copy_up_shared=3Don"},
+=09{OPT_COPY_UP_SHARED_OFF,=09"copy_up_shared=3Doff"},
 =09{OPT_ERR,=09=09=09NULL}
 };
=20
@@ -559,6 +572,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config =
*config)
 =09=09=09config->metacopy =3D false;
 =09=09=09break;
=20
+=09=09case OPT_COPY_UP_SHARED_ON:
+=09=09=09config->copy_up_shared =3D true;
+=09=09=09break;
+
+=09=09case OPT_COPY_UP_SHARED_OFF:
+=09=09=09config->copy_up_shared =3D false;
+=09=09=09break;
+
 =09=09default:
 =09=09=09pr_err("unrecognized mount option \"%s\" or missing value\n",
 =09=09=09=09=09p);
@@ -1609,6 +1630,7 @@ static int ovl_fill_super(struct super_block *sb, voi=
d *data, int silent)
 =09ofs->config.nfs_export =3D ovl_nfs_export_def;
 =09ofs->config.xino =3D ovl_xino_def();
 =09ofs->config.metacopy =3D ovl_metacopy_def;
+=09ofs->config.copy_up_shared =3D ovl_copy_up_shared_def;
 =09err =3D ovl_parse_opt((char *) data, &ofs->config);
 =09if (err)
 =09=09goto out_err;
--=20
2.21.1



