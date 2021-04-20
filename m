Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA50C433B4
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Apr 2021 02:08:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38FC7613AB
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Apr 2021 02:08:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhDTCJF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:09:05 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17180 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229534AbhDTCJE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Apr 2021 22:09:04 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1618884508; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=cstWO2apV6FZzVjYLF2deZWT6ZpZgR0ePYX85Ed8EMQSyH/Pu7lwGAM3ZPEXA/E0Eq9JMQnyS3UNjYBA6kWelPhhjOo2fedm5jGnNAy1rvw82XhV7P5w6ub5N+fGH1h18e9JfUuu5XXoixAYQM5XNiLywmq/8kiqwsdYSw8vGH4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1618884508; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=+qpW1yl4avKEKoUd6ROB81TIdB3ZDhORx2zHd7W7H8I=; 
        b=lmD+5jbgrQUb9AHuNucAaX7EaPSklYNcELkH57SIYXPyHNQZgBQFzL5x9sE6pVDGnqWvAe/TWuQ0EOHBOPYzUhW9IKMvenctPNcNsR2xwgCuSpWvnWJcIrLWreRKIb/ngeM952JEElsmSMYs8NCxp/Q7a45NjNItmN3SyXnmkKE=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1618884508;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=+qpW1yl4avKEKoUd6ROB81TIdB3ZDhORx2zHd7W7H8I=;
        b=fzEIuxqmtBQYG7AYSp1E8YX/iO+VXSFIjCl/7WITxnqcLeNR/hQbMP1k07cRRGcw
        06J2sNs/HtCwT5Q18JKVo6/tf3jKpPMis31zSn4etuyVl4KYOpauCopUUYPdzfFkxjb
        c0g2qX5wxj4D54/+C/0O0QZvBpyIU8CoKXVPl1UA=
Received: from localhost.localdomain (159.75.42.226 [159.75.42.226]) by mx.zoho.com.cn
        with SMTPS id 1618884506653771.9747769806363; Tue, 20 Apr 2021 10:08:26 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20210420020738.201670-1-cgxu519@mykernel.net>
Subject: [PATCH] ovl: restore vma->vm_file to old file
Date:   Tue, 20 Apr 2021 10:07:38 +0800
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

In the error case of ->mmap() we should also restore vma->vm_file
to old file in order to keep correct file reference in error path.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 6e454a294046..046a7adb02c5 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -439,6 +439,7 @@ static int ovl_mmap(struct file *file, struct vm_area_s=
truct *vma)
 =09if (ret) {
 =09=09/* Drop reference count from new vm_file value */
 =09=09fput(realfile);
+=09=09vma->vm_file =3D file;
 =09} else {
 =09=09/* Drop reference count from previous vm_file value */
 =09=09fput(file);
--=20
2.27.0


