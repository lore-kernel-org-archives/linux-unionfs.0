Return-Path: <SRS0=cJ4F=CH=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1210CC433E2
	for <linux-unionfs@archiver.kernel.org>; Sat, 29 Aug 2020 09:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFEC52075B
	for <linux-unionfs@archiver.kernel.org>; Sat, 29 Aug 2020 09:52:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="GYosXaKl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgH2JwF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 05:52:05 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17174 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726258AbgH2JwE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 29 Aug 2020 05:52:04 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1598694696; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=fyRT+djDryfSE/6F0Efu1feLw+nHWukrW/zuhcD7eFm1a893S3BOWn1nszwx+9oJDsBGqY62gEzTWPeZx0/KRoIpvUhg35Db5JhXA1fkoe5Yol3INpe3SBhagvNNol9qz74a7iWaC6cQj39dl19aDAwfyvDJOWmjj4umpc/hhoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1598694696; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=ObZqteZmBQYgsDj6DtN0x+jII/ZXa3ZgcjVA/akvIO4=; 
        b=ORZk9SmyGVtUk62QrrdZQFN7RD7D3XvuJyALOdgkWYLFRXYJ0l6IqijUnQlGqLoW+yRRsCVrLNy030oVg0ap3wVS5M9Q82aluIAC0LCK63jnwd0vBZT4SGyoqtfLpOtxCrwMz4wox3rcqfHmfLPDzu3dMTIbjWBdup05usD9ggc=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1598694696;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=ObZqteZmBQYgsDj6DtN0x+jII/ZXa3ZgcjVA/akvIO4=;
        b=GYosXaKltMEFZfeEXC/NEjJNlCOrEp7lZsf5MunZz8JVw2KCe0hHF+A0KomLuB8S
        YqyJqpT17r7wcqavEx3sfTGjHkUWqsVtsBQcDLAYERVHj/RJlaergT86Fm2GvTXrrkq
        onqWnvkDCVF3exTL71pIXlrNv9K3azGZxOPiyMmc=
Received: from localhost.localdomain (116.30.194.36 [116.30.194.36]) by mx.zoho.com.cn
        with SMTPS id 1598694693783332.6777969196331; Sat, 29 Aug 2020 17:51:33 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     linux-unionfs@vger.kernel.org, linux-mm@kvack.org
Cc:     miklos@szeredi.hu, akpm@linux-foundation.org, amir73il@gmail.com,
        riteshh@linux.ibm.com, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200829095101.25350-4-cgxu519@mykernel.net>
Subject: [RFC PATCH 3/3] ovl: implement stacked mmap for shared map
Date:   Sat, 29 Aug 2020 17:51:01 +0800
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

Implement stacked mmap for shared map to keep data
consistency.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/file.c | 120 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 114 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 14ab5344a918..db5ab200d984 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -21,9 +21,17 @@ struct ovl_aio_req {
 =09struct fd fd;
 };
=20
+static vm_fault_t ovl_fault(struct vm_fault *vmf);
+static vm_fault_t ovl_page_mkwrite(struct vm_fault *vmf);
+
+static const struct vm_operations_struct ovl_vm_ops =3D {
+=09.fault=09=09=3D ovl_fault,
+=09.page_mkwrite=09=3D ovl_page_mkwrite,
+};
+
 struct ovl_file_entry {
 =09struct file *realfile;
-=09void *vm_ops;
+=09const struct vm_operations_struct *vm_ops;
 };
=20
 struct file *ovl_get_realfile(struct file *file)
@@ -40,14 +48,15 @@ void ovl_set_realfile(struct file *file, struct file *r=
ealfile)
 =09ofe->realfile =3D realfile;
 }
=20
-void *ovl_get_real_vmops(struct file *file)
+const struct vm_operations_struct *ovl_get_real_vmops(struct file *file)
 {
 =09struct ovl_file_entry *ofe =3D file->private_data;
=20
 =09return ofe->vm_ops;
 }
=20
-void ovl_set_real_vmops(struct file *file, void *vm_ops)
+void ovl_set_real_vmops(struct file *file,
+=09=09=09const struct vm_operations_struct *vm_ops)
 {
 =09struct ovl_file_entry *ofe =3D file->private_data;
=20
@@ -493,11 +502,104 @@ static int ovl_fsync(struct file *file, loff_t start=
, loff_t end, int datasync)
 =09return ret;
 }
