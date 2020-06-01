Return-Path: <SRS0=DrFc=7O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5BDC433E1
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B713620734
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 15:57:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QXqFWiGY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbgFAP5M (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 11:57:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22399 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726110AbgFAP5M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Jun 2020 11:57:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591027030;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tq8rNGbNayJQptHrwc5JdUpI9s1pLmF9Q3QJEp1XE98=;
        b=QXqFWiGY76ltQUt0TvkrHCRDlbZVva9LWH+OfY2Okbaa9EwCsg70oVlaW7n4F8yEfgWq94
        4iRgXVfS/PrezEMeCUo1w/wv0WxDiz0quViFv18Kp3o1dYBV6Q1xmuCjEnQ4TXEvxBZlqC
        CsbZGw92UNoPcx6NeEyYfk9C10DTECY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-V9umKWliPkeRi_ujJ8DaqA-1; Mon, 01 Jun 2020 11:57:07 -0400
X-MC-Unique: V9umKWliPkeRi_ujJ8DaqA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 453EA107ACCD;
        Mon,  1 Jun 2020 15:57:06 +0000 (UTC)
Received: from horse.redhat.com (ovpn-115-117.rdu2.redhat.com [10.10.115.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 184A76C776;
        Mon,  1 Jun 2020 15:57:06 +0000 (UTC)
Received: by horse.redhat.com (Postfix, from userid 10451)
        id B17A6220B23; Mon,  1 Jun 2020 11:57:05 -0400 (EDT)
From:   Vivek Goyal <vgoyal@redhat.com>
To:     amir73il@gmail.com, miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, yangerkun@huawei.com,
        vgoyal@redhat.com
Subject: [PATCH v2 1/3] overlayfs: Simplify setting of origin for index lookup
Date:   Mon,  1 Jun 2020 11:56:50 -0400
Message-Id: <20200601155652.17486-2-vgoyal@redhat.com>
In-Reply-To: <20200601155652.17486-1-vgoyal@redhat.com>
References: <20200601155652.17486-1-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 0db23baf98e7..c6208f84129f 100644
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
+	if (!upperdentry && ctr)
 		origin = stack[0].dentry;
 
 	if (origin && ovl_indexdir(dentry->d_sb) &&
-- 
2.25.4

