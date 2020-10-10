Return-Path: <SRS0=hnjk=DR=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A2F7C43467
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Oct 2020 22:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6932067C
	for <linux-unionfs@archiver.kernel.org>; Sat, 10 Oct 2020 22:58:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="WPb2nDBf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390710AbgJJW60 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:58:26 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17111 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732184AbgJJW3Z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Oct 2020 18:29:25 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1602339878; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=m1cEkTT0H0XlIYFWEQ1mMaQITIgAc/1m5MQHrP7lXXbtUH6efdVU5U/flqDIY8z2wIMIeENjK7bulU1yy/EYuMpR9Ze+atX55KMhotMDuxG5JVktiq7eain/c1j9UKpWQO7UtyNP5ulODoLsjeanPLP0FkzzrC/SP8YUW3pgyTQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1602339878; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=WuNBrvX2uD8I7aJAM8pNl5RG9FDOvIp9lUEoRwUTYSE=; 
        b=kpWzpyCK4Xs/Az2uQ2GgguNOKzbVoYwhAuGJKYH4Zb8aNCeA9p1iDOk6LspAm2vhcrSZI+8th1ZSEmUJItdma73EUuH0t4ahoiQTm/YtoO+IeU9kmXTWvkHw4TuuR7iRf3dWeypfupVOnSAfo9Et4SgEWoflokqsGJdOjav6cZk=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1602339878;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=WuNBrvX2uD8I7aJAM8pNl5RG9FDOvIp9lUEoRwUTYSE=;
        b=WPb2nDBfZnsUVbmRjUbUgW2AHk2H/MyFfsv+6LhkLqH3x0K/JqZzV8gqUqdRRfhx
        7qwQgPwv2QyO5KTo3969rbYBbwrNZrdSyCr/xxeqgPNiRYz35n2Jq0l1Yb4mQQcawqc
        Mkdc75BwyToPcoB8VPm8nFAJ7quk4JX/aKkFJuo0=
Received: from localhost.localdomain (113.116.157.74 [113.116.157.74]) by mx.zoho.com.cn
        with SMTPS id 1602339877096718.8354649829215; Sat, 10 Oct 2020 22:24:37 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, amir73il@gmail.com, jack@suse.cz
Cc:     linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20201010142355.741645-4-cgxu519@mykernel.net>
Subject: [RFC PATCH 3/5] ovl: setup overlayfs' private bdi
Date:   Sat, 10 Oct 2020 22:23:53 +0800
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201010142355.741645-1-cgxu519@mykernel.net>
References: <20201010142355.741645-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Setup private bdi to collect overlayfs' dirty inodes.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 290983b..dc22725 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1863,6 +1863,9 @@ static int ovl_fill_super(struct super_block *sb, voi=
d *data, int silent)
 =09int err;
=20
 =09sb->s_d_op =3D &ovl_dentry_operations;
+=09err =3D super_setup_bdi(sb);
+=09if (err)
+=09=09goto out;
=20
 =09err =3D -ENOMEM;
 =09ofs =3D kzalloc(sizeof(struct ovl_fs), GFP_KERNEL);
--=20
1.8.3.1


