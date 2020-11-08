Return-Path: <SRS0=dOmM=EO=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 622C8C63777
	for <linux-unionfs@archiver.kernel.org>; Sun,  8 Nov 2020 14:04:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 170BF206F4
	for <linux-unionfs@archiver.kernel.org>; Sun,  8 Nov 2020 14:04:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="dsb89p8M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgKHOEG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 8 Nov 2020 09:04:06 -0500
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17143 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728367AbgKHOEE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 8 Nov 2020 09:04:04 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1604844209; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=Hb8mOqcwPs7reuotzqeUM7DFpz9/aTbcdbXNMnuYYIPkVWS+noyub7wT0AszL/xCG+JhDzIREdjN4WdJTL/U55pPNXMLT0L0jlcX1ONXI14ZNtqhBiYsHFDbT7VSCr+rxYiD6H7xZPA+ufHLJ6/cHaOS/2TjbM0lUA5Rj95gwOM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1604844209; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=TPYWu1w6xFm+9/OPpeWSH1thB8t1sD+PmNY4JWTD5PM=; 
        b=RZIDaNskNAZOXzxqX4R2Jy1DV/y4FjEy+GK2u4hhaLuxCdkpOdXzZtywV5r6ETQ05+wnNea8cHmRxHn1DRARLMlHLBETMwNbxfLT8fwZPvN3Az94DEGKB7eOQHfPbc+c2QecafB7mSsKVxu0cM21JDbaUazafc+GHF2RZ7jSuz4=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1604844209;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=TPYWu1w6xFm+9/OPpeWSH1thB8t1sD+PmNY4JWTD5PM=;
        b=dsb89p8MQT0RlBOlNeUCBWQVITMUnFkMexQjW25X+1qXHySRZHvj/g91zqv6k5S/
        XuA4SYYvAwbA/hHYWg120kx3deE+iubxIJzzGCKUqoaakDUS8dGBCZr6537XEHCyCeN
        NHSGDPVR0S9m1n5Jn8W2WK/OeXVxduJjorvQr3S0=
Received: from localhost.localdomain (113.116.49.189 [113.116.49.189]) by mx.zoho.com.cn
        with SMTPS id 1604844206915521.7392697274494; Sun, 8 Nov 2020 22:03:26 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, jack@suse.cz, amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20201108140307.1385745-9-cgxu519@mykernel.net>
Subject: [RFC PATCH v3 08/10] ovl: cache dirty overlayfs' inode
Date:   Sun,  8 Nov 2020 22:03:05 +0800
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201108140307.1385745-1-cgxu519@mykernel.net>
References: <20201108140307.1385745-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Now drop overlayfs' inode will sync dirty data,
so we change to only drop clean inode.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/super.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0ddee18b0bab..e5607a908d82 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -434,11 +434,20 @@ static void ovl_evict_inode(struct inode *inode)
 =09clear_inode(inode);
 }
=20
+static int ovl_drop_inode(struct inode *inode)
+{
+=09struct inode *upper =3D ovl_inode_upper(inode);
+
+=09if (!upper || !(inode->i_state & I_DIRTY_ALL))
+=09=09return 1;
+=09return generic_drop_inode(inode);
+}
+
 static const struct super_operations ovl_super_operations =3D {
 =09.alloc_inode=09=3D ovl_alloc_inode,
 =09.free_inode=09=3D ovl_free_inode,
 =09.destroy_inode=09=3D ovl_destroy_inode,
-=09.drop_inode=09=3D generic_delete_inode,
+=09.drop_inode=09=3D ovl_drop_inode,
 =09.evict_inode=09=3D ovl_evict_inode,
 =09.write_inode=09=3D ovl_write_inode,
 =09.put_super=09=3D ovl_put_super,
--=20
2.26.2


