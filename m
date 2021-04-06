Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED903C433B4
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Apr 2021 12:03:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF8656108B
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Apr 2021 12:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343672AbhDFMDr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:03:47 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17141 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235453AbhDFMDr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Apr 2021 08:03:47 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617710603; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=TS2Y+OYy3lCivSQTjlbQrhj48AygeDH89eboyvHCj88gY6ULkx+vl+N/kyIFRbEAIn64wCzSRNXD0UflLXZW4XTx90B+mTbCMCuyX7x1VYAAOKqdTUzNS9PXzMHL2lINbl90irlVsYfw1Hq+iDW8kAxvyDTWKCDPMnb2uyahsXg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617710603; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=iDtagNA3S6I3YE2xGu227rYajAbdZ7/ucmopzPUrfZ8=; 
        b=CWsE1Lg8ut6SEPEyahDzCNLvRTsuZcxeWzEoK9o94J6xkUNNl/CtwvOHHnJ3Fi7u+Y044rU/VhoVwLF5V1PsJcQTajJ26Xx8BdGkbdewUUwsiq8yCE2RiBrOmPbFPglynQffQ8g3OAx9dwq6qvsdMBdn4f0mr+1l72EaCTljCvM=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617710603;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=iDtagNA3S6I3YE2xGu227rYajAbdZ7/ucmopzPUrfZ8=;
        b=MZxXY7kCcJoa+DBewLBBnqyONXievAClQBbzW1wSAy5yjoOW4bzQGk0U4mdi5Qhr
        wSLe3vC9oXEwZZinUc04aKAGn7bA25Ys513CzxlkbRFqGl/JlS2vX8IJLXUmrZItnGW
        OJ2MiWedQMOranfb3vIBwbvhRGL61Zvf53449pGo=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1617710600905645.997536736019; Tue, 6 Apr 2021 20:03:20 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210406120245.1338326-3-cgxu519@mykernel.net>
Subject: [PATCH v2 3/3] ovl: copy-up optimization for truncate
Date:   Tue,  6 Apr 2021 20:02:45 +0800
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210406120245.1338326-1-cgxu519@mykernel.net>
References: <20210406120245.1338326-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Currently truncate operation on the file which only has
lower will copy-up whole lower file and calling truncate(2)
on upper file. It is not efficient for the case which
truncates to much smaller size than lower file. This patch
tries to avoid unnecessary data copy and truncate operation
after copy-up.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/copy_up.c   | 18 +++++++++++-------
 fs/overlayfs/inode.c     |  9 ++++++++-
 fs/overlayfs/overlayfs.h |  2 +-
 3 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a1a9a150405a..331cc32eac95 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -874,7 +874,7 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_=
up_ctx *c)
 }
=20
 static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
-=09=09=09   int flags)
+=09=09=09   int flags, loff_t size)
 {
 =09int err;
 =09DEFINE_DELAYED_CALL(done);
@@ -911,6 +911,8 @@ static int ovl_copy_up_one(struct dentry *parent, struc=
t dentry *dentry,
 =09/* maybe truncate regular file. this has no effect on dirs */
 =09if (flags & O_TRUNC)
 =09=09ctx.stat.size =3D 0;
+=09if (size)
+=09=09ctx.stat.size =3D size;
=20
 =09if (S_ISLNK(ctx.stat.mode)) {
 =09=09ctx.link =3D vfs_get_link(ctx.lowerpath.dentry, &done);
@@ -937,7 +939,7 @@ static int ovl_copy_up_one(struct dentry *parent, struc=
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
@@ -970,7 +972,7 @@ static int ovl_copy_up_flags(struct dentry *dentry, int=
 flags)
 =09=09=09next =3D parent;
 =09=09}
=20
-=09=09err =3D ovl_copy_up_one(parent, next, flags);
+=09=09err =3D ovl_copy_up_one(parent, next, flags, size);
=20
 =09=09dput(parent);
 =09=09dput(next);
@@ -1002,7 +1004,7 @@ int ovl_maybe_copy_up(struct dentry *dentry, int flag=
s)
 =09if (ovl_open_need_copy_up(dentry, flags)) {
 =09=09err =3D ovl_want_write(dentry);
 =09=09if (!err) {
-=09=09=09err =3D ovl_copy_up_flags(dentry, flags);
+=09=09=09err =3D ovl_copy_up_flags(dentry, flags, 0);
 =09=09=09ovl_drop_write(dentry);
 =09=09}
 =09}
@@ -1010,12 +1012,14 @@ int ovl_maybe_copy_up(struct dentry *dentry, int fl=
ags)
 =09return err;
 }
=20
-int ovl_copy_up_with_data(struct dentry *dentry)
+int ovl_copy_up_with_data(struct dentry *dentry, loff_t size)
 {
-=09return ovl_copy_up_flags(dentry, O_WRONLY);
+=09if (size)
+=09=09return ovl_copy_up_flags(dentry, O_WRONLY, size);
+=09return  ovl_copy_up_flags(dentry, O_TRUNC | O_WRONLY, 0);
 }
=20
 int ovl_copy_up(struct dentry *dentry)
 {
-=09return ovl_copy_up_flags(dentry, 0);
+=09return ovl_copy_up_flags(dentry, 0, 0);
 }
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index cf41bcb664bc..92f274844947 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -43,13 +43,20 @@ int ovl_setattr(struct dentry *dentry, struct iattr *at=
tr)
 =09if (!full_copy_up)
 =09=09err =3D ovl_copy_up(dentry);
 =09else
-=09=09err =3D ovl_copy_up_with_data(dentry);
+=09=09err =3D ovl_copy_up_with_data(dentry, attr->ia_size);
 =09if (!err) {
 =09=09struct inode *winode =3D NULL;
=20
 =09=09upperdentry =3D ovl_dentry_upper(dentry);
=20
 =09=09if (attr->ia_valid & ATTR_SIZE) {
+=09=09=09if (full_copy_up && !(attr->ia_valid & ~ATTR_SIZE)) {
+=09=09=09=09inode_lock(upperdentry->d_inode);
+=09=09=09=09ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
+=09=09=09=09inode_unlock(upperdentry->d_inode);
+=09=09=09=09goto out_drop_write;
+=09=09=09}
+
 =09=09=09winode =3D d_inode(upperdentry);
 =09=09=09err =3D get_write_access(winode);
 =09=09=09if (err)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index cb4e2d60ecf9..efd0ec9bd3b7 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -513,7 +513,7 @@ long ovl_compat_ioctl(struct file *file, unsigned int c=
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


