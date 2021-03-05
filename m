Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE3FFC433E6
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Mar 2021 13:49:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C74B65016
	for <linux-unionfs@archiver.kernel.org>; Fri,  5 Mar 2021 13:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbhCENso (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 08:48:44 -0500
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17117 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229723AbhCENsd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 5 Mar 2021 08:48:33 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1614952084; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=lsL2+dVl6uuOKunmDKJkoe2kM8RQzb6oEXP7k0LlOChgPuXC5xHH2egZEtuMqWI0u7nG9PpGX4AULSYwPKKGxvhhBMVbIS6in+t3BYDJGSQDPj41xrchTf/455RXXzAXx2p6rhPBnM2nME5Ocg4/w0wGsUSHMIlLmOQcdtkotKc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1614952084; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=tUAwFnHcryHuwIOnmIRDvgf0nRig+8L4gWdWZLEmXRI=; 
        b=JRtcZqNy4uPCzPj4ezrdSx1GfmM9UyDjip4GmIDXebmfFqqieAXzQm1dcPBcTF0LeoHb+CRGRP+TMeoYlsO1mZWaTAKphLXdhJXMUeYZ4bxQCfUXWaddHYovxUQP4XY2Y2CgBh2eHGQUTIM9gHf2kMEPOyLgD300zsZxLrxmErA=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1614952084;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=tUAwFnHcryHuwIOnmIRDvgf0nRig+8L4gWdWZLEmXRI=;
        b=LfDTp4I5SKHnXF2XG8jxRJrk0FL7n/SD7beWCswzpcWynTtTCxz9l3iiJMN2JyQq
        CfoEaL+H4MC0XvQXuj1mYGvPUWUGnrSx0PxP1u1TDgAIluVC+YWVNKkANxxIpsfk3tI
        hb6ngrTxTcwKt8DpjjnD3A21ruvxkqug7+K6OHgA=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1614952082737392.6320680650516; Fri, 5 Mar 2021 21:48:02 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>,
        Amir Goldstein <amir73il@gmail.com>
Message-ID: <20210305134737.1259372-1-cgxu519@mykernel.net>
Subject: [PATCH v2] ovl: fix error code for ovl_fill_super()
Date:   Fri,  5 Mar 2021 21:47:37 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Fix some incorrect error codes for ovl_fill_super() and
change to set error code in a consistent way.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fdd72f1a9c5e..458cf471c25b 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1980,6 +1980,7 @@ static int ovl_fill_super(struct super_block *sb, voi=
d *data, int silent)
 =09if (!splitlower)
 =09=09goto out_err;
=20
+=09err =3D -EINVAL;
 =09numlower =3D ovl_split_lowerdirs(splitlower);
 =09if (numlower > OVL_MAX_STACK) {
 =09=09pr_err("too many lower directories, limit is %d\n",
@@ -1987,6 +1988,7 @@ static int ovl_fill_super(struct super_block *sb, voi=
d *data, int silent)
 =09=09goto out_err;
 =09}
=20
+=09err =3D -ENOMEM;
 =09layers =3D kcalloc(numlower + 1, sizeof(struct ovl_layer), GFP_KERNEL);
 =09if (!layers)
 =09=09goto out_err;
@@ -2013,6 +2015,7 @@ static int ovl_fill_super(struct super_block *sb, voi=
d *data, int silent)
 =09if (ofs->config.upperdir) {
 =09=09struct super_block *upper_sb;
=20
+=09=09err =3D -EINVAL;
 =09=09if (!ofs->config.workdir) {
 =09=09=09pr_err("missing 'workdir'\n");
 =09=09=09goto out_err;
@@ -2022,11 +2025,11 @@ static int ovl_fill_super(struct super_block *sb, v=
oid *data, int silent)
 =09=09if (err)
 =09=09=09goto out_err;
=20
+=09=09err =3D -EIO;
 =09=09upper_sb =3D ovl_upper_mnt(ofs)->mnt_sb;
 =09=09if (!ovl_should_sync(ofs)) {
 =09=09=09ofs->errseq =3D errseq_sample(&upper_sb->s_wb_err);
 =09=09=09if (errseq_check(&upper_sb->s_wb_err, ofs->errseq)) {
-=09=09=09=09err =3D -EIO;
 =09=09=09=09pr_err("Cannot mount volatile when upperdir has an unseen erro=
r. Sync upperdir fs to clear state.\n");
 =09=09=09=09goto out_err;
 =09=09=09}
--=20
2.27.0


