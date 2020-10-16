Return-Path: <SRS0=VTpt=DX=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BBAC433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Oct 2020 15:58:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B02620848
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Oct 2020 15:58:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="U5rcshbN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408875AbgJPP6z (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Oct 2020 11:58:55 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17165 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408468AbgJPP6y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Oct 2020 11:58:54 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602863918; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=WMZ32MmdBbXMukDSAjv4SAGMMzvLh5w1J9Mrpt1RF6DQGEQ89zovueGFK0W1QHeTJlGvqn9YEHmKb77JMbey/ApYLFgJIIqNle7uKYpHm2v517y7D2hk7wnlYiybq4zgONSswMdbCDSIavcZpKzcKdPomLmYchYkeSXHALuGOqI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1602863918; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=D+BYup5SjdGSe8fL4ngX+fL6lJp1PTHREgcJLLy7jSs=; 
        b=Nrsp6cu28y23qZC2+nkIhcKlZUluaSsp7BYyCgLvKKhaCFmUjdYwf2ZEpJaWq0C9BjUKqXF2H+xiTDdWGTKgAMOkNL+QTuNXVSPZfg93nhcINc5LmqT91AaDZZBpmjjB3f1Z/CSrDDsp32Ge8/T3cJghfV47RACtRQKHHjVXB/8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1602863918;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=D+BYup5SjdGSe8fL4ngX+fL6lJp1PTHREgcJLLy7jSs=;
        b=U5rcshbNwzVQ/jyZGiqiqBO2R02dk6bG0jlvAfW605u5aZIac4il8krDdm+emD0y
        tziurpPfMB2GgtzAogjmCBZQddBawWwxZmCuVEGXaKNFMKdE6dX1/Y5zhImpdwHTqgt
        FibzNMyNuBLRzXt2Dbi0x+Tkz5bHGvvLr+Z/Ei0w=
Received: from localhost.localdomain (113.87.91.106 [113.87.91.106]) by mx.zoho.com.cn
        with SMTPS id 1602863916944265.6741588399975; Fri, 16 Oct 2020 23:58:36 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20201016155745.2876-1-cgxu519@mykernel.net>
Subject: (RESEND) [PATCH] ovl: stacked file operation for mmap
Date:   Fri, 16 Oct 2020 23:57:45 +0800
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Currently only mmap does not behave as stacked file operation,
although in practice there is less change to open a file in
RDONLY mode and take long time to do mmap but the fix looks
reasonable.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
Hi Miklos,

I'm sorry that I did a mistake about signed-off-by tag in previous
email, so I resend this patch.

 fs/overlayfs/file.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 3582c3ae819c..f98b1c0c975b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -461,6 +461,7 @@ static int ovl_mmap(struct file *file, struct vm_area_s=
truct *vma)
 {
 =09struct file *realfile =3D file->private_data;
 =09const struct cred *old_cred;
+=09struct fd real;
 =09int ret;
=20
 =09if (!realfile->f_op->mmap)
@@ -469,7 +470,11 @@ static int ovl_mmap(struct file *file, struct vm_area_=
struct *vma)
 =09if (WARN_ON(file !=3D vma->vm_file))
 =09=09return -EIO;
=20
-=09vma->vm_file =3D get_file(realfile);
+=09ret =3D ovl_real_fdget(file, &real);
+=09if (ret)
+=09=09return ret;
+
+=09vma->vm_file =3D get_file(real.file);
=20
 =09old_cred =3D ovl_override_creds(file_inode(file)->i_sb);
 =09ret =3D call_mmap(vma->vm_file, vma);
@@ -477,13 +482,14 @@ static int ovl_mmap(struct file *file, struct vm_area=
_struct *vma)
=20
 =09if (ret) {
 =09=09/* Drop reference count from new vm_file value */
-=09=09fput(realfile);
+=09=09fput(real.file);
 =09} else {
 =09=09/* Drop reference count from previous vm_file value */
 =09=09fput(file);
 =09}
=20
 =09ovl_file_accessed(file);
+=09fdput(real);
=20
 =09return ret;
 }
--=20
2.26.2


