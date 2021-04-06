Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D988C433ED
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Apr 2021 12:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68A4261019
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Apr 2021 12:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbhDFMDt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:03:49 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17142 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343673AbhDFMDt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Apr 2021 08:03:49 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617710601; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=DJy2HS+STEFbphS39VVlMXWLXWgMSUOCZYYQuV0PZhZPOoLTj2eNQFFP1hOPKpYCIxAYKB1z0Ob5mgYh4TFxO6CGL5VQv/l6L0mcJ+Hd6XCQuDIDTF8CTQJeMrNPwrgA8VOjT2kRd48uSlq2bRNJwfgZsJG/2OFnm7/hik+yJRA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617710601; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=lIXr3E+y/DgwAT9nPB0/GjR9wSthraXe9d8xSr7y534=; 
        b=L4roNiomQxmO3+YLigheRaFrL9dh3IUCg31korZwMAsO9Ma2px2FLh+otXYBj/9yRZy8LSmssffTz7XdMwduYDtH9c/eOe3XaO34g/0Oa4ouPaANhaV1/qXuy1MTVpbmtIlScVoW4GO9HsBCHpe9V5EcyjhRsAcMKeutU2I5GAc=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617710601;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=lIXr3E+y/DgwAT9nPB0/GjR9wSthraXe9d8xSr7y534=;
        b=TO+SZk+RFUyhd5gvqeuN5aGuw+N4Q9h54o3sfMIie0VxRGtMAtzgjX5QgRsoaN+b
        e56z311otAwVTCX8TlLT4lELqncQUto89VivnavlmRS9THrnaJvYqjnyTTvQ4BgZIwG
        0LMRqPVVj4SxPz1dIKL6eSlheCJcsBE+7Z4+jVNU=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 161771059894640.939109746453596; Tue, 6 Apr 2021 20:03:18 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210406120245.1338326-1-cgxu519@mykernel.net>
Subject: [PATCH v2 1/3] ovl: do not restore mtime on copy-up for regular file
Date:   Tue,  6 Apr 2021 20:02:43 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In order to simplify truncate operation on the file which
only has lower, we skip restoring mtime on copy-up for
regular file.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/copy_up.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0fed532efa68..8b92b3ba3c46 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -241,12 +241,17 @@ static int ovl_set_size(struct dentry *upperdentry, s=
truct kstat *stat)
=20
 static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *st=
at)
 {
-=09struct iattr attr =3D {
-=09=09.ia_valid =3D
-=09=09     ATTR_ATIME | ATTR_MTIME | ATTR_ATIME_SET | ATTR_MTIME_SET,
-=09=09.ia_atime =3D stat->atime,
-=09=09.ia_mtime =3D stat->mtime,
-=09};
+=09struct iattr attr;
+
+=09if (S_ISREG(upperdentry->d_inode->i_mode)) {
+=09=09attr.ia_valid =3D ATTR_ATIME | ATTR_ATIME_SET;
+=09=09attr.ia_atime =3D stat->atime;
+=09} else {
+=09=09attr.ia_valid =3D ATTR_ATIME | ATTR_MTIME |
+=09=09=09=09ATTR_ATIME_SET | ATTR_MTIME_SET;
+=09=09attr.ia_atime =3D stat->atime;
+=09=09attr.ia_mtime =3D stat->mtime;
+=09}
=20
 =09return notify_change(upperdentry, &attr, NULL);
 }
--=20
2.27.0


