Return-Path: <SRS0=KPW4=65=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B074C433DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 May 2020 07:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 039B62065F
	for <linux-unionfs@archiver.kernel.org>; Fri, 15 May 2020 07:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="QHf+m4K6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgEOHW1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 15 May 2020 03:22:27 -0400
Received: from sender2-of-o52.zoho.com.cn ([163.53.93.247]:21134 "EHLO
        sender2-of-o52.zoho.com.cn" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726532AbgEOHW1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 May 2020 03:22:27 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589527294; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=EFc1uQB7l7xjkb3C+RSIFj7DzCX2VJeZ0xBDc6Qajr7bdBMwJtmSOsg6jY18f9D+ZOD1B2hDqvp6gdiczf5J6fwujVd7MisykWm7PAhMkusbHwHAOYFmU9gVk2asDkuBU24EaDAfvufdJMmHGsZyuSbYjfgmDHxiFp+7XxWo6YA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1589527294; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:MIME-Version:Message-ID:Subject:To; 
        bh=uz5a/I6fmPyoWma24bkyijFguEj6/Hc4VExouZ++fLo=; 
        b=NCQW+RXCNWwgtsrvyC5PcY+D8hFhuvNvjqHxj/tzmfmuj6hVlcpbsl9KPkNBkjco9LAN93z5VCDujZxRtj494gZfOXhZPdjHoc0f7yPHIyfMw4dDsMDbCLhtfxzqrZ+6wc9NpNtJ4gO7+xbpGNYf8ILWTcvmXrtm3tgWXfPVBYA=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589527294;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=From:To:Cc:Message-ID:Subject:Date:MIME-Version:Content-Transfer-Encoding:Content-Type;
        bh=uz5a/I6fmPyoWma24bkyijFguEj6/Hc4VExouZ++fLo=;
        b=QHf+m4K6MHz6Y54mL7bO31wl/t/Kz13BpYCIa5zyOv/SrOkbSYWnT8+kgzTG11Ip
        PSpaQiFXLkpXi2ydRjz89OUkhK0Lvdgc4eY1MFMSJBuy88C6F9vifiz9Kwsv1bFa5/M
        aTAKTIKJAm5EYrUq5Jcrn6Q2WZFCr8U/a/U2W/YM=
Received: from localhost.localdomain (218.18.229.179 [218.18.229.179]) by mx.zoho.com.cn
        with SMTPS id 1589527291227106.70977229530297; Fri, 15 May 2020 15:21:31 +0800 (CST)
From:   Chengguang Xu <cgxu519@mykernel.net>
To:     miklos@szeredi.hu, viro@zeniv.linux.org.uk, amir73il@gmail.com
Cc:     linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20200515072047.31454-1-cgxu519@mykernel.net>
Subject: [RFC PATCH v3 0/9] Suppress negative dentry
Date:   Fri, 15 May 2020 15:20:38 +0800
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-ZohoCNMailClient: External
Content-Type: text/plain; charset=utf8
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This series adds a new lookup flag LOOKUP_DONTCACHE_NEGATIVE
to indicate to drop negative dentry in slow path of lookup.

In overlayfs, negative dentries in upper/lower layers are useless
after construction of overlayfs' own dentry, so in order to
effectively reclaim those dentries, specify LOOKUP_DONTCACHE_NEGATIVE
flag when doing lookup in upper/lower layers.

Patch 1 adds flag LOOKUP_DONTCACHE_NEGATIVE and related logic in vfs layer.
Patch 2 does lookup optimazation for overlayfs.
Patch 3-9 just adjusts function argument when calling
lookup_positive_unlocked() and lookup_one_len_unlocked().

v1->v2:
- Only drop negative dentry in slow path of lookup.

v2->v3:
- Drop negative dentry in vfs layer.
- Rebase on latest linus-tree(5.7.0-rc5).

Chengguang Xu (9):
  fs/dcache: Introduce a new lookup flag LOOKUP_DONTCACHE_NEGATIVE
  ovl: Suppress negative dentry in lookup
  cifs: Adjust argument for lookup_positive_unlocked()
  debugfs: Adjust argument for lookup_positive_unlocked()
  ecryptfs: Adjust argument for lookup_one_len_unlocked()
  exportfs: Adjust argument for lookup_one_len_unlocked()
  kernfs: Adjust argument for lookup_positive_unlocked()
  nfsd: Adjust argument for lookup_positive_unlocked()
  quota: Adjust argument for lookup_positive_unlocked()

 fs/cifs/cifsfs.c      |  2 +-
 fs/debugfs/inode.c    |  2 +-
 fs/ecryptfs/inode.c   |  2 +-
 fs/exportfs/expfs.c   |  2 +-
 fs/kernfs/mount.c     |  2 +-
 fs/namei.c            | 14 ++++++++++----
 fs/nfsd/nfs3xdr.c     |  2 +-
 fs/nfsd/nfs4xdr.c     |  3 ++-
 fs/overlayfs/namei.c  |  9 +++++----
 fs/quota/dquot.c      |  3 ++-
 include/linux/namei.h |  9 +++++++--
 11 files changed, 32 insertions(+), 18 deletions(-)

--=20
2.20.1


