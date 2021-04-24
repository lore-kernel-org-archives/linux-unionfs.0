Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C371C433B4
	for <linux-unionfs@archiver.kernel.org>; Sat, 24 Apr 2021 14:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D0351614A7
	for <linux-unionfs@archiver.kernel.org>; Sat, 24 Apr 2021 14:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhDXOHF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 24 Apr 2021 10:07:05 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17109 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238056AbhDXOEp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 24 Apr 2021 10:04:45 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1619273037; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=aw1uNQKm+lclRfDoFl9A92VvG1sjtjoFi5F2KkO4Kb2VvCw2x8tpk5GxDbef7GhjYG3tCqQweFA+NM9Uk7UHCyv/izzBCCOgad82x5HTNRrFNKEOvrSaECoJJCOCosS1PXFxOjGKyJInvaZ5rjuUKaElQvYZogUjw8zX8S9dQ+0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1619273037; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=DLyFUVZEVGrNMvopQICBA0uayw7m1MLk32GJMNo9GC0=; 
        b=okRCVcnXk2OMD4rFB+amUqV0ZDeKawPR+MW7mIRZiTUK6AjER49Jp0qm09qliFAQSMenLbPlw/mLOJj2glTsAVQuYynJ2qK3KyrsaX3jtkTCENudvl8z2Ba/936x0BAi53GM9cmkzvDlFbFP1nvX5NXvCQ7w6/gm5nhqxChL+D4=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1619273037;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=DLyFUVZEVGrNMvopQICBA0uayw7m1MLk32GJMNo9GC0=;
        b=MYaRK6zkqfFiwKlDZBQfGpmwnK5WY37GO9NT/4x2EMu8kzZ8W5knGQ4At2n5Vpnv
        ID6jXSwB53d5WAp5zhMyjQAYelzkjR+v1wME00zF0VctVFPcaK9AymDE1IdwQNxXVqF
        wGrq4FzporL8c1zBer1NE+xtTHBDxjx/EW7xsjd0=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1619273035620313.50233205996597; Sat, 24 Apr 2021 22:03:55 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210424140316.485444-2-cgxu519@mykernel.net>
Subject: [RFC PATCH 2/2] ovl: enhance write permission check for writable open
Date:   Sat, 24 Apr 2021 22:03:16 +0800
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210424140316.485444-1-cgxu519@mykernel.net>
References: <20210424140316.485444-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Check upper file's write permission when open on writable mode.

NOTE: lower files may be shared between differnt overlayfs instances,
so we skip the check of lower file to avoid introducing interferes.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 6e454a294046..1c3c24d07d01 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -144,12 +144,18 @@ static int ovl_real_fdget(const struct file *file, st=
ruct fd *real)
 static int ovl_open(struct inode *inode, struct file *file)
 {
 =09struct file *realfile;
+=09struct inode *upperinode;
 =09int err;
=20
 =09err =3D ovl_maybe_copy_up(file_dentry(file), file->f_flags);
 =09if (err)
 =09=09return err;
=20
+=09upperinode =3D ovl_inode_upper(inode);
+=09if (((file->f_mode & FMODE_WRITE) || file->f_flags & O_TRUNC) &&
+=09    (upperinode && atomic_read(&upperinode->i_writecount) < 0))
+=09=09return -ETXTBSY;
+
 =09/* No longer need these flags, so don't pass them on to underlying fs *=
/
 =09file->f_flags &=3D ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
=20
--=20
2.27.0


