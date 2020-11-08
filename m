Return-Path: <SRS0=dOmM=EO=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06838C55ABD
	for <linux-unionfs@archiver.kernel.org>; Sun,  8 Nov 2020 14:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1FC8206F9
	for <linux-unionfs@archiver.kernel.org>; Sun,  8 Nov 2020 14:04:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="K7cFuRDp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgKHOEJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 8 Nov 2020 09:04:09 -0500
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17109 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728307AbgKHOEH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 8 Nov 2020 09:04:07 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1604844206; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=J89cnRBdzFs0ke1NLlMh0SfJ0saZNsmGJ6d9nhrheW7ZetqD+Y3TX8r1hNMLheobb4eF/toUL0wcyksIoX8Df1ZdO36lawyq/uHS+MauIC2Mr0xdyFY8nZb/roqt0O8Uwh/BkwaOg2Yh5948Or//Wh45D/IH5VNnVZhWw1j3/kc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1604844206; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=+4OIy9gOCkiY1FUz5xPiYjM/P/B9KenL2bi1cR2ViTY=; 
        b=pq6S2Prroh/lG7ggl1LXcdal5fb/lwD5WPB3rpldlh24YzRiXH9dcNj7RmoZ1J3v7sYdmUR8REoV9lo5512z6ZsOI43zA7Ra+oT2J09cAYBNtFApr2A4oNlYzuTRylaVcm4Xd6ymVaj0WlHdY+f3VhxBkkX2ghtWl7I5iiZ6oNo=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1604844206;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=+4OIy9gOCkiY1FUz5xPiYjM/P/B9KenL2bi1cR2ViTY=;
        b=K7cFuRDpC8Xe00nrj/68Dm+X5rMxX0FtE6rxT7zSVHelHkUupWCSEd+OSf2UDq+a
        KDhQddXrv0AVj9UPMq4ZHD8jZIrppaAuyTLZMYHlXeEK8McHt3SXWDy3MSkl7cyeczB
        eVEFj6ltUa1Zyhy1CUVjXXeFvRNHi0SifR40j2Ik=
Received: from localhost.localdomain (113.116.49.189 [113.116.49.189]) by mx.zoho.com.cn
        with SMTPS id 1604844205643289.42420789308403; Sun, 8 Nov 2020 22:03:25 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, jack@suse.cz, amir73il@gmail.com
Cc:     linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20201108140307.1385745-7-cgxu519@mykernel.net>
Subject: [RFC PATCH v3 06/10] ovl: mark overlayfs' inode dirty on shared mmap
Date:   Sun,  8 Nov 2020 22:03:03 +0800
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

Overlayfs cannot be notified when mmapped area gets dirty,
so we need to proactively mark inode dirty in ->mmap operation.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 fs/overlayfs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index efccb7c1f9bc..662252047fff 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -486,6 +486,8 @@ static int ovl_mmap(struct file *file, struct vm_area_s=
truct *vma)
 =09=09/* Drop reference count from new vm_file value */
 =09=09fput(realfile);
 =09} else {
+=09=09if (vma->vm_flags & (VM_SHARED|VM_MAYSHARE))
+=09=09=09ovl_mark_inode_dirty(file_inode(file));
 =09=09/* Drop reference count from previous vm_file value */
 =09=09fput(file);
 =09}
--=20
2.26.2


