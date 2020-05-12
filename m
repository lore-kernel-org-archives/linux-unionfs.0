Return-Path: <SRS0=bzPr=62=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4261C54E4B
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 May 2020 07:13:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8712E206D6
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 May 2020 07:13:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="RQoNj+uZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgELHNs (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 May 2020 03:13:48 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21113 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725813AbgELHNs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 May 2020 03:13:48 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589267605; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=eTx/oanwav2S3n7gjAOyvTQn/dKiAjYtXT3aKQQRwRdyiIrStwoUpiyEnpGC/Wg+WqFGAZJj8Xc6xE2y7c1u/azFE9TUOzFhRQbjK9noyZiB299iMjbqE3rjeSfwH8sfNDgj7kdumL78d9qTv5/T+ZsDo4hNFowHCHix7MoVA4M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589267605; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=JuiCc5W2rIFjnN/tJIr6eX0Vn/LREAENdMAS1J83/k8=; 
        b=Ic5n2ca81TTTVm7qFTNkVagD/jOmS11UW9RI8yfnO8+VnwpMJxRkdlXB8Ah8pNXWFsbQyo3u+Cq//nuWCNNrL4W5UKpOmT2UnUruNeLaxhXZ1kcrmc0rXlG8n+6hwu3ApOWceWhRfdCzlEuxWN1YJADsp9oOW4oWSdtt1KHTfgs=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589267605;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=JuiCc5W2rIFjnN/tJIr6eX0Vn/LREAENdMAS1J83/k8=;
        b=RQoNj+uZNv6jeTBDFVKYY6xyKk0I7PPGPITvPVv/PxzBOKl55xNZ1L5twH6hWcIt
        kdVDLle9eCQQ8F0qq2eAWY2xxOtlBgHuF+VQ9QibWqvnCm9snWZRFgdXw8foJtsWPQ0
        zs9jBMj3QZGO2/Cr+N+em7aJAXLJ4rqg5rnNwF9k=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1589267602835874.8317166112041; Tue, 12 May 2020 15:13:22 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200512071313.4525-1-cgxu519@mykernel.net>
