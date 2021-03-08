Return-Path: <SRS0=PSAs=IG=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB17C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Mar 2021 11:18:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73CA765105
	for <linux-unionfs@archiver.kernel.org>; Mon,  8 Mar 2021 11:18:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbhCHLR6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 8 Mar 2021 06:17:58 -0500
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17175 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231249AbhCHLR5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Mar 2021 06:17:57 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615202263; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=iJ55CvL4x0eHFAuQHIDPKgQXrJ02hDbc73PfMIa/MhrqwtpVUnk7DEk2YpwNvLr+T1C9L2l/vgKNH5dE2LIuGnsAoDoyHG3S4MC+2GS3ZbLraRLFFDP7YaXT+9vDGlAjUZrE4Ppra/gWDVqn1vAKZ6zCcbpk70/8tl+FuBQaW0k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1615202263; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=NeXuomRJ8cSVbWjiTjYpxXwSvsVYgYG/vBMVDlZ0o+Y=; 
        b=ZNIYpCVIvIPrwCTK904aE1Q08R5MWiZpWWM1rj3BlOFrjFl22Ba73deEUoeQ5MCaNsIvtOBglr/ipE/oE35ka631Rs5mloSazZOdhoMxu5/h/ZqVAVDtsybpzntwWrwL47PZLWRcN6xCZtoMGkFHOyRE2Cfs9l+4pjd8bEnJ3wk=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1615202263;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=NeXuomRJ8cSVbWjiTjYpxXwSvsVYgYG/vBMVDlZ0o+Y=;
        b=a9v4KE2cAFdkyQ4nBqWLVUXx7BFcT9N53t8ysOIy8A5u9EUTnS9+slf9dV6H8SEA
        oslXA6NV7wp2C0wW46Hpc23zqcpzjAGuC2IjNsdeLJ9FkTK+wmuvx64X5/WbwIyK7g6
        galwkhQx85PT+dsyUSalpw1p5j2AzVJR3X7uB58c=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1615202261788784.824955723745; Mon, 8 Mar 2021 19:17:41 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210308111717.2027030-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: copy-up optimization for truncate
Date:   Mon,  8 Mar 2021 19:17:17 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Currently copy-up will copy whole lower file to upper
regardless of the data range which is needed for further
operation. This patch avoids unnecessary copy when truncate
size is smaller than the file size.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/copy_up.c   | 16 +++++++++-------
 fs/overlayfs/inode.c     |  4 +++-
 fs/overlayfs/overlayfs.h |  2 +-
 3 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0b2891c6c71e..b426a3f59636 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -866,7 +866,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_=
up_ctx *c)
 }
=20
 static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
-=09=09=09   int flags)
+=09=09=09   int flags, loff_t size)
 {
 =09int err;
 =09DEFINE_DELAYED_CALL(done);
@@ -903,6 +903,8 @@ static int ovl_copy_up_one(struct dentry *parent, struc=
t dentry *dentry,
 =09/* maybe truncate regular file. this has no effect on dirs */
 =09if (flags & O_TRUNC)
 =09=09ctx.stat.size =3D 0;
+=09if (size)
+=09=09ctx.stat.size =3D size;
=20
 =09if (S_ISLNK(ctx.stat.mode)) {
 =09=09ctx.link =3D vfs_get_link(ctx.lowerpath.dentry, &done);
@@ -929,7 +931,7 @@ static int ovl_copy_up_one(struct dentry *parent, struc=
t dentry *dentry,
 =09return err;
 }
=20
-static int ovl_copy_up_flags(struct dentry *dentry, int flags)
+static int ovl_copy_up_flags(struct dentry *dentry, int flags, loff_t size=
)
 {
 =09int err =3D 0;
 =09const struct cred *old_cred =3D ovl_override_creds(dentry->d_sb);
@@ -962,7 +964,7 @@ static int ovl_copy_up_flags(struct dentry *dentry, int=
 flags)
 =09=09=09next =3D parent;
 =09=09}
=20
-=09=09err =3D ovl_copy_up_one(parent, next, flags);
+=09=09err =3D ovl_copy_up_one(parent, next, flags, size);
=20
 =09=09dput(parent);
 =09=09dput(next);
@@ -994,7 +996,7 @@ int ovl_maybe_copy_up(struct dentry *dentry, int flags)
 =09if (ovl_open_need_copy_up(dentry, flags)) {
 =09=09err =3D ovl_want_write(dentry);
 =09=09if (!err) {
-=09=09=09err =3D ovl_copy_up_flags(dentry, flags);
+=09=09=09err =3D ovl_copy_up_flags(dentry, flags, 0);
 =09=09=09ovl_drop_write(dentry);
 =09=09}
 =09}
@@ -1002,12 +1004,12 @@ int ovl_maybe_copy_up(struct dentry *dentry, int fl=
ags)
 =09return err;
 }
=20
-int ovl_copy_up_with_data(struct dentry *dentry)
+int ovl_copy_up_with_data(struct dentry *dentry, loff_t size)
 {
-=09return ovl_copy_up_flags(dentry, O_WRONLY);
+=09return ovl_copy_up_flags(dentry, O_WRONLY, size);
 }
=20
 int ovl_copy_up(struct dentry *dentry)
 {
-=09return ovl_copy_up_flags(dentry, 0);
+=09return ovl_copy_up_flags(dentry, 0, 0);
 }
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 003cf83bf78a..5eb99e4c3c73 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -44,7 +44,9 @@ int ovl_setattr(struct user_namespace *mnt_userns, struct=
 dentry *dentry,
 =09if (!full_copy_up)
 =09=09err =3D ovl_copy_up(dentry);
 =09else
-=09=09err =3D ovl_copy_up_with_data(dentry);
+=09=09err =3D ovl_copy_up_with_data(dentry,
+=09=09=09=09attr->ia_size < i_size_read(d_inode(dentry)) ?
+=09=09=09=09attr->ia_size : 0);
 =09if (!err) {
 =09=09struct inode *winode =3D NULL;
=20
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 95cff83786a5..1bc17ca87158 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -524,7 +524,7 @@ long ovl_compat_ioctl(struct file *file, unsigned int c=
md, unsigned long arg);
=20
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
-int ovl_copy_up_with_data(struct dentry *dentry);
+int ovl_copy_up_with_data(struct dentry *dentry, loff_t size);
 int ovl_maybe_copy_up(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 =09=09   struct dentry *new);
--=20
2.27.0


