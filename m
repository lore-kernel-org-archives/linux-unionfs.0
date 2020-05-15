Return-Path: <SRS0=KPW4=65=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB4CC433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 May 2020 07:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D4962065F
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 May 2020 07:22:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="PWRCpzl8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgEOHWj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 15 May 2020 03:22:39 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21120 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726665AbgEOHWj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 May 2020 03:22:39 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589527305; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=YM4hnMpOZ7PQIQyp3EpriEIqiWBDiUP0cjsNmmxMaz9f3jPnDv2JyIzPzBa70RtHMR1eAfLwNJz62X9Id1KZmScAsUc/62DCFFkM0jY+a2nM0E8IIvlQpKMkMnaRaKY8WikJRxwlTnGMkoyKCRtGEvnwn2iLbhD94OHUyyqZ4fQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589527305; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=olns2XfB6tJoDBwJH0OMezwkXtbEgUdzY7HgpQ0/JL8=; 
        b=qR86ijZ4nr30BK+mm9k4FCQL+eslMkPqJHjXXWOJBCPMqNSQBks04P6WwRrmSgdZRnbdjM4xnJFO0NLJQ5kbva2p0LpEXmW279GtDgtOtSu7gaVaWxM6/LVIf6peRaSzAdkCWsf2eLORM29RErfoQHbOtclFUAeYUr/9syOZzfQ=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589527305;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=olns2XfB6tJoDBwJH0OMezwkXtbEgUdzY7HgpQ0/JL8=;
        b=PWRCpzl809CyJmy6RUlijxQpelqmPydPDev/eOZAom/iRY0RUlaxBVWnvE+9wipP
        KmKqhU0pW75/6mPaO76RPZFuuewqTzvh21gjzbWOLVB3a9BAcvkfHgtq7EcnWTLYBcC
        M6/N7ODErN6i6NaLfio2k/FoC3DhvsGsIYxnlvPA=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1589527304133785.5848804527277; Fri, 15 May 2020 15:21:44 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, viro@zeniv.linux.org.uk, amir73il@gmail.com
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200515072047.31454-6-cgxu519@mykernel.net>
Subject: [RFC PATCH v3 5/9] ecryptfs: Adjust argument for lookup_one_len_unlocked()
Date:   Fri, 15 May 2020 15:20:43 +0800
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

Set 0 as lookup flag argument when calling lookup_one_len_unlocked(),
because we don't hope to drop negative dentry in lookup.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/ecryptfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index e23752d9a79f..e39af6313ad9 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -407,7 +407,7 @@ static struct dentry *ecryptfs_lookup(struct inode *ecr=
yptfs_dir_inode,
 =09=09name =3D encrypted_and_encoded_name;
 =09}
=20
-=09lower_dentry =3D lookup_one_len_unlocked(name, lower_dir_dentry, len);
+=09lower_dentry =3D lookup_one_len_unlocked(name, lower_dir_dentry, len, 0=
);
 =09if (IS_ERR(lower_dentry)) {
 =09=09ecryptfs_printk(KERN_DEBUG, "%s: lookup_one_len() returned "
 =09=09=09=09"[%ld] on lower_dentry =3D [%s]\n", __func__,
--=20
2.20.1


