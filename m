Return-Path: <SRS0=PZEe=AF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF03C433E1
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 Jun 2020 10:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9D6D20706
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 Jun 2020 10:21:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="Jrv7hKGp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390281AbgFXKUt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 06:20:49 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17121 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390119AbgFXKUj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Jun 2020 06:20:39 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1592994024; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=IqN2qZZFWCWXx7ZbgnUguHUEiyf+iZSXuhycRXu3EUpBcbpgC60lopEp+F7y4l3xGju6H8csVIEfL4s4TkUPa7KtmlUzysTLSliYT1Tqcy0JqMe16UFsTq08pJ48ZAb65KT4lhrz+HBvR+qD5DWneim10buRhG8g2zWktIX81rQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1592994024; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=PKCfyGEEjSlRJRyjrJZ+V4F7+BsUscDEqIXVbuYd0hw=; 
        b=UEA4NS0hsekmv3TEmyLFaLoh7zU+E71TMq3BepASP80qwX9dBv0d1sn2oX7NvvB05063IKvRZEkTSAu2cv7P+Trh19ZKGESidY+n2DpxJbyThqPsQadLdeRP6Y80E1Je+tqlA6RO+eM2ahqnTCsEBjtyxGR7ewTZJbcjaJDp1nY=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1592994024;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=PKCfyGEEjSlRJRyjrJZ+V4F7+BsUscDEqIXVbuYd0hw=;
        b=Jrv7hKGp4F8ZA9hoYhj9mCT9MV7lwwvv9uZ5NFCqodRcNojvys170OcWkspzYEYO
        4QAWvE9uXorpiq77bUrRaFJ3kvnfieKIyzjCWnpvrtCtOQpc7BJ3NK5u9v6vnKXrk5E
        fwg2C2H1zNyFXihmgWNNnhTM4feyUnqtGHlc376o=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1592994021027332.3870125354415; Wed, 24 Jun 2020 18:20:21 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200624102011.4861-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: fix incorrect extent info in metacopy case
Date:   Wed, 24 Jun 2020 18:20:11 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In metacopy case, we should use ovl_inode_realdata() instead of
ovl_inode_real() to get real inode which has data, so that
we can get correct information of extentes in ->fiemap operation.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 981f11ec51bc..a524af04b71d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -472,7 +472,7 @@ static int ovl_fiemap(struct inode *inode, struct fiema=
p_extent_info *fieinfo,
 =09=09      u64 start, u64 len)
 {
 =09int err;
-=09struct inode *realinode =3D ovl_inode_real(inode);
+=09struct inode *realinode =3D ovl_inode_realdata(inode);
 =09const struct cred *old_cred;
=20
 =09if (!realinode->i_op->fiemap)
--=20
2.20.1


