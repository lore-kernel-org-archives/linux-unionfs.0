Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCF8AC678D5
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Mar 2023 16:54:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjCHQyI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Mar 2023 11:54:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjCHQyB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Mar 2023 11:54:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA81561A90
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Mar 2023 08:53:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678294397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PhbxTzWahXdd/JlmGrRowyeASqSlq5EbDSo0Q9TZAGc=;
        b=CPM7YH0JTybwYLMZD/6imtwcOyOfNFdhdq8EtrW8Ti7JSP74LPQQUdCWmBIM9UsRdee7MM
        UTQr7r4RoOHVchvfzJMwU5slh446oCfxsimZeEPjUQzh3Pw7sqzs1Zq0LK95WjbEHi+dR+
        Or6zR/jivhh/CAmNJuhcFeLNQBxlgCk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-18-Nut58j8COw2eSbYYTRM5UQ-1; Wed, 08 Mar 2023 11:53:14 -0500
X-MC-Unique: Nut58j8COw2eSbYYTRM5UQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1025F1C12983;
        Wed,  8 Mar 2023 16:53:13 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E0E9492B04;
        Wed,  8 Mar 2023 16:53:10 +0000 (UTC)
From:   David Howells <dhowells@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>
Cc:     David Howells <dhowells@redhat.com>,
        Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Jeff Layton <jlayton@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Hillf Danton <hdanton@sina.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Jan Harkes <jaharkes@cs.cmu.edu>,
        Christoph Hellwig <hch@lst.de>,
        John Hubbard <jhubbard@nvidia.com>, coda@cs.cmu.edu,
        codalist@coda.cs.cmu.edu, linux-unionfs@vger.kernel.org
Subject: [PATCH v17 05/14] coda: Implement splice-read
Date:   Wed,  8 Mar 2023 16:52:42 +0000
Message-Id: <20230308165251.2078898-6-dhowells@redhat.com>
In-Reply-To: <20230308165251.2078898-1-dhowells@redhat.com>
References: <20230308165251.2078898-1-dhowells@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Implement splice-read for coda by passing the request down a layer rather
than going through generic_file_splice_read() which is going to be changed
to assume that ->read_folio() is present on buffered files.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Jan Harkes <jaharkes@cs.cmu.edu>
cc: Christoph Hellwig <hch@lst.de>
cc: Jens Axboe <axboe@kernel.dk>
cc: Al Viro <viro@zeniv.linux.org.uk>
cc: John Hubbard <jhubbard@nvidia.com>
cc: David Hildenbrand <david@redhat.com>
cc: Matthew Wilcox <willy@infradead.org>
cc: coda@cs.cmu.edu
cc: codalist@coda.cs.cmu.edu
cc: linux-unionfs@vger.kernel.org
cc: linux-block@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
cc: linux-mm@kvack.org
---

Notes:
    ver #17)
     - Use vfs_splice_read() helper rather than open-coding checks.

 fs/coda/file.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/coda/file.c b/fs/coda/file.c
index 3f3c81e6b1ab..12b26bd13564 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/uio.h>
+#include <linux/splice.h>
 
 #include <linux/coda.h>
 #include "coda_psdev.h"
@@ -94,6 +95,32 @@ coda_file_write_iter(struct kiocb *iocb, struct iov_iter *to)
 	return ret;
 }
 
+static ssize_t
+coda_file_splice_read(struct file *coda_file, loff_t *ppos,
+		      struct pipe_inode_info *pipe,
+		      size_t len, unsigned int flags)
+{
+	struct inode *coda_inode = file_inode(coda_file);
+	struct coda_file_info *cfi = coda_ftoc(coda_file);
+	struct file *in = cfi->cfi_container;
+	loff_t ki_pos = *ppos;
+	ssize_t ret;
+
+	ret = venus_access_intent(coda_inode->i_sb, coda_i2f(coda_inode),
+				  &cfi->cfi_access_intent,
+				  len, ki_pos, CODA_ACCESS_TYPE_READ);
+	if (ret)
+		goto finish_read;
+
+	ret = vfs_splice_read(in, ppos, pipe, len, flags);
+
+finish_read:
+	venus_access_intent(coda_inode->i_sb, coda_i2f(coda_inode),
+			    &cfi->cfi_access_intent,
+			    len, ki_pos, CODA_ACCESS_TYPE_READ_FINISH);
+	return ret;
+}
+
 static void
 coda_vm_open(struct vm_area_struct *vma)
 {
@@ -302,5 +329,5 @@ const struct file_operations coda_file_operations = {
 	.open		= coda_open,
 	.release	= coda_release,
 	.fsync		= coda_fsync,
-	.splice_read	= generic_file_splice_read,
+	.splice_read	= coda_file_splice_read,
 };

