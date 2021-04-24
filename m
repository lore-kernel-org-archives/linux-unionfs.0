Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9ACBC43461
	for <linux-unionfs@archiver.kernel.org>; Sat, 24 Apr 2021 14:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95CC960FDB
	for <linux-unionfs@archiver.kernel.org>; Sat, 24 Apr 2021 14:06:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbhDXOHG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 24 Apr 2021 10:07:06 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17110 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238061AbhDXOEq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 24 Apr 2021 10:04:46 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1619273037; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=JUQNSGvzOVIXWtr94AwqnwTBE7eJTnBdNYxGRnvpB107WXblJTYMM/5rr0ql58hZ1HC0FMOQN3uRB0BbysTwWeabW9Omsz+ZE4S2w9db7GnFad29fUgmvEiCVkeLNaoWnjPbLadr/GM9UxieIVYhMQGsUkrOx/qj/eICDYpHoZw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1619273037; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=Q0fPy6ChO9Jv2Svyagg6LXDJq5Bjw4RVZDWRdfW1MeM=; 
        b=eMO/YgbWvfKEg1AyLxdz1Ro1D1AFWAelBFEZN0exTPiT+asMo157sewu4HNVDFs/Z1MeSOXnbdFy/zxQ54jdkFYmBSIgbPLETUriGGCTOJ3CG8PrebG/NV/+/egvVccCBdzEEJDApMzVcY9raHoO/G+mPvFgB/Xn/jMN3cQKzf4=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1619273037;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=Q0fPy6ChO9Jv2Svyagg6LXDJq5Bjw4RVZDWRdfW1MeM=;
        b=M0dEnulAnZRsFBm2wtnI8KzcJ6HH82O77KWEImOYyym7ZKQYDcHa7kTomooZsCKB
        peiyqMoAdaEHGqnppBUv7jydG3z8JDIfeCACeFOeffllF9G6fW69FiFVB3492Kn3pZz
        SMinsrhWAdkQlV8YThhmF85mDnuItdRDlUSA3r/Y=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1619273032855833.7516682846252; Sat, 24 Apr 2021 22:03:52 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210424140316.485444-1-cgxu519@mykernel.net>
Subject: [RFC PATCH 1/2] ovl: skip checking lower file's write permisson on truncate
Date:   Sat, 24 Apr 2021 22:03:15 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Lower files may be shared in overlayfs so strictly checking write
perssmion on lower file will cause interferes between different
overlayfs instances.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/inode.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 28c71978eb2e..17d1add0af1a 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -31,12 +31,6 @@ int ovl_setattr(struct user_namespace *mnt_userns, struc=
t dentry *dentry,
 =09=09goto out;
=20
 =09if (attr->ia_valid & ATTR_SIZE) {
-=09=09struct inode *realinode =3D d_inode(ovl_dentry_real(dentry));
-
-=09=09err =3D -ETXTBSY;
-=09=09if (atomic_read(&realinode->i_writecount) < 0)
-=09=09=09goto out_drop_write;
-
 =09=09/* Truncate should trigger data copy up as well */
 =09=09full_copy_up =3D true;
 =09}
--=20
2.27.0


