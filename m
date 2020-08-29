Return-Path: <SRS0=cJ4F=CH=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57487C433E7
	for <linux-unionfs@archiver.kernel.org>; Sat, 29 Aug 2020 09:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 365D92075B
	for <linux-unionfs@archiver.kernel.org>; Sat, 29 Aug 2020 09:52:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="VdCYBUiH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgH2JwF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 05:52:05 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17159 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbgH2JwE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 29 Aug 2020 05:52:04 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1598694693; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=YBE7Pv1efxlf1AAxaIoD3yTwlut8GbiWLhItLSzb75VKosrMcu8E+zxtkQCO0o1GEr1wmARPmUzNbnLMqnVp2IDVcWb3f1aN2VGkzSpXNEmZqXftIwZ3ObDt7rADXjMu0YjgijZDPZkB9pQGk625k7kft4O51oOzJOtXJuvpo+o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1598694693; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=/mgZ6omCjLzte5zMdd9RURwLPDtaIIQG4E0QLcHBYCk=; 
        b=YQfHeJhqjNXXYa/tyIjUkhnXypDPjyK6xn5+H0Rmh5tDYpJ1hufAtjxLCAkiaRTqKIxiR7PDzUiUllGO7fOL3wTouJje6JBMmq3l1be3nHee6+AhMipxMPeiw3cFYRtIuPLBMl8wd6NMT0gu0BDhS4/bBd5lC2UFjJAwQCnQi4k=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1598694693;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=/mgZ6omCjLzte5zMdd9RURwLPDtaIIQG4E0QLcHBYCk=;
        b=VdCYBUiH8r7HhyaUv/Lu4nc8lsMH0dwYTU1Ps2qELaHkJCW1mF+ZnH5Jm8++hkKX
        7Fp6O3tLZAFn5ZU0QJQyGMuAlPj+VFC5f/DJH+57pksWtaPu4++RxzKyIyMJ/k9L2Iy
        28ZebKeyHWHgB5KPswewZ3S+Md5P1VQdcV7uK2nA=
Received: from localhost.localdomain (116.30.194.36 [116.30.194.36]) by mx.zoho.com.cn
        with SMTPS id 1598694691937238.97463573795892; Sat, 29 Aug 2020 17:51:31 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     linux-unionfs@vger.kernel.org, linux-mm@kvack.org
Cc:     miklos@szeredi.hu, akpm@linux-foundation.org, amir73il@gmail.com,
        riteshh@linux.ibm.com, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200829095101.25350-3-cgxu519@mykernel.net>
Subject: [RFC PATCH 2/3] ovl: introduce struct ovl_file_entry
Date:   Sat, 29 Aug 2020 17:51:00 +0800
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200829095101.25350-1-cgxu519@mykernel.net>
References: <20200829095101.25350-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Introduce new struct ovl_file_entry to store real file
and real vm_ops handler.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/file.c | 64 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 54 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 0d940e29d62b..14ab5344a918 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -21,6 +21,39 @@ struct ovl_aio_req {
 =09struct fd fd;
 };
=20
+struct ovl_file_entry {
+=09struct file *realfile;
+=09void *vm_ops;
+};
+
+struct file *ovl_get_realfile(struct file *file)
+{
+=09struct ovl_file_entry *ofe =3D file->private_data;
+
+=09return ofe->realfile;
+}
+
+void ovl_set_realfile(struct file *file, struct file *realfile)
+{
+=09struct ovl_file_entry *ofe =3D file->private_data;
+
+=09ofe->realfile =3D realfile;
+}
+
+void *ovl_get_real_vmops(struct file *file)
+{
+=09struct ovl_file_entry *ofe =3D file->private_data;
+
+=09return ofe->vm_ops;
+}
+
+void ovl_set_real_vmops(struct file *file, void *vm_ops)
+{
+=09struct ovl_file_entry *ofe =3D file->private_data;
+
+=09ofe->vm_ops =3D vm_ops;
+}
+
 static struct kmem_cache *ovl_aio_request_cachep;
=20
 static char ovl_whatisit(struct inode *inode, struct inode *realinode)
@@ -105,14 +138,14 @@ static int ovl_change_flags(struct file *file, unsign=
ed int flags)
 =09return 0;
 }
=20
-static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
+static int ovl_real_fdget_meta(struct file *file, struct fd *real,
 =09=09=09       bool allow_meta)
 {
 =09struct inode *inode =3D file_inode(file);
 =09struct inode *realinode;
=20
 =09real->flags =3D 0;
-=09real->file =3D file->private_data;
+=09real->file =3D ovl_get_realfile(file);
=20
 =09if (allow_meta)
 =09=09realinode =3D ovl_inode_real(inode);
@@ -134,7 +167,7 @@ static int ovl_real_fdget_meta(const struct file *file,=
 struct fd *real,
 =09return 0;
 }
=20
-static int ovl_real_fdget(const struct file *file, struct fd *real)
+static int ovl_real_fdget(struct file *file, struct fd *real)
 {
 =09return ovl_real_fdget_meta(file, real, false);
 }
@@ -144,25 +177,36 @@ static int ovl_open(struct inode *inode, struct file =
*file)
 =09struct file *realfile;
 =09int err;
=20
+=09file->private_data =3D kzalloc(sizeof(struct ovl_file_entry), GFP_KERNE=
L);
+=09if (!file->private_data)
+=09=09return -ENOMEM;
+
 =09err =3D ovl_maybe_copy_up(file_dentry(file), file->f_flags);
 =09if (err)
-=09=09return err;
+=09=09goto out;
=20
 =09/* No longer need these flags, so don't pass them on to underlying fs *=
/
 =09file->f_flags &=3D ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
=20
 =09realfile =3D ovl_open_realfile(file, ovl_inode_realdata(inode));
-=09if (IS_ERR(realfile))
-=09=09return PTR_ERR(realfile);
-
-=09file->private_data =3D realfile;
+=09if (IS_ERR(realfile)) {
+=09=09err =3D PTR_ERR(realfile);
+=09=09goto out;
+=09}
=20
+=09ovl_set_realfile(file, realfile);
 =09return 0;
+out:
+=09kfree(file->private_data);
+=09file->private_data =3D NULL;
+=09return err;
 }
=20
 static int ovl_release(struct inode *inode, struct file *file)
 {
-=09fput(file->private_data);
+=09fput(ovl_get_realfile(file));
+=09kfree(file->private_data);
+=09file->private_data =3D NULL;
=20
 =09return 0;
 }
@@ -451,7 +495,7 @@ static int ovl_fsync(struct file *file, loff_t start, l=
off_t end, int datasync)
=20
 static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
-=09struct file *realfile =3D file->private_data;
+=09struct file *realfile =3D ovl_get_realfile(file);
 =09const struct cred *old_cred;
 =09int ret;
=20
--=20
2.20.1


