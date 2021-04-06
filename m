Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52579C433ED
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Apr 2021 12:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B46161019
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Apr 2021 12:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343674AbhDFMDj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Apr 2021 08:03:39 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17130 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235453AbhDFMDh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Apr 2021 08:03:37 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617710601; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=bjYUYrJ0iVhNnYKjAH26Z8VnlTsieB08hOF7mXEjVsMynLmx0R8iuJHjXoY0bpMDoL3XjfnczKC33pn5mj3AH+6ZRv8Qi1qWMM53kahbPOBYSlwf4PVboxQp4JY5N5YD4fLEdqMgWORi43RmPzIc2yNGy60kfSUoW3DR361sSyc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1617710601; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=q95V60AvGuzYowYrxHiFurC3fUSXBpkBq0I9BwPz9O0=; 
        b=ljw+MdvSHh4J+borhkZtGCTfio8tHi3sGRCQxH8Baypmvgo7RbAHKV9DLaTpwlaZSd/MR8rn+C7zq3PuIcKwIiH0JuvKqDGjsLobtSp2/XL0Cv6PooO6RiMepUzs+hr3UDR1NhJ5YcH75tjGEaNh1XLjgjDQIY72FyyKzbj50F8=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1617710601;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=q95V60AvGuzYowYrxHiFurC3fUSXBpkBq0I9BwPz9O0=;
        b=HHQInbAaE1xVFMOStGy+6EQ81xT1dlrN7RsrSczXX/qTJ1ayLmKBsxiESDtq6UIf
        L0CtI0GK9lwACtePMP5UlX9tweNvJ5ah00UfHgOLZkE1k53uFwL67WU+mRy+qVPvRpR
        XrB40Vp+OPdpyq67jG4iWjKnz+DmkkaWvamyVasw=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1617710600498586.6069236070001; Tue, 6 Apr 2021 20:03:20 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210406120245.1338326-2-cgxu519@mykernel.net>
Subject: [PATCH v2 2/3] ovl: check actual copy-up size
Date:   Tue,  6 Apr 2021 20:02:44 +0800
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210406120245.1338326-1-cgxu519@mykernel.net>
References: <20210406120245.1338326-1-cgxu519@mykernel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In order to simplify truncate operation on the file which
only has lower, we allow specifying larger size than lower
file when calling ovl_copy_up_data(), so we should check
actual copy size carefully before doing copy-up.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/copy_up.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8b92b3ba3c46..a1a9a150405a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -156,6 +156,9 @@ static int ovl_copy_up_data(struct ovl_fs *ofs, struct =
path *old,
 =09=09goto out_fput;
 =09}
=20
+=09len =3D (len <=3D i_size_read(file_inode(old_file))) ? len :
+=09=09=09=09i_size_read(file_inode(old_file));
+
 =09/* Try to use clone_file_range to clone up within the same fs */
 =09cloned =3D do_clone_file_range(old_file, 0, new_file, 0, len, 0);
 =09if (cloned =3D=3D len)
--=20
2.27.0


