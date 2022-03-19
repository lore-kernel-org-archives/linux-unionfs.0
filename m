Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1663AC433EF
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Mar 2022 05:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242213AbiCSFkM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 19 Mar 2022 01:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiCSFkK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 19 Mar 2022 01:40:10 -0400
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA39BC90
        for <linux-unionfs@vger.kernel.org>; Fri, 18 Mar 2022 22:38:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1647668317; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=BL17HeKrlKdwDLciADdS2pq1AX25um4pNZ70d4HQROy8wR/54j/ZDwVfEUrE0n6vsKAM/sW0DEwKFCU14V4yBrvoUT9xB3Fritz7jfKQzBKk69JO+Lt9FDWxSVFS2Y7b0rH1DfA8x9YMZ8cP5WB72YXI+xCCwTKjd/ov0Mxp5oo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1647668317; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=iyxUeI3LNsEmn3hvFd8lLx5YCK0Zt/QyUPgnxI2jDR0=; 
        b=FqDQy4glyYEBLA2w9PYu4XaUaqtMzESkoBQ1+4peSl9Na8PxBNg1DGJEL5MJZqHfkOvX9Emds1m2zPkf7YBuOB9TpNB69hP26+/C2Dhv6lwVPlbRonBu+MDJvg1Ghjq77CKWT/7TX+SOMN8OSdyYnEsqu3XWkwmwwfhL4pJGLGE=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1647668317;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=iyxUeI3LNsEmn3hvFd8lLx5YCK0Zt/QyUPgnxI2jDR0=;
        b=HjyooxELlAyt6d3LPC/apSidrKCics+Qz+EowL0ErHVvCNdpq/wDYTkEG/6XyCoK
        ISPxMWf8d+tILqaAO3gTbmkfJmlrxsv1zK/WFeLsqnbIqhfk2PupxN31JL6GwzoVcPy
        OkshGklKE8WG53eERFhJnR5mWihufVE96Fi1733s=
Received: from localhost.localdomain (106.55.170.121 [106.55.170.121]) by mx.zoho.com.cn
        with SMTPS id 1647668315141864.8586636174805; Sat, 19 Mar 2022 13:38:35 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220319053828.2354927-1-cgxu519@mykernel.net>
Subject: [RFC Patch] ovl: skip delever fadvise request to lower layers
Date:   Sat, 19 Mar 2022 13:38:28 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The files in lower layers are shared with multiple overlayfs instances.
so directly delever fadvise request to lower layers may cause interfears
between instances.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/file.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index fa125feed0ff..7b51f3afef02 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -539,6 +539,9 @@ static int ovl_fadvise(struct file *file, loff_t offset=
, loff_t len, int advice)
 =09const struct cred *old_cred;
 =09int ret;
=20
+=09if (!ovl_inode_upper(file_inode(file)))
+=09=09return 0;
+
 =09ret =3D ovl_real_fdget(file, &real);
 =09if (ret)
 =09=09return ret;
--=20
2.27.0


