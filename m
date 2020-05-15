Return-Path: <SRS0=KPW4=65=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48707C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 May 2020 07:22:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DDB72065F
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 May 2020 07:22:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="DUvQrPgV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbgEOHWa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 15 May 2020 03:22:30 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21135 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbgEOHW3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 May 2020 03:22:29 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589527312; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=maG4CChuV70ufvyzozEvm1K24WH8QAe0i7s8MDgKz+Oo9fWFNPDpT0a4dR/YxH99FrmMApoF9ke7yi4WM1Mz0+01M1X75v45dh2oKxI86A0vzKsg+ojG8VVr61yoQ0tleeMBBVMSTSchf6U+oFnyuR/bsaOxuGSvK5k/Ggj3WG0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589527312; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=xUFcLyWr4D8q4EQRC/9G8D3ERMkZBUzlZqLURVLHOP8=; 
        b=n8ZIefAncCbit8tq8y7jyrsnBvFMlCdAn9VBaxt7x6Wp0bcNIrnk/dqBNnOPBWaI+1kne9TZotSTVTdNlXol++2cVw9AaSIGM6jSlyQeLohkRwfSMDp5iXTSEgQgsrx6PzkX4T4eqJxofE1mTrkfbWwJYMwC467cqHJkzMRfCQQ=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589527312;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=xUFcLyWr4D8q4EQRC/9G8D3ERMkZBUzlZqLURVLHOP8=;
        b=DUvQrPgVk+bvT+BlHUbjK6vPj3wVxyTBBisJOVMT9sNr0ubRuvSuaVkC6CataIkN
        tOBtYsquB8fTmn615t2ZZ9ddCL+yJqWVP7qRLY24Jew1GfQ7naqLQlMSSja9qZwltzW
        wIkBScdk7Du+SKygRCfkuyDle4iAEz4YlFBj7R6E=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1589527309583206.8447354867062; Fri, 15 May 2020 15:21:49 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, viro@zeniv.linux.org.uk, amir73il@gmail.com
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200515072047.31454-10-cgxu519@mykernel.net>
Subject: [RFC PATCH v3 9/9] quota: Adjust argument for lookup_positive_unlocked()
Date:   Fri, 15 May 2020 15:20:47 +0800
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200515072047.31454-1-cgxu519@mykernel.net>
References: <20200515072047.31454-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Set 0 as lookup flag argument when calling lookup_positive_unlocked(),
because we don't hope to drop negative dentry in lookup.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/quota/dquot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index b6a4f692d345..8d6c32f75a4d 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2488,7 +2488,8 @@ int dquot_quota_on_mount(struct super_block *sb, char=
 *qf_name,
 =09struct dentry *dentry;
 =09int error;
=20
-=09dentry =3D lookup_positive_unlocked(qf_name, sb->s_root, strlen(qf_name=
));
+=09dentry =3D lookup_positive_unlocked(qf_name, sb->s_root,
+=09=09=09=09=09  strlen(qf_name), 0);
 =09if (IS_ERR(dentry))
 =09=09return PTR_ERR(dentry);
=20
--=20
2.20.1


