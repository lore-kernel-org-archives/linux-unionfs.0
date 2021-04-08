Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7921C433B4
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 11:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6134D610E5
	for <linux-unionfs@archiver.kernel.org>; Thu,  8 Apr 2021 11:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhDHLVo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 8 Apr 2021 07:21:44 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17161 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229751AbhDHLVn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Apr 2021 07:21:43 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617880872; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=YosQVs2W47rwncS81cmIiDZ0HrtTV0sbRvBy4QHjhhCeJ9QBgfkdW4CEhaLAtg2sgFsfC8jfkJaNgykOUA7MzTS1RCUrXdXWvxszBIDDTBsyMxLy5mcBLLeo1Wp8I7J1DGgYrGzFd+y0HJfg1LG9USljGdTLv2Mw1YjadLUY2wI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617880872; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=TXMwvspWx7jljz36pY+9Z4og2kjpcuKdqDU34og/oII=; 
        b=hyR3Xbee+1yiCcqK1uxMTYDu1UEUBkc7KS0YK+9M7sPBQNixfWBaERoXNb/jPstkl4Vqcw7FhUzznYEMsxUURuWzMi53SbKjVPMKjXWMBAWTjXpMd5Ouf0eQnFD5dtsHdizGMVzz6GLVyVystQ8sw3MSvWHjf0B3KONyW28E274=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617880872;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=TXMwvspWx7jljz36pY+9Z4og2kjpcuKdqDU34og/oII=;
        b=ZZO4wZQB4gL+3HWuY2wA602xKFNB9TJgm2yBEkhnfchC2meOmcRdCcRbV1qpZdb5
        rmQwFjVnnSg1A+0mX00LnoRvDCb2rlpIqNkZjt+Pk80R9eXznTwbQm6MMQVT+IsfneX
        4OBA/TREcxCtTRkhenbeWstFE6p0DiDo3nRyTh+U=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1617880867964127.15995471167491; Thu, 8 Apr 2021 19:21:07 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210408112042.2586996-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: check VM_DENYWRITE mappings in copy-up
Date:   Thu,  8 Apr 2021 19:20:42 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In overlayfs copy-up, if open flag has O_TRUNC then upper
file will truncate to zero size, in this case we should check
VM_DENYWRITE mappings to keep compatibility with other filesystems.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/copy_up.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0fed532efa68..c56c81494b0c 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -901,8 +901,11 @@ static int ovl_copy_up_one(struct dentry *parent, stru=
ct dentry *dentry,
 =09}
=20
 =09/* maybe truncate regular file. this has no effect on dirs */
-=09if (flags & O_TRUNC)
+=09if (flags & O_TRUNC) {
+=09=09if (atomic_read(&d_inode(ovl_dentry_real(dentry))->i_writecount) < 0=
)
+=09=09=09return -ETXTBSY;
 =09=09ctx.stat.size =3D 0;
+=09}
=20
 =09if (S_ISLNK(ctx.stat.mode)) {
 =09=09ctx.link =3D vfs_get_link(ctx.lowerpath.dentry, &done);
--=20
2.27.0


