Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DD15C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Sep 2021 12:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C314610E5
	for <linux-unionfs@archiver.kernel.org>; Tue, 28 Sep 2021 12:48:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240768AbhI1MuD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 28 Sep 2021 08:50:03 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17289 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240680AbhI1MuD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Sep 2021 08:50:03 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1632833286; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=a5Ep0YJGvsWxN/Aat3N82lfo5VoaxZRFcYnPJ5BO8spvxRAyEuuMIBRannnDsiw44FRVxeHuvHaXU2MqDqYPs0LIKt5aSRWpNbgYeX3d7vlYeSuNFc0yFe7TVO6eS34pb5SXINhgc4PSr5eK+M//XMsV7ryb3UHA8PY9Z0jMLdM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1632833286; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=rDqltl4+T1qXU+P+jV0U8PYgZoQvBg89ny48K91KWOs=; 
        b=YZ/CSbDfB0Nb2iOV+Qr9DzA4Nw3IoNUPJJ6H72Gt9k0k3sko42Ik8HJQW1Dk3jvIs0wpZyD3QKB8lWYG7ICwn9mgnNjUUnEW+SVk5JP1jlgTLjelHwOHY6QNWf9zKoe7/mFSkE1FXCVwVsMAtj+vp2bQLtPmJ7zypx76wYXq8aw=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1632833286;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=rDqltl4+T1qXU+P+jV0U8PYgZoQvBg89ny48K91KWOs=;
        b=HYkj3yqQVfgxWkvYPpbef+K4utyr/0RmfZPy+vrhEW6V8cA2ArI8nYugKGIdVbRi
        t2dLU4NJSM+zTpljFeHtGhWuieNx8vANWhNDyRRy5nXd/qf6aD18pNbc584c+53j993
        oN/t51KDuan2acATJTAUCpIm11dt7Ye49aXIkNw8=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1632833285801795.8323026481827; Tue, 28 Sep 2021 20:48:05 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     mszeredi@redhat.com
Cc:     linux-unionfs@vger.kernel.org, huangjianan@oppo.com,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210928124757.117556-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: set overlayfs inode's a_ops->direct_IO properly
Date:   Tue, 28 Sep 2021 20:47:57 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Loop device checks the ability of DIRECT-IO by checking
a_ops->direct_IO of inode, in order to avoid this kind of
false detection we set a_ops->direct_IO for overlayfs inode
only when underlying inode really has DIRECT-IO ability.

Reported-by: Huang Jianan <huangjianan@oppo.com>
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/dir.c       |  2 ++
 fs/overlayfs/inode.c     |  4 ++--
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 14 ++++++++++++++
 4 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1fefb2b8960e..32a60f9e3f9e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -648,6 +648,8 @@ static int ovl_create_object(struct dentry *dentry, int=
 mode, dev_t rdev,
 =09/* Did we end up using the preallocated inode? */
 =09if (inode !=3D d_inode(dentry))
 =09=09iput(inode);
+=09else
+=09=09ovl_inode_set_aops(inode);
=20
 out_drop_write:
 =09ovl_drop_write(dentry);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 832b17589733..a7a327e4f790 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -659,7 +659,7 @@ static const struct inode_operations ovl_special_inode_=
operations =3D {
 =09.update_time=09=3D ovl_update_time,
 };
=20
-static const struct address_space_operations ovl_aops =3D {
+const struct address_space_operations ovl_aops =3D {
 =09/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
 =09.direct_IO=09=09=3D noop_direct_IO,
 };
@@ -786,6 +786,7 @@ void ovl_inode_init(struct inode *inode, struct ovl_ino=
de_params *oip,
 =09ovl_copyattr(realinode, inode);
 =09ovl_copyflags(realinode, inode);
 =09ovl_map_ino(inode, ino, fsid);
+=09ovl_inode_set_aops(inode);
 }
=20
 static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
@@ -802,7 +803,6 @@ static void ovl_fill_inode(struct inode *inode, umode_t=
 mode, dev_t rdev)
 =09case S_IFREG:
 =09=09inode->i_op =3D &ovl_file_inode_operations;
 =09=09inode->i_fop =3D &ovl_file_operations;
-=09=09inode->i_mapping->a_ops =3D &ovl_aops;
 =09=09break;
=20
 =09case S_IFDIR:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 3894f3347955..976c9d634293 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -349,6 +349,7 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 =09=09=09     int padding);
 int ovl_sync_status(struct ovl_fs *ofs);
+void ovl_inode_set_aops(struct inode *inode);
=20
 static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f48284a2a896..33535dbee1c3 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1060,3 +1060,17 @@ int ovl_sync_status(struct ovl_fs *ofs)
=20
 =09return errseq_check(&mnt->mnt_sb->s_wb_err, ofs->errseq);
 }
+
+extern const struct address_space_operations ovl_aops;
+void ovl_inode_set_aops(struct inode *inode)
+{
+=09struct inode *realinode;
+
+=09if (!S_ISREG(inode->i_mode))
+=09=09return;
+
+=09realinode =3D ovl_inode_realdata(inode);
+=09if (realinode && realinode->i_mapping && realinode->i_mapping->a_ops &&
+=09    realinode->i_mapping->a_ops->direct_IO)
+=09=09inode->i_mapping->a_ops =3D &ovl_aops;
+}
--=20
2.27.0


