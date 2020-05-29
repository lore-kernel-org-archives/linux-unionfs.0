Return-Path: <SRS0=taqF=7L=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66B69C433E1
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 21:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B22B20776
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 21:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KqVQQJuS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgE2VaW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 May 2020 17:30:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728350AbgE2VaV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 May 2020 17:30:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590787820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cngBmGaeX4memCnuYPb7Oz525NxcV3Q98SYL/8eYdZY=;
        b=KqVQQJuSH/UazVh0KR/98L1ocg3Er6Zvdqw22zpEIb6+lw5MQBN7mvlPrDnb5RONd6xUgv
        WuCwii2XiRC5bG/7+t4f7v+HOHkkVS2CjvCCLJJsAhF/ui6m0oyFzQ8gIiQ5AI2zQxQ7ZP
        RE3XGdKrYYG3n5NkVc2Y8A3PGPYmDMc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-422-nPXZD9kWMJmbi1kgdDCVew-1; Fri, 29 May 2020 17:30:17 -0400
X-MC-Unique: nPXZD9kWMJmbi1kgdDCVew-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEFBB461;
        Fri, 29 May 2020 21:30:15 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-93.rdu2.redhat.com [10.10.115.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7CE565D9D7;
        Fri, 29 May 2020 21:30:15 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id E2A2F22066B; Fri, 29 May 2020 17:30:14 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     amir73il@gmail.com
Cc:     miklos@szeredi.hu, yangerkun@huawei.com,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 0/3] overlayfs: Do not check metacopy in ovl_get_inode() 
Date:   Fri, 29 May 2020 17:29:49 -0400
Message-Id: <20200529212952.214175-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This series tries to implement Amir's suggestion of initializing
OVL_UPPERDATA in callers of ovl_get_inode() and move checking of 
metacopy xattr out of ovl_get_inode().

It also has to patches to cleanup metacopy logic a bit and make it
little more readable and understandable in ovl_lookup().

yangerkun, can you please make sure if this patch series fixes the
xfstest issue you were facing once in a while.

Vivek Goyal (3):
  overlayfs: Simplify setting of origin for index lookup
  overlayfs: ovl_lookup(): Use only uppermetacopy state
  overlayfs: Initialize OVL_UPPERDATA in ovl_lookup()

 fs/overlayfs/dir.c   |  2 +
 fs/overlayfs/inode.c | 11 +-----
 fs/overlayfs/namei.c | 88 +++++++++++++++++++++++---------------------
 3 files changed, 50 insertions(+), 51 deletions(-)

-- 
2.25.4

