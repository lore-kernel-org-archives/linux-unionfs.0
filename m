Return-Path: <SRS0=upMg=6V=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EE7AC28CBC
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 May 2020 01:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2497D2075A
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 May 2020 01:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgEGBTj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 6 May 2020 21:19:39 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21144 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727929AbgEGBTj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 May 2020 21:19:39 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1588814365; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=H5TVOGxY7oxUGDY96jQ8dNPqqGtPXrfG7m+RkEYJuQ1LayPFDZ0qj7rOZU6u/XqMErq/Qblx23YR/YxU4gKX9Nkwm2V4k4KvqwPRJtaO73jqUeDZa80kcGbrkXU93X5Pk3B+5ZBU28zGewhjzkMNWrVblwz8oL5S45t3fE+7FQ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1588814365; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=1LtuCARgp+BOcDsTsBYl7F/02dAjhWwCFqzFO4xPYGo=; 
        b=MguXPY3S1TWa2Bn2tPi6jBS+2KqHdM2FbLzTS1KVQ3BvJFqBqIqRRNtJIqgo3Dvvm2JmkjNLtrYuZhZp5SyiH1MsUAfuuEhtibQPePZP4I8sXf90XDHfxjv1PFsoQNBaiujHXEY0+dCDe2ykGYCgNpeZSf2J7rUTqD4xFKWWKEc=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1588814365;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=1LtuCARgp+BOcDsTsBYl7F/02dAjhWwCFqzFO4xPYGo=;
        b=TIk4V6lJTR3tm8IiiQqBRRBmbyPMuejzAGhxUwxfm2uVpqkQLBhn8GT/zlm5Mrgi
        jP7QXLb4aJ/4YwY/Y79Ri0++RHk833F9B7SAhlE4sGqau6HGswNpIDiZzDRIG48qCsK
        59l/w5pncyBzhWwQ2LiL+kV6zd+35UfMfe6q6uxQ=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1588814363055445.13772552833655; Thu, 7 May 2020 09:19:23 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200507011900.23523-1-cgxu519@mykernel.net>
Subject: [RFC PATCH] ovl: suppress negative dentry in lookup
Date:   Thu,  7 May 2020 09:19:00 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When a file is only in a lower layer, after lookup a negative
dentry will be generated in the upper layer or even worse many
negetive dentries will be generated in upper/lower layers. These
negative dentries will be useless after construction of overlayfs'
own dentry and may keep in the memory long time even after unmount
of overlayfs instance. This patch tries to kill unnecessary negative
dentry during lookup.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/namei.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 723d17744758..cf0ec4d7bcec 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -200,7 +200,7 @@ static int ovl_lookup_single(struct dentry *base, struc=
t ovl_lookup_data *d,
 =09int err;
 =09bool last_element =3D !post[0];
=20
-=09this =3D lookup_positive_unlocked(name, base, namelen);
+=09this =3D lookup_one_len_unlocked(name, base, namelen);
 =09if (IS_ERR(this)) {
 =09=09err =3D PTR_ERR(this);
 =09=09this =3D NULL;
@@ -209,6 +209,15 @@ static int ovl_lookup_single(struct dentry *base, stru=
ct ovl_lookup_data *d,
 =09=09goto out_err;
 =09}
=20
+=09/* Borrow the check from lookup_positive_unlocked */
+=09if (d_flags_negative(smp_load_acquire(&this->d_flags))) {
+=09=09d_drop(this);
+=09=09dput(this);
+=09=09this =3D NULL;
+=09=09err =3D -ENOENT;
+=09=09goto out;
+=09}
+
 =09if (ovl_dentry_weird(this)) {
 =09=09/* Don't support traversing automounts and other weirdness */
 =09=09err =3D -EREMOTE;
--=20
2.20.1


