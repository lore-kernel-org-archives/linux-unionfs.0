Return-Path: <SRS0=taqF=7L=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4B60C433E3
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 21:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82CF120776
	for <linux-unionfs@archiver.kernel.org>; Fri, 29 May 2020 21:30:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U1DPUVti"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgE2VaW (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 29 May 2020 17:30:22 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38850 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728166AbgE2VaW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 29 May 2020 17:30:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590787820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xE/FZWCBrD5sJ5AcqwdAlS9kJPuODYbHtA3YRjBpBLc=;
        b=U1DPUVtiafw6CGAZa2Iwz+HMvOcaHR9AjE0siZlq+IDgbDflNM4t+lmakUBRTo0OrnguJE
        IZrHY9hp5Y4k3AwNgIlwTUP7Ju/tCr/PGe5LTpN2NJWIIf9GmxDg4cQ2ONc3GsW+VS2GeK
        Kz4Ay+CcPrLOdk8Jwim/XibysEfzXzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-K_5IuXpWOlSXJDzxnbuaDQ-1; Fri, 29 May 2020 17:30:17 -0400
X-MC-Unique: K_5IuXpWOlSXJDzxnbuaDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DD51C8018AB;
        Fri, 29 May 2020 21:30:15 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-93.rdu2.redhat.com [10.10.115.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72036A2947;
        Fri, 29 May 2020 21:30:15 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id E77C022066C; Fri, 29 May 2020 17:30:14 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     amir73il@gmail.com
Cc:     miklos@szeredi.hu, yangerkun@huawei.com,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 1/3] overlayfs: Simplify setting of origin for index lookup
Date:   Fri, 29 May 2020 17:29:50 -0400
Message-Id: <20200529212952.214175-2-vgoyal@redhat.com>
In-Reply-To: <20200529212952.214175-1-vgoyal@redhat.com>
References: <20200529212952.214175-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

overlayfs can keep index of copied up files and directories and it
seems to serve two primary puroposes. For regular files, it avoids
breaking lower hardlinks over copy up. For directories it seems to
be used for various error checks.

During ovl_lookup(), we lookup for index using lower dentry in many
a cases. That lower dentry is called "origin" and following is a summary
of current logic.

If there is no upperdentry, always lookup for index using lower dentry.
For regular files it helps avoiding breaking hard links over copyup
and for directories it seems to be just error checks.

If there is an upperdentry, then there are 3 possible cases.

- For directories, lower dentry is found using two ways. One is regular
  path based lookup in lower layers and second is using ORIGIN xattr
  on upper dentry. First verify that path based lookup lower dentry
  matches the one pointed by upper ORIGIN xattr. If yes, use this
  verified origin for index lookup.

- For regular files (non-metacopy), there is no path based lookup in
  lower layers as lookup stops once we find upper dentry. So there
  is no origin verification. If there is ORIGIN xattr present on upper,
  use that to lookup index otherwise don't.

- For regular metacopy files, again lower dentry is found using
  path based lookup as well as ORIGIN xattr on upper. Path based lookup
  is continued in this case to find lower data dentry for metacopy
  upper. So like directories we only use verified origin. If ORIGIN
  xattr is not present (Either because lower did not support file
  handles or because this is hardlink copied up with index=off), then
  don't use path lookup based lower dentry as origin. This is same
  as regular non-metacopy file case.

Suggested-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 0db23baf98e7..5d80d8cc0063 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1005,25 +1005,30 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 		stack = origin_path;
 		ctr = 1;
+		origin = origin_path->dentry;
 		origin_path = NULL;
 	}
 
 	/*
-	 * Lookup index by lower inode and verify it matches upper inode.
-	 * We only trust dir index if we verified that lower dir matches
-	 * origin, otherwise dir index entries may be inconsistent and we
-	 * ignore them.
+	 * Always lookup index if there is no-upperdentry.
 	 *
-	 * For non-dir upper metacopy dentry, we already set "origin" if we
-	 * verified that lower matched upper origin. If upper origin was
-	 * not present (because lower layer did not support fh encode/decode),
-	 * or indexing is not enabled, do not set "origin" and skip looking up
-	 * index. This case should be handled in same way as a non-dir upper
-	 * without ORIGIN is handled.
+	 * For the case of upperdentry, we have set origin by now if it
+	 * needed to be set. There are basically three cases.
+	 *
+	 * For directories, lookup index by lower inode and verify it matches
+	 * upper inode. We only trust dir index if we verified that lower dir
+	 * matches origin, otherwise dir index entries may be inconsistent
+	 * and we ignore them.
+	 *
+	 * For regular upper, we already set origin if upper had ORIGIN
+	 * xattr. There is no verification though as there is no path
+	 * based dentry lookup in lower in this case.
+	 *
+	 * For metacopy upper, we set a verified origin already if index
+	 * is enabled and if upper had an ORIGIN xattr.
 	 *
-	 * Always lookup index of non-dir non-metacopy and non-upper.
 	 */
-	if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
+	if (!origin && ctr && !upperdentry)
 		origin = stack[0].dentry;
 
 	if (origin && ovl_indexdir(dentry->d_sb) &&
-- 
2.25.4

