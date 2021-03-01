Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8B6C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Mar 2021 06:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50E5760230
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Mar 2021 06:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbhCAGWO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 01:22:14 -0500
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17169 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231308AbhCAGVD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Mar 2021 01:21:03 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1614579596; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=UP3tS6VnfqpjSXwBcDnHWyl6p9MdDijj1GrgUpOQxKTl87A+ZFO0haVcV7j5QHVNzbSj6468Ry+0l+e7Uw/hV1aVjvbevCTaL2GlyWijkzGDGFkm3uj4qRa3bPNdgRx30HqqLC+D5r+ejY2ox4ghH20zi0RxsOfX+qAK85VDThw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1614579596; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=hJYrCj6gWlpMPDLmoiB19rNT6uRwMZZx/P/09yuSSRo=; 
        b=lDZH9yXjRmpSJPqoeeN3Vlc4/hI15he4AoS8EMlhAVUujsoSArM91pIewmXQ+aowPS1UVvkOYO5H1PszKpZr2GXi/0cRRKZF3vqyGNoTPcDAZZ0lPM7DICs1mocUtmXwx7PUWKRRj2jlfm1o5LfZSzQCYC6XBLL3iQD6djXRkno=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1614579596;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=hJYrCj6gWlpMPDLmoiB19rNT6uRwMZZx/P/09yuSSRo=;
        b=c11RI3IjD2c8EXczlZ82oDcyqoaREuL18p7DCkvRqxs/sgZ0vlalSqDHup2BNcmX
        RR/SPWepf6vd8cmcBFdMhcksDWJS+TMOivV+LrNGtUW7/ren7wx1PSCiPqGCveux94V
        efV3vzLcAvTQoZjytGwaOPl1S05Obly4zMPIEqAk=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1614579594927560.5513261855243; Mon, 1 Mar 2021 14:19:54 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210301061930.3459022-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: fix error for ovl_fill_super()
Date:   Mon,  1 Mar 2021 14:19:30 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

There are some places should return -EINVAL instead of
-ENOMEM in ovl_fill_super(), so just fix it.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fdd72f1a9c5e..3dda1d530a43 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1984,6 +1984,7 @@ static int ovl_fill_super(struct super_block *sb, voi=
d *data, int silent)
 =09if (numlower > OVL_MAX_STACK) {
 =09=09pr_err("too many lower directories, limit is %d\n",
 =09=09       OVL_MAX_STACK);
+=09=09err =3D -EINVAL;
 =09=09goto out_err;
 =09}
=20
@@ -2010,6 +2011,7 @@ static int ovl_fill_super(struct super_block *sb, voi=
d *data, int silent)
 =09/* alloc/destroy_inode needed for setting up traps in inode cache */
 =09sb->s_op =3D &ovl_super_operations;
=20
+=09err =3D -EINVAL;
 =09if (ofs->config.upperdir) {
 =09=09struct super_block *upper_sb;
=20
--=20
2.27.0


