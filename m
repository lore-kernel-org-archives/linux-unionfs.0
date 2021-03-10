Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CECFC433DB
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Mar 2021 02:10:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C1A164E7A
	for <linux-unionfs@archiver.kernel.org>; Wed, 10 Mar 2021 02:10:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhCJCKO (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Mar 2021 21:10:14 -0500
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17117 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231673AbhCJCKA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Mar 2021 21:10:00 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615342189; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=I1kdfD0N21ll01SLFXdzYWBCDIpjc+lto5M16jq0rCp99pbCVawMlicFpj7akpVNoM0cTDjUkzX1FHtGGsjwUDUKzMeAnPT6PDLr5vPMcH9GbbGkwXMQz5CwF43MRYXsUHv68oGernEi8dnwJjeoUUq/Z+mbMi7z0gK0CLeEUXA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1615342189; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=GRE+nKQUA+6jQmod38uxDT7TxYqC8fCIwevHNHwIaWY=; 
        b=bsnWNuTmwjOKM8W3Vrc4OeX+pJT6LhDiFz9dIjTDZUNYLyndA56OkwmwjHdCAMiF6sElYdp4wJ87CubGKw8cWwgPF0JvVtcJsBquRRlVnAPmjDNVWDBM2CSWDhVKIzLOMM/eaG4lKdthbh12DPl0qgswceh85cDAIwtTZzkOSuU=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1615342189;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=GRE+nKQUA+6jQmod38uxDT7TxYqC8fCIwevHNHwIaWY=;
        b=gyxAAf6QHGb8Yk7kfjXhbgLk7k2vH2OQOQrmh/oirKRZeOU2Wwqctdhtm21K3MJb
        rFt0GvcRK5hgAWTQXNDYAwS8pRA2OQVO+CTZgd/wevn6VK+rucxmH8Ckzw0g45NqSoK
        Rj69r2mrqYDZqJ0oL3bjeZsqbKdgJ4ty4Jghj7WI=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1615342187501903.8555299093559; Wed, 10 Mar 2021 10:09:47 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210310020925.2441670-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: update ctime when changing file attribution
Date:   Wed, 10 Mar 2021 10:09:25 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Currently we keep size, mode and times of overlay inode
as the same as upper inode, so should update ctime when
changing file attribution as well.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index dbfb35fb0ff7..49b73a2e92a7 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -546,6 +546,8 @@ static long ovl_ioctl_set_flags(struct file *file, unsi=
gned int cmd,
 =09ret =3D ovl_real_ioctl(file, cmd, arg);
=20
 =09ovl_copyflags(ovl_inode_real(inode), inode);
+=09/* Update ctime */
+=09ovl_copyattr(ovl_inode_real(inode), inode);
 unlock:
 =09inode_unlock(inode);
=20
--=20
2.27.0


