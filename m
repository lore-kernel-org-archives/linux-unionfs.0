Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7D57C433E6
	for <linux-unionfs@archiver.kernel.org>; Fri, 26 Feb 2021 09:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F38664EB7
	for <linux-unionfs@archiver.kernel.org>; Fri, 26 Feb 2021 09:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230209AbhBZJnZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 26 Feb 2021 04:43:25 -0500
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17177 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230299AbhBZJmN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 26 Feb 2021 04:42:13 -0500
X-Greylist: delayed 989 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2021 04:42:11 EST
ARC-Seal: i=1; a=rsa-sha256; t=1614331488; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=G4Hba9YRz71lrZcwpZ6SLpwT+VJI6MfiDmDDhvRqu0zY6SQ9XJpuFOfgKPFCdp+hOywdcJotw21dlARJMhhi30Vzwbx1Brg41vLIn31BBQA+U8UjGVuViXYm8sijpnNNfMF0j1FnciE3Ub/94f7n+BODRXm/vc7tpuKtKxqfIfQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1614331488; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=CTztSl9UKkvRbao4QSE6TZe/Ttt/tA+rDUDI/ZzmUnc=; 
        b=BcZuJDfmcEN/Ig+8UPhP3HehjdCHmziR7rSdZs65Sj1u3IthGqfaQ/bIyESDNsQDzcXE4yV7VWwuOyDSMpbdPZg37R34dsVQMBRIPDK2hnEQSh5RXQFK0UOsr0B+WQuAQ8/oAhljQZAQAEl14vZla0EP8LPbJJzLFWFhGvT5U1w=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1614331488;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=CTztSl9UKkvRbao4QSE6TZe/Ttt/tA+rDUDI/ZzmUnc=;
        b=DrsUeY4ZHz6d3VfBSd1shX+lPh1vn3JLT9l3x0lEt5ma1OS2wzgNXIriGF5MPRNj
        GOcJFBRtcDvdY/Bi5yNOWYSKOHO357hWTRp4w+XBsvTqglK1iWQIQoWCvksW3gZ1QAK
        CqR8ZJZuD9ZtrF+pqToprpVjPU13OM29OcnYIPDE=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1614331485304836.4058185585586; Fri, 26 Feb 2021 17:24:45 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210226092417.2621682-1-cgxu519@mykernel.net>
Subject: [RFC PATCH] ovl: do not copy attr several times
Date:   Fri, 26 Feb 2021 17:24:17 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In ovl_xattr_set() we have already copied attr of real inode
so no need to copy it again in ovl_posix_acl_xattr_set().

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/super.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d58b8f2bf9d0..c61f42c901d1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1035,9 +1035,6 @@ ovl_posix_acl_xattr_set(const struct xattr_handler *h=
andler,
 =09}
=20
 =09err =3D ovl_xattr_set(dentry, inode, handler->name, value, size, flags)=
;
-=09if (!err)
-=09=09ovl_copyattr(ovl_inode_real(inode), inode);
-
 =09return err;
=20
 out_acl_release:
--=20
2.27.0