=20
+vm_fault_t ovl_fault(struct vm_fault *vmf)
+{
+=09struct vm_area_struct *vma =3D vmf->vma;
+=09struct file *file =3D vma->vm_file;
+=09struct file *realfile;
+=09struct file *fpin, *tmp;
+=09struct inode *inode =3D file_inode(file);
+=09struct inode *realinode;
+=09const struct cred *old_cred;
+=09bool retry_allowed;
+=09vm_fault_t ret;
+=09int err =3D 0;
+
+=09if (fault_flag_check(vmf, FAULT_FLAG_TRIED)) {
+=09=09realfile =3D ovl_get_realfile(file);
+
+=09=09if (!ovl_has_upperdata(inode) ||
+=09=09    realfile->f_inode !=3D ovl_inode_upper(inode) ||
+=09=09    !realfile->f_op->mmap)
+=09=09=09return VM_FAULT_SIGBUS;
+
+=09=09if (!ovl_get_real_vmops(file)) {
+=09=09=09old_cred =3D ovl_override_creds(inode->i_sb);
+=09=09=09err =3D call_mmap(realfile, vma);
+=09=09=09revert_creds(old_cred);
+
+=09=09=09vma->vm_file =3D file;
+=09=09=09if (err) {
+=09=09=09=09vma->vm_ops =3D &ovl_vm_ops;
+=09=09=09=09return VM_FAULT_SIGBUS;
+=09=09=09}
+=09=09=09ovl_set_real_vmops(file, vma->vm_ops);
+=09=09=09vma->vm_ops =3D &ovl_vm_ops;
+=09=09}
+
+=09=09retry_allowed =3D fault_flag_check(vmf, FAULT_FLAG_ALLOW_RETRY);
+=09=09if (retry_allowed)
+=09=09=09vma->vm_flags &=3D ~FAULT_FLAG_ALLOW_RETRY;
+=09=09vma->vm_file =3D realfile;
+=09=09ret =3D ovl_get_real_vmops(file)->fault(vmf);
+=09=09vma->vm_file =3D file;
+=09=09if (retry_allowed)
+=09=09=09vma->vm_flags |=3D FAULT_FLAG_ALLOW_RETRY;
+=09=09return ret;
+
+=09} else {
+=09=09fpin =3D maybe_unlock_mmap_for_io(vmf, NULL);
+=09=09if (!fpin)
+=09=09=09return VM_FAULT_SIGBUS;
+
+=09=09ret =3D VM_FAULT_RETRY;
+=09=09if (!ovl_has_upperdata(inode)) {
+=09=09=09err =3D ovl_copy_up_with_data(file->f_path.dentry);
+=09=09=09if (err)
+=09=09=09=09goto out;
+=09=09}
+
+=09=09realinode =3D ovl_inode_realdata(inode);
+=09=09realfile =3D ovl_open_realfile(file, realinode);
+=09=09if (IS_ERR(realfile))
+=09=09=09goto out;
+
+=09=09tmp =3D ovl_get_realfile(file);
+=09=09ovl_set_realfile(file, realfile);
+=09=09fput(tmp);
+
+out:
+=09=09fput(fpin);
+=09=09return ret;
+=09}
+}
+
+static vm_fault_t ovl_page_mkwrite(struct vm_fault *vmf)
+{
+=09struct vm_area_struct *vma =3D vmf->vma;
+=09struct file *file =3D vma->vm_file;
+=09struct file *realfile;
+=09struct inode *inode =3D file_inode(file);
+=09vm_fault_t ret;
+
+=09realfile =3D ovl_get_realfile(file);
+
+=09sb_start_pagefault(inode->i_sb);
+=09file_update_time(file);
+
+=09vma->vm_file =3D realfile;
+=09ret =3D ovl_get_real_vmops(file)->page_mkwrite(vmf);
+=09vma->vm_file =3D file;
+
+=09sb_end_pagefault(inode->i_sb);
+=09return ret;
+}
+
 static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
 =09struct file *realfile =3D ovl_get_realfile(file);
 =09const struct cred *old_cred;
-=09int ret;
+=09int ret =3D 0;
=20
 =09if (!realfile->f_op->mmap)
 =09=09return -ENODEV;
@@ -505,6 +607,13 @@ static int ovl_mmap(struct file *file, struct vm_area_=
struct *vma)
 =09if (WARN_ON(file !=3D vma->vm_file))
 =09=09return -EIO;
=20
+=09if (!ovl_has_upperdata(file_inode(file)) &&
+=09    (vma->vm_flags & (VM_SHARED|VM_MAYSHARE))) {
+=09=09vma->vm_ops =3D &ovl_vm_ops;
+=09=09ovl_file_accessed(file);
+=09=09return 0;
+=09}
+
 =09vma->vm_file =3D get_file(realfile);
=20
 =09old_cred =3D ovl_override_creds(file_inode(file)->i_sb);
@@ -517,10 +626,9 @@ static int ovl_mmap(struct file *file, struct vm_area_=
struct *vma)
 =09} else {
 =09=09/* Drop reference count from previous vm_file value */
 =09=09fput(file);
+=09=09ovl_file_accessed(file);
 =09}
=20
-=09ovl_file_accessed(file);
-
 =09return ret;
 }
=20
--=20
2.20.1


