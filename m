Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A281C433EF
	for <linux-unionfs@archiver.kernel.org>; Sat, 26 Feb 2022 15:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232201AbiBZPWH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 26 Feb 2022 10:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiBZPWG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 26 Feb 2022 10:22:06 -0500
Received: from sender2-op-o12.zoho.com.cn (sender2-op-o12.zoho.com.cn [163.53.93.243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB202563FE
        for <linux-unionfs@vger.kernel.org>; Sat, 26 Feb 2022 07:21:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1645888882; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=obmzgwoziOVvXzIYBV2eODXhdn2HTqRgr+1n74mcOg5LIJzxAr2o+lAujq9otmmXCfQe6T9BP/oelSIOCsonw6CvfAbECf2UeQSazrq/ADGoqeJv5xw10jojvJXplfWn/MhEPhzuExosusfkyvG/46w8yvfuNIo9o/xukyrkoiY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1645888882; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=GWCeqWjUqN0kWlV6wQoTsH0Q8Og74C29EeJDWiSiSj0=; 
        b=TV/NJ6flB0cyWuWMYvZEnn/nkq1Nj+jW2wO9xSGpVIjQKP89Uu2zNFC+FE76FOJfgW0TO8u2DCrtWNno6sN2WtBsDqoBx7b79TNm4aVbcBNn8GpIhXSbKRDeVmgkrZ+KpxYRZU70wysL3BGE2ud1/5KRlOZ06vmAff26x7irRpg=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1645888882;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=GWCeqWjUqN0kWlV6wQoTsH0Q8Og74C29EeJDWiSiSj0=;
        b=LYx8WvO7yxT6uMXHwIN2pow5FE2zYCQOK5fj8G4VzF4ukrYIQvVCSLrgiInYQS12
        P4aLKjPx5GVeeCONc/BT0NJkKtJoWpzvaOKDE5OTpB+4k0tmo/uj2CmzdOlSokGzDBU
        4Aba/BtWH4i2S/w5xLgcF5a2waVVep1xf4uVt+pE=
Received: from localhost.localdomain (106.55.170.121 [106.55.170.121]) by mx.zoho.com.cn
        with SMTPS id 1645888880274283.3483293117988; Sat, 26 Feb 2022 23:21:20 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20220226152058.288353-1-cgxu519@mykernel.net>
Subject: [RFC PATCH] ovl: fsync parent directory in copy-up
Date:   Sat, 26 Feb 2022 23:20:58 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Calling fsync for parent directory in copy-up to
ensure the change get synced.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/copy_up.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e040970408d4..52ca915f04a3 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -944,6 +944,7 @@ static int ovl_copy_up_one(struct dentry *parent, struc=
t dentry *dentry,
 {
 =09int err;
 =09DEFINE_DELAYED_CALL(done);
+=09struct file *parent_file =3D NULL;
 =09struct path parentpath;
 =09struct ovl_copy_up_ctx ctx =3D {
 =09=09.parent =3D parent,
@@ -972,6 +973,12 @@ static int ovl_copy_up_one(struct dentry *parent, stru=
ct dentry *dentry,
 =09=09=09=09  AT_STATX_SYNC_AS_STAT);
 =09=09if (err)
 =09=09=09return err;
+
+=09=09parent_file =3D ovl_path_open(&parentpath, O_WRONLY);
+=09=09if (IS_ERR(parent_file)) {
+=09=09=09err =3D PTR_ERR(parent_file);
+=09=09=09return err;
+=09=09}
 =09}
=20
 =09/* maybe truncate regular file. this has no effect on dirs */
@@ -998,6 +1005,14 @@ static int ovl_copy_up_one(struct dentry *parent, str=
uct dentry *dentry,
 =09=09=09err =3D ovl_copy_up_meta_inode_data(&ctx);
 =09=09ovl_copy_up_end(dentry);
 =09}
+
+=09if (!err) {
+=09=09if (parent_file) {
+=09=09=09vfs_fsync(parent_file, 0);
+=09=09=09fput(parent_file);
+=09=09}
+=09}
+
 =09do_delayed_call(&done);
=20
 =09return err;
--=20
2.27.0