Subject: [RFC PATCH v2] ovl: suppress negative dentry in lookup
Date:   Tue, 12 May 2020 15:13:13 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When a file is only in a lower layer or in no layer at all, after
lookup a negative dentry will be generated in the upper layer or
even worse many negetive dentries will be generated in upper/lower
layers. These negative dentries will be useless after construction
of overlayfs' own dentry and may keep in the memory long time even
after unmount of overlayfs instance. This patch tries to kill
unnecessary negative dentry during lookup.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
v1->v2:
- Only drop negative dentry after slow lookup.

 fs/namei.c            |  9 ++++++---
 fs/overlayfs/namei.c  | 35 ++++++++++++++++++++++++++++++++++-
 include/linux/namei.h |  8 ++++++++
 3 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index a320371899cf..1cc2960c7804 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1386,7 +1386,7 @@ static inline int handle_mounts(struct nameidata *nd,=
 struct dentry *dentry,
  * This looks up the name in dcache and possibly revalidates the found den=
try.
  * NULL is returned if the dentry does not exist in the cache.
  */
-static struct dentry *lookup_dcache(const struct qstr *name,
+struct dentry *lookup_dcache(const struct qstr *name,
 =09=09=09=09    struct dentry *dir,
 =09=09=09=09    unsigned int flags)
 {
@@ -1402,6 +1402,7 @@ static struct dentry *lookup_dcache(const struct qstr=
 *name,
 =09}
 =09return dentry;
 }
+EXPORT_SYMBOL(lookup_dcache);
=20
 /*
  * Parent directory has inode locked exclusive.  This is one
@@ -1500,7 +1501,7 @@ static struct dentry *lookup_fast(struct nameidata *n=
d,
 }
=20
 /* Fast lookup failed, do it the slow way */
-static struct dentry *__lookup_slow(const struct qstr *name,
+struct dentry *__lookup_slow(const struct qstr *name,
 =09=09=09=09    struct dentry *dir,
 =09=09=09=09    unsigned int flags)
 {
@@ -1536,6 +1537,7 @@ static struct dentry *__lookup_slow(const struct qstr=
 *name,
 =09}
 =09return dentry;
 }
+EXPORT_SYMBOL(__lookup_slow);
=20
 static struct dentry *lookup_slow(const struct qstr *name,
 =09=09=09=09  struct dentry *dir,
@@ -2460,7 +2462,7 @@ int vfs_path_lookup(struct dentry *dentry, struct vfs=
mount *mnt,
 }
 EXPORT_SYMBOL(vfs_path_lookup);
=20
-static int lookup_one_len_common(const char *name, struct dentry *base,
+int lookup_one_len_common(const char *name, struct dentry *base,
 =09=09=09=09 int len, struct qstr *this)
 {
 =09this->name =3D name;
@@ -2491,6 +2493,7 @@ static int lookup_one_len_common(const char *name, st=
ruct dentry *base,
=20
 =09return inode_permission(base->d_inode, MAY_EXEC);
 }
+EXPORT_SYMBOL(lookup_one_len_common);
=20
 /**
  * try_lookup_one_len - filesystem helper to lookup single pathname compon=
ent
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 723d17744758..d8e71173ea75 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -191,6 +191,39 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
 =09return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
 }
=20
+static struct dentry *ovl_lookup_positive_unlocked(const char *name,
+=09=09=09=09=09=09   struct dentry *base,
+=09=09=09=09=09=09   int len)
+{
+=09struct qstr this;
+=09struct dentry *ret;
+=09bool not_found =3D false;
+=09int err;
+
+=09err =3D lookup_one_len_common(name, base, len, &this);
+=09if (err)
+=09=09return ERR_PTR(err);
+
+=09ret =3D lookup_dcache(&this, base, 0);
+=09if (ret)
+=09=09return ret;
+
+=09inode_lock_shared(base->d_inode);
+=09ret =3D __lookup_slow(&this, base, 0);
+=09if (!IS_ERR(ret) &&
+=09    d_flags_negative(ret->d_flags)) {
+=09=09not_found =3D true;
+=09=09d_drop(ret);
+=09}
+=09inode_unlock_shared(base->d_inode);
+
+=09if (not_found) {
+=09=09dput(ret);
+=09=09ret =3D ERR_PTR(-ENOENT);
+=09}
+=09return ret;
+}
+
 static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *=
d,
 =09=09=09     const char *name, unsigned int namelen,
 =09=09=09     size_t prelen, const char *post,
@@ -200,7 +233,7 @@ static int ovl_lookup_single(struct dentry *base, struc=
t ovl_lookup_data *d,
 =09int err;
 =09bool last_element =3D !post[0];
=20
-=09this =3D lookup_positive_unlocked(name, base, namelen);
+=09this =3D ovl_lookup_positive_unlocked(name, base, namelen);
 =09if (IS_ERR(this)) {
 =09=09err =3D PTR_ERR(this);
 =09=09this =3D NULL;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index a4bb992623c4..c65b863657eb 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -66,6 +66,14 @@ extern struct dentry *user_path_create(int, const char _=
_user *, struct path *,
 extern void done_path_create(struct path *, struct dentry *);
 extern struct dentry *kern_path_locked(const char *, struct path *);
=20
+extern int lookup_one_len_common(const char *name, struct dentry *base,
+=09=09=09=09 int len, struct qstr *this);
+extern struct dentry *lookup_dcache(const struct qstr *name,
+=09=09=09=09    struct dentry *base,
+=09=09=09=09    unsigned int flags);
+extern struct dentry *__lookup_slow(const struct qstr *name,
+=09=09=09=09    struct dentry *dir,
+=09=09=09=09    unsigned int flags);
 extern struct dentry *try_lookup_one_len(const char *, struct dentry *, in=
t);
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
 extern struct dentry *lookup_one_len_unlocked(const char *, struct dentry =
*, int);
--=20
2.20.1


