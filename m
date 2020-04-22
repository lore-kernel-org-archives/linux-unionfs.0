Return-Path: <SRS0=lkgI=6G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB837C38A30
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 04:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3ADA32064C
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 04:29:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="dO4WKPUg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgDVE3v (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 00:29:51 -0400
Received: from [163.53.93.247] ([163.53.93.247]:21173 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgDVE3u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Apr 2020 00:29:50 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1587529743; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=DiurC1J6JdAIDFnRSs+0VohKD7Xp4UOKhKXKzcA2e5aRW8BrCfah2cLPRx3E8wij2xVA9gsix+m9V8/qpTZzGEfKcckxdPfIXL0PLw7+9IXhgNs92WTsdFpM0z3c2cITQ8cquKHoUw7Yf2kJw+c1b3NWK82RZ5LFdWqloRDcdZI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1587529743; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=CxUVpAhlJ/WDB7EZdJuIlJt5pxmCdpMkpUMEDIbbKhU=; 
        b=NnUHx1dFdDGKtfv6kGPcguRWy30mrXukugAjqB4Y9KfjDX2JVDndkJX86qjtNTqXmhkDu0qZ8Mu/SmFJA7noOYCPKbJTSUFliNuQJvREVBApw+FB4i9rsygAORPYCw9aXIk+uKvGbTGTclCtVtze9At/zkFJkIDXFwhxNj2nXZY=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1587529743;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=CxUVpAhlJ/WDB7EZdJuIlJt5pxmCdpMkpUMEDIbbKhU=;
        b=dO4WKPUgWFAvoZKwgA0BuU6SuFlnG94m6rbZPkkpO7zQpQOHoD88S2KcrG9u3rL/
        RpGii/wZdYLAhDF9NTafvCA0ZFn8iRBdgGKS4YnIwmkB4affjZSHmaM6QV1t/Knv929
        0oBAArx05FVRcENvtSoSBRPq2u/qlo8cpdWrEeQY=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 158752974185819.696338531126344; Wed, 22 Apr 2020 12:29:01 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200422042843.4881-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: sync dirty data when remounting to ro mode
Date:   Wed, 22 Apr 2020 12:28:43 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

sync_filesystem() does not sync dirty data for readonly
filesystem during umount, so before changing to readonly
filesystem we should sync dirty data for data integrity.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/super.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f57aa348dcd6..1bab326342bc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -364,11 +364,20 @@ static int ovl_show_options(struct seq_file *m, struc=
t dentry *dentry)
 static int ovl_remount(struct super_block *sb, int *flags, char *data)
 {
 =09struct ovl_fs *ofs =3D sb->s_fs_info;
+=09struct super_block *upper_sb;
+=09int ret =3D 0;
=20
 =09if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
 =09=09return -EROFS;
=20
-=09return 0;
+=09if (*flags & SB_RDONLY && !sb_rdonly(sb)) {
+=09=09upper_sb =3D ofs->upper_mnt->mnt_sb;
+=09=09down_read(&upper_sb->s_umount);
+=09=09ret =3D sync_filesystem(upper_sb);
+=09=09up_read(&upper_sb->s_umount);
+=09}
+
+=09return ret;
 }
=20
 static const struct super_operations ovl_super_operations =3D {
--=20
2.20.1


