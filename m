Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A69C433FE
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Sep 2021 13:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37D066115A
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Sep 2021 13:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241384AbhIWNZu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 23 Sep 2021 09:25:50 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17280 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241363AbhIWNZp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 23 Sep 2021 09:25:45 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1632402519; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=hcflms2yGXPj40zXwh79bs9B+rZlwAiNHoAiDqeB4kA5p8f5VY28Pp2nyg/53vRHwWM7SfZsc87Nm5OEwvWTqeX7ibL/bYV3V6FsT0LgGNsmLQrPiq6yWye5y5MBU2s+iHPIDT7rypigGbqTkczAIS89q9YoNUiZjxpeE22oRQk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1632402519; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=oiT5pr0K1SzNaD+tk1eXPsdcldxnjdYU+xq7vNjbxmY=; 
        b=QYvnxb8rUmPDsebgB8N/Dp0/H2Ln1nV+HF4EVJ5sKBBnAn+rSaHxEGCjm3WoPzsESQ/cYEqiSYR4TO4z7uoCF6s1Mul3kg7AUS7+ezr1kDhk3yvxq1w8rJ1AeBh/rOC9eEa94k/NlhsOlsfhGUIbHmdmEWMsqiAaUIZAbxQE5Ms=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1632402519;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=oiT5pr0K1SzNaD+tk1eXPsdcldxnjdYU+xq7vNjbxmY=;
        b=HHkVZft3KaPjFQxhfMb9MimXpR/ixs/USm+dwjyN9o90gVKkZQIi9yN3CHGKROpQ
        xWKvsGFH027LE3F55nu02bb+Xaj+mR+HWpTj/BUCoAYBtLAJ6ymn/EumJ3uk8u3lAxB
        MWj7zmmv4iPT9gdstaLn8nem+Mx9GjqgkfWFxa2w=
Received: from localhost.localdomain (81.71.33.115 [81.71.33.115]) by mx.zoho.com.cn
        with SMTPS id 1632402517441659.6191501603354; Thu, 23 Sep 2021 21:08:37 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, jack@suse.cz, amir73il@gmail.com
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210923130814.140814-3-cgxu519@mykernel.net>
Subject: [RFC PATCH v5 02/10] ovl: implement ->writepages operation
Date:   Thu, 23 Sep 2021 21:08:06 +0800
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210923130814.140814-1-cgxu519@mykernel.net>
References: <20210923130814.140814-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Implement overlayfs' ->writepages operation so that
we can sync dirty data/metadata to upper filesystem.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/inode.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 832b17589733..d854e59a3710 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -659,9 +659,22 @@ static const struct inode_operations ovl_special_inode=
_operations =3D {
 =09.update_time=09=3D ovl_update_time,
 };
=20
+static int ovl_writepages(struct address_space *mapping,
+=09=09=09  struct writeback_control *wbc)
+{
+=09struct inode *inode =3D mapping->host;
+=09struct ovl_fs *ofs =3D inode->i_sb->s_fs_info;
+=09struct inode *upper =3D ovl_inode_upper(inode);
+
+=09if (!ovl_should_sync(ofs))
+=09=09return 0;
+=09return filemap_fdatawrite_wbc(upper->i_mapping, wbc);
+}
+
 static const struct address_space_operations ovl_aops =3D {
 =09/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
 =09.direct_IO=09=09=3D noop_direct_IO,
+=09.writepages=09=09=3D ovl_writepages,
 };
=20
 /*
--=20
2.27.0


