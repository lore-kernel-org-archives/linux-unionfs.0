Return-Path: <SRS0=dOmM=EO=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135E6C388F9
	for <linux-unionfs@archiver.kernel.org>; Sun,  8 Nov 2020 14:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D38EF20760
	for <linux-unionfs@archiver.kernel.org>; Sun,  8 Nov 2020 14:04:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="EVmBOh7k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728537AbgKHOEN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 8 Nov 2020 09:04:13 -0500
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17154 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728307AbgKHOEL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 8 Nov 2020 09:04:11 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1604844204; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=AfIW3PvGM4TqXsUx9IqomkG4qfwSEVbO2Tiqo3xv5ZgP7tsPVD7+t5WQsFQ7DZuQkMZKj7baVuac50Ya5uTR+Tm6iFVcFL18wIwnSSp8M8920VWHYQPGtzAMDZUbFE+TZ0GqawIqpGTuMsEzyxam3741A28uTiMVdVq7TwRqTIo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1604844204; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=XY1M6ngEHJazNPj3h/d5suhPsLhPCHaUvxhKABnNVTo=; 
        b=D56m6oaZYLtgh9S78SCkK//0Zy81bes05Ed9dPlLmz1HGl/B81ycxmVIo+JedgPLi0nlyg7Sz7quLnSNLsgYWN6m/Twojt45QAvj3ZcZ/rflpsDB012thN+7ZhwoHVjp8XnhBIolyFOdafKQE2lambW6RT0M1OSb7ptBajSa25Q=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1604844204;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=XY1M6ngEHJazNPj3h/d5suhPsLhPCHaUvxhKABnNVTo=;
        b=EVmBOh7kJ7TnDXi24rKjT0RnLSJs+h5oU3RBNdDMxAVeg9arsCkvOVjYHVtsn0s0
        ka38P1Bq6ir2F/77RbNDZdGxc+SU45bDyoBN+U5P+FLOxz3iM3eiZvLU6jRBL2Hgrki
        Hppeq4p16TCxOa5oiW/WTtaIvYrnyYHkTYAuO3lU=
Received: from localhost.localdomain (113.116.49.189 [113.116.49.189]) by mx.zoho.com.cn
        with SMTPS id 1604844203598419.0458980977053; Sun, 8 Nov 2020 22:03:23 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, jack@suse.cz, amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20201108140307.1385745-4-cgxu519@mykernel.net>
Subject: [RFC PATCH v3 03/10] ovl: implement ->writepages operation
Date:   Sun,  8 Nov 2020 22:03:00 +0800
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

Implement overlayfs' ->writepages operation so that
we can sync dirty data/metadata to upper filesystem.
If writeback mode is sync_mode we add overlayfs inode
to extra syncfs wait list so that we can wait completion
in ->syncfs.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/inode.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b584dca845ba..1f5cbbc60b28 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/posix_acl.h>
 #include <linux/ratelimit.h>
 #include <linux/fiemap.h>
+#include <linux/writeback.h>
 #include "overlayfs.h"
=20
=20
@@ -516,7 +517,30 @@ static const struct inode_operations ovl_special_inode=
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
+=09int ret;
+
+=09if (!ovl_should_sync(ofs))
+=09=09return 0;
+=09ret =3D sync_inode(upper, wbc);
+=09if (!ret && wbc->for_sync =3D=3D 1) {
+=09=09spin_lock(&ofs->syncfs_wait_list_lock);
+=09=09if (list_empty(&OVL_I(inode)->wait_list))
+=09=09=09list_add_tail(&OVL_I(inode)->wait_list,
+=09=09=09=09      &ofs->syncfs_wait_list);
+=09=09spin_unlock(&ofs->syncfs_wait_list_lock);
+=09}
+
+=09return ret;
+}
+
 static const struct address_space_operations ovl_aops =3D {
+=09.writepages=09=09=3D ovl_writepages,
 =09/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
 =09.direct_IO=09=09=3D noop_direct_IO,
 };
--=20
2.26.2


