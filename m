Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F411BC433DB
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Mar 2021 16:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABF3964F43
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Mar 2021 16:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236806AbhCDQrQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Mar 2021 11:47:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31129 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234351AbhCDQq7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Mar 2021 11:46:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614876334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uGryV7ONDWIwnagotfmPqTyutncbPaoGif+BKTtcnVY=;
        b=cjeUWV/l4XIubQD1xon6cepxvpNoUJv2HXG02yC8qXW0Ois8angPCmwAevYBw1aLmKqT5t
        fKPL0Z8s6Y4l+rzKwyStaNILXFSBcGZPEAgOXC6mlnkJU5URaNlCljpaU62uOBlA9X0O6s
        bxG5wYucGqwMNYiS4B2cYCVh9BZ0ye4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-lIDXXdDtPLCDNJRX6GD7jw-1; Thu, 04 Mar 2021 11:45:32 -0500
X-MC-Unique: lIDXXdDtPLCDNJRX6GD7jw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0CE4640B1;
        Thu,  4 Mar 2021 16:45:31 +0000 (UTC)
Received: from lithium.redhat.com (ovpn-114-74.ams2.redhat.com [10.36.114.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80AA260C0F;
        Thu,  4 Mar 2021 16:45:30 +0000 (UTC)
From:   Giuseppe Scrivano <gscrivan@redhat.com>
To:     linux-unionfs@vger.kernel.org
Cc:     vgoyal@redhat.com, miklos@szeredi.hu
Subject: [PATCH] overlay: show "userxattr" in the mount data
Date:   Thu,  4 Mar 2021 17:45:15 +0100
Message-Id: <20210304164515.3735726-1-gscrivan@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Signed-off-by: Giuseppe Scrivano <gscrivan@redhat.com>
---
 fs/overlayfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fdd72f1a9c5e..d16120d63240 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -380,6 +380,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 			   ofs->config.metacopy ? "on" : "off");
 	if (ofs->config.ovl_volatile)
 		seq_puts(m, ",volatile");
+	if (ofs->config.userxattr)
+		seq_puts(m, ",userxattr");
 	return 0;
 }
 
-- 
2.29.2

