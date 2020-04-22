Return-Path: <SRS0=lkgI=6G=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B12C5518C
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 13:09:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF7502098B
	for <linux-unionfs@archiver.kernel.org>; Wed, 22 Apr 2020 13:09:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aOZynPdP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgDVNJM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 09:09:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25224 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726760AbgDVNJL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Apr 2020 09:09:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587560950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QsBYY8nA1H/W5ZTBMxGzXAXmpNhqbAKkJ22flzpKMqc=;
        b=aOZynPdPrVsw98hYDe0c1rytaqk82vPtBpEUIyrR/wlTWtHQteZNMiHwjF4lmLtJe5bJd+
        NB7/4k1n2t7mNtiDhCTC0ObLjZHlC7yFQ7O7Ok6uhRDndmMd80a4T1z9ONatB53Tbx9j73
        jAM8i6QkfVPkRSjLdrrMI47SmV6B4eU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-237-zt6CHfikMYSuRgAeYSNc2A-1; Wed, 22 Apr 2020 09:09:07 -0400
X-MC-Unique: zt6CHfikMYSuRgAeYSNc2A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CA148005B4;
        Wed, 22 Apr 2020 13:09:06 +0000 (UTC)
Received: from horse.redhat.com (ovpn-114-112.rdu2.redhat.com [10.10.114.112])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 01A295D9E2;
        Wed, 22 Apr 2020 13:09:03 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id 6B04A222FC6; Wed, 22 Apr 2020 09:09:02 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc:     vgoyal@redhat.com, virtio-fs@redhat.com
Subject: [PATCH 0/2] overlayfs: Fix overlayfs on virtiofs open(O_TRUNC) issue
Date:   Wed, 22 Apr 2020 09:08:48 -0400
Message-Id: <20200422130850.59900-1-vgoyal@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Hi Miklos,

Here are couple of fixes solving open(O_TRUNC) issue while overlayfs
is layered on top of virtiofs.

These are also available here.

https://github.com/rhvgoyal/linux/commits/ovl-setattr-fix

Thanks
Vivek

Vivek Goyal (2):
  overlayfs: ovl_setattr() should clear ATTR_FILE from attr->ia_valid
  overlayfs: ovl_setattr() should clear ATTR_OPEN

 fs/overlayfs/inode.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--=20
2.25.3

