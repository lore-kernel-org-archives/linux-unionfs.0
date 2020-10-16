Return-Path: <SRS0=VTpt=DX=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AC1C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Oct 2020 15:49:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3EAA2083B
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Oct 2020 15:49:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="fBI9dPgA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407025AbgJPPtf (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Oct 2020 11:49:35 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17159 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406687AbgJPPtf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Oct 2020 11:49:35 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602863354; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=n8n+T9suWdA+MP6k+ouomSl0/y5nqRXlbajHZ4DYtBihhFJYiN+efSabqqicH2RTj/mg00h95VNx8FW6ZO/Ymoc7hJRG5nWzYY8ZaLAORYkbv5FFSbfWFHFLVgYLSVjzmoQglGvbULQAWsRjjMrY74TQCpKTSfduoWcyvyTctOw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1602863354; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=WzcysgbH6jSlo6zzm50b5GIwTt5zoaIlP4opho722+4=; 
        b=c5Kkqg4d24kf94TtL6VxL0Ob9Epelj94O3+degOmvkL2xRUp+UDCtskd3hRY9epnpfqPKh0Bem1HjcaIQA864Fv8rJJz+Nin2YfmhhAMURqyZHz+vXogAsD2nGnnDXLa+0yM7dWTe9Rxkz4BkMiejicf7+YQmBE0mU8OGrTR4/M=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1602863354;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=WzcysgbH6jSlo6zzm50b5GIwTt5zoaIlP4opho722+4=;
        b=fBI9dPgAHrlFq+cq/Bb24EDHKc2mEheOKCa8vChKFZL8pKhSOOqp8MFvTXNnlI6F
        xgvJF5rNf+zUGPLtDzkiaw2Fm46pPrlbmTPjRSEQghMqAkynLWbxHcMc8RvMymZpCIU
        Z0gIMmKYL9uGPD/DN1YY+otpzsMNd+WCvd7cI3/4=
Received: from localhost.localdomain (113.87.91.106 [113.87.91.106]) by mx.zoho.com.cn
        with SMTPS id 1602863350971138.31672795862335; Fri, 16 Oct 2020 23:49:10 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, root <root@localhost.localdomain>
Message-ID: <20201016154852.2958-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: stacked file operation for mmap
Date:   Fri, 16 Oct 2020 23:48:52 +0800
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: root <root@localhost.localdomain>

Currently only mmap does not behave as stacked file operation,
although in practice there is less change to open a file in
RDONLY mode and take long time to do mmap but the fix looks
reasonable.

Signed-off-by: root <root@localhost.localdomain>
---
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


