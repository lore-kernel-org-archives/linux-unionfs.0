Return-Path: <SRS0=DrFc=7O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E882C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F373620734
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:57:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KWz4MvC+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgFAP5L (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 11:57:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48452 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726125AbgFAP5L (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Jun 2020 11:57:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591027030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2pd6Xzcu1JWIby5DmUzaFLCvN2zrBEb1cNoTx2NJ074=;
        b=KWz4MvC+JEosE8wB53Jc95wtkq43vNr7gtvovnFaP9IuJYzeuf3Glm68qO5NfzVnkw+GHm
        jVhnXUmJYU0s4fReY02fFXxfFcTXWq5Ocjd7Vk1Q3vDZINImsgbWQdkB3sJIVw9LlJb8cU
        fHmNn1olB1VC7uUz3mS08PS4sQsIZIE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-lznm76MeNcuyV7CufrRiIA-1; Mon, 01 Jun 2020 11:57:07 -0400
X-MC-Unique: lznm76MeNcuyV7CufrRiIA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CE6D18A8220;
        Mon,  1 Jun 2020 15:57:06 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-117.rdu2.redhat.com [10.10.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F2E56116F;
        Mon,  1 Jun 2020 15:57:06 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id ADFAF220244; Mon,  1 Jun 2020 11:57:05 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     amir73il@gmail.com, miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, yangerkun@huawei.com,
        vgoyal@redhat.com
Subject: [PATCH v2 0/3] overlayfs: Do not check metacopy in ovl_get_inode()
Date:   Mon,  1 Jun 2020 11:56:49 -0400
Message-Id: <20200601155652.17486-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi,

This is V2 of the patches. Took care of few suggestions from Amir.

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
 fs/overlayfs/namei.c | 89 ++++++++++++++++++++++++--------------------
 3 files changed, 51 insertions(+), 51 deletions(-)

-- 
2.25.4

