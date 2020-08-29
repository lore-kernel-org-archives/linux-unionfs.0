Return-Path: <SRS0=cJ4F=CH=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83C7C433E6
	for <linux-unionfs@archiver.kernel.org>; Sat, 29 Aug 2020 09:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EC2920E65
	for <linux-unionfs@archiver.kernel.org>; Sat, 29 Aug 2020 09:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="D0xMOiZC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgH2JwE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 29 Aug 2020 05:52:04 -0400
Received: from sender2-op-o12.zoho.com.cn ([163.53.93.243]:17133 "EHLO
        sender2-op-o12.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726900AbgH2JwD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 29 Aug 2020 05:52:03 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1598694686; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=If0As52fb25P6rlWhPCodjf1Av7iwB0m0zxiaeQANQkvBEBn4giVeky3gfL2lS531GkMQrF3Lsl8IgVTGrAGBysZhEcASu/KD1wbXmXakrqXl0+CGhHQxtoAepJpvLh6JP3i1FgsmgUXuT8reh8VoESeN2YnpKhgpV5tuL52RsQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1598694686; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=tX3B1l15hO/83TfyRX4DcvD2+Bkx6ul/guU7N9R9v20=; 
        b=cn5VK5fqCkHvJkzRGC9oxGx3KtVS6y7UIvoy4Go5iwfoLp85tTWQ6LP5yhUbp5lfCi3D5QLPDu6G4zZuxEtwYkAdtB/mxNhqZdhWXu/uz9IC5D6H8HA6r91C0ylH/FoxEMOi2r3zKWEe0PUST70WyZZwuXDNSEHTpM9jPxPPgjA=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1598694686;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=tX3B1l15hO/83TfyRX4DcvD2+Bkx6ul/guU7N9R9v20=;
        b=D0xMOiZCEQ5QLo9vnsW5fSlWlBv18sFoH3Fz4TrAI/VgcJbposK9VXLQa5AaZ+b4
        gPo+H3PDgKliuZHOm5GS9dqOjD1mTHKcx8FoPYvzsz1hcf6coi1D6stFj6KfpXM5Zw5
        9cDOTgzrP1jRaluONAWX498ZaMEm/tUGyTkbC2Xs=
Received: from localhost.localdomain (116.30.194.36 [116.30.194.36]) by mx.zoho.com.cn
        with SMTPS id 1598694683536758.9096728812141; Sat, 29 Aug 2020 17:51:23 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     linux-unionfs@vger.kernel.org, linux-mm@kvack.org
Cc:     miklos@szeredi.hu, akpm@linux-foundation.org, amir73il@gmail.com,
        riteshh@linux.ibm.com, Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200829095101.25350-1-cgxu519@mykernel.net>
Subject: [RFC PATCH 0/3] ovl: stacked mmap for shared map
Date:   Sat, 29 Aug 2020 17:50:58 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Currently, there is still ro/rw inconsistency related to shared mmap
in overlayfs, this patch set implements stacked mmap for shared map
and transfer necessary operations to upper inode, so that we can keep
data consistency in any kind of mmap.=20

Patch 1 exports necessary functions from kernel to module.
Patch 2 introduces struct ovl_file_entry to store real vm_ops.
Patch 3 implements stacked mmap for shared map to keep data
consistency.

Chengguang Xu (3):
  mm: mmap: export necessary functions for overlayfs' mmap
  ovl: introduce struct ovl_file_entry
  ovl: implement stacked mmap for shared map

 fs/overlayfs/file.c | 178 ++++++++++++++++++++++++++++++++++++++++----
 include/linux/mm.h  |   2 +
 mm/filemap.c        |  28 +++++++
 mm/internal.h       |  22 ------
 4 files changed, 195 insertions(+), 35 deletions(-)

--=20
2.20.1


